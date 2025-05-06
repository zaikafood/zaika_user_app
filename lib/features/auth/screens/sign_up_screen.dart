import 'package:zaika/features/auth/widgets/sign_up_widget.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:zaika/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  final bool exitFromApp;
  const SignUpScreen({super.key, this.exitFromApp = false});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? null : !widget.exitFromApp ? AppBar(leading: IconButton(
        onPressed: () => Get.back(result: false),
        icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).textTheme.bodyLarge!.color),
      ), elevation: 0, backgroundColor: Theme.of(context).cardColor) : null,
      body: SafeArea(child: Center(
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700 ? const EdgeInsets.all(40) : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          decoration: context.width > 700 ? BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ) : null,
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              ResponsiveHelper.isDesktop(context) ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.clear),
                ),
              ) : const SizedBox(),

              Image.asset(Images.logo, width: 60),
              // const SizedBox(height: Dimensions.paddingSizeSmall),
              // Text(
              //     AppConstants.appName.tr,
              //     style:robotoBold.copyWith(
              //       fontSize: Dimensions.fontSizeOverLarge,
              //       color: Theme.of(context).primaryColor,
              // )),
              // Image.asset(Images.logoName, width: 100),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Align(
                alignment: Alignment.topLeft,
                child: Text('sign_up'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              const SignUpWidget(),

            ]),
          ),
        ),
      )),
    );
  }

}

