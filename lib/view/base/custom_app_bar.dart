import 'package:efood_table_booking/controller/printer_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/view/base/askViewDialog.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:efood_table_booking/view/screens/cart/cart_screen.dart';
import 'package:efood_table_booking/view/screens/home/Sales/sales.dart';
import 'package:efood_table_booking/view/screens/order/widget/invoice_print_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/product_controller.dart';
import '../../controller/theme_controller.dart';
import '../screens/home/widget/category_view.dart';
import '../screens/home/widget/search_bar_view.dart';
import '../screens/order/widget/order_success_screen.dart';
import '../screens/promotional_page/widget/setting_widget.dart';
import 'animated_dialog.dart';
import 'cart_widget.dart';
import 'custom_rounded_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  const CustomAppBar(
      {super.key,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.showCart = false});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isTab(context)
        ? TabAppBar(
            ishome: showCart,
          )
        : PreferredSize(
            preferredSize: const Size(double.maxFinite, 60),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 6),
                        blurRadius: 12,
                        spreadRadius: -3)
                  ]),
              child: AppBar(
                elevation: 0,
                title: CustomImage(
                  image:
                      '${Get.find<SplashController>().configModel?.baseUrls?.restaurantImageUrl}/${Get.find<SplashController>().configModel?.restaurantLogo}',
                  height: 50,
                  placeholder: Images.logo,
                ),
                centerTitle: true,
                leading: isBackButtonExist
                    ? Padding(
                        padding:
                            EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                offset: const Offset(0, 4.44),
                                blurRadius: 4.44,
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: InkWell(
                            onTap: () => onBackPressed != null
                                ? onBackPressed!()
                                : Get.back(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_back_ios,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                actions: showCart
                    ? [
                        IconButton(
                          onPressed: () {
                            Get.to(() => const CartScreen(),
                                transition: Transition.leftToRight,
                                duration: const Duration(milliseconds: 300));
                          },
                          icon: CartWidget(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                              size: 25),
                        ),
                      ]
                    : null,
              ),
            ),
          );
  }

  @override
  Size get preferredSize => Size(
      Dimensions.webMaxWidth, ResponsiveHelper.isTab(Get.context) ? 70 : 60);
}

class TabAppBar extends StatefulWidget implements PreferredSizeWidget {
  bool ishome = false;
  TabAppBar({Key? key, required this.ishome}) : super(key: key);

  @override
  State<TabAppBar> createState() => _TabAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _TabAppBarState extends State<TabAppBar> {
  final _scrollController = ScrollController();
  late String selectedProductType;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    final productController = Get.find<ProductController>();

    selectedProductType = productController.productTypeList.first;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).cardColor.withOpacity(0.1),
                    offset: const Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: -3,
                  ),
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel?.baseUrls?.restaurantImageUrl}/${Get.find<SplashController>().configModel?.restaurantLogo}',
                    height: 50,
                    placeholder: Images.logo,
                  ),
                ),
                if (Get.currentRoute.contains("/home"))
                  Expanded(
                    child: SearchBarView(
                        controller: TextEditingController(), type: null),
                  ),
                if (Get.currentRoute.contains("/home"))
                  Row(
                    children: [
                      SizedBox(
                        width: Dimensions.paddingSizeLarge,
                      ),
                      CustomRoundedButton(
                        image: Images.themeIcon,
                        onTap: () => Get.find<ThemeController>().toggleTheme(),
                      ),
                      SizedBox(
                        width: Dimensions.paddingSizeLarge,
                      ),
                      CustomRoundedButton(
                          image: Images.settingIcon,
                          onTap: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return const Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: SettingWidget(formSplash: false),
                                );
                              },
                              animationType:
                                  DialogTransitionType.slideFromBottomFade,
                            );
                          }),
                      if (Get.currentRoute.contains("/home"))
                        SizedBox(
                          width: Dimensions.paddingSizeLarge,
                        ),
                      if (Get.currentRoute.contains("/home"))
                        CustomRoundedButton(
                          image: Images.order,
                          //  onTap: () => Get.to(() => const AllOrdersScreen()),
                          onTap: () => Get.to(() => const OrderSuccessScreen()),
                        ),
                      if (Get.currentRoute.contains("/home"))
                        SizedBox(
                          width: Dimensions.paddingSizeLarge,
                        ),
                      if (Get.currentRoute.contains("/home"))
                        GetBuilder<PrinterController>(
                            builder: (printerController) {
                          return CustomRoundedButton(
                              image: Images.order,
                              widget: Icon(
                                Icons.print_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                Get.dialog(Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall)),
                                  insetPadding: const EdgeInsets.all(20),
                                  child: InvoicePrintScreen(),
                                ));
                                //   Get.to(const InvoicePrintScreen());
                              });
                        }),
                      SizedBox(
                        width: Dimensions.paddingSizeLarge,
                      ),
                      if (Get.currentRoute.contains("/home"))
                        CustomRoundedButton(
                          image: "assets/image/eye.png",

                          //  onTap: () => Get.to(() => const AllOrdersScreen()),
                          onTap: () {
                            Get.dialog(Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall)),
                              insetPadding: const EdgeInsets.all(20),
                              child: const AskViewDialog(),
                            ));
                            // showAnimatedDialog(
                            //     barrierDismissible: true,
                            //     context: context,
                            //     builder: (context) {

                            //       return AlertDialog(

                            //         title: Text(
                            //           overflow: TextOverflow.ellipsis,
                            //           'Select View for Items',
                            //           style: robotoMedium.copyWith(
                            //               fontSize: Dimensions.fontSizeExtraLarge),
                            //         ),
                            //         content: const AskViewDialog(),
                            //         actionsPadding: EdgeInsets.zero,
                            //         actions: const [],
                            //       );
                            //     });
                          },
                        ),
                      if (Get.currentRoute.contains("/home"))
                        SizedBox(
                          width: Dimensions.paddingSizeLarge,
                        ),
                      if (Get.currentRoute.contains("/home"))
                        CustomRoundedButton(
                          image: Images.accounting,
                          //  onTap: () => Get.to(() => const AllOrdersScreen()),
                          onTap: () => Get.to(() => Sales()),
                        ),
                    ],
                  ),
                SizedBox(width: Dimensions.paddingSizeLarge),

                // Flexible(child: Container(height: ResponsiveHelper.isSmallTab() ? 50 : 70, color: Theme.of(context).primaryColor, ))
              ],
            ),
          ),
          if (Get.currentRoute.contains("/home"))
            GetBuilder<ProductController>(builder: (productController) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CategoryView(onSelected: (id) {
                  if (productController.selectedCategory == id) {
                    productController.setSelectedCategory(null);
                  } else {
                    productController.setSelectedCategory(id);
                  }
                  productController.getProductList(
                    true,
                    true,
                    categoryId: productController.selectedCategory,
                    productType: selectedProductType,
                    searchPattern: searchController.text.trim().isEmpty
                        ? null
                        : searchController.text,
                  );
                }),
              );
            }),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
