import 'dart:math';
import '../../domain/models/quote_model.dart';
import '../../domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final List<QuoteModel> _allQuotes = [
    // DISCIPLINE & CONSISTENCY
    QuoteModel(
      id: '1',
      text: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
      author: "Aristotle",
      category: QuoteCategory.discipline,
    ),
    QuoteModel(
      id: '2',
      text: "Success is the sum of small efforts repeated day in and day out.",
      author: "Robert Collier",
      category: QuoteCategory.discipline,
    ),
    QuoteModel(
      id: '3',
      text: "Motivation gets you going, discipline keeps you growing.",
      author: "John C. Maxwell",
      category: QuoteCategory.discipline,
    ),

    // RESILIENCE & COMEBACK
    QuoteModel(
      id: '4',
      text: "Fall seven times, stand up eight.",
      author: "Japanese Proverb",
      category: QuoteCategory.resilience,
    ),
    QuoteModel(
      id: '5',
      text: "The comeback is always stronger than the setback.",
      author: "Unknown",
      category: QuoteCategory.resilience,
    ),
    QuoteModel(
      id: '6',
      text: "Rock bottom became the solid foundation on which I rebuilt my life.",
      author: "J.K. Rowling",
      category: QuoteCategory.resilience,
    ),

    // VISION & AMBITION
    QuoteModel(
      id: '7',
      text: "The future belongs to those who believe in the beauty of their dreams.",
      author: "Eleanor Roosevelt",
      category: QuoteCategory.vision,
    ),
    QuoteModel(
      id: '8',
      text: "You don't have to be great to start, but you have to start to be great.",
      author: "Zig Ziglar",
      category: QuoteCategory.vision,
    ),

    // FOCUS & CLARITY
    QuoteModel(
      id: '9',
      text: "Where focus goes, energy flows.",
      author: "Tony Robbins",
      category: QuoteCategory.focus,
    ),
    QuoteModel(
      id: '10',
      text: "Concentrate all your thoughts upon the work at hand.",
      author: "Alexander Graham Bell",
      category: QuoteCategory.focus,
    ),

    // GROWTH & LEARNING
    QuoteModel(
      id: '11',
      text: "Live as if you were to die tomorrow. Learn as if you were to live forever.",
      author: "Mahatma Gandhi",
      category: QuoteCategory.growth,
    ),
    QuoteModel(
      id: '12',
      text: "Education is not the filling of a pail but the lighting of a fire.",
      author: "W.B. Yeats",
      category: QuoteCategory.growth,
    ),

    // MINDFULNESS & PEACE
    QuoteModel(
      id: '13',
      text: "The present moment is the only moment available to us.",
      author: "Thich Nhat Hanh",
      category: QuoteCategory.mindfulness,
    ),
    QuoteModel(
      id: '14',
      text: "Peace comes from within. Do not seek it without.",
      author: "Buddha",
      category: QuoteCategory.mindfulness,
    ),

    // LEGACY & GREATNESS
    QuoteModel(
      id: '15',
      text: "Don't count the days. Make the days count.",
      author: "Muhammad Ali",
      category: QuoteCategory.legacy,
    ),
    QuoteModel(
      id: '16',
      text: "What you do today can improve all your tomorrows.",
      author: "Ralph Marston",
      category: QuoteCategory.legacy,
    ),

    // NEW BEGINNINGS
    QuoteModel(
      id: '17',
      text: "Every moment is a fresh beginning.",
      author: "T.S. Eliot",
      category: QuoteCategory.beginnings,
    ),
    QuoteModel(
      id: '18',
      text: "Tomorrow is the first blank page of a 365-page book. Write a good one.",
      author: "Brad Paisley",
      category: QuoteCategory.beginnings,
    ),

    // MILESTONE
    QuoteModel(
      id: '19',
      text: "A journey of a thousand miles begins with a single step.",
      author: "Lao Tzu",
      category: QuoteCategory.milestone,
    ),
    QuoteModel(
      id: '20',
      text: "Motivation is what gets you started. Habit is what keeps you going.",
      author: "Jim Ryun",
      category: QuoteCategory.milestone,
    ),
  ];

  final List<String> _bookmarkedIds = [];
  final List<QuoteModel> _history = [];

  @override
  Future<QuoteModel> getRandomQuoteByCategory(QuoteCategory category) async {
    final filtered = _allQuotes.where((q) => q.category == category).toList();
    if (filtered.isEmpty) {
      // Fallback to discipline if category not found (shouldn't happen with full data)
      return _allQuotes.firstWhere((q) => q.category == QuoteCategory.discipline);
    }
    final quote = filtered[Random().nextInt(filtered.length)];
    
    // Add to history if not already there
    if (!_history.any((h) => h.id == quote.id)) {
      _history.insert(0, quote);
    }
    
    return quote.copyWith(isBookmarked: _bookmarkedIds.contains(quote.id));
  }

  @override
  Future<List<QuoteModel>> getBookmarkedQuotes() async {
    return _allQuotes
        .where((q) => _bookmarkedIds.contains(q.id))
        .map((q) => q.copyWith(isBookmarked: true))
        .toList();
  }

  @override
  Future<void> toggleBookmark(String quoteId) async {
    if (_bookmarkedIds.contains(quoteId)) {
      _bookmarkedIds.remove(quoteId);
    } else {
      _bookmarkedIds.add(quoteId);
    }
  }

  @override
  Future<List<QuoteModel>> getQuoteHistory() async {
    return _history.map((q) => q.copyWith(isBookmarked: _bookmarkedIds.contains(q.id))).toList();
  }
}
