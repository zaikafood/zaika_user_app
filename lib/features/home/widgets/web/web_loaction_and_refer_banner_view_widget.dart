import 'package:zaika/features/home/widgets/location_banner_view_widget.dart';
import 'package:zaika/features/home/widgets/refer_banner_view_widget.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebLocationAndReferBannerViewWidget extends StatelessWidget {
  const WebLocationAndReferBannerViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(children: [
            const Expanded(
              child: LocationBannerViewWidget(),
            ),

            (Get.find<SplashController>().configModel!.refEarningStatus == 1) ? const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                child: ReferBannerViewWidget(),
              ),
            ) : const SizedBox(),
          ],
          ),
        ),
      ),
    );
  }
}



