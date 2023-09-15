import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final Function onTap;
  const QuantityButton(
      {super.key, required this.isIncrement, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: ResponsiveHelper.isSmallTab()
            ? 30
            : ResponsiveHelper.isTab(context)
                ? 40
                : 30,
        width: ResponsiveHelper.isSmallTab()
            ? 30
            : ResponsiveHelper.isTab(context)
                ? 40
                : 30,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardColor.withOpacity(0.4),
              offset: const Offset(0, 4.44),
              blurRadius: 4.44,
              spreadRadius: 0,
            )
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          size: Dimensions.paddingSizeDefault,
          isIncrement ? Icons.add : Icons.remove,
        ),
      ),
    );
  }
}
