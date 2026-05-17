import '../models/year_review_model.dart';

abstract class YearReviewRepository {
  Future<YearReviewModel> generateYearReview(String userId, int year, {bool isDemo = false});
  Future<void> saveYearReview(YearReviewModel review);
  Future<YearReviewModel?> getSavedYearReview(String userId, int year);
}
