import 'dart:async';
import 'dart:io';
import 'package:zaika/features/auth/widgets/sign_in/sign_in_view.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/util/dimensions.dart';
import 'package:zaika/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../util/app_constants.dart';
import '../../../util/styles.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  final bool fromResetPassword;
  const SignInScreen({super.key, required this.exitFromApp, required this.backFromThis, this.fromResetPassword = false});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool _canExit = GetPlatform.isWeb ? true : false;


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async {
        if(widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getInitialRoute());
            }
            // return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            ));
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            // return Future.value(false);
          }
        }else {
          return;
          // Get.back(result: false);
        }
      },
      child: Scaffold(
        backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ? null : !widget.exitFromApp ? AppBar(leading: IconButton(
          onPressed: () => Get.back(result: false),
          icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).textTheme.bodyLarge!.color),
        ), elevation: 0, backgroundColor: Theme.of(context).cardColor) : null,
        body: SafeArea(child: Align(
          alignment: Alignment.center,
          child: Container(
            width: context.width > 700 ? 500 : context.width,
            padding: context.width > 700 ? const EdgeInsets.all(50) : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
            margin: context.width > 700 ? const EdgeInsets.all(50) : EdgeInsets.zero,
            decoration: context.width > 700 ? BoxDecoration(
              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: ResponsiveHelper.isDesktop(context) ? null : [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)],
            ) : null,
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                ResponsiveHelper.isDesktop(context) ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.clear),
                  ),
                ) : const SizedBox(),

                // Image.asset(Images.logo, width: 60),
                // const SizedBox(height: Dimensions.paddingSizeSmall),
                // Image.asset(Images.logoName, width: 100),
                // const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                Row(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(Images.logo, height: 50, width: 50),
                  // const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  // Text(
                  //     AppConstants.appName.tr,
                  //     style:robotoBold.copyWith(
                  //       fontSize: Dimensions.fontSizeOverLarge,
                  //       color: Theme.of(context).primaryColor,
                  //     )),
                  // Image.asset(Images.logoName, height: 50, width: 120),
                ]),


                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                SignInView(exitFromApp: widget.exitFromApp, backFromThis: widget.backFromThis, fromResetPassword: widget.fromResetPassword, isOtpViewEnable: (v){},),

              ]),
            ),
          ),
        )),
      ),
    );
  }

}

