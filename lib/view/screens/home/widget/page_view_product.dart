import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/view/screens/home/widget/product_widget.dart';
import 'package:efood_table_booking/view/screens/root/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product_shimmer_list.dart';

class PageViewProduct extends StatelessWidget {
  final int totalPage;
  final String? search;

  const PageViewProduct({
    Key? key,
    required this.totalPage,
    this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return productController.productList == null
          ? const ProductShimmerList()
          : productController.productList!.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: ResponsiveHelper.isSmallTab()
                        ? 5
                        : Dimensions.paddingSizeDefault,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: !ResponsiveHelper.isSmallTab() ? 1 : 0.9,
                    //itemLen == 6 ? 1 :  0.9,
                    crossAxisCount: !ResponsiveHelper.isSmallTab() ? 4 : 3,
                    //itemLen == 8 ? 4 :  3,
                    crossAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                  ),
                  itemCount: productController.productList?.length,
                  itemBuilder: (BuildContext context, int item) {
                    // int currentIndex0 = item  + currentIndex;
                    return ProductWidget(
                      product: productController.productList![item]!,
                    );
                  },
                )
              // PageView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount: totalPage,
              //   onPageChanged: (index) {
              //     productController.updatePageViewCurrentIndex(index);
              //     if(totalPage == index + 1) {
              //       int totalSize = (productController.totalSize! / 10).ceil();
              //       if (productController.productOffset < totalSize) {
              //         productController.productOffset++;

              //         productController.getProductList(false, true,
              //           offset: productController.productOffset,
              //           searchPattern: search, categoryId: productController.selectedCategory,
              //           productType: productController.selectedProductType,
              //         );
              //         // productController.filterFormattedProduct (false, true, offset: productController.productOffset);

              //       }
              //     }
              //   },

              //   itemBuilder: (context, index) {
              //    // int initialLength = ResponsiveHelper.getLen(context);
              //     //final itemLen = ResponsiveHelper.getLen(context);

              //     // int currentIndex = initialLength * index;
              //     // if(index + 1 == totalPage) {
              //     //   initialLength = productController.productList!.length - (index * initialLength);
              //     // }
              //     return productController.productList != null && productController.productList?[index] != null ?
              //     Stack(
              //       children: [
              //         GridView.builder(
              //           padding: EdgeInsets.symmetric(
              //             horizontal: Dimensions.paddingSizeDefault,
              //             vertical: ResponsiveHelper.isSmallTab() ? 5 : Dimensions.paddingSizeDefault,
              //           ),
              //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //             childAspectRatio: 0.9,
              //             //itemLen == 6 ? 1 :  0.9,
              //             crossAxisCount: 4,
              //             //itemLen == 8 ? 4 :  3,
              //             crossAxisSpacing: Dimensions.paddingSizeDefault,
              //             mainAxisSpacing: Dimensions.paddingSizeSmall,
              //           ),
              //           itemCount: productController.productList?.length,
              //           itemBuilder: (BuildContext context, int item) {
              //            // int currentIndex0 = item  + currentIndex;
              //             return ProductWidget(
              //               product: productController.productList![item]!,
              //             );
              //           },
              //         ),

              //         if(productController.isLoading) Positioned.fill(
              //           child: Align(alignment: Alignment.bottomCenter,
              //             child: Padding(
              //               padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
              //               child: CustomLoader(color: Theme.of(context).primaryColor,),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ) : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
              //   },
              // )
              : SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: NoDataScreen(
                    text: 'no_food_available'.tr,
                  ),
                ));
    });
  }
}
