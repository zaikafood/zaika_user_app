import 'dart:async';
import 'dart:io';
import 'package:zaika/app.dart';
import 'package:zaika/features/notification/domain/models/notification_body_model.dart';
import 'package:zaika/features/splash/domain/models/deep_link_body.dart';
import 'package:zaika/helper/notification_helper.dart';
import 'package:zaika/helper/responsive_helper.dart';
import 'package:zaika/util/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:url_strategy/url_strategy.dart';
import 'config/app_config.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  AppConfig.init(Environment.STAGING);
  // AppConstants.baseUrl = 'https://staging.zaika.ltd';
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Staging Base URL

  DeepLinkBody? linkBody;

  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'YOUR_PRODUCTION_API_KEY',
      appId: 'YOUR_PRODUCTION_APP_ID',
      messagingSenderId: 'YOUR_PRODUCTION_SENDER_ID',
      projectId: 'YOUR_PRODUCTION_PROJECT_ID',
    ));
    MetaSEO().config();
  } else if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAGJenQNd-KCVh4vaL4u8D0gRXfCQKYW2o', // Staging Key
        appId:
            '1:533169250177:android:b66d74b7c61006585ed280', // Staging App ID
        messagingSenderId: '533169250177', // Staging Sender ID
        projectId: 'zaika-19c9b', // Staging Project ID
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  Map<String, Map<String, String>> languages = await di.init();

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "YOUR_PRODUCTION_FACEBOOK_APP_ID", // Production Facebook App ID
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  runApp(MyApp(
      languages: languages, body: body, linkBody: linkBody, staging: true));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
