import 'package:zaika/features/splash/controllers/theme_controller.dart';
import 'package:zaika/features/loyalty/controllers/loyalty_controller.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:zaika/util/styles.dart';
import 'package:zaika/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CongratulationDialogue extends StatelessWidget {
  const CongratulationDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(Get.find<ThemeController>().darkTheme ? Images.giftBox1 : Images.giftBox, width: 100, height: 100),

                Text('congratulations'.tr , style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(
                    '${'you_will_earn'.tr} ${Get.find<LoyaltyController>().getEarningPint()} ${'points_after_completing_this_order'.tr}',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                CustomButtonWidget(
                  buttonText: 'visit_loyalty_points'.tr,
                  onPressed: (){
                    Get.find<LoyaltyController>().saveEarningPoint('');
                    Get.back();
                    Get.toNamed(RouteHelper.getLoyaltyRoute());
                  },
                )
              ]),
            ),

            Positioned(
              top: 5, right: 5,
                child: InkWell(
                  onTap: (){
                    Get.find<LoyaltyController>().saveEarningPoint('');
                    Get.back();
                  },
                    child: const Icon(Icons.clear, size: 18),
                ),
            )
          ],
        ),
      ),
    );
  }
}
