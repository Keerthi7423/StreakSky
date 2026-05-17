import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/ai_controller.dart';
import '../../domain/models/chat_message.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/voice_check_in_button.dart';
import '../widgets/pattern_recognition_card.dart';
import '../../../quotes/presentation/controllers/quote_controller.dart';
import '../../../quotes/domain/models/quote_model.dart';
import '../widgets/suggested_prompt_chips.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiControllerProvider);

    ref.listen(aiControllerProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB3FF00).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB3FF00).withOpacity(0.3)),
              ),
              child: const Icon(Icons.auto_awesome, color: Color(0xFFB3FF00), size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sky AI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFB3FF00),
          labelColor: const Color(0xFFB3FF00),
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'CHAT', icon: Icon(Icons.chat_bubble_outline, size: 20)),
            Tab(text: 'HISTORY', icon: Icon(Icons.history, size: 20)),
            Tab(text: 'SAVED', icon: Icon(Icons.bookmark_border, size: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white54),
            onPressed: () => ref.read(aiControllerProvider.notifier).clearChat(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Chat
          Column(
            children: [
              Expanded(
                child: aiState.messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: aiState.messages.length + (aiState.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == aiState.messages.length) {
                            return _buildLoadingBubble();
                          }
                          final message = aiState.messages[index];
                          return _buildChatBubble(message);
                        },
                      ),
              ),
              const SizedBox(height: 8),
              SuggestedPromptChips(
                onPromptSelected: (prompt) {
                  ref.read(aiControllerProvider.notifier).sendMessage(prompt);
                },
              ),
              const SizedBox(height: 8),
              _buildInputArea(),
            ],
          ),
          // Tab 2: History
          _buildQuoteList(ref.watch(quoteHistoryProvider), 'No history yet.'),
          // Tab 3: Saved
          _buildQuoteList(ref.watch(bookmarkedQuotesProvider), 'No saved quotes.'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_queue,
            size: 80,
            color: const Color(0xFFB3FF00).withOpacity(0.2),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2.seconds, color: const Color(0xFFB3FF00).withOpacity(0.3))
            .moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOut),
          const SizedBox(height: 24),
          const Text(
            'Clear skies ahead!',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ask me anything about your habits.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 32),
          _buildPinnedCommitCard(),
          const SizedBox(height: 24),
          const PatternRecognitionCard(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Mock year summary data for the Pace Check
              ref.read(aiControllerProvider.notifier).fetchMidYearPaceCheck(
                  "Completed 140 habits, missed mostly on weekends. Kept a 20-day streak in March.");
            },
            icon: const Icon(Icons.calendar_today, color: Colors.black, size: 16),
            label: const Text(
              "Run Mid-Year Pace Check",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3FF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedCommitCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Color(0xFFB3FF00), size: 16),
              const SizedBox(width: 8),
              Text(
                'LATEST ACTIVITY',
                style: TextStyle(
                  color: const Color(0xFFB3FF00).withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'You completed 4/5 habits yesterday.',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const Text(
            'Streak: 12 Days 🔥',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.role == MessageRole.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFB3FF00) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: isUser 
            ? [BoxShadow(color: const Color(0xFFB3FF00).withOpacity(0.2), blurRadius: 10, spreadRadius: 1)]
            : [],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.black : Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ).animate().fade(duration: 300.ms).slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            _buildDot(1),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
    ).animate(onPlay: (controller) => controller.repeat())
      .scale(
        duration: 600.ms,
        delay: (index * 200).ms,
        begin: const Offset(1, 1),
        end: const Offset(1.5, 1.5),
        curve: Curves.easeInOut,
      )
      .then()
      .scale(
        duration: 600.ms,
        begin: const Offset(1.5, 1.5),
        end: const Offset(1, 1),
        curve: Curves.easeInOut,
      );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const VoiceCheckInButton(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFB3FF00),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    final text = _textController.text;
    if (text.isNotEmpty) {
      ref.read(aiControllerProvider.notifier).sendMessage(text);
      _textController.clear();
    }
  }
  Widget _buildQuoteList(AsyncValue<List<QuoteModel>> quotesAsync, String emptyMsg) {
    return quotesAsync.when(
      data: (quotes) {
        if (quotes.isEmpty) {
          return Center(child: Text(emptyMsg, style: const TextStyle(color: Colors.white38)));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            final quote = quotes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.text,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '— ${quote.author}',
                        style: const TextStyle(color: Color(0xFFB3FF00), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          quote.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: quote.isBookmarked ? const Color(0xFFB3FF00) : Colors.white24,
                          size: 18,
                        ),
                        onPressed: () {
                          ref.read(quoteControllerProvider.notifier).toggleBookmark(quote.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFB3FF00))),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }
}
