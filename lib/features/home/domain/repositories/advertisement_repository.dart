import 'dart:convert';
import 'package:get/get.dart';
import 'package:zaika/api/api_client.dart';
import 'package:zaika/api/local_client.dart';
import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/home/domain/models/advertisement_model.dart';
import 'package:zaika/features/home/domain/repositories/advertisement_repository_interface.dart';
import 'package:zaika/util/app_constants.dart';

class AdvertisementRepository implements AdvertisementRepositoryInterface {
  final ApiClient apiClient;
  AdvertisementRepository({required this.apiClient});

  @override
  Future<List<AdvertisementModel>?> getList({int? offset, DataSourceEnum? source}) async {
    List<AdvertisementModel>? advertisementList;
    String cacheId = AppConstants.advertisementListUri;

    switch(source!){
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.advertisementListUri);
        if(response.statusCode == 200) {
          advertisementList = [];
          response.body.forEach((data) {
            advertisementList?.add(AdvertisementModel.fromJson(data));
          });
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }
      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          advertisementList = [];
          jsonDecode(cacheResponseData).forEach((data) {
            advertisementList?.add(AdvertisementModel.fromJson(data));
          });
        }
    }

    return advertisementList;
  }

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
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}