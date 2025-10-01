import 'package:zaika/common/widgets/custom_ink_well_widget.dart';
import 'package:zaika/features/home/widgets/arrow_icon_button_widget.dart';
import 'package:zaika/features/language/controllers/localization_controller.dart';
import 'package:zaika/features/category/controllers/category_controller.dart';
import 'package:zaika/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:zaika/features/restaurant/screens/veg_nonveg_restaurant_screen.dart';
import 'package:zaika/features/splash/domain/models/config_model.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../restaurant/controllers/restaurant_controller.dart';

class WhatOnYourMindViewWidget extends StatelessWidget {
  const WhatOnYourMindViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return GetBuilder<RestaurantController>(builder: (restaurantController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeLarge
                  : Dimensions.paddingSizeOverLarge,
              left: Get.find<LocalizationController>().isLtr
                  ? Dimensions.paddingSizeExtraSmall
                  : 0,
              right: Get.find<LocalizationController>().isLtr
                  ? 0
                  : Dimensions.paddingSizeExtraSmall,
              bottom: ResponsiveHelper.isMobile(context)
                  ? Dimensions.paddingSizeDefault
                  : Dimensions.paddingSizeOverLarge,
            ),
            child: ResponsiveHelper.isDesktop(context)
                ? Text('what_on_your_mind'.tr,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600))
                : Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeSmall,
                        right: Dimensions.paddingSizeDefault),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('what_on_your_mind'.tr,
                            style: robotoBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w600)),
                        ArrowIconButtonWidget(
                            onTap: () =>
                                Get.toNamed(RouteHelper.getCategoryRoute())),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      restaurantController.nonVeg = 0;
                      restaurantController.veg = 1;
                      restaurantController.getRestaurantList(1, true);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            VegNonvegRestaurantScreen(category: "Pure Veg"),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.eco, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Pure Veg',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      restaurantController.veg = 0;
                      restaurantController.nonVeg = 1;
                      restaurantController.getRestaurantList(1, true);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            VegNonvegRestaurantScreen(category: "Veg Non-Veg"),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.set_meal, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Veg Non-Veg',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          SizedBox(
            height: ResponsiveHelper.isMobile(context) ? 130 : 170,
            child: categoryController.categoryList != null
                ? ListView.builder(
                    physics: ResponsiveHelper.isMobile(context)
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault),
                    itemCount: categoryController.categoryList!.length > 10
                        ? 10
                        : categoryController.categoryList!.length,
                    itemBuilder: (context, index) {
                      if (index == 9) {
                        return ResponsiveHelper.isDesktop(context)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Dimensions.paddingSizeSmall,
                                    top: Dimensions.paddingSizeSmall),
                                child: Container(
                                  width: 70,
                                  padding: const EdgeInsets.only(
                                      left: Dimensions.paddingSizeExtraSmall,
                                      right: Dimensions.paddingSizeExtraSmall,
                                      top: Dimensions.paddingSizeSmall,
                                      bottom: Dimensions.paddingSizeSmall),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      onTap: () => Get.toNamed(
                                          RouteHelper.getCategoryRoute()),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).cardColor,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withValues(alpha: 0.3)),
                                        ),
                                        child: Icon(Icons.arrow_forward,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeSmall,
                            right: Dimensions.paddingSizeDefault),
                        child: Container(
                          width: ResponsiveHelper.isMobile(context) ? 80 : 100,
                          height:
                              ResponsiveHelper.isMobile(context) ? 110 : 100,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: CustomInkWellWidget(
                            onTap: () =>
                                Get.toNamed(RouteHelper.getCategoryProductRoute(
                              categoryController.categoryList![index].id,
                              categoryController.categoryList![index].name!,
                            )),
                            radius: Dimensions.radiusSmall,
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withValues(alpha: 0.2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault),
                                  child: CustomImageWidget(
                                    image:
                                        '${categoryController.categoryList![index].imageFullUrl}',
                                    height: ResponsiveHelper.isMobile(context)
                                        ? 70
                                        : 100,
                                    width: ResponsiveHelper.isMobile(context)
                                        ? 70
                                        : 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveHelper.isMobile(context)
                                      ? Dimensions.paddingSizeDefault
                                      : Dimensions.paddingSizeLarge),
                              Expanded(
                                  child: Text(
                                categoryController.categoryList![index].name!,
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              )),
                            ]),
                          ),
                        ),
                      );
                    },
                  )
                : WebWhatOnYourMindViewShimmer(
                    categoryController: categoryController),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
        ]);
      });
    });
  }
}

class WebWhatOnYourMindViewShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const WebWhatOnYourMindViewShimmer(
      {super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.isMobile(context) ? 120 : 170,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall,
                top: Dimensions.paddingSizeSmall),
            child: Container(
              width: ResponsiveHelper.isMobile(context) ? 70 : 108,
              height: ResponsiveHelper.isMobile(context) ? 70 : 100,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              margin: EdgeInsets.only(
                  top: ResponsiveHelper.isMobile(context)
                      ? 0
                      : Dimensions.paddingSizeSmall),
              child: Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).shadowColor),
                      height: ResponsiveHelper.isMobile(context) ? 70 : 80,
                      width: 70,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: Shimmer(
                    child: Container(
                      height: ResponsiveHelper.isMobile(context) ? 10 : 15,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color: Theme.of(context).shadowColor),
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
