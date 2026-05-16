import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../controllers/quote_controller.dart';
import '../../domain/models/quote_model.dart';

class MorningQuoteCard extends ConsumerStatefulWidget {
  const MorningQuoteCard({super.key});

  @override
  ConsumerState<MorningQuoteCard> createState() => _MorningQuoteCardState();
}

class _MorningQuoteCardState extends ConsumerState<MorningQuoteCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final quoteAsync = ref.watch(todayQuoteProvider);

    return quoteAsync.when(
      data: (quote) => _buildCard(context, quote),
      loading: () => _buildLoading(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(BuildContext context, QuoteModel quote) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB3FF00).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB3FF00).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB3FF00).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.format_quote_rounded,
                            color: Color(0xFFB3FF00),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'DAILY WISDOM',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        quote.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: quote.isBookmarked ? const Color(0xFFB3FF00) : Colors.white24,
                        size: 20,
                      ),
                      onPressed: () {
                        ref.read(quoteControllerProvider.notifier).toggleBookmark(quote.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  quote.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                ).animate().fadeIn(duration: 600.ms),
                if (_isExpanded) ...[
                  const SizedBox(height: 16),
                  Text(
                    '— ${quote.author}',
                    style: const TextStyle(
                      color: Color(0xFFB3FF00),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ).animate().slideY(begin: 0.5, end: 0).fadeIn(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFFB3FF00).withOpacity(0.2),
        ),
      ),
    );
  }
}
