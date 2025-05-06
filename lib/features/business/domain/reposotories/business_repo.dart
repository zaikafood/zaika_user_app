import 'package:zaika/api/api_client.dart';
import 'package:zaika/features/business/domain/models/business_plan_body.dart';
import 'package:zaika/features/business/domain/reposotories/business_repo_interface.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class BusinessRepo implements BusinessRepoInterface<dynamic> {
  final ApiClient apiClient;

  BusinessRepo({required this.apiClient});

  @override
  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody) async {
    return await apiClient.postData(AppConstants.businessPlanUri, businessPlanBody.toJson());
  }

  @override
  Future<Response> subscriptionPayment(String id, String? paymentName) async {
    String callback = '';
    if(GetPlatform.isWeb) {
      String? hostname = html.window.location.hostname;
      String protocol = html.window.location.protocol;
      callback = '$protocol//$hostname${RouteHelper.subscriptionSuccess}';
    }

    return await apiClient.postData(AppConstants.businessPlanPaymentUri, {'id': id, 'payment_gateway': paymentName, 'callback': callback});
  }

  @override
  Future add(dynamic value) {
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

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

}
