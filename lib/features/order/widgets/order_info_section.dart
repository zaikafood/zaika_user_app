import 'package:dotted_border/dotted_border.dart';
import 'package:zaika/common/models/review_model.dart';
import 'package:zaika/common/widgets/rating_bar_widget.dart';
import 'package:zaika/features/address/domain/models/address_model.dart';
import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/order/widgets/log_bottom_sheet_widget.dart';
import 'package:zaika/features/order/widgets/offline_info_edit_dialog.dart';
import 'package:zaika/features/notification/domain/models/notification_body_model.dart';
import 'package:zaika/features/order/controllers/order_controller.dart';
import 'package:zaika/features/order/widgets/delivery_details.dart';
import 'package:zaika/features/order/widgets/order_product_widget.dart';
import 'package:zaika/features/review/widgets/review_dialog_widget.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/order/domain/models/order_model.dart';
import 'package:zaika/features/chat/domain/models/conversation_model.dart';
import 'package:zaika/features/chat/widgets/image_dialog_widget.dart';
import 'package:zaika/helper/date_converter.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/custom_image_widget.dart';
import 'package:zaika/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderInfoSection extends StatelessWidget {
  final OrderModel order;
  final OrderController orderController;
  final List<String> schedules;
  final bool showChatPermission;
  final String? contactNumber;
  final double? totalAmount;
  const OrderInfoSection({super.key, required this.order, required this.orderController, required this.schedules, required this.showChatPermission,
    this.contactNumber, this.totalAmount});

  @override
  Widget build(BuildContext context) {
    ExpansionTileController expansionTileController = ExpansionTileController();
    bool subscription = order.subscription != null;

    bool pending = order.orderStatus == AppConstants.pending;
    bool accepted = order.orderStatus == AppConstants.accepted;
    bool confirmed = order.orderStatus == AppConstants.confirmed;
    bool processing = order.orderStatus == AppConstants.processing;
    bool pickedUp = order.orderStatus == AppConstants.pickedUp;
    bool delivered = order.orderStatus == AppConstants.delivered;
    bool cancelled = order.orderStatus == AppConstants.cancelled;
    bool takeAway = order.orderType == 'take_away';
    bool isDineIn = order.orderType == 'dine_in';
    bool cod = order.paymentMethod == 'cash_on_delivery';
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();

    bool ongoing = ((isDineIn ? true : order.orderStatus != 'delivered') && order.orderStatus != 'failed'
        && order.orderStatus != 'refund_requested' && order.orderStatus != 'refunded'
        && order.orderStatus != 'refund_request_canceled' && order.orderStatus != 'canceled');

    bool pastOrder = ((isDineIn ? false : order.orderStatus == 'delivered') || order.orderStatus == 'failed'
        || order.orderStatus == 'refund_requested' || order.orderStatus == 'refunded'
        || order.orderStatus == 'refund_request_canceled' ||order.orderStatus == 'canceled');

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      isDesktop ? Padding(
        padding: EdgeInsets.only(top: subscription ? Dimensions.paddingSizeSmall : 0, bottom: Dimensions.paddingSizeSmall),
        child: Text(subscription ? 'subscription_details'.tr : 'general_info'.tr, style: robotoMedium),
      ) : const SizedBox(),

      Container(
        decoration: isDesktop ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withValues(alpha: 0.05) : Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
        ) : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DateConverter.isBeforeTime(order.scheduleAt) || isDineIn ? (!cancelled && ongoing && !subscription) ?
          isDineIn ? Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

            isDesktop ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

              SizedBox(height: Dimensions.paddingSizeSmall),
              Text('${'order'.tr} # ${order.id.toString()}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                (order.orderStatus == 'pending' || order.orderStatus == 'confirmed') ? '${'your_order_is'.tr} ${order.orderStatus?.tr}'
                    : order.orderStatus == 'processing' ? 'your_food_is_cooking'.tr
                    : order.orderStatus == 'handover' ? 'your_food_is_ready'.tr
                    : order.orderStatus == 'canceled' ? 'your_order_is_canceled'.tr
                    : 'your_food_is_served'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
              ),

            ]) : const SizedBox(),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        order.orderStatus == 'pending' ? Images.pendingDineIn
                            : (order.orderStatus == 'confirmed') ? Images.confirmDineIn
                            : order.orderStatus == 'processing' ? Images.cookingDineIn
                            : order.orderStatus == 'handover' ? Images.preparingFoodOrderDetails
                            : Images.servedDineIn,
                        height: 200,),
                    ),
                  ),

                  Center(child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                    child: order.orderStatus == 'pending' ? Text(
                      'your_order_is_pending_please_wait_for_restaurant_confirmation'.tr,
                      textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge/*, color: Theme.of(context).disabledColor*/),
                    ) : order.orderStatus == 'processing' ? Column(children: [
                      Text(
                        'your_food_is_almost_ready'.tr,
                        textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge/*, color: Theme.of(context).disabledColor*/),
                      ),

                      Row(mainAxisSize: MainAxisSize.min, children: [

                        Text(
                          DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt, fromDineIn: true, processing: order.processing) < 5 ? '1 - 5'
                              : '${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt, fromDineIn: true, processing: order.processing)-5} '
                              '- ${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt, fromDineIn: true, processing: order.processing)}',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text('min'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color)),
                      ]),

                    ]) : order.orderStatus == 'confirmed' ? RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(text: 'your_dine_in_order_is_confirmed_please_make_sure_to_arrive_on_time'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color)),
                        TextSpan(text: ' - ', style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                        TextSpan(
                          text: DateConverter.dateTimeStringToDateTime(order.scheduleAt!),
                          style: robotoMedium.copyWith(fontSize:Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color),
                        ),
                      ]),
                    ) : order.orderStatus == 'handover' ? DateConverter.differenceInMinute(null, order.createdAt, null, order.scheduleAt) > 0 ? Column(children: [
                      Text(
                        'your_food_is_ready_to_serve_you_are'.tr,
                        textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge/*, color: Theme.of(context).disabledColor*/),
                      ),

                      Row(mainAxisSize: MainAxisSize.min, children: [

                        Text(
                          DateConverter.differenceInMinute(null, order.createdAt, null, order.scheduleAt) < 5 ? '1 - 5 ${'min'.tr}'
                              : DateConverter.convertMinutesToDayHourMinute(DateConverter.differenceInMinute(null, order.createdAt, null, order.scheduleAt)),
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                        ),
                        // const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        // Text('min'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyMedium!.color)),
                      ]),

                      Text(
                        'away_from_restaurant_hurry_up'.tr,
                        textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge/*, color: Theme.of(context).disabledColor*/),
                      ),

                    ]) : Text(
                      'your_food_is_ready_to_serve_hurry_up'.tr,
                      textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge/*, color: Theme.of(context).disabledColor*/),
                    ) : Text(
                      'enjoy_your_meal'.tr,
                      textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge/*, color: Theme.of(context).disabledColor*/),
                    ),
                  )),

                  SizedBox(height: Dimensions.paddingSizeDefault),

                ],
              ),
            ),
            SizedBox(height: Dimensions.paddingSizeDefault),

          ]) : Column(children: [

            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(order.orderStatus == 'pending' ? Images.pendingOrderDetails : (order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover')
                ? Images.preparingFoodOrderDetails : Images.animateDeliveryMan, fit: BoxFit.contain, height: 180)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('your_food_will_delivered_within'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [

                Text(
                  DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt) < 5 ? '1 - 5'
                      : '${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)-5} '
                      '- ${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)}',
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('min'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          ]) : const SizedBox() : const SizedBox(),

          (pastOrder) ? CustomImageWidget(
            image: '${order.restaurant!.coverPhotoFullUrl}',
            height: 160, width: double.infinity,
            isRestaurant: true,
          ): const SizedBox(),

          Container(
            decoration: !isDesktop ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
            ) : null,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              !isDesktop ? Text(subscription ? 'subscription_details'.tr : 'general_info'.tr, style: robotoMedium) : const SizedBox(),
              SizedBox(height: !isDesktop ? Dimensions.paddingSizeLarge : 0),

              subscription ? Row(children: [
                Text('order_created'.tr, style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                const Expanded(child: SizedBox()),

                Text(DateConverter.dateTimeStringToDateTime(order.createdAt!), style: robotoRegular),

              ]) : Row(children: [
                Text('${'order_id'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(order.id.toString(), style: robotoMedium),
                const Expanded(child: SizedBox()),

                !isDineIn ? Row(children: [
                  const Icon(Icons.watch_later, size: 17),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    DateConverter.dateTimeStringToDateTime(order.createdAt!),
                    style: robotoRegular,
                  ),
                ]) : const SizedBox(),
              ]),
              const Divider(height: Dimensions.paddingSizeLarge),

              subscription ? Row(children: [
                Text('status'.tr, style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                const Expanded(child: SizedBox()),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 3),
                  decoration: BoxDecoration(
                    color: (subscription ? order.subscription!.status == 'canceled' || order.subscription!.status == 'expired' : (order.orderStatus == 'failed' || cancelled || order.orderStatus == 'refund_request_canceled'))
                      ? Colors.red.withValues(alpha: 0.1) : order.orderStatus == 'refund_requested' ? Colors.yellow.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(
                    delivered ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(order.delivered!)}'
                        : subscription ? order.subscription!.status!.tr : order.orderStatus!.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: (subscription ? order.subscription!.status == 'canceled' || order.subscription!.status == 'expired' : (order.orderStatus == 'failed' || cancelled || order.orderStatus == 'refund_request_canceled'))
                        ? Colors.red : order.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green,
                    ),
                  ),
                ),

              ]) : const SizedBox(),

              isDineIn ? Row(children: [
                Text('${'order_date'.tr}:', style: robotoRegular),
                Spacer(),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(DateConverter.dateTimeStringToDateTime(order.createdAt!), style: robotoMedium),
              ]) : const SizedBox(),
              isDineIn ? const Divider(height: Dimensions.paddingSizeExtraLarge) : const SizedBox(),

              isDineIn ? Row(children: [
                Text('${'dine_in_date'.tr}:', style: robotoRegular),
                Spacer(),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: robotoMedium),
              ]) : const SizedBox(),
              isDineIn ? const Divider(height: Dimensions.paddingSizeExtraLarge) : const SizedBox(),

              subscription ? const Divider(height: Dimensions.paddingSizeExtraLarge) : const SizedBox(),

              order.scheduled == 1 ? Row(children: [
                Text('${'scheduled_at'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: robotoMedium),
              ]) : const SizedBox(),
              order.scheduled == 1 ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Row(children: [
                Text('${order.orderType == 'delivery' ? 'delivery_verification_code'.tr : 'order_verification_code'.tr}:', style: robotoRegular),
                const Expanded(child: SizedBox()),
                Text(order.otp!, style: robotoMedium),
              ]) : const SizedBox(),
              Get.find<SplashController>().configModel!.orderDeliveryVerification! ?const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              Row(children: [
                Text(order.orderType!.tr, style: robotoRegular),
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(
                    cod ? 'cash_on_delivery'.tr
                        : order.paymentMethod == 'wallet' ? 'wallet_payment'.tr
                        : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                        : order.paymentMethod == 'offline_payment' ? 'offline_payment'.tr : 'digital_payment'.tr,
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ),
              ]),
              const Divider(height: Dimensions.paddingSizeLarge),

              subscription ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(children: [
                  Text('type'.tr, style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  const Expanded(child: SizedBox()),

                  Text(order.subscription!.type!.tr, style: robotoRegular),

                  Text(' (${DateConverter.dateTimeToMonth(order.subscription!.startAt!)} ''- ${DateConverter.dateTimeToMonth(order.subscription!.endAt!)})',
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ]),
                const Divider(height: Dimensions.paddingSizeExtraLarge),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text('${'subscription_schedule'.tr}:', style: robotoMedium),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Text('you_will_get_your_order_daily_at'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),

                      ]),

                      schedules.length > 1 ? const SizedBox() : SizedBox(height: 35, width: 88, child: ListView.builder(
                        itemCount: schedules.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusSmall),
                            dashPattern: const [3, 3],
                            color: Theme.of(context).disabledColor,
                            padding: EdgeInsets.zero,
                            strokeWidth: 1,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(
                                  schedules[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: robotoRegular,
                                ),
                              ]),
                            ),
                          );
                        },
                      )),

                    ]),
                    SizedBox(height: schedules.length > 1 ? Dimensions.paddingSizeDefault : 0),

                    schedules.length > 1 ? SizedBox(height: ResponsiveHelper.isDesktop(context) ? 50 : 45, child: ListView.builder(
                      itemCount: schedules.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {

                        String schedulesDay = schedules[index].split(' ')[0];
                        String schedulesTime = '${schedules[index].split(' ')[1].replaceAll('(', '')} ${schedules[index].split(' ')[2].replaceAll(')', '')}';

                        return Padding(
                          padding: EdgeInsets.only(right: index == schedules.length - 1 ? 0 : Dimensions.paddingSizeSmall),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusSmall),
                            dashPattern: const [3, 3],
                            color: Theme.of(context).disabledColor,
                            padding: EdgeInsets.zero,
                            strokeWidth: 1,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text(schedulesDay, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoRegular),
                                Text(schedulesTime, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoRegular),
                              ]),
                            ),
                          ),
                        );
                      },
                    )) : const SizedBox(),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                Row(children: [

                  Expanded(child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true, useRootNavigator: true, context: Get.context!,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                        ),
                        builder: (context) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                            child: LogBottomSheetWidget(isDeliveryLog: true, subscriptionID: order.subscriptionId, totalAmount: totalAmount, orderQuantity: order.subscription!.quantity),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      ),
                      child: Text('delivery_log'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                    ),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  Expanded(child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true, useRootNavigator: true, context: Get.context!,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                        ),
                        builder: (context) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                            child: LogBottomSheetWidget(isDeliveryLog: false, subscriptionID: order.subscriptionId),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).hintColor, width: 1),
                      ),
                      child: Text('pause_log'.tr, textAlign: TextAlign.center, style: robotoRegular),
                    ),
                  )),

                ]),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                const Divider(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),

              subscription ? const SizedBox() : Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${'item'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    orderController.orderDetails!.length.toString(),
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(height: 7, width: 7, decoration: BoxDecoration(
                    color: (subscription ? order.subscription!.status == 'canceled' : (order.orderStatus == 'failed' || cancelled || order.orderStatus == 'refund_request_canceled'))
                        ? Colors.red : order.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green ,
                    shape: BoxShape.circle,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    delivered ? '${isDineIn ? 'served_at'.tr : 'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(order.delivered!)}'
                        : subscription ? order.subscription!.status!.tr
                        : isDineIn ? order.orderStatus == 'processing' ? 'cooking'.tr
                        : order.orderStatus == 'handover' ? 'ready_to_serve'.tr
                        : order.orderStatus == 'pending' ? 'pending'.tr
                        : order.orderStatus == 'canceled' ? 'canceled'.tr
                        : order.orderStatus == 'confirmed' ? 'confirmed'.tr
                        : 'served'.tr : order.orderStatus!.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ),

              order.orderType != 'dine_in' ? Column(children: [
                subscription ? const SizedBox() : const Divider(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Text('${'cutlery'.tr}: ', style: robotoRegular),
                  const Expanded(child: SizedBox()),

                  Text(
                    order.cutlery! ? 'yes'.tr : 'no'.tr,
                    style: robotoRegular,
                  ),
                ]),
              ]) : const SizedBox(),

              order.unavailableItemNote != null && order.orderType == 'delivery' ? Column(
                children: [
                  const Divider(height: Dimensions.paddingSizeLarge),
                  Row(children: [
                    Text('${'if_item_is_not_available'.tr}: ', style: robotoMedium),

                    Text(
                      order.unavailableItemNote!.tr,
                      style: robotoRegular,
                    ),
                  ]),
                ],
              ) : const SizedBox(),

              order.deliveryInstruction != null && order.orderType == 'delivery' ? Column(children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Text('${'delivery_instruction'.tr}: ', style: robotoMedium),

                  Text(
                    order.deliveryInstruction!.tr,
                    style: robotoRegular,
                  ),
                ]),
              ]) : const SizedBox(),
              SizedBox(height: order.deliveryInstruction != null && order.orderType == 'delivery' ? Dimensions.paddingSizeSmall : 0),

              cancelled ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),
                Text('${'cancellation_reason'.tr}:', style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.cancellationReason), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationReason ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),

              ]) : const SizedBox(),

              cancelled && order.cancellationNote != null && order.cancellationNote != '' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Text('${'cancellation_note'.tr}:', style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.cancellationNote), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationNote ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),

              ]) : const SizedBox(),

              (order.orderStatus == 'refund_requested' || order.orderStatus == 'refund_request_canceled') ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                const Divider(height: Dimensions.paddingSizeLarge),
                order.orderStatus == 'refund_requested' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  RichText(text: TextSpan(children: [
                    TextSpan(text: '${'refund_note'.tr}:', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                    TextSpan(text: '(${(order.refund != null) ? order.refund!.customerReason : ''})', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  (order.refund != null && order.refund!.customerNote != null) ? InkWell(
                    onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.customerNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund!.customerNote}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (order.refund != null && order.refund!.imageFullUrl != null) ? Dimensions.paddingSizeSmall : 0),

                  (order.refund != null && order.refund!.imageFullUrl != null && order.refund!.imageFullUrl!.isNotEmpty) ? InkWell(
                    onTap: () => showDialog(context: context, builder: (context) {
                      return ImageDialogWidget(imageUrl: order.refund!.imageFullUrl!.isNotEmpty ? order.refund!.imageFullUrl![0] : '');
                    }),
                    child: CustomImageWidget(
                      height: 40, width: 40, fit: BoxFit.cover,
                      image: order.refund != null ? order.refund!.imageFullUrl!.isNotEmpty ? order.refund!.imageFullUrl![0] : '' : '',
                    ),
                  ) : const SizedBox(),
                ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(height: Dimensions.paddingSizeLarge),

                  Text('${'refund_cancellation_note'.tr}:', style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.adminNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund != null ? order.refund!.adminNote : ''}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ),

                ]),
              ]) : const SizedBox(),

              (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Text('additional_note'.tr, style: robotoRegular),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: Dimensions.webMaxWidth,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                  ),
                  child: Text(
                    order.orderNote!,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),
              
              (order.orderReference != null && order.orderReference!.tableNumber != null && !isDesktop) ? Container(
                width: Dimensions.webMaxWidth,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
                  boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), blurRadius: 10)]
                ),
                child: Wrap(runAlignment: WrapAlignment.spaceBetween, children: [

                  (order.orderReference!.tokenNumber != null && order.orderReference!.tokenNumber!.isNotEmpty) ? Row(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset(Images.couponIcon, height: 20, width: 20, color: Theme.of(context).primaryColor),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(order.orderReference!.tokenNumber??'', style: robotoBold),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text('(${'token_no'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
                  ]) : const SizedBox(),

                  Text('${'table_no'.tr} - ${order.orderReference!.tableNumber}',
                    style: robotoRegular.copyWith(color: Colors.blue),
                  ),

                ]),
              ) : const SizedBox(),

              (order.orderStatus == 'delivered' && order.orderProofFullUrl != null && order.orderProofFullUrl!.isNotEmpty) ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('order_proof'.tr, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.5,
                      crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.orderProofFullUrl!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => openDialog(context, order.orderProofFullUrl![index]),
                          child: Center(child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImageWidget(
                              image: order.orderProofFullUrl![index],
                              width: 100, height: 100,
                            ),
                          )),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ) : const SizedBox(),
            ]),
          ),
        ]),
      ),

      (order.orderReference != null && order.orderReference!.tableNumber != null && isDesktop) ? Container(
        // width: Dimensions.webMaxWidth,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, ),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            // border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
            boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), blurRadius: 10)]
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Expanded(
            child: Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(Images.couponIcon, height: 20, width: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text(order.orderReference!.tokenNumber??'', style: robotoBold),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('(${'token_no'.tr})', style: robotoRegular.copyWith(color: Theme.of(context).primaryColor)),
              ]),
            ),
          ),

          Container(height: 40, width: 1, color: Colors.grey),

          Expanded(
            child: Center(
              child: Text('${'table_no'.tr} - ${order.orderReference!.tableNumber}',
                style: robotoRegular.copyWith(color: Colors.blue),
              ),
            ),
          ),

        ]),
      ) : const SizedBox(),


      !ResponsiveHelper.isDesktop(context) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Text('item_info'.tr, style: robotoMedium),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderController.orderDetails!.length,
          itemBuilder: (context, index) {
            return OrderProductWidget(order: order, orderDetails: orderController.orderDetails![index], itemLength: orderController.orderDetails!.length, index: index);
          },
        ),
      ]) : const SizedBox(),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      isDesktop && !isDineIn ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('delivery_details'.tr, style: robotoMedium),
      ) : const SizedBox(),

      !isDineIn ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        !isDesktop ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Text('delivery_details'.tr, style: robotoMedium),
        ) : const SizedBox(),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
            boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withValues(alpha: 0.05) : Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            InkWell(
              onTap: () {
                if(order.restaurant != null && order.restaurant!.latitude != null && order.restaurant!.longitude != null){
                  Get.toNamed(RouteHelper.getMapRoute(
                    AddressModel(
                      id: order.restaurant?.id, address: order.restaurant?.address, latitude: order.restaurant?.latitude,
                      longitude: order.restaurant?.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
                    ), 'restaurant',
                  ));
                }else {
                  showCustomSnackBar('unable_to_launch_google_map'.tr);
                }
              },
              child: DeliveryDetails(from: true, address: order.restaurant?.address ?? ''),
            ),
            const Divider(height: Dimensions.paddingSizeLarge),

            InkWell(
              onTap: () async {
                if(order.deliveryAddress != null && order.deliveryAddress!.latitude != null && order.deliveryAddress!.longitude != null){
                  Get.toNamed(RouteHelper.getMapRoute(
                    AddressModel(
                      id: order.deliveryAddress?.id, address: order.deliveryAddress?.address, latitude: order.deliveryAddress?.latitude,
                      longitude: order.deliveryAddress?.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
                    ), 'user',
                  ));
                }else {
                  showCustomSnackBar('unable_to_launch_google_map'.tr);
                }
              },
              child: DeliveryDetails(from: false, address: order.deliveryAddress?.address ?? ''),
            ),
          ]),
        ),

      ]) : const SizedBox(),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('restaurant_details'.tr, style: robotoMedium),
      ) : const SizedBox(),

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        !isDesktop ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Text('restaurant_details'.tr, style: robotoMedium),
        ) : const SizedBox(),

        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getRestaurantRoute(order.restaurant?.id)),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withValues(alpha: 0.05) : Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              order.restaurant != null ? Row(children: [

                ClipOval(child: CustomImageWidget(
                  image: '${order.restaurant!.logoFullUrl}',
                  height: 50, width: 50, fit: BoxFit.cover, isRestaurant: true,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    order.restaurant!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoMedium,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    order.restaurant!.address!, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),

                ])),

                (takeAway && !isDineIn && (pending || accepted || confirmed || processing || order.orderStatus == 'handover'
                || pickedUp)) ? TextButton.icon(
                  onPressed: () async {
                    String url ='https://www.google.com/maps/dir/?api=1&destination=${order.restaurant!.latitude}'
                        ',${order.restaurant!.longitude}&mode=d';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url, mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('unable_to_launch_google_map'.tr);
                    }
                  },
                  icon: const Icon(Icons.directions), label: Text('direction'.tr),
                ) : const SizedBox(),

                isDineIn ? InkWell(
                  onTap: ()=> Get.toNamed(RouteHelper.getMapRoute(
                    AddressModel(
                      id: order.restaurant!.id, address: order.restaurant!.address, latitude: order.restaurant!.latitude,
                      longitude: order.restaurant!.longitude, contactPersonNumber: '', contactPersonName: '', addressType: '',
                    ), 'order',
                    restaurantName: order.restaurant!.name, restaurant: order.restaurant, isDineOrder: isDineIn,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Images.restaurantIconMarker, height: 25, width: 25, fit: BoxFit.cover),
                  ),
                ) : const SizedBox(),

                (showChatPermission && !delivered && order.orderStatus != 'failed' && !cancelled && order.orderStatus != 'refunded' && !isGuestLoggedIn) ? InkWell(
                  onTap: () async {
                    orderController.cancelTimer();
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBodyModel(orderId: order.id, restaurantId: order.restaurant!.vendorId),
                      user: User(id: order.restaurant!.vendorId, fName: order.restaurant!.name, lName: '', imageFullUrl: order.restaurant!.logoFullUrl),
                    ));
                    orderController.callTrackOrderApi(orderModel: order, orderId: order.id.toString());
                  },
                  child: Image.asset(Images.chatImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ) : const SizedBox(),

                SizedBox(width: order.restaurant!.phone != null ? Dimensions.paddingSizeDefault : 0),

                order.restaurant!.phone != null ? InkWell(
                  onTap: () async {
                    if(await canLaunchUrlString('tel:${order.restaurant!.phone}')) {
                      launchUrlString('tel:${order.restaurant!.phone}', mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('${'can_not_launch'.tr} ${order.restaurant!.phone}');
                    }
                  },
                  child: Image.asset(Images.callImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ) : const SizedBox(),

                SizedBox(width: (!subscription && Get.find<SplashController>().configModel!.refundStatus! && delivered && orderController.orderDetails![0].itemCampaignId == null && !isGuestLoggedIn)
                    ? Dimensions.paddingSizeDefault : 0),

                (!subscription && Get.find<SplashController>().configModel!.refundStatus! && delivered && orderController.orderDetails![0].itemCampaignId == null && !isGuestLoggedIn) ? InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getRefundRequestRoute(order.id.toString())),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
                    child: Text('request_for_refund'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                  ),
                ) : const SizedBox(),

              ]) : Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text(
                  'no_restaurant_data_found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              )),
            ]),
          ),
        ),
      ]),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      order.deliveryMan != null ? Column(children: [

        isDesktop ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text('delivery_man_details'.tr, style: robotoMedium),
        ) : const SizedBox(),

        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          !isDesktop ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Text('delivery_man_details'.tr, style: robotoMedium),
          ) : const SizedBox(),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withValues(alpha: 0.05) : Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [
                ClipOval(child: CustomImageWidget(
                  image: '${order.deliveryMan!.imageFullUrl}',
                  height: 35, width: 35, fit: BoxFit.cover, placeholder: Images.profilePlaceholder,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)
                  ),
                  RatingBarWidget(
                    rating: order.deliveryMan!.avgRating, size: 10,
                    ratingCount: order.deliveryMan!.ratingCount,
                  ),
                ])),

                !isGuestLoggedIn ? InkWell(
                  onTap: () async {
                    orderController.cancelTimer();
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBodyModel(deliverymanId: order.deliveryMan!.id, orderId: int.parse(order.id.toString())),
                      user: User(id: order.deliveryMan!.id, fName: order.deliveryMan!.fName, lName: order.deliveryMan!.lName, imageFullUrl: order.deliveryMan!.imageFullUrl),
                    ));
                    orderController.callTrackOrderApi(orderModel: order, orderId: order.id.toString());
                  },
                  child: Image.asset(Images.chatImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                InkWell(
                  onTap: () async {
                    if(await canLaunchUrlString('tel:${order.deliveryMan!.phone}')) {
                      launchUrlString('tel:${order.deliveryMan!.phone}', mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('${'can_not_launch'.tr} ${order.deliveryMan!.phone}');
                    }

                  },
                  child: Image.asset(Images.callImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ),

              ]),

              order.deliveryMan!.restaurantId != null ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                ),
                padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                margin: EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                child: Text(
                    'this_delivery_man_is_restaurant_delivery_man'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),
              ) : const SizedBox(),

            ]),
          ),
        ]),
      ]) : const SizedBox(),
      SizedBox(height: order.deliveryMan != null ? Dimensions.paddingSizeLarge : 0),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('payment_method'.tr, style: robotoMedium),
      ) : const SizedBox(),

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        !isDesktop ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Text('payment_method'.tr, style: robotoMedium),
        ) : const SizedBox(),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
            boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withValues(alpha: 0.05) : Theme.of(context).primaryColor.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            !isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              order.paymentMethod == 'offline_payment' || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null) ? Text(
                orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status!.tr : '',
                style: robotoMedium.copyWith(color: (orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status.toString() == 'denied' : false) ? Colors.red : Theme.of(context).primaryColor),
              ) : const SizedBox(),
            ]) : const SizedBox(),
            SizedBox(height: (!isDesktop && order.paymentMethod != 'offline_payment') ? Dimensions.paddingSizeSmall : 0),

            order.paymentMethod == 'offline_payment'  || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null)
            ? offlineView(context, orderController, expansionTileController, ongoing, contactNumber) :  Row(children: [

              Image.asset(
                order.paymentMethod == 'cash_on_delivery' ? Images.cash : order.paymentMethod == 'wallet' ? Images.wallet
                : order.paymentMethod == 'partial_payment' ? Images.partialWallet : Images.digitalPayment,
                width: 24, height: 24,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Text(
                  order.paymentMethod == 'cash_on_delivery' ? 'cash'.tr : order.paymentMethod == 'wallet' ? 'wallet'.tr
                  : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr : 'digital'.tr,
                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor),
                ),
              ),

            ]),
          ]),
        ),
      ]),
    ]);
  }
}

Widget offlineView(BuildContext context, OrderController orderController, ExpansionTileController controller, bool ongoing, String? contactNumber) {
  return ListTileTheme(
    contentPadding: const EdgeInsets.all(0),
    dense: true,
    horizontalTitleGap: 5.0,
    minLeadingWidth: 0,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: controller,
        leading: Image.asset(
          Images.cash, width: 20, height: 20,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        title: Text(
          'offline_payment'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),
        trailing: Icon(orderController.isExpanded ? Icons.expand_more : Icons.expand_less, size: 18),
        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        onExpansionChanged: (value) => orderController.expandedUpdate(value),

        children: [
          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('seller_payment_info'.tr, style: robotoMedium),
            const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.methodFields!.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputName.toString().replaceAll('_', ' ')} : ', style: robotoRegular),
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputData}', style: robotoRegular),
                ]),
              );
            },
          ) : Text('no_data_found'.tr),
          const Divider(),

          orderController.trackModel!.offlinePayment != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('my_payment_info'.tr, style: robotoMedium),

            (ongoing && orderController.trackModel!.offlinePayment!.data!.status != 'verified') ? InkWell(
              onTap: (){
                Get.dialog(OfflineInfoEditDialog(offlinePayment: orderController.trackModel!.offlinePayment!, orderId: orderController.trackModel!.id!, contactNumber: contactNumber), barrierDismissible: true);
              },
              child: Text('edit_details'.tr, style: robotoBold.copyWith(color: Colors.blue)),
            ) : const SizedBox(),
          ]) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.input!.length,
            itemBuilder: (context, index){
              Input data = orderController.trackModel!.offlinePayment!.input![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${data.userInput.toString().replaceAll('_', ' ')}: ', style: robotoRegular),
                  Text(data.userData.toString(), style: robotoRegular),
                ]),
              );
            },
          ) : const SizedBox(),
          // const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    ),
  );
}

void openDialog(BuildContext context, String imageUrl) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Stack(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          child: PhotoView(
            tightMode: true,
            imageProvider: NetworkImage(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          ),
        ),

        Positioned(top: 0, right: 0, child: IconButton(
          splashRadius: 5,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel, color: Colors.red),
        )),

      ]),
    );
  },
);