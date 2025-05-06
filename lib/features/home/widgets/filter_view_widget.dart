import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaika/features/restaurant/controllers/restaurant_controller.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';

class FilterViewWidget extends StatelessWidget {
  const FilterViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurant) {
      return PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 'all',
              child: Text(
                'all'.tr,
                style: robotoMedium.copyWith(
                  color: restaurant.restaurantType == 'all' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
                ),
              ),

            ),

            PopupMenuItem(
              value: 'take_away',
              child: Text(
                'take_away'.tr,
                style: robotoMedium.copyWith(
                  color: restaurant.restaurantType == 'take_away' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'delivery',
              child: Text(
                'delivery'.tr,
                style: robotoMedium.copyWith(
                  color: restaurant.restaurantType == 'delivery' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'dine_in',
              child: Text(
                'dine_in'.tr,
                style: robotoMedium.copyWith(
                  color: restaurant.restaurantType == 'dine_in' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'latest',
              child: Text(
                'latest'.tr,
                style: robotoMedium.copyWith(
                  color: restaurant.restaurantType == 'latest' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
                ),
              ),
            ),
            PopupMenuItem(
              value: 'popular',
              child: Text(
                'popular'.tr,
                style: robotoMedium.copyWith(
                  color: restaurant.restaurantType == 'popular' ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor,
                ),
              ),
            ),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
          ),
          child: Icon(Icons.tune, color: Theme.of(context).primaryColor, size: 20),
        ),
        onSelected: (dynamic value) => restaurant.setRestaurantType(value),
      );
    });
  }
}