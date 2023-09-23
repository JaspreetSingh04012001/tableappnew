import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/repository/sales_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_constants.dart';

class SalesController extends GetxController {
  final SalesRepo salesRepo;
  bool loading = true;
  SalesController({required this.salesRepo});
  int? selectedIndex;
  String? from;
  String? to;
  int branchId = Get.find<SplashController>().selectedBranchId ?? 0;
  var selectedSale;
  List sales = [];
  void getSales() async {
    loading = true;
    update();
    DateTime yo = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(yo).replaceAll("/", '-');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response = await salesRepo.getSales(
        branch_id: sharedPreferences.getInt(AppConstants.branch) ?? 0,
        from: from ?? formatted,
        to: to ?? formatted);
    print(sharedPreferences.getInt(AppConstants.branch));
    print(from ?? formatted);
    print(to ?? formatted);
    selectedIndex = null;
    if (response.statusCode == 200) {
      sales = [...response.body["orders"]];
      loading = false;
      update();
    }
  }

  today() async {
    loading = true;
    update();
    DateTime yo = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(yo).replaceAll("/", '-');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response = await salesRepo.getSales(
        branch_id: sharedPreferences.getInt(AppConstants.branch) ?? 0,
        from: formatted,
        to: formatted);
    print(sharedPreferences.getInt(AppConstants.branch));
    print(from ?? formatted);
    print(to ?? formatted);

    if (response.statusCode == 200) {
      sales = [...response.body["orders"]];
      loading = false;
      update();
    }
  }

  week() async {
    loading = true;
    update();
    DateTime yo = DateTime.now();

    // Subtract one week from the current date.
    DateTime oneWeekAgo = yo.subtract(const Duration(days: 7));

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattednow = formatter.format(yo).replaceAll("/", '-');
    final String formattedweek =
        formatter.format(oneWeekAgo).replaceAll("/", '-');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response = await salesRepo.getSales(
        branch_id: sharedPreferences.getInt(AppConstants.branch) ?? 0,
        from: formattedweek,
        to: formattednow);
    // print(sharedPreferences.getInt(AppConstants.branch));

    if (response.statusCode == 200) {
      sales = [...response.body["orders"]];
      loading = false;
      update();
    }
  }

  months() async {
     loading = true;
    update();
    DateTime now = DateTime.now();

    // Subtract seven months from the current date.
    DateTime sevenMonthsAgo = DateTime(now.year, now.month - 7, now.day);

    // If the day is greater than 28 and the month is one of the months with 31 days,
    // subtract one day.
    if (sevenMonthsAgo.day > 28 &&
        [1, 3, 5, 7, 8, 10, 12].contains(sevenMonthsAgo.month)) {
      sevenMonthsAgo = sevenMonthsAgo.subtract(const Duration(days: 1));
    }

    // Print the new date.
    print("jassDaee$sevenMonthsAgo");

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formattednow = formatter.format(now).replaceAll("/", '-');
    final String formattedweek =
        formatter.format(sevenMonthsAgo).replaceAll("/", '-');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response = await salesRepo.getSales(
        branch_id: sharedPreferences.getInt(AppConstants.branch) ?? 0,
        from: formattedweek,
        to: formattednow);
    // print(sharedPreferences.getInt(AppConstants.branch));

    if (response.statusCode == 200) {
      sales = [...response.body["orders"]];
       loading = false;
   
      update();
    }
  }

  Future<Response> sendSales(String year, String? quarter) async {
    // DateTime yo = DateTime.now();
    // final DateFormat formatter = DateFormat('dd/MM/yyyy');
    // final String formatted = formatter.format(yo).replaceAll("/", '-');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Response response = await salesRepo.sendSales(
        branch_id: sharedPreferences.getInt(AppConstants.branch) ?? 0,
        year: year,
        quarter: quarter);
    // print(sharedPreferences.getInt(AppConstants.branch));
    // print(from ?? formatted);
    // print(to ?? formatted);
    return response;
    // if (response.statusCode == 200) {
    //   //  sales = [...response.body["orders"]];
    //   update();
    // }
  }
}
