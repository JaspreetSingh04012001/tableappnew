import 'dart:async';

import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/theme_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/askViewDialog.dart';
import 'package:efood_table_booking/view/base/body_template.dart';
import 'package:efood_table_booking/view/base/confirmation_dialog.dart';
import 'package:efood_table_booking/view/base/custom_app_bar.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/base/fab_circular_menu.dart';
import 'package:efood_table_booking/view/screens/home/widget/category_view.dart';
import 'package:efood_table_booking/view/screens/home/widget/filter_button_widget.dart';
import 'package:efood_table_booking/view/screens/home/widget/page_view_product.dart';
import 'package:efood_table_booking/view/screens/home/widget/product_shimmer_list.dart';
import 'package:efood_table_booking/view/screens/home/widget/product_widget.dart';
import 'package:efood_table_booking/view/screens/home/widget/search_bar_view.dart';
import 'package:efood_table_booking/view/screens/order/widget/invoice_print_screen.dart';
import 'package:efood_table_booking/view/screens/order/widget/order_success_screen.dart';
import 'package:efood_table_booking/view/screens/promotional_page/widget/setting_widget.dart';
import 'package:efood_table_booking/view/screens/root/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../../controller/printer_controller.dart';
import '../../../util/images.dart';
import 'Sales/sales.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  late String selectedProductType;
  final GlobalKey<FabCircularMenuState> _fabKey = GlobalKey();
  Timer? _timer;

  @override
  void initState() {
    final productController = Get.find<ProductController>();
    //Get.find<SalesController>();
    Get.find<OrderController>().getOrderList();
    selectedProductType = productController.productTypeList.first;
    productController.getCategoryList(true);
    productController.getProductList(false, false);

    searchController.addListener(() {
      if (searchController.text.trim().isNotEmpty) {
        productController.isSearchChange(false);
      } else {
        productController.isSearchChange(true);
        FocusScope.of(context).unfocus();
      }
    });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     int totalSize = (productController.totalSize! / 10).ceil();

    //     if (productController.productOffset < totalSize) {
    //       productController.productOffset++;

    //       productController.getProductList(
    //         false,
    //         true,
    //         offset: productController.productOffset,
    //         productType: selectedProductType,
    //         categoryId: productController.selectedCategory,
    //         searchPattern: searchController.text.trim().isEmpty
    //             ? null
    //             : searchController.text,
    //       );
    //     }
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    changeButtonState();
    super.dispose();
  }

  void changeButtonState() {
    if (_fabKey.currentState != null && _fabKey.currentState!.isOpen) {
      _fabKey.currentState?.close();
      _timer?.cancel();
      _timer = null;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      changeButtonState();
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (searchController.text.trim().isEmpty) {
            RouteHelper.openDialog(
                context,
                ConfirmationDialog(
                  title: '${'exit'.tr} !',
                  icon: Icons.question_mark_sharp,
                  description: 'are_you_exit_the_app'.tr,
                  onYesPressed: () => SystemNavigator.pop(),
                  onNoPressed: () => Get.back(),
                ));
          } else {
            searchController.clear();
          }

          return Future.value(false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: ResponsiveHelper.isTab(context)
              ? null
              : const CustomAppBar(
                  isBackButtonExist: false,
                  onBackPressed: null,
                  showCart: true,
                ),
          body: ResponsiveHelper.isTab(context)
              ? BodyTemplate(
                  body: _bodyWidget(),
                  showSetting: true,
                  showOrderButton: true,
                )
              : homeMobileView(),
          floatingActionButton: ResponsiveHelper.isTab(context)
              ? null
              : SpeedDial(
                  closedForegroundColor: Theme.of(context).colorScheme.primary,
                  openForegroundColor: Theme.of(context).colorScheme.background,
                  closedBackgroundColor:
                      Theme.of(context).colorScheme.background,
                  openBackgroundColor: Theme.of(context).colorScheme.background,
                  labelsStyle: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    // color: Colors.white,
                  ),
                  labelsBackgroundColor:
                      Theme.of(context).colorScheme.background,
                  // controller: /* Your custom animation controller goes here */,
                  speedDialChildren: <SpeedDialChild>[
                    SpeedDialChild(
                      child: Image.asset(
                        Images.themeIcon,
                        width: Dimensions.paddingSizeExtraLarge,
                      ),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      label: 'Theme',
                      onPressed: () =>
                          Get.find<ThemeController>().toggleTheme(),
                      closeSpeedDialOnPressed: false,
                    ),
                    SpeedDialChild(
                      child: Image.asset(
                        Images.settingIcon,
                        width: Dimensions.paddingSizeExtraLarge,
                      ),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      label: 'Settings',
                      onPressed: () {
                        Get.bottomSheet(
                          const SettingWidget(formSplash: false),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      closeSpeedDialOnPressed: false,
                    ),
                    SpeedDialChild(
                      child: GetBuilder<PrinterController>(
                          builder: (printerController) {
                        return Icon(
                          Icons.print_rounded,
                          color: Theme.of(context).primaryColor,
                        );
                      }),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      label: 'Printer Setup',
                      onPressed: () {
                        Get.to(() => InvoicePrintScreen(
                              ismobile: true,
                            ));
                      },
                      closeSpeedDialOnPressed: false,
                    ),
                    SpeedDialChild(
                      child: GetBuilder<PrinterController>(
                          builder: (printerController) {
                        return Image.asset(
                          Images.order,
                          width: Dimensions.paddingSizeExtraLarge,
                        );
                      }),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      label: 'Orders',
                      onPressed: () => Get.to(() => const OrderSuccessScreen()),
                      closeSpeedDialOnPressed: false,
                    ),
                    SpeedDialChild(
                      child: GetBuilder<PrinterController>(
                          builder: (printerController) {
                        return Image.asset(
                          "assets/image/eye.png",
                          width: Dimensions.paddingSizeExtraLarge,
                        );
                      }),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      label: 'Views',
                      onPressed: () {
                        Get.dialog(Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSmall)),
                          insetPadding: const EdgeInsets.all(20),
                          child: const AskViewDialog(),
                        ));
                      },
                      closeSpeedDialOnPressed: false,
                    ),
                    SpeedDialChild(
                      child: GetBuilder<PrinterController>(
                          builder: (printerController) {
                        return Image.asset(
                          Images.accounting,
                          width: Dimensions.paddingSizeExtraLarge,
                        );
                      }),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      label: 'Reports',
                      onPressed: () {
                        Get.to(() => Sales(
                              isMobile: true,
                            ));
                        // Get.dialog(Dialog(
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(
                        //           Dimensions.radiusSmall)),
                        //   insetPadding: const EdgeInsets.all(20),
                        //   child: const AskViewDialog(),
                        // ));
                      },
                      closeSpeedDialOnPressed: false,
                    ),

                    //  Your other SpeedDialChildren go here.
                  ],
                  child: const Icon(Icons.add),
                ),
        )

        //  Padding(
        //     padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
        //     child: FabCircularMenu(
        //       onDisplayChange: (isOpen) {
        //         if (isOpen) {
        //           _startTimer();
        //         }
        //       },
        //       key: _fabKey,
        //       ringColor: Theme.of(context).cardColor.withOpacity(0.2),
        //       fabSize: 50,
        //       ringWidth: 100,
        //       ringDiameter: 320,
        //       fabOpenIcon: const Icon(Icons.settings, color: Colors.white),
        //       children: [
        //         CustomRoundedButton(
        //           image: Images.themeIcon,
        //           onTap: () => Get.find<ThemeController>().toggleTheme(),
        //         ),
        //         CustomRoundedButton(
        //             image: Images.settingIcon,
        //             onTap: () {
        //               Get.bottomSheet(
        //                 const SettingWidget(formSplash: false),
        //                 backgroundColor: Colors.transparent,
        //               );
        //             }),
        //         CustomRoundedButton(
        //           image: Images.order,
        //           // onTap: () => Get.to(() => const AllOrdersScreen()),
        //           onTap: () => Get.to(() => const OrderSuccessScreen()),
        //         ),
        //         GetBuilder<PrinterController>(builder: (printerController) {
        //           return CustomRoundedButton(
        //               image: Images.order,
        //               widget: Icon(
        //                 Icons.print_rounded,
        //                 color: Theme.of(context).primaryColor,
        //               ),
        //               onTap: () {
        //                 Get.dialog(Dialog(
        //                   shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(
        //                           Dimensions.radiusSmall)),
        //                   insetPadding: const EdgeInsets.all(20),
        //                   child: const InvoicePrintScreen(),
        //                 ));
        //                 //   Get.to(const InvoicePrintScreen());
        //               });
        //         }),
        //         CustomRoundedButton(
        //           image: "assets/image/eye.png",

        //           //  onTap: () => Get.to(() => const AllOrdersScreen()),
        //           onTap: () {
        //             Get.dialog(Dialog(
        //               shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(
        //                       Dimensions.radiusSmall)),
        //               insetPadding: const EdgeInsets.all(20),
        //               child: const AskViewDialog(),
        //             ));

        //           },
        //         ),
        //         CustomRoundedButton(
        //           image: Images.accounting,
        //           //  onTap: () => Get.to(() => const AllOrdersScreen()),
        //           onTap: () => Get.to(() => const Sales()),
        //         ),
        //       ],
        //     ),
        //   ),

        );
  }

  Widget homeMobileView() {
    return GetBuilder<ProductController>(builder: (productController) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
            child: SearchBarView(
                controller: searchController, type: selectedProductType),
          ),
          SizedBox(
            height: 90,
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
          ),
          SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          IgnorePointer(
            ignoring: productController.productList == null,
            child: FilterButtonWidget(
              items: productController.productTypeList,
              type: selectedProductType,
              onSelected: (type) {
                selectedProductType = type;
                productController.setSelectedProductType = type;
                productController.getProductList(
                  true,
                  true,
                  categoryId: productController.selectedCategory,
                  productType: type,
                  searchPattern: searchController.text.trim().isEmpty
                      ? null
                      : searchController.text,
                );
              },
            ),
          ),
          SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Expanded(
            child: GetBuilder<ProductController>(builder: (productController) {
              final isBig = (Get.height / Get.width) > 1 &&
                  (Get.height / Get.width) < 1.7;

              return productController.productList == null
                  ? const ProductShimmerList()
                  : productController.productList!.isNotEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  selectedProductType =
                                      Get.find<ProductController>()
                                          .productTypeList
                                          .first;
                                  Get.find<ProductController>()
                                      .setSelectedCategory(null);
                                  await Get.find<ProductController>()
                                      .getProductList(
                                    true,
                                    true,
                                    offset: 1,
                                  );
                                },
                                child: GridView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge),
                                  itemCount:
                                      productController.productList?.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio:
                                        productController.listView ? 3 : 1,
                                    crossAxisCount: isBig ? 3 : 2,
                                    crossAxisSpacing:
                                        Dimensions.paddingSizeDefault,
                                    mainAxisSpacing:
                                        Dimensions.paddingSizeDefault,
                                  ),
                                  itemBuilder: (context, index) {
                                    return productController
                                                .productList?[index] !=
                                            null
                                        ? ProductWidget(
                                            product: productController
                                                .productList![index]!)
                                        : Center(
                                            child: CustomLoader(
                                                color: Theme.of(context)
                                                    .primaryColor));
                                  },
                                ),
                              ),
                            ),
                            if (productController.isLoading)
                              Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(
                                    Dimensions.paddingSizeDefault),
                                child: CustomLoader(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            selectedProductType = Get.find<ProductController>()
                                .productTypeList
                                .first;
                            Get.find<ProductController>()
                                .setSelectedCategory(null);
                            await Get.find<ProductController>().getProductList(
                              true,
                              true,
                              offset: 1,
                            );
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: NoDataScreen(text: 'no_food_available'.tr),
                          ),
                        );
            }),
          ),
        ],
      );
    });
  }

  Widget _bodyWidget() {
    return GetBuilder<ProductController>(builder: (productController) {
      int totalPage = 1;
      if (productController.productList != null) {
        // totalPage = (productController.productList!.length / ResponsiveHelper.getLen(context)).ceil();
      }
      return Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                //   child: SearchBarView(
                //       controller: searchController, type: selectedProductType),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault),
                  child: IgnorePointer(
                    ignoring: productController.productList == null,
                    child: FilterButtonWidget(
                      items: productController.productTypeList,
                      type: selectedProductType,
                      onSelected: (value) {
                        selectedProductType = value;
                        productController.setSelectedProductType = value;
                        productController.getProductList(
                          true,
                          true,
                          categoryId: productController.selectedCategory,
                          productType: value,
                          searchPattern: searchController.text.trim().isEmpty
                              ? null
                              : searchController.text,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // SizedBox(
            //     height: ResponsiveHelper.isSmallTab() ? 80 : 100,
            //     child: CategoryView(onSelected: (id) {
            //       if (productController.selectedCategory == id) {
            //         productController.setSelectedCategory(null);
            //       } else {
            //         productController.setSelectedCategory(id);
            //       }
            //       productController.getProductList(
            //         true,
            //         true,
            //         categoryId: productController.selectedCategory,
            //         productType: selectedProductType,
            //         searchPattern: searchController.text.trim().isEmpty
            //             ? null
            //             : searchController.text,
            //       );
            //     })),
            // SizedBox(
            //   height: productController.CatImage ? 65 : 35,
            // ),
            Expanded(
              child: PageViewProduct(
                  totalPage: totalPage,
                  search: searchController.text.isEmpty
                      ? null
                      : searchController.text),
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            //     child: GetBuilder<ProductController>(
            //         builder: (productController) {
            //           // int totalPage = 0;
            //           // if(productController.productList != null) {
            //           //   totalPage = (productController.totalSize! / ResponsiveHelper.getLen(context)).ceil();
            //           // }
            //          // List list = [for (var i = 0; i <= totalPage -1; i++) i];
            //           return Padding(
            //             padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: list.map((index) =>
            //                   Container(
            //                     margin: const EdgeInsets.symmetric(horizontal: 2),
            //                     decoration: BoxDecoration(
            //                       color:  index == productController.pageViewCurrentIndex
            //                           ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            //                       borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
            //                     ),
            //                     height: 5, width: Dimensions.paddingSizeExtraLarge,
            //                   ),

            //               ).toList(),
            //             ),
            //           );
            //         }
            //     ),
            //   ),),
          ],
        ),
      );
    });
  }
}
