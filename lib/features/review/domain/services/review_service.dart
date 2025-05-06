import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/common/models/product_model.dart';
import 'package:zaika/common/models/response_model.dart';
import 'package:zaika/common/models/review_model.dart';
import 'package:zaika/features/product/domain/models/review_body_model.dart';
import 'package:zaika/features/review/domain/repositories/review_repository_interface.dart';
import 'package:zaika/features/review/domain/services/review_service_interface.dart';

class ReviewService implements ReviewServiceInterface {
  final ReviewRepositoryInterface reviewRepositoryInterface;
  ReviewService({required this.reviewRepositoryInterface});

  @override
  Future<List<Product>?> getReviewedProductList({required String type, DataSourceEnum? source}) async {
    return await reviewRepositoryInterface.getList(type: type, source: source);
  }

  @override
  Future<ResponseModel> submitProductReview(ReviewBodyModel reviewBody) async {
    return await reviewRepositoryInterface.submitReview(reviewBody, true);
  }

  @override
  Future<ResponseModel> submitDeliverymanReview(ReviewBodyModel reviewBody) async {
    return await reviewRepositoryInterface.submitReview(reviewBody, false);
  }

  @override
  Future<List<ReviewModel>?> getRestaurantReviewList(String? restaurantID) async {
    return await reviewRepositoryInterface.getRestaurantReviewList(restaurantID);
  }
}