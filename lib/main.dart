// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';

import 'package:efood_table_booking/controller/localization_controller.dart';
import 'package:efood_table_booking/controller/theme_controller.dart';
import 'package:efood_table_booking/helper/notification_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/theme/dark_theme.dart';
import 'package:efood_table_booking/theme/light_theme.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:efood_table_booking/util/messages.dart';
import 'package:efood_table_booking/view/screens/root/not_found_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  //CachedNetworkImageProvider.debugEnable = true;
  if (!GetPlatform.isWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'apiKey',
            appId: 'appId',
            messagingSenderId: 'messagingSenderId',
            projectId: 'projectId'));
  }
  Map<String, Map<String, String>> languages = await di.init();

  int? orderID;
  try {
    if (GetPlatform.isMobile) {
      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        orderID = notificationAppLaunchDetails?.notificationResponse?.payload !=
                null
            ? int.parse(
                '${notificationAppLaunchDetails?.notificationResponse?.payload}')
            : null;
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  runApp(MyApp(languages: languages, orderID: orderID));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final int? orderID;
  const MyApp({super.key, @required this.languages, required this.orderID});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              translations: Messages(languages: languages!),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
              initialRoute: RouteHelper.splash,
              getPages: RouteHelper.routes,
              unknownRoute:
                  GetPage(name: '/', page: () => const NotFoundScreen()),
              defaultTransition: Transition.topLevel,
              transitionDuration: const Duration(milliseconds: 500),
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
              ),
            );
          },
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
