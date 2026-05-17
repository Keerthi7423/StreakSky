import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/weather/domain/models/weather_model.dart';
import 'package:streaksky/features/weather/presentation/controllers/weather_controller.dart';
import '../../domain/models/quote_model.dart';
import '../../domain/repositories/quote_repository.dart';

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return getIt<QuoteRepository>();
});

final todayQuoteProvider = FutureProvider<QuoteModel>((ref) async {
  final weatherAsync = ref.watch(weatherProvider);
  final repo = ref.watch(quoteRepositoryProvider);

  return weatherAsync.when(
    data: (weather) {
      final category = _mapWeatherToCategory(weather.type);
      return repo.getRandomQuoteByCategory(category);
    },
    loading: () => repo.getRandomQuoteByCategory(QuoteCategory.discipline),
    error: (_, _) => repo.getRandomQuoteByCategory(QuoteCategory.discipline),
  );
});

final quoteHistoryProvider = FutureProvider<List<QuoteModel>>((ref) async {
  final repo = ref.watch(quoteRepositoryProvider);
  return repo.getQuoteHistory();
});

final bookmarkedQuotesProvider = FutureProvider<List<QuoteModel>>((ref) async {
  final repo = ref.watch(quoteRepositoryProvider);
  return repo.getBookmarkedQuotes();
});

QuoteCategory _mapWeatherToCategory(WeatherType type) {
  switch (type) {
    case WeatherType.sunny:
      return QuoteCategory.discipline;
    case WeatherType.partlyCloudy:
      return QuoteCategory.focus;
    case WeatherType.cloudy:
    case WeatherType.rainy:
    case WeatherType.storm:
    case WeatherType.tornado:
      return QuoteCategory.resilience;
    case WeatherType.rainbow:
      return QuoteCategory.growth;
  }
}

class QuoteController extends StateNotifier<AsyncValue<void>> {
  final QuoteRepository _repository;
  final Ref _ref;

  QuoteController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> toggleBookmark(String quoteId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.toggleBookmark(quoteId);
      _ref.invalidate(todayQuoteProvider);
      _ref.invalidate(quoteHistoryProvider);
      _ref.invalidate(bookmarkedQuotesProvider);
    });
  }
}

final quoteControllerProvider = StateNotifierProvider<QuoteController, AsyncValue<void>>((ref) {
  final repo = ref.watch(quoteRepositoryProvider);
  return QuoteController(repo, ref);
});
