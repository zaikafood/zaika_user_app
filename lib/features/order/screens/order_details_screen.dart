import 'package:zaika/features/checkout/widgets/offline_success_dialog.dart';
import 'package:zaika/features/order/controllers/order_controller.dart';
import 'package:zaika/features/order/domain/models/subscription_schedule_model.dart';
import 'package:zaika/features/order/widgets/bottom_view_widget.dart';
import 'package:zaika/features/order/widgets/order_info_section.dart';
import 'package:zaika/features/order/widgets/order_pricing_section.dart';
import 'package:zaika/features/order/domain/models/order_details_model.dart';
import 'package:zaika/features/order/domain/models/order_model.dart';
import 'package:zaika/helper/date_converter.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/common/widgets/custom_app_bar_widget.dart';
import 'package:zaika/common/widgets/custom_dialog_widget.dart';
import 'package:zaika/common/widgets/footer_view_widget.dart';
import 'package:zaika/common/widgets/menu_drawer_widget.dart';
import 'package:zaika/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaika/util/styles.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final bool fromOfflinePayment;
  final String? contactNumber;
  final bool fromGuestTrack;
  final bool fromNotification;
  final bool fromDineIn;
  const OrderDetailsScreen({super.key, required this.orderModel, required this.orderId, this.contactNumber, this.fromOfflinePayment = false, this.fromGuestTrack = false, this.fromNotification = false, this.fromDineIn = false});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {

  final ScrollController scrollController = ScrollController();

  void _loadData() async {
    await Get.find<OrderController>().trackOrder(widget.orderId.toString(), widget.orderModel, false, contactNumber: widget.contactNumber).then((value) {
      if(widget.fromOfflinePayment) {
        Future.delayed(const Duration(seconds: 2), () => showAnimatedDialog(Get.context!, OfflineSuccessDialog(orderId: widget.orderId)));
      }else if(widget.fromDineIn) {
        Future.delayed(const Duration(seconds: 2), () => showAnimatedDialog(Get.context!, OfflineSuccessDialog(orderId: widget.orderId, isDineIn: true)));
      }
    });
    // if(widget.orderModel == null && !widget.fromDineIn) {
    //   await Get.find<SplashController>().getConfigData();
    // }
    Get.find<OrderController>().getOrderCancelReasons();
    Get.find<OrderController>().getOrderDetails(widget.orderId.toString());
    if(Get.find<OrderController>().trackModel != null){
      Get.find<OrderController>().callTrackOrderApi(orderModel: Get.find<OrderController>().trackModel!, orderId: widget.orderId.toString(), contactNumber: widget.contactNumber);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadData();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<OrderController>().callTrackOrderApi(orderModel: Get.find<OrderController>().trackModel!, orderId: widget.orderId.toString(), contactNumber: widget.contactNumber);
    }else if(state == AppLifecycleState.paused){
      Get.find<OrderController>().cancelTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

    Get.find<OrderController>().cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if (((widget.orderModel == null || widget.fromOfflinePayment) && !widget.fromGuestTrack) || widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        } else if(widget.fromGuestTrack){
          return;
        } else{
          return;
        }
      },
      child: GetBuilder<OrderController>(builder: (orderController) {
          double? deliveryCharge = 0;
          double itemsPrice = 0;
          double? discount = 0;
          double? couponDiscount = 0;
          double? tax = 0;
          double addOns = 0;
          double? dmTips = 0;
          double additionalCharge = 0;
          double extraPackagingCharge = 0;
          double referrerBonusAmount = 0;
          bool showChatPermission = true;
          bool? taxIncluded = false;
          OrderModel? order = orderController.trackModel;
          bool subscription = false;
          bool isDineIn = false;
          List<String> schedules = [];
          if(orderController.orderDetails != null && order != null) {
            isDineIn = order.orderType == 'dine_in';
            subscription = order.subscription != null;

            if(subscription) {
              if(order.subscription!.type == 'weekly') {
                List<String> weekDays = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
                for(SubscriptionScheduleModel schedule in orderController.schedules!) {
                  schedules.add('${weekDays[schedule.day!].tr} (${DateConverter.convertTimeToTime(schedule.time!)})');
                }
              }else if(order.subscription!.type == 'monthly') {
                for(SubscriptionScheduleModel schedule in orderController.schedules!) {
                  schedules.add('${'day_capital'.tr} ${schedule.day} (${DateConverter.convertTimeToTime(schedule.time!)})');
                }
              }else {
                schedules.add(DateConverter.convertTimeToTime(orderController.schedules![0].time!));
              }
            }
            if(order.orderType == 'delivery') {
              deliveryCharge = order.deliveryCharge;
              dmTips = order.dmTips;
            }
            couponDiscount = order.couponDiscountAmount;
            discount = order.restaurantDiscountAmount;
            tax = order.totalTaxAmount;
            taxIncluded = order.taxStatus;
            additionalCharge = order.additionalCharge!;
            extraPackagingCharge = order.extraPackagingAmount!;
            referrerBonusAmount = order.referrerBonusAmount!;
            for(OrderDetailsModel orderDetails in orderController.orderDetails!) {
              for(AddOn addOn in orderDetails.addOns!) {
                addOns = addOns + (addOn.price! * addOn.quantity!);
              }
              itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
            }
            if(order.restaurant != null) {
              if (order.restaurant!.restaurantModel == 'commission') {
                showChatPermission = true;
              } else if (order.restaurant!.restaurantSubscription != null &&
                  order.restaurant!.restaurantSubscription!.chat == 1) {
                showChatPermission = true;
              } else {
                showChatPermission = false;
              }
            }
          }
          double subTotal = itemsPrice + addOns;
          double total = itemsPrice + addOns - discount! + (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingCharge - referrerBonusAmount;

        return Scaffold(
            appBar: (subscription || isDineIn) && !ResponsiveHelper.isDesktop(context) ? AppBar(
              surfaceTintColor: Theme.of(context).cardColor,
              title: Column(children: [

                Text('${isDineIn ? 'order'.tr : 'subscription'.tr} # ${order?.id.toString()}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                subscription
                    ? Text('${'your_order_is'.tr} ${order?.orderStatus}', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor))
                    : Text(
                  (order?.orderStatus == 'pending' || order?.orderStatus == 'confirmed') ? '${'your_order_is'.tr} ${order?.orderStatus?.tr}'
                      : order?.orderStatus == 'processing' ? 'your_food_is_cooking'.tr
                      : order?.orderStatus == 'handover' ? 'your_food_is_ready'.tr
                      : order?.orderStatus == 'canceled' ? 'your_order_is_canceled'.tr
                      : 'your_food_is_served'.tr,
                  style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
                ),

              ]),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if((widget.orderModel == null || widget.fromOfflinePayment) && !widget.fromGuestTrack) {
                    Get.offAllNamed(RouteHelper.getInitialRoute());
                  } else if(widget.fromGuestTrack){
                    Get.back();
                  } else {
                    Get.back();
                  }
                },
              ),
              actions: const [SizedBox()],
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
            ) : CustomAppBarWidget(title: subscription ? 'subscription_details'.tr : 'order_details'.tr, onBackPressed: () {
              if(((widget.orderModel == null || widget.fromOfflinePayment) && !widget.fromGuestTrack) || widget.fromNotification) {
                Get.offAllNamed(RouteHelper.getInitialRoute());
              } else if(widget.fromGuestTrack){
                Get.back();
              } else {
                Get.back();
              }
            }),
            endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
            body: SafeArea(
              child: (order != null && orderController.orderDetails != null) ? Column(children: [

                WebScreenTitleWidget(title: subscription ? 'subscription_details'.tr : 'order_details'.tr),

                Expanded(child: SingleChildScrollView(
                  // physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  child: FooterViewWidget(child: SizedBox(width: Dimensions.webMaxWidth,
                    child: ResponsiveHelper.isDesktop(context) ? Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Expanded(flex: 6, child: Column(children: [

                          subscription ? Text('${'subscription'.tr} # ${order.id.toString()}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)) : const SizedBox(),
                          SizedBox(height: subscription ? Dimensions.paddingSizeExtraSmall : 0),

                          subscription ? Text('${'your_order_is'.tr} ${order.orderStatus}', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)) : const SizedBox(),
                          SizedBox(height: subscription ? Dimensions.paddingSizeLarge : 0),

                            OrderInfoSection(order: order, orderController: orderController, schedules: schedules, showChatPermission: showChatPermission,
                              contactNumber: widget.contactNumber, totalAmount: total),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(flex: 4,child: OrderPricingSection(
                          itemsPrice: itemsPrice, addOns: addOns, order: order, subTotal: subTotal, discount: discount,
                          couponDiscount: couponDiscount, tax: tax!, dmTips: dmTips, deliveryCharge: deliveryCharge,
                          total: total, orderController: orderController, orderId: widget.orderId, contactNumber: widget.contactNumber,
                          extraPackagingAmount: extraPackagingCharge, referrerBonusAmount: referrerBonusAmount,
                        ))

                      ]),
                    ) : Column(children: [

                      OrderInfoSection(order: order, orderController: orderController, schedules: schedules, showChatPermission: showChatPermission,
                        contactNumber: widget.contactNumber, totalAmount: total),

                      OrderPricingSection(
                        itemsPrice: itemsPrice, addOns: addOns, order: order, subTotal: subTotal, discount: discount,
                        couponDiscount: couponDiscount, tax: tax!, dmTips: dmTips, deliveryCharge: deliveryCharge,
                        total: total, orderController: orderController, orderId: widget.orderId, contactNumber: widget.contactNumber,
                        extraPackagingAmount: extraPackagingCharge, referrerBonusAmount: referrerBonusAmount,
                      ),

                    ]),
                  )),
                )),

                !ResponsiveHelper.isDesktop(context) ? BottomViewWidget(orderController: orderController, order: order, orderId: widget.orderId, total: total, contactNumber: widget.contactNumber) : const SizedBox(),


              ]) : const Center(child: CircularProgressIndicator()),
            ),

        );
      }),
    );
  }
}