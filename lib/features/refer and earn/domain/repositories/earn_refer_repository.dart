import 'package:get/get_connect/http/src/response/response.dart';
import 'package:zaika/api/api_client.dart';
import 'package:zaika/features/refer%20and%20earn/domain/model/earn_refer.dart';
import 'package:zaika/features/refer%20and%20earn/domain/repositories/earn_refer_repository_interface.dart';

import '../../../../util/app_constants.dart';

class EarnReferRepository implements EarnReferRepositoryInterface{
 final  ApiClient apiClient;
  EarnReferRepository({required this.apiClient});

  @override
  Future<TransactionHistoryResponse?> getEarnReferData({required int page}) async {

    TransactionHistoryResponse? transactionHistoryResponse;
    Response response = await apiClient.getData('${AppConstants.getReferralDetail}?limit=50&page=$page');
    if (response.statusCode == 200) {
      transactionHistoryResponse = TransactionHistoryResponse.fromJson(response.body);
    }
    return transactionHistoryResponse;
  }

}