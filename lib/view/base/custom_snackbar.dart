import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError = true, bool isToast = false}) {
  if(!ResponsiveHelper.isTab(Get.context) && isToast) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        fontSize: 16.0
    );
  }else{
    ScaffoldMessenger.of(Get.context!).clearSnackBars();
    final width = MediaQuery.of(Get.context!).size.width;
    ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(key: UniqueKey(), content: Text(message,),
        margin: ResponsiveHelper.isTab(Get.context!) ?  EdgeInsets.only(
          right: width * 0.60, bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeExtraSmall,
        ) : EdgeInsets.all(Dimensions.paddingSizeSmall),
        behavior: SnackBarBehavior.floating ,
        dismissDirection: DismissDirection.down,
        backgroundColor: isError ? Theme.of(Get.context!).colorScheme.error : Colors.green)
    );
  }


}