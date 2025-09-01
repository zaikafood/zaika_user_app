import 'dart:convert';
import 'package:zaika/api/api_client.dart';
import 'package:zaika/api/local_client.dart';
import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/features/home/domain/models/banner_model.dart';
import 'package:zaika/features/home/domain/models/cashback_model.dart';
import 'package:zaika/features/home/domain/repositories/home_repository_interface.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:get/get_connect.dart';

import '../../../dashboard/model/StockCount.dart';

class HomeRepository implements HomeRepositoryInterface {
  final ApiClient apiClient;
  HomeRepository({required this.apiClient});

  @override
  Future<BannerModel?> getList({int? offset, DataSourceEnum? source}) async {
    return await _getBannerList(source: source!);
  }
  @override
  Future<StockModel> getStock() async {
    StockModel? stockModel;
    Response response = await apiClient.getData('${AppConstants.getStocks}');
    if(response.statusCode == 200) {
      stockModel=StockModel.fromJson(response.body);
    }
    return stockModel??StockModel(count: 0, stock: 0);
  }
  Future<BannerModel?> _getBannerList({required DataSourceEnum source}) async {
    BannerModel? bannerModel;
    String cacheId = AppConstants.bannerUri;

    switch(source) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.bannerUri);
        if(response.statusCode == 200) {
          bannerModel = BannerModel.fromJson(response.body);
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          bannerModel = BannerModel.fromJson(jsonDecode(cacheResponseData));
        }
    }

    return bannerModel;
  }

  @override
  Future<List<CashBackModel>?> getCashBackOfferList({DataSourceEnum? source}) async {
    List<CashBackModel>? cashBackModelList;
    String cacheId = AppConstants.cashBackOfferListUri;

    switch(source!) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.cashBackOfferListUri);
        if(response.statusCode == 200) {
          cashBackModelList = [];
          response.body.forEach((data) {
            cashBackModelList!.add(CashBackModel.fromJson(data));
          });
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          cashBackModelList = [];
          jsonDecode(cacheResponseData).forEach((data) {
            cashBackModelList!.add(CashBackModel.fromJson(data));
          });
        }
    }
    return cashBackModelList;
  }

  @override
  Future<CashBackModel?> getCashBackData(double amount) async {
    CashBackModel? cashBackModel;
    Response response = await apiClient.getData('${AppConstants.getCashBackAmountUri}?amount=$amount');
    if(response.statusCode == 200) {
      cashBackModel = CashBackModel.fromJson(response.body);
    }
    return cashBackModel;
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