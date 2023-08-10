import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Function onYesPressed;
  final bool isLogOut;
  final Function? onNoPressed;
  const ConfirmationDialog({super.key, required this.icon, required this.title, required this.description, required this.onYesPressed,
    this.isLogOut = false, required this.onNoPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width * 0.4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        ),
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge,  horizontal: Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Icon(icon, size: 50,color: Theme.of(context).colorScheme.error),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Text(
              title, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text(description, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          ),
          SizedBox(height: Dimensions.paddingSizeLarge),

          Row(children: [
            Expanded(child: TextButton(
              onPressed: () => isLogOut ? onYesPressed() : onNoPressed != null ? onNoPressed!() : Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              ),
              child: Text(
                isLogOut ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            )),
            SizedBox(width: Dimensions.paddingSizeLarge),

            Expanded(child: CustomButton(
              buttonText: isLogOut ? 'no'.tr : 'yes'.tr,
              onPressed: () => isLogOut ? Get.back() : onYesPressed(),
              radius: Dimensions.radiusSmall, height: 40,
            )),
          ]),

        ]));
  }
}
