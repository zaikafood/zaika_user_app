import 'package:carousel_slider/carousel_slider.dart';
import 'package:zaika/features/home/controllers/home_controller.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/product/domain/models/basic_campaign_model.dart';
import 'package:zaika/common/models/product_model.dart';
import 'package:zaika/common/models/restaurant_model.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/common/widgets/custom_image_widget.dart';
import 'package:zaika/common/widgets/product_bottom_sheet_widget.dart';
import 'package:zaika/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerViewWidget1 extends StatelessWidget {
  const BannerViewWidget1({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(builder: (homeController) {
      List<String?>? bannerList = homeController.bannerImageList;
      List<dynamic>? bannerDataList = homeController.bannerDataList;

      return (bannerList != null && bannerList.isEmpty) ? const SizedBox() : Container(
        width: MediaQuery.of(context).size.width,
        height: GetPlatform.isDesktop ? 500 : MediaQuery.of(context).size.width * 0.45,
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
        child: bannerList != null ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: 0.95,
                  autoPlayInterval: const Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    homeController.setCurrentIndex(index, true);
                  },
                ),
                itemCount: bannerList.isEmpty ? 1 : bannerList.length,
                itemBuilder: (context, index, _) {
                  return InkWell(
                    onTap: () {
                      if(bannerDataList?[index] is Product) {
                        Product? product = bannerDataList?[index];
                        ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                          builder: (con) => ProductBottomSheetWidget(product: product),
                        ) : showDialog(context: context, builder: (con) => Dialog(
                            child: ProductBottomSheetWidget(product: product)),
                        );
                      }else if(bannerDataList?[index] is Restaurant) {
                        Restaurant restaurant = bannerDataList?[index];
                        Get.toNamed(
                          RouteHelper.getRestaurantRoute(restaurant.id),
                          arguments: RestaurantScreen(restaurant: restaurant),
                        );
                      }else if(bannerDataList?[index] is BasicCampaignModel) {
                        BasicCampaignModel campaign = bannerDataList?[index];
                        Get.toNamed(RouteHelper.getBasicCampaignRoute(campaign));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: GetBuilder<SplashController>(builder: (splashController) {
                          return CustomImageWidget(
                            image: '${bannerList[index]}',
                            fit: BoxFit.cover,
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bannerList.map((bnr) {
                int index = bannerList.indexOf(bnr);
                return TabPageSelectorIndicator(
                  backgroundColor: index == homeController.currentIndex ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withValues(alpha: 0.5),
                  borderColor: Theme.of(context).colorScheme.surface,
                  size: index == homeController.currentIndex ? 10 : 7,
                );
              }).toList(),
            ),

          ],
        ) : Shimmer(
          duration: const Duration(seconds: 2),
          enabled: bannerList == null,
          child: Container(margin: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: Colors.grey[300],
          )),
        ),
      );
    });
  }

}