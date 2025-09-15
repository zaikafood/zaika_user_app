import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaika/features/auth/controllers/auth_controller.dart';
import 'package:zaika/features/cart/controllers/cart_controller.dart';
import 'package:zaika/features/favourite/controllers/favourite_controller.dart';
import 'package:zaika/features/language/controllers/localization_controller.dart';
import 'package:zaika/features/notification/domain/models/notification_body_model.dart';
import 'package:zaika/features/splash/controllers/splash_controller.dart';
import 'package:zaika/features/splash/controllers/theme_controller.dart';
import 'package:zaika/features/splash/domain/models/deep_link_body.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/helper/route_helper.dart';
import 'package:zaika/theme/dark_theme.dart';
import 'package:zaika/theme/light_theme.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:zaika/util/messages.dart';
import 'package:zaika/common/widgets/cookies_view_widget.dart';
import 'package:flutter/gestures.dart';

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  final DeepLinkBody? linkBody;
  final bool staging;
  const MyApp(
      {super.key,
      required this.languages,
      required this.body,
      required this.linkBody,
      this.staging = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getFcmToken();
    _route();
  }

  Future<void> getFcmToken() async {
    String? _token;
    await FirebaseMessaging.instance.requestPermission();

    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _token = token;
    });
    print("FCM Token: $_token");
  }

  Future<void> _route() async {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      if (!Get.find<AuthController>().isLoggedIn() &&
          !Get.find<AuthController>().isGuestLoggedIn()) {
        await Get.find<AuthController>().guestLogin();
      }
      if (Get.find<AuthController>().isLoggedIn() ||
          Get.find<AuthController>().isGuestLoggedIn()) {
        Get.find<CartController>().getCartDataOnline();
      }
      Get.find<SplashController>().getConfigData(fromMainFunction: true);
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<AuthController>().updateToken();
        await Get.find<FavouriteController>().getFavouriteList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: widget.staging ? true : false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  theme: themeController.darkTheme ? dark : light,
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode),
                  initialRoute: GetPlatform.isWeb
                      ? RouteHelper.getInitialRoute()
                      : RouteHelper.getSplashRoute(
                          widget.body, widget.linkBody),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, widget) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1)),
                        child: Material(
                            child: Stack(children: [
                          widget!,
                          GetBuilder<SplashController>(
                              builder: (splashController) {
                            if (!splashController.savedCookiesData ||
                                !splashController.getAcceptCookiesStatus(
                                    splashController.configModel?.cookiesText ??
                                        "")) {
                              return ResponsiveHelper.isWeb()
                                  ? const Align(
                                      alignment: Alignment.bottomCenter,
                                      child: CookiesViewWidget())
                                  : const SizedBox();
                            } else {
                              return const SizedBox();
                            }
                          })
                        ])));
                  });
        });
      });
    });
  }
}
