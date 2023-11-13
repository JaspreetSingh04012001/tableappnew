import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:efood_table_booking/view/screens/home/widget/search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarView extends StatefulWidget {
  final TextEditingController controller;
  final String? type;
  const SearchBarView({Key? key, required this.controller, this.type})
      : super(key: key);

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      // padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      height: ResponsiveHelper.isSmallTab()
          ? 35
          : ResponsiveHelper.isTab(context)
              ? 50
              : 40,
      child: SearchField(
          controller: widget.controller,
          hint: 'search'.tr,
          iconPressed: () {
            if (Get.find<ProductController>().isSearch) {
              if (widget.controller.value.text.isEmpty) {
                showCustomSnackBar('please_enter_food_name'.tr, isToast: true);
              } else {
                // Get.find<ProductController>().filterFormattedProduct(true, widget.controller.text, From.search);
                Get.find<ProductController>().getProductList(
                  true,
                  true,
                  categoryId: Get.find<ProductController>().selectedCategory,
                  productType: widget.type,
                  searchPattern: widget.controller.text.trim().isEmpty
                      ? null
                      : widget.controller.text,
                );
                //Get.find<ProductController>().searchProduct(widget.controller.text, widget.type);
              }
            } else {
              if (Get.find<ProductController>().searchIs) {
                Get.find<ProductController>().getProductList(
                  true,
                  true,
                  categoryId: Get.find<ProductController>().selectedCategory,
                  productType: widget.type,
                  searchPattern: widget.controller.text.trim().isEmpty
                      ? null
                      : widget.controller.text,
                );
              }
              widget.controller.clear();
              FocusScope.of(context).unfocus();
            }
          },
          onChanged: (String pattern) {
            Get.find<ProductController>().f(pattern);
            // Get.find<ProductController>().getProductList(
            //   true,
            //   true,
            //   categoryId: Get.find<ProductController>().selectedCategory,
            //   productType: widget.type,
            //   searchPattern: pattern.isEmpty ? null : pattern,
            // );
            // if(pattern.trim().isEmpty) {
            //   FocusScope.of(context).unfocus();
            // }
          },
          onSubmit: (String pattern) {
            if (pattern.trim().isNotEmpty) {
              // Get.find<ProductController>().filterFormattedProduct(true, widget.controller.text, From.search);
              // Get.find<ProductController>().searchProduct(widget.controller.text, widget.type);

              Get.find<ProductController>().getProductList(
                true,
                true,
                categoryId: Get.find<ProductController>().selectedCategory,
                productType: widget.type,
                searchPattern: widget.controller.text.trim().isEmpty
                    ? null
                    : widget.controller.text,
              );
            }
          },
          suffixIcon:
              //Get.find<ProductController>().isSearch ?
              Icons.search
          //: Icons.cancel,
          ),
    );
  }
}
