import 'dart:convert';

import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<CartModel> getCartList() {
    List<String>? carts = [];
    if(sharedPreferences.containsKey(AppConstants.cartList)) {
      carts = sharedPreferences.getStringList(AppConstants.cartList);
    }
    List<CartModel> cartList = [];
    carts?.forEach((cart) {
      cartList.add(CartModel.fromJson(jsonDecode(cart)));
    } );
    carts?.forEach((cart) {
    });
    return cartList;
  }

  void addToCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    for (var cartModel in cartProductList) {
      carts.add(jsonEncode(cartModel));
    }
    sharedPreferences.setStringList(AppConstants.cartList, carts);
  }

  int? getTableNumber() {
    int? number = -1;
    if(sharedPreferences.containsKey(AppConstants.tableNumber)) {
      number = sharedPreferences.getInt(AppConstants.tableNumber);
    }

    return number;
  }

  void clearCartData() {
    if(sharedPreferences.containsKey(AppConstants.cartList)) {
      sharedPreferences.remove(AppConstants.cartList);
    }
  }




}