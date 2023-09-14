import 'dart:convert';

import 'package:efood_table_booking/data/api/api_client.dart';
import 'package:efood_table_booking/data/model/response/order_success_model.dart';
import 'package:efood_table_booking/data/model/response/place_order_body.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getOrderDetails(String orderID, String orderToken) async {
    return await apiClient.getData(
      '${AppConstants.orderDetailsUri}order_id=$orderID&branch_table_token=$orderToken',
    );
  }

  Future<Response> getOderList(String orderToken) async {
    return await apiClient.getData('${AppConstants.orderList}$orderToken');
  }

  //
  Future<Response> placeOrder(PlaceOrderBody orderBody) async {
    return await apiClient.postData(
        AppConstants.placeOrderUri, orderBody.toJson());
  }

  Future<Response> upDateOrder(int orderId, String paymentStatus) async {
    return await apiClient.postData(AppConstants.orderUpdate,
        {"order_id": orderId, "payment_status": paymentStatus});
  }

  void setOrderID(String orderInfo) {
    sharedPreferences.setString(AppConstants.orderInfo, orderInfo);
  }

  String getOrderInfo() {
    return sharedPreferences.getString(AppConstants.orderInfo) ?? '';
  }

  List<OrderSuccessModel> getOrderSuccessModelList() {
    List<String>? orderList = [];
    if (sharedPreferences.containsKey(AppConstants.orderInfo)) {
      orderList = sharedPreferences.getStringList(AppConstants.orderInfo);
    }
    List<OrderSuccessModel> orderSuccessList = [];
    orderList?.forEach((orderSuccessModel) => orderSuccessList
        .add(OrderSuccessModel.fromJson(jsonDecode(orderSuccessModel))));
    return orderSuccessList;
  }

  void addOrderModel(List<OrderSuccessModel> orderSuccessList) {
    List<String> orderList = [];
    for (var orderModel in orderSuccessList) {
      orderList.add(jsonEncode(orderModel));
    }
    sharedPreferences.setStringList(AppConstants.orderInfo, orderList);
  }
}
