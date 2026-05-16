import '../models/quote_model.dart';

abstract class QuoteRepository {
  Future<QuoteModel> getRandomQuoteByCategory(QuoteCategory category);
  Future<List<QuoteModel>> getBookmarkedQuotes();
  Future<void> toggleBookmark(String quoteId);
  Future<List<QuoteModel>> getQuoteHistory();
}
