import 'package:efood_table_booking/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRoundedButton extends StatelessWidget {
  final String image;
  final Function onTap;
  final Widget? widget;
  final BoxBorder? boxBorder;
  const CustomRoundedButton({
    Key? key,
    required this.image,
    required this.onTap,
    this.widget,
    this.boxBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      radius: 30,
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5)
              : Theme.of(context).cardColor,
          shape: BoxShape.circle,
          border: boxBorder,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.10),
              offset: const Offset(0, 4.64),
              blurRadius: 9.29,
            )
          ],
        ),
        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: widget ??
            Image.asset(
              image,
              width: Dimensions.paddingSizeExtraLarge,
            ),
      ),
    );
  }
}
