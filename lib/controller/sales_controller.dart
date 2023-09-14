import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/repository/sales_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_constants.dart';

class SalesController extends GetxController {
  final SalesRepo salesRepo;
  SalesController({required this.salesRepo});
  int? selectedIndex;
  String? from;
  String? to;
  int branchId = Get.find<SplashController>().selectedBranchId ?? 0;
  var selectedSale;
  List sales = [];
  void getSales() async {
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

    if (response.statusCode == 200) {
      sales = [...response.body["orders"]];
      update();
    }
  }
}
