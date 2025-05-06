import 'dart:convert';
import 'package:zaika/api/api_client.dart';
import 'package:zaika/api/local_client.dart';
import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/cuisine/domain/models/cuisine_model.dart';
import 'package:zaika/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:zaika/features/cuisine/domain/repositories/cuisine_repository_interface.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:get/get_connect/connect.dart';

class CuisineRepository implements CuisineRepositoryInterface {
  final ApiClient apiClient;
  CuisineRepository({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<CuisineModel?> getList({int? offset, DataSourceEnum? source}) async {
    CuisineModel? cuisineModel;
    String cacheId = AppConstants.cuisineUri;

    switch(source!){
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.cuisineUri);
        if(response.statusCode == 200){
          cuisineModel = CuisineModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          cuisineModel = CuisineModel.fromJson(jsonDecode(cacheResponseData));
        }
    }

    return cuisineModel;
  }

  @override
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId) async {
    CuisineRestaurantModel? cuisineRestaurantsModel;
    Response response = await apiClient.getData('${AppConstants.cuisineRestaurantUri}?cuisine_id=$cuisineId&offset=$offset&limit=10');
    if(response.statusCode == 200) {
      cuisineRestaurantsModel = CuisineRestaurantModel.fromJson(response.body);
    }
    return cuisineRestaurantsModel;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}