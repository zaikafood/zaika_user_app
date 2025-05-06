import 'dart:convert';

import 'package:zaika/api/api_client.dart';
import 'package:zaika/api/local_client.dart';
import 'package:zaika/common/enums/data_source_enum.dart';
import 'package:zaika/common/models/response_model.dart';
import 'package:zaika/features/address/domain/models/address_model.dart';
import 'package:zaika/features/address/domain/reposotories/address_repo_interface.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:get/get.dart';

class AddressRepo implements AddressRepoInterface<AddressModel> {
  final ApiClient apiClient;

  AddressRepo({required this.apiClient});

  @override
  Future<List<AddressModel>?> getList({int? offset, bool isLocal = false, DataSourceEnum? source}) async {
    List<AddressModel>? addressList;
    String cacheId = AppConstants.addressListUri;

    switch (source!) {
      case DataSourceEnum.client:
        Response response = await apiClient.getData(AppConstants.addressListUri);
        if (response.statusCode == 200) {
          addressList = [];
          response.body['addresses'].forEach((address) {
            addressList!.add(AddressModel.fromJson(address));
          });
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body['addresses']), apiClient.getHeader());
        }
      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if (cacheResponseData != null) {
          addressList = [];
          jsonDecode(cacheResponseData).forEach((address) {
            addressList!.add(AddressModel.fromJson(address));
          });
        }
    }
    return addressList;
  }

  @override
  Future add(AddressModel addressModel) async {
    Response response = await apiClient.postData(AppConstants.addAddressUri, addressModel.toJson(), handleError: false);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      String? message = response.body["message"];
      List<int> zoneIds = [];
      response.body['zone_ids'].forEach((z) => zoneIds.add(z));
      responseModel = ResponseModel(true, message, zoneIds: zoneIds);
    } else {
      responseModel = ResponseModel(false,
          response.statusText == 'Out of coverage!' ? 'service_not_available_in_this_area'.tr : response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> update(Map<String, dynamic> body, int? addressId) async {
    Response response = await apiClient.putData('${AppConstants.updateAddressUri}$addressId', body, handleError: false);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> delete(int? id) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData('${AppConstants.removeAddressUri}$id', {"_method": "delete"}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }
}
