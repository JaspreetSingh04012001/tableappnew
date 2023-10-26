import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ProductRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getProductList(int offset, String? productType,
      String? searchPattern, String? categoryId) async {
    String params =
        '?limit=3000&offset=$offset&branch_id=${sharedPreferences.getInt(AppConstants.branch) ?? -1}';
//https://admin.posd2home.au/api/v1/products/latest?limit=3000&offset=1&branch_id=1
    if (productType != null) {
      params = '$params&product_type=$productType';
    }
    if (searchPattern != null) {
      params = '$params&name=$searchPattern';
    }
    if (categoryId != null) {
      params = '$params&category_ids=$categoryId';
    }
    return await apiClient.getData('${AppConstants.productUri}$params');
  }

  Future<Response> getCategoryList() async {
    String params =
        '?branch_id=${sharedPreferences.getInt(AppConstants.branch) ?? -1}';
    //print("fuck ${AppConstants.categoryUri}$params");
    return await apiClient.getData(AppConstants.categoryUri + params);
  }

  Future<Response> getCategoryProductList(String categoryID) async {
    return await apiClient
        .getData('${AppConstants.categoryProductUri}/$categoryID');
  }
}
