import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/common/models/product_model.dart';
import 'package:zaika/common/models/response_model.dart';
import 'package:zaika/common/models/review_model.dart';
import 'package:zaika/features/order/domain/models/order_details_model.dart';
import 'package:zaika/features/product/domain/models/review_body_model.dart';
import 'package:zaika/features/review/domain/services/review_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController implements GetxService {
  final ReviewServiceInterface reviewServiceInterface;

  ReviewController({required this.reviewServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<int> _ratingList = [];
  List<int> get ratingList => _ratingList;

  List<String> _reviewList = [];
  List<String> get reviewList => _reviewList;

  List<bool> _loadingList = [];
  List<bool> get loadingList => _loadingList;

  List<bool> _submitList = [];
  List<bool> get submitList => _submitList;

  int _deliveryManRating = 0;
  int get deliveryManRating => _deliveryManRating;

  String _reviewedType = 'all';
  String get reviewType => _reviewedType;

  List<Product>? _reviewedProductList;
  List<Product>? get reviewedProductList => _reviewedProductList;

  List<ReviewModel>? _restaurantReviewList;
  List<ReviewModel>? get restaurantReviewList => _restaurantReviewList;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    for (var orderDetails in orderDetailsList) {
      debugPrint('$orderDetails');
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    }
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    update();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    update();
  }

  Future<void> getReviewedProductList(bool reload, String type, bool notify, {DataSourceEnum dataSource = DataSourceEnum.local, bool fromRecall = false}) async {
    _reviewedType = type;
    if(reload && !fromRecall) {
      _reviewedProductList = null;
    }
    if(notify) {
      update();
    }
    List<Product>? reviewedProductList;
    if(_reviewedProductList == null || reload || fromRecall) {
      if(dataSource == DataSourceEnum.local) {
        reviewedProductList = await reviewServiceInterface.getReviewedProductList(type: type, source: DataSourceEnum.local);
        _prepareReviewedProductList(reviewedProductList);
        getReviewedProductList(false, type, false, dataSource: DataSourceEnum.client, fromRecall: true);
      } else {
        reviewedProductList = await reviewServiceInterface.getReviewedProductList(type: type, source: DataSourceEnum.client);
        _prepareReviewedProductList(reviewedProductList);
      }
    }
  }

  _prepareReviewedProductList(List<Product>? reviewedProductList) {
    if(reviewedProductList != null) {
      _reviewedProductList = [];
      _reviewedProductList = reviewedProductList;
    }
    update();
  }

  Future<ResponseModel> submitReview(int index, ReviewBodyModel reviewBody) async {
    _loadingList[index] = true;
    update();

    ResponseModel responseModel = await reviewServiceInterface.submitProductReview(reviewBody);
    if(responseModel.isSuccess) {
      _submitList[index] = true;
      update();
    }
    _loadingList[index] = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBodyModel reviewBody) async {
    _isLoading = true;
    update();

    ResponseModel responseModel = await reviewServiceInterface.submitDeliverymanReview(reviewBody);
    if(responseModel.isSuccess) {
      _deliveryManRating = 0;
      update();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getRestaurantReviewList(String? restaurantID) async {
    _restaurantReviewList = await reviewServiceInterface.getRestaurantReviewList(restaurantID);

    update();
  }

}