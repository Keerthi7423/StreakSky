import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaksky/core/di/injection.dart';
import 'package:streaksky/features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/year_review_model.dart';
import '../../domain/repositories/year_review_repository.dart';

final yearReviewRepositoryProvider = Provider<YearReviewRepository>((ref) {
  return getIt<YearReviewRepository>();
});

class YearReviewController extends StateNotifier<AsyncValue<YearReviewModel?>> {
  final YearReviewRepository _repository;
  final Ref _ref;

  YearReviewController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> generateReview(int year) async {
    final isDemo = _ref.read(demoLoggedInProvider);
    final user = _ref.read(authStateProvider).asData?.value;
    final userId = user?.uid ?? 'demo-user';

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final review = await _repository.generateYearReview(
        userId,
        year,
        isDemo: isDemo,
      );
      return review;
    });
  }
}

final yearReviewControllerProvider = StateNotifierProvider<YearReviewController, AsyncValue<YearReviewModel?>>((ref) {
  final repo = ref.watch(yearReviewRepositoryProvider);
  return YearReviewController(repo, ref);
});
