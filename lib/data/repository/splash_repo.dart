import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getConfigData() async {
    Response response = await apiClient.getData(AppConstants.configUri);
    return response;
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.languageCode)) {
      return sharedPreferences.setString(AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.cartList)) {
      return sharedPreferences.setStringList(AppConstants.cartList, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.tableNumber)) {
      return sharedPreferences.setInt(AppConstants.tableNumber, -1);
    }

    if(!sharedPreferences.containsKey(AppConstants.branch)) {
      return sharedPreferences.setInt(AppConstants.branch, -1);
    }
    if(!sharedPreferences.containsKey(AppConstants.orderInfo)) {
      return sharedPreferences.setString(AppConstants.orderInfo, '');
    }
    if(!sharedPreferences.containsKey(AppConstants.isFixTable)) {
      return sharedPreferences.setBool(AppConstants.isFixTable, false);
    }

    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  int getTable() => sharedPreferences.getInt(AppConstants.tableNumber) ?? -1;
  void satTable(int number) => sharedPreferences.setInt(AppConstants.tableNumber, number);

  void setFixTable(bool value) => sharedPreferences.setBool(AppConstants.isFixTable, value);
  bool getFixTable() => sharedPreferences.getBool(AppConstants.isFixTable) ?? false;

  int getBranchId() => sharedPreferences.getInt(AppConstants.branch) ?? -1;
  void setBranchId(int id) => sharedPreferences.setInt(AppConstants.branch, id);
}
