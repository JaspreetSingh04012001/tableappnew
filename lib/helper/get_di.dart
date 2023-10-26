import 'dart:convert';

import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/language_controller.dart';
import 'package:efood_table_booking/controller/localization_controller.dart';
import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/printer_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/promotional_controller.dart';
import 'package:efood_table_booking/controller/sales_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/controller/theme_controller.dart';
import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/data/model/response/language_model.dart';
import 'package:efood_table_booking/data/repository/cart_repo.dart';
import 'package:efood_table_booking/data/repository/language_repo.dart';
import 'package:efood_table_booking/data/repository/order_repo.dart';
import 'package:efood_table_booking/data/repository/product_repo.dart';
import 'package:efood_table_booking/data/repository/sales_repo.dart';
import 'package:efood_table_booking/data/repository/splash_repo.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(
      () => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => ProductRepo(sharedPreferences: Get.find(),apiClient: Get.find()));
  Get.lazyPut(() => SalesRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => OrderRepo(sharedPreferences: Get.find(), apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => SplashController(splashRepo: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LanguageController(sharedPreferences: Get.find()));
  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => PromotionalController());
  Get.lazyPut(() => SalesController(salesRepo: Get.find()), fenix: true);
  Get.put(
    PrinterController(),
    permanent: true,
  );
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}
