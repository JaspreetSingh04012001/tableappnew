import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/model/response/product.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/date_converter.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:efood_table_booking/view/base/custom_rounded_button.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:efood_table_booking/view/screens/home/widget/price_stack_tag.dart';
import 'package:efood_table_booking/view/screens/home/widget/quantity_button.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/custom_text_field.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final CartModel? cart;
  final int? cartIndex;
  const ProductBottomSheet(
      {super.key, required this.product, this.cart, this.cartIndex});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  TextEditingController note = TextEditingController();
  late SharedPreferences sharedPreferences;
  var logger = Logger();
  void initVariation() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (widget.product.variations != null) {
      // variationList = widget.product.variations ?? [];
      j:
      for (Variation element in widget.product.variations ?? []) {
        logger.i(element.name);
        if (element.name == "Order Type" || element.name == "Order type") {
          Get.find<ProductController>().setCartVariationIndex(
              widget.product.variations!.indexOf(element),
              sharedPreferences.getInt("lastOrderType") ?? 0,
              widget.product,
              element.isMultiSelect!);
          break j;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // initVariation();
    Get.find<ProductController>().initData(widget.product, widget.cart);
    logger.i(widget.product.toJson());
    if (widget.cart?.note != null) note.text = widget.cart?.note ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final bool isTab = ResponsiveHelper.isTab(context);
    // late int _cartIndex;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Stack(
        children: [
          Container(
            width: ResponsiveHelper.isSmallTab()
                ? 550
                : ResponsiveHelper.isTab(context)
                    ? 700
                    : 550,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                topRight: Radius.circular(Dimensions.radiusExtraLarge),
                bottomLeft: isTab
                    ? Radius.circular(Dimensions.radiusExtraLarge)
                    : Radius.zero,
                bottomRight: isTab
                    ? Radius.circular(Dimensions.radiusExtraLarge)
                    : Radius.zero,
              ),
            ),
            child: GetBuilder<CartController>(builder: (cartController) {
              // note.text = cartController.
              return GetBuilder<ProductController>(initState: (state) {
                initVariation();
              }, builder: (productController) {
                double variationPrice = 0;
                double price = widget.product.price ?? 0;
                double discount = widget.product.discount ?? 0;
                String discountType = widget.product.discountType ?? 'percent';
                List<Variation> variationList = [];
                int addonLimit = widget.product.addonlimit ?? 0;
                if (widget.product.branchProduct != null &&
                    widget.product.branchProduct!.isAvailable!) {
                  variationList =
                      widget.product.branchProduct!.variations ?? [];
                  discount = widget.product.branchProduct?.discount ?? 0;
                  price = widget.product.branchProduct?.price ?? 0;
                  discountType =
                      widget.product.branchProduct?.discountType ?? 'percent';
                } else {
                  variationList = widget.product.variations ?? [];
                }

                for (int index = 0; index < variationList.length; index++) {
                  if (variationList[index].variationValues != null) {
                    for (int i = 0;
                        i < variationList[index].variationValues!.length;
                        i++) {
                      if (productController.selectedVariations[index][i]) {
                        variationPrice += variationList[index]
                                .variationValues![i]
                                .optionPrice ??
                            0;
                      }
                    }
                  }
                }

                double priceWithDiscount = PriceConverter.convertWithDiscount(
                  price,
                  discount,
                  discountType.toString(),
                );

                double addonsCost = 0;
                double addonsTax = 0;
                List<AddOn> addOnIdList = [];
                int addonLen = widget.product.addOns != null
                    ? widget.product.addOns!.length
                    : 0;
                int addoncount = 0;
                for (int index = 0; index < addonLen; index++) {
                  if (productController.addOnActiveList[index]) {
                    addoncount =
                        addoncount + productController.addOnQtyList[index];
                    double addonItemPrice =
                        widget.product.addOns![index].price! *
                            productController.addOnQtyList[index];
                    addonsCost = addonsCost + (addonItemPrice);
                    addonsTax = addonsTax +
                        (addonItemPrice -
                            PriceConverter.convertWithDiscount(
                                (addonItemPrice),
                                widget.product.addOns![index].tax ?? 0,
                                'percent'));

                    addOnIdList.add(AddOn(
                      id: widget.product.addOns![index].id,
                      price: (widget.product.addOns![index].price != null)
                          ? (widget.product.addOns![index].price! *
                              productController.addOnQtyList[index])
                          : null,
                      quantity: productController.addOnQtyList[index],
                      name: widget.product.addOns![index].name,
                    ));
                  }
                }
                //   productController.setQty(addonLen);

                double priceWithAddonsVariation = addonsCost +
                    (PriceConverter.convertWithDiscount(
                            variationPrice + price, discount, discountType) *
                        productController.quantity);
                double priceWithAddonsVariationWithoutDiscount =
                    ((price + variationPrice) * productController.quantity) +
                        addonsCost;
                double priceWithVariation = price + variationPrice;
                bool isAvailable = DateConverter.isAvailable(
                    widget.product.availableTimeStarts,
                    widget.product.availableTimeEnds);

                void updateAddon() {
                  variationPrice = 0;
                  for (int index = 0; index < variationList.length; index++) {
                    if (variationList[index].variationValues != null) {
                      for (int i = 0;
                          i < variationList[index].variationValues!.length;
                          i++) {
                        if (productController.selectedVariations[index][i]) {
                          variationPrice += variationList[index]
                                  .variationValues![i]
                                  .optionPrice ??
                              0;
                        }
                      }
                    }
                  }

                  addonsCost = 0;
                  addOnIdList.clear();
                  int addonLen = widget.product.addOns != null
                      ? widget.product.addOns!.length
                      : 0;

                  for (int index = 0; index < addonLen; index++) {
                    if (productController.addOnActiveList[index]) {
                      double addonItemPrice =
                          widget.product.addOns![index].price! *
                              productController.addOnQtyList[index];
                      addonsCost = addonsCost + (addonItemPrice);
                      addonsTax = addonsTax +
                          (addonItemPrice -
                              PriceConverter.convertWithDiscount(
                                  (addonItemPrice),
                                  widget.product.addOns![index].tax ?? 0,
                                  'percent'));

                      addOnIdList.add(AddOn(
                        id: widget.product.addOns![index].id,
                        price: (widget.product.addOns![index].price != null)
                            ? (widget.product.addOns![index].price! *
                                productController.addOnQtyList[index])
                            : null,
                        quantity: productController.addOnQtyList[index],
                        name: widget.product.addOns![index].name,
                      ));
                    }
                  }
                }

                void removeMe() {
                  for (var cartItem in cartController.cartList) {
                    if (cartItem.product!.id == widget.product.id) {
                      cartController.cartList
                          .removeAt(cartController.cartList.indexOf(cartItem));
                      //  cartController.update();
                    }
                  }
                }

                void myChutiyaFunction(Function() onTap) {
                  addonsCost = 0;
                  addOnIdList.clear();
                  addoncount = 0;
                  for (int index = 0; index < addonLen; index++) {
                    if (productController.addOnActiveList[index]) {
                      addoncount =
                          addoncount + productController.addOnQtyList[index];
                    }
                  }
                  // productController.setQty(addoncount);
                  if (addonLimit != 0 && addoncount == addonLimit) {
                    showCustomSnackBar('Limit has been reached',
                        isToast: true, isError: true);
                    return;
                  }

                  if (variationList.isNotEmpty) {
                    for (int index = 0; index < variationList.length; index++) {
                      if (!variationList[index].isMultiSelect! &&
                          variationList[index].isRequired! &&
                          !productController.selectedVariations[index]
                              .contains(true)) {
                        showCustomSnackBar(
                            '${'choose_a_variation_from'.tr} ${variationList[index].name}',
                            isToast: true,
                            isError: true);
                        return;
                      } else if (variationList[index].isMultiSelect! &&
                          (variationList[index].isRequired! ||
                              productController.selectedVariations[index]
                                  .contains(true)) &&
                          variationList[index].min! >
                              productController.selectedVariationLength(
                                  productController.selectedVariations,
                                  index)) {
                        showCustomSnackBar(
                            '${'you_need_to_select_minimum'.tr} ${variationList[index].min} '
                            '${'to_maximum'.tr} ${variationList[index].max} ${'options_from'.tr} ${variationList[index].name} ${'variation'.tr}',
                            isError: true,
                            isToast: true);
                        return;
                      }
                    }
                  }
                  onTap();
                  variationPrice = 0;
                  for (int index = 0; index < variationList.length; index++) {
                    if (variationList[index].variationValues != null) {
                      for (int i = 0;
                          i < variationList[index].variationValues!.length;
                          i++) {
                        if (productController.selectedVariations[index][i]) {
                          variationPrice += variationList[index]
                                  .variationValues![i]
                                  .optionPrice ??
                              0;
                        }
                      }
                    }
                  }

                  //if (addonLen > addonLimit) return;
                  for (int index = 0; index < addonLen; index++) {
                    if (productController.addOnActiveList[index]) {
                      double addonItemPrice =
                          widget.product.addOns![index].price! *
                              productController.addOnQtyList[index];
                      addonsCost = addonsCost + (addonItemPrice);
                      addonsTax = addonsTax +
                          (addonItemPrice -
                              PriceConverter.convertWithDiscount(
                                  (addonItemPrice),
                                  widget.product.addOns![index].tax ?? 0,
                                  'percent'));

                      addOnIdList.add(AddOn(
                        is_product: widget.product.addOns![index].is_product,
                        id: widget.product.addOns![index].id,
                        price: (widget.product.addOns![index].price != null)
                            ? (widget.product.addOns![index].price! *
                                productController.addOnQtyList[index])
                            : 0,
                        quantity: productController.addOnQtyList[index],
                        name: widget.product.addOns![index].name,
                      ));
                    }
                  }

                  bool found = false;
                  if (addonsCost == 0) productController.setQuantity(true);
                  if (cartController.cartList.isNotEmpty) {
                    for (var cartItem in cartController.cartList) {
                      if (cartItem.product!.id == widget.product.id) {
                        found = true;
                        cartController.addToCart(
                            CartModel(
                              note: note.text.isNotEmpty
                                  ? note.text.toString()
                                  : null,
                              price: addonsCost == 0
                                  ? ((productController.quantity != null ||
                                          productController.quantity > 0)
                                      ? widget.product.price! *
                                          productController.quantity
                                      : widget.product.price)
                                  : addonsCost + variationPrice,
                              discountedPrice: priceWithDiscount,
                              variation: [],
                              discountAmount: priceWithVariation -
                                  PriceConverter.convertWithDiscount(
                                    priceWithVariation,
                                    discount,
                                    discountType,
                                  ),
                              quantity: productController.quantity,
                              // : addOnIdList
                              //     .map((e) => e.quantity)
                              //     .toList()
                              //     .reduce((a, b) => a! + b!),
                              taxAmount: (priceWithVariation -
                                  PriceConverter.convertWithDiscount(
                                      priceWithVariation,
                                      widget.product.tax!,
                                      widget.product.taxType!) +
                                  addonsTax),
                              addOnIds:
                                  addOnIdList.isEmpty ? null : addOnIdList,
                              product: widget.product,
                              variations: productController.selectedVariations,
                            ),
                            cartController.cartList.indexOf(cartItem));
                      }
                    }
                  }

                  if (found == false) {
                    cartController.addToCart(
                        CartModel(
                          note: note.text.isNotEmpty
                              ? note.text.toString()
                              : null,
                          price: addonsCost == 0
                              ? ((productController.quantity != null ||
                                      productController.quantity > 0)
                                  ? widget.product.price! *
                                      productController.quantity
                                  : widget.product.price)
                              : addonsCost + variationPrice,
                          discountedPrice: priceWithDiscount,
                          variation: [],
                          discountAmount: priceWithVariation -
                              PriceConverter.convertWithDiscount(
                                priceWithVariation,
                                discount,
                                discountType,
                              ),
                          quantity: productController.quantity,
                          taxAmount: (priceWithVariation -
                              PriceConverter.convertWithDiscount(
                                  priceWithVariation,
                                  widget.product.tax!,
                                  widget.product.taxType!) +
                              addonsTax),
                          addOnIds: addOnIdList,
                          product: widget.product,
                          variations: productController.selectedVariations,
                        ),
                        widget.cart != null
                            ? widget.cartIndex!
                            : productController.cartIndex);

                    // for (int index = 0; index < addonLen; index++) {
                    //   if (productController.addOnActiveList[index]) {
                    //     addoncount =
                    //         addoncount + productController.addOnQtyList[index];
                    //   }
                    // }
                    // productController.setQty(addoncount);
                  }
                  if (addonsCost == 0) productController.setQuantity(false);

                  showCustomSnackBar('Item added to cart',
                      isError: false, isToast: true);
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(isTab
                                  ? Dimensions.paddingSizeExtraLarge
                                  : Dimensions.paddingSizeLarge),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Product
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (widget.product.image != null &&
                                                        widget.product.image!
                                                            .isNotEmpty)
                                                    ? Stack(children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .radiusSmall),
                                                          child: CustomImage(
                                                            image:
                                                                '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${widget.product.image ?? ''}',
                                                            width: ResponsiveHelper
                                                                    .isSmallTab()
                                                                ? 100
                                                                : isTab
                                                                    ? 170
                                                                    : 100,
                                                            height: ResponsiveHelper
                                                                    .isSmallTab()
                                                                ? 100
                                                                : isTab
                                                                    ? 170
                                                                    : 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        if (discount > 0)
                                                          PriceStackTag(
                                                              value: PriceConverter
                                                                  .percentageCalculation(
                                                            price.toString(),
                                                            discount.toString(),
                                                            discountType,
                                                          )),
                                                      ])
                                                    : const SizedBox.shrink(),
                                                SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          widget.product.name ??
                                                              '',
                                                          style: robotoBold
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                    .fontSizeExtraLarge +
                                                                3,
                                                          ),
                                                          maxLines: 3,
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeSmall,
                                                        ),
                                                        if (widget.product
                                                                    .addOns ==
                                                                null ||
                                                            widget
                                                                .product
                                                                .addOns!
                                                                .isEmpty)
                                                          Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      PriceConverter
                                                                          .convertPrice(
                                                                        price,
                                                                        discount:
                                                                            discount,
                                                                        discountType:
                                                                            discountType,
                                                                      ),
                                                                      style: robotoMedium.copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeExtraLarge + 5),
                                                                    ),
                                                                    SizedBox(
                                                                        width: Dimensions
                                                                            .paddingSizeExtraSmall),
                                                                    price > priceWithDiscount
                                                                        ? Text(
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            PriceConverter.convertPrice(price),
                                                                            style:
                                                                                robotoMedium.copyWith(color: Theme.of(context).primaryColor, decoration: TextDecoration.lineThrough),
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ]),
                                                        if (isTab)
                                                          SizedBox(
                                                               height: ResponsiveHelper
                                                                    .isSmallTab()
                                                                ? 100
                                                                : isTab
                                                                    ? 170
                                                                    : 100,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                _productDescription(),
                                                                Expanded(child: Container()),
                                                                SizedBox(
                                                                    width: 150,
                                                                    child: Text.rich(
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        TextSpan(
                                                                            text: variationList[0].name ??
                                                                                "",
                                                                            style:
                                                                                robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                                                            children: const <InlineSpan>[]))),
                                                                SizedBox(
                                                                  // width: 150,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (variationList[0]
                                                                              .isRequired ??
                                                                          false)
                                                                        Text(
                                                                          ' (${'required'.tr})',
                                                                          style: robotoMedium.copyWith(
                                                                              color:
                                                                                  Theme.of(context).primaryColor,
                                                                              fontSize: Dimensions.fontSizeSmall),
                                                                        ),
                                                                      (variationList[0]
                                                                              .isMultiSelect!)
                                                                          ? Text(
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                              '${'you_need_to_select_minimum'.tr} ${'${variationList[0].min}'
                                                                                  ' ${'to_maximum'.tr} ${variationList[0].max}'}',
                                                                              style:
                                                                                  robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                                                            )
                                                                          : Text(
                                                                              overflow:
                                                                                  TextOverflow.ellipsis,
                                                                              '',
                                                                              style:
                                                                                  robotoMedium.copyWith(
                                                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                if (variationList[
                                                                            0]
                                                                        .variationValues !=
                                                                    null)
                                                                  Row(
                                                                    //     MainAxisSize
                                                                    //         .min,
                                                                    children: List
                                                                        .generate(
                                                                            variationList[0].variationValues?.length ??
                                                                                0,
                                                                            (i) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                2,
                                                                            vertical:
                                                                                0),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (variationList[0].name == "Order Type" ||
                                                                                variationList[0].name == "Order type") {
                                                                              sharedPreferences.setInt("lastOrderType",
                                                                                  i);
                                                                            }
                                                                            productController.setCartVariationIndex(
                                                                                0,
                                                                                i,
                                                                                widget.product,
                                                                                variationList[0].isMultiSelect!);
                                                                            if (productController.quantity >
                                                                                0) {
                                                                              myChutiyaFunction(() =>
                                                                                  null);
                                                                            }
                                                                            if (productController.quantity ==
                                                                                0) {
                                                                              myChutiyaFunction(() {
                                                                                //   productController.setQuantity(true);
                                                                              });
                                                                            }
                                                                            //    myChutiyaFunction();
                                                                          },
                                                                          child:
                                                                              Stack(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                constraints: const BoxConstraints(minWidth: 110, maxWidth: 150),
                                                                                alignment: Alignment.center,
                                                                                // width: 110,
                                                                                decoration: BoxDecoration(border: Border.all(width: 1.5, color: Theme.of(context).disabledColor), borderRadius: BorderRadius.circular(4), color: productController.selectedVariations[0][i] ? Theme.of(context).primaryColor : null),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                                                  child: Text(
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    variationList[0].variationValues![i].level != null ? variationList[0].variationValues![i].level!.trim() : '',
                                                                                    maxLines: 1,
                                                                                    //  overflow: TextOverflow.ellipsis,
                                                                                    style: productController.selectedVariations[0][i] ? robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 3, right: 3),
                                                                                child: Text(
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  variationList[0].variationValues![i].optionPrice! > 0 ? '+${PriceConverter.convertPrice(variationList[0].variationValues![i].optionPrice ?? 0)}' : 'free'.tr,
                                                                                  maxLines: 1,
                                                                                  // overflow:
                                                                                  //     TextOverflow.ellipsis,
                                                                                  style: productController.selectedVariations[0][i] ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                      ]),
                                                ),
                                              ]),
                                          if (!ResponsiveHelper.isSmallTab())
                                            SizedBox(
                                                height: Dimensions
                                                    .paddingSizeSmall),

                                          if (!isTab) _productDescription(),

                                          SizedBox(
                                              height: Dimensions
                                                  .paddingSizeDefault),

                                          variationList.isNotEmpty
                                              ? Wrap(
                                                  children: List.generate(
                                                      variationList.length,
                                                      (index) {
                                                    if (isTab == true &&
                                                        index == 0) {
                                                      return Container();
                                                    } else {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 2),
                                                        child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                  width: 150,
                                                                  child: Text.rich(
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      TextSpan(
                                                                          text: variationList[index].name ??
                                                                              "",
                                                                          style:
                                                                              robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                                                          children: const <InlineSpan>[]))),
                                                              SizedBox(
                                                                // width: 150,
                                                                child: Row(
                                                                  children: [
                                                                    if (variationList[index]
                                                                            .isRequired ??
                                                                        false)
                                                                      Text(
                                                                        ' (${'required'.tr})',
                                                                        style: robotoMedium.copyWith(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            fontSize: Dimensions.fontSizeSmall),
                                                                      ),
                                                                    (variationList[index]
                                                                            .isMultiSelect!)
                                                                        ? Text(
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            '${'you_need_to_select_minimum'.tr} ${'${variationList[index].min}'
                                                                                ' ${'to_maximum'.tr} ${variationList[index].max}'}',
                                                                            style:
                                                                                robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                                                                          )
                                                                        : Text(
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            '',
                                                                            style:
                                                                                robotoMedium.copyWith(
                                                                              fontSize: Dimensions.fontSizeExtraSmall,
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                              if (variationList[
                                                                          index]
                                                                      .variationValues !=
                                                                  null)
                                                                Wrap(
                                                                  // mainAxisSize:
                                                                  //     MainAxisSize
                                                                  //         .min,
                                                                  children: List
                                                                      .generate(
                                                                          variationList[index].variationValues?.length ??
                                                                              0,
                                                                          (i) =>
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    if (variationList[index].name == "Order Type" || variationList[index].name == "Order type") {
                                                                                      sharedPreferences.setInt("lastOrderType", i);
                                                                                    }
                                                                                    productController.setCartVariationIndex(index, i, widget.product, variationList[index].isMultiSelect!);
                                                                                    if (productController.quantity > 0) {
                                                                                      myChutiyaFunction(() => null);
                                                                                    }
                                                                                    if (productController.quantity == 0) {
                                                                                      myChutiyaFunction(() {
                                                                                        //   productController.setQuantity(true);
                                                                                      });
                                                                                    }
                                                                                    //    myChutiyaFunction();
                                                                                  },
                                                                                  child: Stack(
                                                                                    alignment: Alignment.topRight,
                                                                                    children: [
                                                                                      Container(
                                                                                        constraints: const BoxConstraints(minWidth: 110, maxWidth: 150),
                                                                                        alignment: Alignment.center,
                                                                                        // width: 110,
                                                                                        decoration: BoxDecoration(border: Border.all(width: 1.5, color: Theme.of(context).disabledColor), borderRadius: BorderRadius.circular(4), color: productController.selectedVariations[index][i] ? Theme.of(context).primaryColor : null),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                                                                                          child: Text(
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            variationList[index].variationValues![i].level != null ? variationList[index].variationValues![i].level!.trim() : '',
                                                                                            maxLines: 1,
                                                                                            //  overflow: TextOverflow.ellipsis,
                                                                                            style: productController.selectedVariations[index][i] ? robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 3, right: 3),
                                                                                        child: Text(
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          variationList[index].variationValues![i].optionPrice! > 0 ? '+${PriceConverter.convertPrice(variationList[index].variationValues![i].optionPrice ?? 0)}' : 'free'.tr,
                                                                                          maxLines: 1,
                                                                                          // overflow:
                                                                                          //     TextOverflow.ellipsis,
                                                                                          style: productController.selectedVariations[index][i] ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white) : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                ),
                                                              SizedBox(
                                                                  height: index !=
                                                                          variationList.length -
                                                                              1
                                                                      ? Dimensions
                                                                          .paddingSizeLarge
                                                                      : 0),
                                                            ]),
                                                      );
                                                    }
                                                  }),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                      ButtonWidget(
                                                          cartIndex: widget
                                                                  .cartIndex ??
                                                              -1),
                                                    ]),

                                          // Variation

                                          SizedBox(
                                              height: widget.product
                                                      .choiceOptions!.isNotEmpty
                                                  ? Dimensions
                                                      .paddingSizeDefault
                                                  : 0),

                                          // Addons
                                          widget.product.addOns != null &&
                                                  widget.product.addOns!
                                                      .isNotEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            'addons'.tr,
                                                            style: robotoMedium
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall,
                                                          ),
                                                          Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            '(${'optional'.tr})',
                                                            style: robotoRegular
                                                                .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeDefault),
                                                      Wrap(
                                                        children: List.generate(
                                                            widget.product
                                                                .addOns!.length,
                                                            (index) => InkWell(
                                                                  onTap: () {
                                                                    myChutiyaFunction(
                                                                        () {
                                                                      if (!productController
                                                                              .addOnActiveList[
                                                                          index]) {
                                                                        productController.addAddOn(
                                                                            true,
                                                                            index);

                                                                        if (widget.product.addOns![index].is_product ==
                                                                            true) {
                                                                          productController
                                                                              .setQuantity(true);
                                                                        }
                                                                      } else if (productController
                                                                              .addOnQtyList[index] ==
                                                                          1) {
                                                                        productController.addAddOn(
                                                                            false,
                                                                            index);
                                                                        // if (productController
                                                                        //         .quantity !=
                                                                        //     1) {
                                                                        if (widget.product.addOns![index].is_product ==
                                                                            true) {
                                                                          productController
                                                                              .setQuantity(false);
                                                                        }
                                                                        // }
                                                                        // if (productController
                                                                        //         .quantity ==
                                                                        //     0) {
                                                                        //   removeMe();
                                                                        // }
                                                                      }
                                                                    });
                                                                    if (productController
                                                                            .quantity ==
                                                                        0) {
                                                                      removeMe();
                                                                    }

                                                                    productController
                                                                        .update();
                                                                    cartController
                                                                        .update();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 140,
                                                                    height: 130,
                                                                    margin: EdgeInsets.only(
                                                                        right: Dimensions
                                                                            .paddingSizeDefault,
                                                                        bottom:
                                                                            Dimensions.paddingSizeDefault),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: productController.addOnActiveList[
                                                                              index]
                                                                          ? Theme.of(context)
                                                                              .primaryColor
                                                                          : Theme.of(context)
                                                                              .hintColor
                                                                              .withOpacity(0.15),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimensions.radiusSmall),
                                                                      boxShadow: productController
                                                                              .addOnActiveList[index]
                                                                          ? [
                                                                              BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, blurRadius: 5, spreadRadius: 1)
                                                                            ]
                                                                          : null,
                                                                    ),
                                                                    child: Column(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                              Text(
                                                                                overflow: TextOverflow.ellipsis,
                                                                                widget.product.addOns![index].name ?? '',
                                                                                maxLines: 2,
                                                                                // overflow: TextOverflow.ellipsis,
                                                                                textAlign: TextAlign.center,
                                                                                style: robotoMedium.copyWith(
                                                                                  color: productController.addOnActiveList[index] ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
                                                                                  fontSize: Dimensions.fontSizeExtraLarge,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(height: 5),
                                                                              Text(
                                                                                overflow: TextOverflow.ellipsis,
                                                                                widget.product.addOns![index].price! > 0 ? PriceConverter.convertPrice(widget.product.addOns![index].price!) : 'free'.tr,
                                                                                maxLines: 1,
                                                                                //  overflow: TextOverflow.ellipsis,
                                                                                style: robotoRegular.copyWith(
                                                                                  color: productController.addOnActiveList[index] ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
                                                                                  fontSize: Dimensions.fontSizeLarge,
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          ),
                                                                          productController.addOnActiveList[index]
                                                                              ? Container(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                                                                  margin: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                                                    color: Theme.of(context).canvasColor,
                                                                                  ),
                                                                                  child: Row(children: [
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          // if(widget.product.addOns![index].is_product == false){
                                                                                          //   myChutiyaFunction(() => null);
                                                                                          //   return ;
                                                                                          // }
                                                                                          if (addonLimit != 0 && addoncount == addonLimit) {
                                                                                            if (productController.addOnQtyList[index] > 1) {
                                                                                              productController.setAddOnQuantity(false, index);
                                                                                              //   if (productController.quantity != 1) {
                                                                                              if (widget.product.addOns![index].is_product == true) productController.setQuantity(false);
                                                                                              //   }
                                                                                            } else {
                                                                                              productController.addAddOn(false, index);
                                                                                              //  if (productController.quantity != 1) {
                                                                                              if (widget.product.addOns![index].is_product == true) productController.setQuantity(false);
                                                                                              //  }
                                                                                            }
                                                                                            myChutiyaFunction(() {});
                                                                                          } else {
                                                                                            myChutiyaFunction(() {
                                                                                              if (productController.addOnQtyList[index] > 1) {
                                                                                                productController.setAddOnQuantity(false, index);
                                                                                                //  if (productController.quantity != 1) {
                                                                                                if (widget.product.addOns![index].is_product == true) productController.setQuantity(false);
                                                                                                //  }
                                                                                              } else {
                                                                                                productController.addAddOn(false, index);
                                                                                                //   if (productController.quantity != 1) {
                                                                                                if (widget.product.addOns![index].is_product == true) productController.setQuantity(false);
                                                                                                //    }
                                                                                              }
                                                                                            });
                                                                                          }
                                                                                          if (productController.quantity == 0) {
                                                                                            Get.back();
                                                                                            removeMe();
                                                                                          }

                                                                                          productController.update();
                                                                                          cartController.update();
                                                                                        },
                                                                                        child: Center(child: Icon(Icons.remove, size: Dimensions.paddingSizeLarge)),
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      productController.addOnQtyList[index].toString(),
                                                                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () async {
                                                                                          if (addonLimit != 0 && addoncount == addonLimit) {
                                                                                            return;
                                                                                          }

                                                                                          myChutiyaFunction(() {
                                                                                            productController.setAddOnQuantity(true, index);

                                                                                            if (widget.product.addOns![index].is_product == true) productController.setQuantity(true);
                                                                                          });

                                                                                          productController.update();
                                                                                          cartController.update();
                                                                                        },
                                                                                        child: Center(
                                                                                            child: Icon(
                                                                                          Icons.add,
                                                                                          size: Dimensions.paddingSizeLarge,
                                                                                          color: (addonLimit != 0 && addoncount == addonLimit) ? Colors.transparent : null,
                                                                                        )),
                                                                                      ),
                                                                                    ),
                                                                                  ]),
                                                                                )
                                                                              : const SizedBox(),
                                                                        ]),
                                                                  ),
                                                                )),
                                                      ),
                                                      // ListView.builder(

                                                      //   scrollDirection:
                                                      //       Axis.horizontal,
                                                      //   itemCount: widget
                                                      //       .product
                                                      //       .addOns!
                                                      //       .length,
                                                      //   itemBuilder:
                                                      //       (context, index) {
                                                      //     return
                                                      //     InkWell(
                                                      //       onTap: () {
                                                      //         myChutiyaFunction(
                                                      //             () {
                                                      //           if (!productController
                                                      //                   .addOnActiveList[
                                                      //               index]) {
                                                      //             productController
                                                      //                 .addAddOn(
                                                      //                     true,
                                                      //                     index);

                                                      //             productController
                                                      //                 .setQuantity(
                                                      //                     true);
                                                      //           } else if (productController
                                                      //                       .addOnQtyList[
                                                      //                   index] ==
                                                      //               1) {
                                                      //             productController
                                                      //                 .addAddOn(
                                                      //                     false,
                                                      //                     index);
                                                      //             // if (productController
                                                      //             //         .quantity !=
                                                      //             //     1) {
                                                      //             productController
                                                      //                 .setQuantity(
                                                      //                     false);
                                                      //             // }
                                                      //             // if (productController
                                                      //             //         .quantity ==
                                                      //             //     0) {
                                                      //             //   removeMe();
                                                      //             // }
                                                      //           }
                                                      //         });
                                                      //         if (productController
                                                      //                 .quantity ==
                                                      //             0) {
                                                      //           removeMe();
                                                      //         }

                                                      //         productController
                                                      //             .update();
                                                      //         cartController
                                                      //             .update();
                                                      //       },
                                                      //       child: Container(
                                                      //         width: 140,
                                                      //         height: 130,
                                                      //         margin: EdgeInsets.only(
                                                      //             right: Dimensions
                                                      //                 .paddingSizeDefault),
                                                      //         alignment:
                                                      //             Alignment
                                                      //                 .center,
                                                      //         decoration:
                                                      //             BoxDecoration(
                                                      //           color: productController
                                                      //                       .addOnActiveList[
                                                      //                   index]
                                                      //               ? Theme.of(
                                                      //                       context)
                                                      //                   .primaryColor
                                                      //               : Theme.of(
                                                      //                       context)
                                                      //                   .hintColor
                                                      //                   .withOpacity(
                                                      //                       0.15),
                                                      //           borderRadius:
                                                      //               BorderRadius.circular(
                                                      //                   Dimensions
                                                      //                       .radiusSmall),
                                                      //           boxShadow:
                                                      //               productController
                                                      //                       .addOnActiveList[index]
                                                      //                   ? [
                                                      //                       BoxShadow(
                                                      //                           color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                                      //                           blurRadius: 5,
                                                      //                           spreadRadius: 1)
                                                      //                     ]
                                                      //                   : null,
                                                      //         ),
                                                      //         child: Column(
                                                      //             children: [
                                                      //               Expanded(
                                                      //                 child: Column(
                                                      //                     mainAxisAlignment:
                                                      //                         MainAxisAlignment.center,
                                                      //                     children: [
                                                      //                       Text(
                                                      //                         overflow: TextOverflow.ellipsis,
                                                      //                         widget.product.addOns![index].name ?? '',
                                                      //                         maxLines: 2,
                                                      //                         // overflow: TextOverflow.ellipsis,
                                                      //                         textAlign: TextAlign.center,
                                                      //                         style: robotoMedium.copyWith(
                                                      //                           color: productController.addOnActiveList[index] ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
                                                      //                           fontSize: Dimensions.fontSizeExtraLarge,
                                                      //                         ),
                                                      //                       ),
                                                      //                       const SizedBox(height: 5),
                                                      //                       Text(
                                                      //                         overflow: TextOverflow.ellipsis,
                                                      //                         widget.product.addOns![index].price! > 0 ? PriceConverter.convertPrice(widget.product.addOns![index].price!) : 'free'.tr,
                                                      //                         maxLines: 1,
                                                      //                         //  overflow: TextOverflow.ellipsis,
                                                      //                         style: robotoRegular.copyWith(
                                                      //                           color: productController.addOnActiveList[index] ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
                                                      //                           fontSize: Dimensions.fontSizeLarge,
                                                      //                         ),
                                                      //                       ),
                                                      //                     ]),
                                                      //               ),
                                                      //               productController
                                                      //                       .addOnActiveList[index]
                                                      //                   ? Container(
                                                      //                       padding:
                                                      //                           const EdgeInsets.symmetric(vertical: 6),
                                                      //                       margin:
                                                      //                           EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                                      //                       decoration:
                                                      //                           BoxDecoration(
                                                      //                         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                      //                         color: Theme.of(context).canvasColor,
                                                      //                       ),
                                                      //                       child:
                                                      //                           Row(children: [
                                                      //                         Expanded(
                                                      //                           child: InkWell(
                                                      //                             onTap: () async {
                                                      //                               if (addonLimit != 0 && addoncount == addonLimit) {
                                                      //                                 if (productController.addOnQtyList[index] > 1) {
                                                      //                                   productController.setAddOnQuantity(false, index);
                                                      //                                   //   if (productController.quantity != 1) {
                                                      //                                   productController.setQuantity(false);
                                                      //                                   //   }
                                                      //                                 } else {
                                                      //                                   productController.addAddOn(false, index);
                                                      //                                   //  if (productController.quantity != 1) {
                                                      //                                   productController.setQuantity(false);
                                                      //                                   //  }
                                                      //                                 }
                                                      //                                 myChutiyaFunction(() {});
                                                      //                               } else {
                                                      //                                 myChutiyaFunction(() {
                                                      //                                   if (productController.addOnQtyList[index] > 1) {
                                                      //                                     productController.setAddOnQuantity(false, index);
                                                      //                                     //  if (productController.quantity != 1) {
                                                      //                                     productController.setQuantity(false);
                                                      //                                     //  }
                                                      //                                   } else {
                                                      //                                     productController.addAddOn(false, index);
                                                      //                                     //   if (productController.quantity != 1) {
                                                      //                                     productController.setQuantity(false);
                                                      //                                     //    }
                                                      //                                   }
                                                      //                                 });
                                                      //                               }
                                                      //                               if (productController.quantity == 0) {
                                                      //                                 Get.back();
                                                      //                                 removeMe();
                                                      //                               }

                                                      //                               productController.update();
                                                      //                               cartController.update();
                                                      //                             },
                                                      //                             child: Center(child: Icon(Icons.remove, size: Dimensions.paddingSizeLarge)),
                                                      //                           ),
                                                      //                         ),
                                                      //                         Text(
                                                      //                           overflow: TextOverflow.ellipsis,
                                                      //                           productController.addOnQtyList[index].toString(),
                                                      //                           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                                      //                         ),
                                                      //                         Expanded(
                                                      //                           child: InkWell(
                                                      //                             onTap: () async {
                                                      //                               if (addonLimit != 0 && addoncount == addonLimit) {
                                                      //                                 return;
                                                      //                               }

                                                      //                               myChutiyaFunction(() {
                                                      //                                 productController.setAddOnQuantity(true, index);

                                                      //                                 productController.setQuantity(true);
                                                      //                               });

                                                      //                               productController.update();
                                                      //                               cartController.update();
                                                      //                             },
                                                      //                             child: Center(
                                                      //                                 child: Icon(
                                                      //                               Icons.add,
                                                      //                               size: Dimensions.paddingSizeLarge,
                                                      //                               color: (addonLimit != 0 && addoncount == addonLimit) ? Colors.transparent : null,
                                                      //                             )),
                                                      //                           ),
                                                      //                         ),
                                                      //                       ]),
                                                      //                     )
                                                      //                   : const SizedBox(),
                                                      //             ]),
                                                      //       ),
                                                      //     );
                                                      //   },
                                                      // ),
                                                    ])
                                              : const SizedBox(),
                                        ]),
                                  ]),
                            ),
                            // if (!ResponsiveHelper.isSmallTab())
                            //   SizedBox(height: Dimensions.paddingSizeSmall),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12)
                                      .copyWith(bottom: 20),
                              child: CustomTextField(
                                borderColor: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.4),
                                controller: note,
                                onChanged: (value) {
                                  setState(() {
                                    // customerName = value;
                                    // cartController.setCustomerName =
                                    //     customerName;
                                  });
                                },
                                onSubmit: (value) {
                                  // setState(() {
                                  //   customerName = value;
                                  //   cartController.setCustomerName =
                                  //       customerName;
                                  // });
                                },
                                // inputType: TextInputType.number,
                                //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                hintText: 'Note',
                                hintStyle: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall + 5),
                                //  focusNode: _nameFocusNode,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight:
                              Radius.circular(Dimensions.radiusExtraLarge),
                          bottomLeft:
                              Radius.circular(Dimensions.radiusExtraLarge),
                        ),
                        color: Theme.of(context).canvasColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, -4),
                          )
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Row(
                          children: [
                            // isTab
                            //     ? Flexible(
                            //         flex: 2,
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Text(
                            //                 overflow: TextOverflow.ellipsis,
                            //                 'total'.tr,
                            //                 style: robotoRegular.copyWith(
                            //                     fontSize:
                            //                         Dimensions.fontSizeLarge)),
                            //             SizedBox(
                            //                 width: Dimensions.paddingSizeSmall),
                            //             SizedBox(
                            //                 width: Dimensions.paddingSizeSmall),
                            //             Text(
                            //                 overflow: TextOverflow.ellipsis,
                            //                 PriceConverter.convertPrice(
                            //                     priceWithAddonsVariation),
                            //                 style: robotoBold.copyWith(
                            //                     color: Theme.of(context)
                            //                         .primaryColor)),
                            //             SizedBox(
                            //                 width: Dimensions
                            //                     .paddingSizeExtraSmall),
                            //             (priceWithAddonsVariationWithoutDiscount >
                            //                     priceWithAddonsVariation)
                            //                 ? Text(
                            //                     overflow: TextOverflow.ellipsis,
                            //                     '(${PriceConverter.convertPrice(priceWithAddonsVariationWithoutDiscount)})',
                            //                     style: robotoMedium.copyWith(
                            //                         color: Theme.of(context)
                            //                             .disabledColor,
                            //                         fontSize: Dimensions
                            //                             .fontSizeExtraLarge,
                            //                         decoration: TextDecoration
                            //                             .lineThrough),
                            //                   )
                            //                 : const SizedBox(),
                            //           ],
                            //         ),
                            //       )
                            //     :
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeDefault),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        'total'.tr,
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge)),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        PriceConverter.convertPrice((widget
                                                        .product.addOns ==
                                                    null ||
                                                widget.product.addOns!.isEmpty)
                                            ? priceWithAddonsVariationWithoutDiscount
                                            : addonsCost + variationPrice),
                                        style: robotoBold.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraLarge +
                                                    4)),

                                    // SizedBox(
                                    //     width: Dimensions
                                    //         .paddingSizeExtraSmall),
                                    // (priceWithAddonsVariationWithoutDiscount >
                                    //         priceWithAddonsVariation)
                                    //     ? Text(
                                    //         overflow:
                                    //             TextOverflow.ellipsis,
                                    //         '(${PriceConverter.convertPrice(priceWithAddonsVariationWithoutDiscount)})',
                                    //         style: robotoMedium.copyWith(
                                    //             color: Theme.of(context)
                                    //                 .disabledColor,
                                    //             fontSize: Dimensions
                                    //                 .fontSizeSmall,
                                    //             decoration: TextDecoration
                                    //                 .lineThrough),
                                    //       )
                                    //     : const SizedBox(),
                                  ]),
                            ),
                            if (widget.product.addOns == null ||
                                widget.product.addOns!.isEmpty)
                              Expanded(child: Container()),
                            if (widget.product.addOns == null ||
                                widget.product.addOns!.isEmpty)
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Expanded(child: Container()),
                                    QuantityButton(
                                        isIncrement: false,
                                        onTap: () {
                                          // int cartIndex =
                                          //     widget.cartIndex ?? -1;
                                          if (productController.quantity == 1) {
                                            productController
                                                .setQuantity(false);
                                            removeMe();
                                            productController.update();
                                            cartController.update();
                                            //   Get.back();
                                          } else if (productController
                                                  .quantity >
                                              1) {
                                            productController
                                                .setQuantity(false);
                                            myChutiyaFunction(() => null);
                                            productController.update();
                                            cartController.update();
                                          }
                                        }),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      productController.quantity.toString(),
                                      style: robotoBold.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge +
                                                  15),
                                    ),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraSmall),
                                    QuantityButton(
                                        isIncrement: true,
                                        onTap: () {
                                          myChutiyaFunction(() {
                                            productController.setQuantity(true);
                                          });
                                        }),
                                  ]),

                            // if (widget.product.addOns == null ||
                            //     widget.product.addOns!.isEmpty)
                            //   Flexible(
                            //     flex: 3,
                            //     child: CustomButton(
                            //       margin: EdgeInsets.all(
                            //           ResponsiveHelper.isSmallTab()
                            //               ? 5
                            //               : Dimensions.paddingSizeSmall),
                            //       buttonText: isAvailable
                            //           ? (widget.cart != null)
                            //               ? 'update_in_cart'.tr
                            //               : 'add_to_cart'.tr
                            //           : 'not_available'.tr,
                            //       onPressed: isAvailable
                            //           ? () {
                            //               if (variationList.isNotEmpty) {
                            //                 for (int index = 0;
                            //                     index < variationList.length;
                            //                     index++) {
                            //                   if (!variationList[index]
                            //                           .isMultiSelect! &&
                            //                       variationList[index]
                            //                           .isRequired! &&
                            //                       !productController
                            //                           .selectedVariations[index]
                            //                           .contains(true)) {
                            //                     showCustomSnackBar(
                            //                         '${'choose_a_variation_from'.tr} ${variationList[index].name}',
                            //                         isToast: true,
                            //                         isError: true);
                            //                     return;
                            //                   } else if (variationList[index]
                            //                           .isMultiSelect! &&
                            //                       (variationList[index]
                            //                               .isRequired! ||
                            //                           productController
                            //                               .selectedVariations[
                            //                                   index]
                            //                               .contains(true)) &&
                            //                       variationList[index].min! >
                            //                           productController
                            //                               .selectedVariationLength(
                            //                                   productController
                            //                                       .selectedVariations,
                            //                                   index)) {
                            //                     showCustomSnackBar(
                            //                         '${'you_need_to_select_minimum'.tr} ${variationList[index].min} '
                            //                         '${'to_maximum'.tr} ${variationList[index].max} ${'options_from'.tr} ${variationList[index].name} ${'variation'.tr}',
                            //                         isError: true,
                            //                         isToast: true);
                            //                     return;
                            //                   }
                            //                 }
                            //               }

                            //               cartController.addToCart(
                            //                   CartModel(
                            //                     note: note.text.isNotEmpty
                            //                         ? note.text.toString()
                            //                         : null,
                            //                     price: priceWithVariation,
                            //                     discountedPrice:
                            //                         priceWithDiscount,
                            //                     variation: [],
                            //                     discountAmount:
                            //                         priceWithVariation -
                            //                             PriceConverter
                            //                                 .convertWithDiscount(
                            //                               priceWithVariation,
                            //                               discount,
                            //                               discountType,
                            //                             ),
                            //                     quantity:
                            //                         productController.quantity,
                            //                     taxAmount: (priceWithVariation -
                            //                         PriceConverter
                            //                             .convertWithDiscount(
                            //                                 priceWithVariation,
                            //                                 widget.product.tax!,
                            //                                 widget.product
                            //                                     .taxType!) +
                            //                         addonsTax),
                            //                     addOnIds: addOnIdList,
                            //                     product: widget.product,
                            //                     variations: productController
                            //                         .selectedVariations,
                            //                   ),
                            //                   widget.cart != null
                            //                       ? widget.cartIndex!
                            //                       : productController
                            //                           .cartIndex);

                            //               showCustomSnackBar(
                            //                   'Item added to cart',
                            //                   isError: false,
                            //                   isToast: true);

                            //               productController.update();
                            //               cartController.update();
                            //               Get.back();
                            //             }
                            //           : null,
                            //     ),
                            //   )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
            }),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomRoundedButton(
                  widget: const Icon(Icons.close_outlined, size: 15),
                  image: '',
                  onTap: () => Get.back(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productDescription() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              overflow: TextOverflow.ellipsis,
              'description'.tr,
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            VegTagView(product: widget.product),
          ],
        ),
        SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: ExpandableText(
            // overflow: TextOverflow.ellipsis,
            widget.product.description ?? '',
            expandText: 'show_more'.tr,
            collapseText: 'show_less'.tr,
            maxLines: 2,
            linkColor: Colors.blue,
            animation: true,
            animationDuration: const Duration(milliseconds: 500),
            collapseOnTextTap: true,
            urlStyle: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}

class VegTagView extends StatelessWidget {
  const VegTagView({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return splashController.configModel!.isVegNonVegActive!
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5,
                      color: Theme.of(context).cardColor.withOpacity(0.05))
                ],
              ),
              child: product.productType == null
                  ? const SizedBox()
                  : SizedBox(
                      height: ResponsiveHelper.isSmallTab() ? 25 : 30,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                Dimensions.paddingSizeExtraSmall),
                            child: Image.asset(
                              fit: BoxFit.fitHeight,
                              Images.getImageUrl(product.productType!),
                            ),
                          ),
                          SizedBox(width: Dimensions.paddingSizeSmall),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            product.productType!.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        ],
                      ),
                    ),
            )
          : const SizedBox();
    });
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required int cartIndex,
  }) : _cartIndex = cartIndex;

  final int _cartIndex;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        QuantityButton(
            isIncrement: false,
            onTap: () {
              if (productController.quantity == 1 && _cartIndex != -1) {
                Get.find<CartController>().removeFromCart(_cartIndex);
                Get.back();
              } else if (productController.quantity > 1) {
                productController.setQuantity(false);
              }
            }),
        SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Text(
          overflow: TextOverflow.ellipsis,
          productController.quantity.toString(),
          style: robotoBold.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: Dimensions.fontSizeExtraLarge + 15),
        ),
        SizedBox(width: Dimensions.paddingSizeExtraSmall),
        QuantityButton(
          isIncrement: true,
          onTap: () => productController.setQuantity(true),
        ),
      ]);
    });
  }
}
