import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget child;
  const NoInternetScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.noInternet, width: 150, height: 150),
            Text('oops'.tr, style: robotoBold.copyWith(
              fontSize: 30,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(
              'no_internet_connection'.tr,
              textAlign: TextAlign.center,
              style: robotoRegular,
            ),
            const SizedBox(height: 40),
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                onPressed: () async {
                  if(await Connectivity().checkConnectivity() != ConnectivityResult.none) {
                    Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (_) => child));
                  }
                },
                buttonText: 'retry'.tr,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
