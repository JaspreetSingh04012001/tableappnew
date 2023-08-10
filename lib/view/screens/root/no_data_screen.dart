import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/responsive_helper.dart';
import '../../base/custom_button.dart';
import '../home/home_screen.dart';

class NoDataScreen extends StatelessWidget {
  final String text;
  bool backbutton;
  NoDataScreen({super.key, required this.text, this.backbutton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              Images.emptyBox,
              width: MediaQuery.of(context).size.height * 0.22,
              height: MediaQuery.of(context).size.height * 0.22,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Text(
              text,
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.titleLarge?.color),
              textAlign: TextAlign.center,
            ),
            if (backbutton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                  width: 300,
                  transparent: true,
                  buttonText: 'back_to_home'.tr,
                  fontSize: Dimensions.fontSizeDefault,
                  onPressed: () => Get.offAll(() => const HomeScreen()),
                ),
              ),
          ]),
    );
  }
}
