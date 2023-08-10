import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:efood_table_booking/view/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  const CustomAppBar({super.key, this.isBackButtonExist = true,  this.onBackPressed, this.showCart = false});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isTab(context)
        ? const TabAppBar() :
    PreferredSize(
      preferredSize: const Size(double.maxFinite, 60),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: -3
              )
            ]),

        child: AppBar(
          elevation: 0,
          title: CustomImage(image: '${Get.find<SplashController>().configModel?.baseUrls?.restaurantImageUrl}/${
              Get.find<SplashController>().configModel?.restaurantLogo}',
            height: 50, placeholder: Images.logo,
          ),
          centerTitle: true,
          leading: isBackButtonExist ? Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.10), offset: const Offset(0, 4.44), blurRadius: 4.44, spreadRadius: 0,
                )],
              ),
              child: InkWell(
                onTap: () => onBackPressed != null ? onBackPressed!() : Get.back(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge?.color),
                    const SizedBox(width: 8.0),
                  ],
                ),
              ),
            ),
          ) : const SizedBox(),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          actions: showCart ? [
            IconButton(onPressed: (){
              Get.to(()=> const CartScreen(), transition: Transition.leftToRight, duration: const Duration(milliseconds: 300));
            },
              icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color!, size: 25),
            ),

          ] : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, ResponsiveHelper.isTab(Get.context) ? 70 : 60);
}

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).cardColor.withOpacity(0.1),
                  offset: const Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: -3,
                ),
              ]),
          child: Row(children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: CustomImage(image: '${Get.find<SplashController>().configModel?.baseUrls?.restaurantImageUrl}/${
                  Get.find<SplashController>().configModel?.restaurantLogo}',
                height: 50, placeholder: Images.logo,
              ),
            ),
            SizedBox(width: Dimensions.paddingSizeLarge),

            Flexible(child: Container(height: ResponsiveHelper.isSmallTab() ? 50 : 70, color: Theme.of(context).primaryColor, ))

          ],),
        ),
      ],),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
