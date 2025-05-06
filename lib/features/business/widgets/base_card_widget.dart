import 'package:flutter/material.dart';
import 'package:zaika/features/auth/controllers/restaurant_registration_controller.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';

class BaseCardWidget extends StatelessWidget {
  final RestaurantRegistrationController restaurantRegistrationController;
  final String title;
  final String? description;
  final int index;
  final Function onTap;
  const BaseCardWidget({super.key, required this.restaurantRegistrationController, required this.title, required this.index, required this.onTap, this.description});

  @override
  Widget build(BuildContext context) {

    bool isDesktop = ResponsiveHelper.isDesktop(context);

    return InkWell(
      onTap: onTap as void Function()?,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: restaurantRegistrationController.businessIndex == index ? Theme.of(context).primaryColor.withValues(alpha: 0.05) : Theme.of(context).cardColor,
            border: restaurantRegistrationController.businessIndex == index && isDesktop ? Border.all(color: Theme.of(context).primaryColor) : !isDesktop ? Border.all(color: restaurantRegistrationController.businessIndex == index ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withValues(alpha: 0.5), width: 0.5) : null,
            boxShadow: restaurantRegistrationController.businessIndex == index ? null : [BoxShadow(color: Colors.grey[200]!, offset: const Offset(5, 5), blurRadius: 10)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
          child: Column(crossAxisAlignment : isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center, children: [

            Align(
              alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
              child: Text(title, style: robotoMedium.copyWith(color: restaurantRegistrationController.businessIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7), fontSize: Dimensions.fontSizeDefault,
                fontWeight: restaurantRegistrationController.businessIndex == index ? FontWeight.w600 : isDesktop ? FontWeight.w600 : FontWeight.w400,
              )),
            ),

            SizedBox(height: isDesktop ? Dimensions.paddingSizeSmall : 0),

            isDesktop ? Text(
              description ?? '', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)), textAlign: TextAlign.justify, textScaler: const TextScaler.linear(1.1),
            ) : const SizedBox(),

          ]),
        ),

        restaurantRegistrationController.businessIndex == index ? Positioned(
          top: -10, right: -10,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.check, size: 14, color: Theme.of(context).cardColor),
          ),

        ) : const SizedBox()
      ]),
    );
  }
}