
import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/common/models/product_model.dart';
import 'package:zaika/common/models/restaurant_model.dart';
import 'package:zaika/features/address/domain/models/address_model.dart';
import 'package:zaika/features/category/domain/models/category_model.dart';
import 'package:zaika/features/location/domain/models/zone_response_model.dart';
import 'package:zaika/features/restaurant/domain/models/recommended_product_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class RestaurantServiceInterface {
  double getRestaurantDistanceFromUser(LatLng restaurantLatLng);
  String filterRestaurantLinkUrl(String slug, int? restaurantId, int? restaurantZoneId);
  Future<RestaurantModel?> getRestaurantList(int offset, String filterBy, int topRated, int discount, int veg, int nonVeg, {bool fromMap = false, DataSourceEnum? source});
  Future<List<Restaurant>?> getOrderAgainRestaurantList({DataSourceEnum? source});
  Future<List<Restaurant>?> getRecentlyViewedRestaurantList(String type, {DataSourceEnum? source});
  Future<List<Restaurant>?> getPopularRestaurantList(String type, {DataSourceEnum? source});
  Future<List<Restaurant>?> getLatestRestaurantList(String type, {DataSourceEnum? source});
  Future<RecommendedProductModel?> getRestaurantRecommendedItemList(int? restaurantId);
  int setTopRated(int rated);
  int setDiscounted(int discounted);
  int setVeg(int isVeg);
  int setNonVeg(int isNonVeg);
  List<CategoryModel>? setCategories(List<CategoryModel> categoryList, Restaurant restaurant);
  Future<Restaurant?> getRestaurantDetails(String restaurantID, String slug, String? languageCode);
  AddressModel prepareAddressModel(Position storePosition, ZoneResponseModel responseModel, String addressFromGeocode);
  Future<List<Product>?> getCartRestaurantSuggestedItemList(int? restaurantID);
  Future<ProductModel?> getRestaurantProductList(int? restaurantID, int offset, int? categoryID, String type);
  Future<ProductModel?> getRestaurantSearchProductList(String searchText, String? storeID, int offset, String type);
  bool isRestaurantClosed(DateTime dateTime, bool active, List<Schedules>? schedules);
  bool isRestaurantOpenNow(bool active, List<Schedules>? schedules);
}