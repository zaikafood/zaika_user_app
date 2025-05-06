import 'package:zaika/common/models/product_model.dart';
import 'package:zaika/features/search/domain/models/search_suggestion_model.dart';
import 'package:zaika/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class SearchRepositoryInterface extends RepositoryInterface {
  Future<List<Product>?> getSuggestedFoods();
  Future<SearchSuggestionModel?> getSearchSuggestions(String searchText);
  Future<Response> getSearchData({required String query, required bool isRestaurant, required int offset,
    String? type, int? isNew = 0, int? isPopular = 0, double? minPrice, double? maxPrice,
    int? isOneRatting = 0, int? isTwoRatting = 0, int? isThreeRatting = 0, int? isFourRatting = 0, int? isFiveRatting = 0,
    String? sortBy, int? discounted = 0, required List<int> selectedCuisines, int? isOpenRestaurant});
  Future<bool> saveSearchHistory(List<String> searchHistories);
  List<String> getSearchHistory();
  Future<bool> clearSearchHistory();
}