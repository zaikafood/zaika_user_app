import 'dart:collection';
import 'package:zaika/features/checkout/widgets/payment_failed_dialog.dart';
import 'package:zaika/features/dashboard/controllers/dashboard_controller.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/order/domain/models/order_model.dart';
import 'package:zaika/features/location/domain/models/zone_response_model.dart';
import 'package:zaika/features/loyalty/controllers/loyalty_controller.dart';
import 'package:zaika/features/wallet/widgets/fund_payment_dialog_widget.dart';
import 'package:zaika/helper/address_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:zaika/common/widgets/custom_app_bar_widget.dart';
import 'package:zaika/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final OrderModel orderModel;
  final String paymentMethod;
  final String? addFundUrl;
  final String? subscriptionUrl;
  final String guestId;
  final String contactNumber;
  final int? restaurantId;
  final int? packageId;
  const PaymentWebViewScreen({super.key, required this.orderModel, required this.paymentMethod, this.addFundUrl, this.subscriptionUrl,
    required this.guestId, required this.contactNumber, this.restaurantId, this.packageId});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentWebViewScreen> {
  late String selectedUrl;
  bool _isLoading = true;
  bool _canRedirect = true;
  double? _maximumCodOrderAmount;
  PullToRefreshController? pullToRefreshController;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    if(widget.addFundUrl == '' && widget.addFundUrl!.isEmpty && widget.subscriptionUrl == '' && widget.subscriptionUrl!.isEmpty){
      selectedUrl = '${AppConstants.baseUrl}/payment-mobile?customer_id=${widget.orderModel.userId == 0 ? widget.guestId : widget.orderModel.userId}&order_id=${widget.orderModel.id}&payment_method=${widget.paymentMethod}';
    } else if(widget.subscriptionUrl != '' && widget.subscriptionUrl!.isNotEmpty){
      selectedUrl = widget.subscriptionUrl!;
    } else {
      selectedUrl = widget.addFundUrl!;
    }

    _initData();
  }

  void _initData() async {
    if(widget.addFundUrl == '' && widget.addFundUrl!.isEmpty){
      ZoneData zoneData = AddressHelper.getAddressFromSharedPref()!.zoneData!.firstWhere((data) => data.id == widget.orderModel.restaurant!.zoneId);
      _maximumCodOrderAmount = zoneData.maxCodOrderAmount;
    }

    pullToRefreshController = GetPlatform.isWeb || ![TargetPlatform.iOS, TargetPlatform.android].contains(defaultTargetPlatform) ? null : PullToRefreshController(
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        _exitApp();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CustomAppBarWidget(title: '', onBackPressed: () => _exitApp()),
        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(selectedUrl)),
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              pullToRefreshController: pullToRefreshController,
              initialSettings: InAppWebViewSettings(
                userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36',
                useHybridComposition: true,
              ),
              onWebViewCreated: (controller) async {
                webViewController = controller;
              },
              onLoadStart: (controller, url) async {
                _redirect(url.toString(), widget.contactNumber, widget.restaurantId, widget.packageId);
                setState(() {
                  _isLoading = true;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                Uri uri = navigationAction.request.url!;
                if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();
                setState(() {
                  _isLoading = false;
                });
                _redirect(url.toString(), widget.contactNumber, widget.restaurantId, widget.packageId);
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                // setState(() {
                //   _value = progress / 100;
                // });
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint(consoleMessage.message);
              },
            ),
            _isLoading ? Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<bool?> _exitApp() async {
    ///ToDO: need implement for subscription-----
    if((widget.addFundUrl == '' && widget.addFundUrl!.isEmpty) || !Get.find<SplashController>().configModel!.digitalPaymentInfo!.pluginPaymentGateways!){
      return Get.dialog(PaymentFailedDialog(
        orderID: widget.orderModel.id.toString(),
        orderAmount: widget.orderModel.orderAmount,
        maxCodOrderAmount: _maximumCodOrderAmount,
      ));
    } else {
      return Get.dialog(FundPaymentDialogWidget(isSubscription: widget.subscriptionUrl != null && widget.subscriptionUrl!.isNotEmpty));
    }

  }

  void _redirect(String url, String? contactNumber, int? restaurantId, int? packageId) {
    if(_canRedirect) {
      bool isSuccess = url.contains('success') && url.startsWith(AppConstants.baseUrl);
      bool isFailed = url.contains('fail') && url.startsWith(AppConstants.baseUrl);
      bool isCancel = url.contains('cancel') && url.startsWith(AppConstants.baseUrl);
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
      }

      if((widget.addFundUrl == '' && widget.addFundUrl!.isEmpty && widget.subscriptionUrl == '' && widget.subscriptionUrl!.isEmpty)){
        if (isSuccess) {
          double total = ((widget.orderModel.orderAmount! / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
          Get.find<LoyaltyController>().saveEarningPoint(total.toStringAsFixed(0));
          Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'success', widget.orderModel.orderAmount, contactNumber, isDeliveryOrder: widget.orderModel.orderType == 'delivery'));
        } else if (isFailed || isCancel) {
          Get.offNamed(RouteHelper.getOrderSuccessRoute(widget.orderModel.id.toString(), 'fail', widget.orderModel.orderAmount, contactNumber, isDeliveryOrder: widget.orderModel.orderType == 'delivery'));
        }
      } else{
        if(isSuccess || isFailed || isCancel) {
          if(Get.currentRoute.contains(RouteHelper.payment)) {
            Get.back();
          }
          if( widget.subscriptionUrl != null &&  widget.subscriptionUrl!.isNotEmpty &&  widget.addFundUrl == '' &&  widget.addFundUrl!.isEmpty) {
            Get.find<DashboardController>().saveRegistrationSuccessfulSharedPref(true);
            Get.find<DashboardController>().saveIsRestaurantRegistrationSharedPref(true);
            Get.offAllNamed(RouteHelper.getSubscriptionSuccessRoute(
              status: isSuccess ? 'success' : isFailed ? 'fail' : 'cancel',
              fromSubscription: true, restaurantId:  restaurantId, packageId: packageId,
            ));
          } else {
            Get.back();
            Get.offAllNamed(RouteHelper.getWalletRoute(fundStatus: isSuccess ? 'success' : isFailed ? 'fail' : 'cancel', /*token: UniqueKey().toString()*/));
          }
        }
      }
    }
  }

}