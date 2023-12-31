// ignore_for_file: unnecessary_string_interpolations

import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/model/response/place_order_body.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/date_converter.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/confirmation_dialog.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_divider.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:efood_table_booking/view/screens/cart/widget/order_note_view.dart';
import 'package:efood_table_booking/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:efood_table_booking/view/screens/order/payment_screen.dart';
import 'package:efood_table_booking/view/screens/order/widget/order_success_screen.dart';
import 'package:efood_table_booking/view/screens/root/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../controller/printer_controller.dart';
import '../../../base/custom_text_field.dart';

class CartDetails extends StatefulWidget {
  final bool showButton;
  const CartDetails({
    Key? key,
    required this.showButton,
  }) : super(key: key);

  @override
  State<CartDetails> createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  void callBack(bool isSuccess, String message, String orderID) async {
    //    orderDetailsModel = orderDetailsModel.copyWith(id: orderID);
    if (isSuccess) {
      Get.find<CartController>().clearCartData();
      Get.find<OrderController>().updateOrderNote(null);
      Get.find<OrderController>().setSelectedMethod(
          Get.find<OrderController>().paymentMethodList.first);
      if (Get.find<OrderController>().getOrderSuccessModel() != null) {
        Get.find<OrderController>()
            .getCurrentOrder(
                Get.find<OrderController>().orderSuccessModel!.orderId!)
            .then((value) {
          Get.find<PrinterController>().printTest();

          Get.off(() => const OrderSuccessScreen(fromPlaceOrder: true));
        });
      }
    } else {
      showCustomSnackBar(message);
    }
  }

  String replaceNumbersInRange(String input, int start, int end) {
    for (int i = start; i <= end && i < input.length; i++) {
      if (isNumeric(input[i])) {
        input = input.replaceRange(i, i + 1, "");
      }
    }

    return input;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isTab(context)
        ? Expanded(
            child: _body(context),
          )
        : _body(context);
  }

  Widget _body(BuildContext context) {
    // bool _isPortrait = context.height < context.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeDefault,
      ),
      child: GetBuilder<SplashController>(builder: (splashController) {
        return GetBuilder<OrderController>(builder: (orderController) {
          return GetBuilder<CartController>(builder: (cartController) {
            DateTime dateTime = DateTime.now();
            List<List<AddOn>> addOnsList = [];
            List<bool> availableList = [];
            double itemPrice = 0;
            int itemsCount = 0;
            double discount = 0;
            double tax = 0;
            double addOns = 0;
            double variationsPrice = 0;
            String customerName = "";
            String customerEmail = "";
            final orderController = Get.find<OrderController>();

            List<CartModel> cartList = cartController.cartList;
            itemsCount = 0;
            for (var cartModel in cartList) {
              List<AddOn> addOnList = [];
              itemsCount += cartModel.quantity ?? 0;

              cartModel.addOnIds?.forEach((addOnId) {
                if (cartModel.product != null &&
                    cartModel.product?.addOns! != null) {
                  for (AddOn addOns in cartModel.product!.addOns!) {
                    if (addOns.id == addOnId.id) {
                      addOnList.add(addOns);
                      break;
                    }
                  }
                }
              });
              addOnsList.add(addOnList);

              availableList.add(DateConverter.isAvailable(
                  cartModel.product?.availableTimeStarts,
                  cartModel.product?.availableTimeEnds));

              for (int index = 0; index < addOnList.length; index++) {
                addOns = addOns +
                    (addOnList[index].price! *
                        cartModel.addOnIds![index].quantity!.toDouble());
              }
              // itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
              itemPrice = itemPrice + (cartModel.price!);
              discount = discount +
                  (cartModel.discountAmount! * cartModel.quantity!.toDouble());
              tax =
                  tax + (cartModel.taxAmount! * cartModel.quantity!.toDouble());
            }

            // cartController.customerName
            // double _subTotal = _itemPrice + _tax + _addOns;
            double total = itemPrice;
            // itemPrice -
            //     discount +
            //     //  orderController.previousDueAmount() +
            //     tax +
            //addOns;

            cartController.setTotalAmount = total;
            if (cartController.customerName != null) {
              customerName = cartController.customerName.toString();
            }
            // if (cartList.isNotEmpty) {
            //   itemsCount = cartList.length;
            // }

            return cartController.cartList.isEmpty
                ? NoDataScreen(
                    text: 'please_add_food_to_order'.tr,
                    backbutton: !widget.showButton,
                  )
                : Column(
                    children: [
                      !widget.showButton
                          ? Text(
                              overflow: TextOverflow.ellipsis,
                              '${cartController.customerName ?? ''}',
                              style: robotoRegular.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.back_hand,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          if (cartController.cartList.isEmpty) {
                                            showCustomSnackBar(
                                                'please_add_food_to_order'.tr);
                                          } else {
                                            List<Cart> carts = [];
                                            for (int index = 0;
                                                index <
                                                    cartController
                                                        .cartList.length;
                                                index++) {
                                              CartModel cart = cartController
                                                  .cartList[index];
                                              List<int> addOnIdList = [];
                                              List<int> addOnQtyList = [];
                                              List<OrderVariation> variations =
                                                  [];
                                           
                                              cart.addOnIds?.forEach((addOn) {
                                                addOnIdList.add(addOn.id!);
                                                addOnQtyList
                                                    .add(addOn.quantity!);
                                              });

                                              if (cart.product != null &&
                                                  cart.product!.variations !=
                                                      null &&
                                                  cart.variations != null) {
                                                for (int i = 0;
                                                    i <
                                                        cart.product!
                                                            .variations!.length;
                                                    i++) {
                                                  if (cart.variations![i]
                                                      .contains(true)) {
                                                    variations
                                                        .add(OrderVariation(
                                                      name: cart.product!
                                                          .variations![i].name,
                                                      values:
                                                          OrderVariationValue(
                                                              label: []),
                                                    ));

                                                    if (cart
                                                            .product!
                                                            .variations![i]
                                                            .variationValues !=
                                                        null) {
                                                      for (int j = 0;
                                                          j <
                                                              cart
                                                                  .product!
                                                                  .variations![
                                                                      i]
                                                                  .variationValues!
                                                                  .length;
                                                          j++) {
                                                        if (cart.variations![i]
                                                            [j]) {
                                                          variations[variations
                                                                      .length -
                                                                  1]
                                                              .values
                                                              ?.label
                                                              ?.add(cart
                                                                      .product!
                                                                      .variations![
                                                                          i]
                                                                      .variationValues?[
                                                                          j]
                                                                      .level ??
                                                                  '');
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }

                                              carts.add(Cart(
                                                  cart.product!.id!.toString(),
                                                  cart.discountedPrice
                                                      .toString(),
                                                  '',
                                                  variations,
                                                  cart.discountAmount!,
                                                  cart.quantity!,
                                                  cart.taxAmount!,
                                                  addOnIdList,
                                                  addOnQtyList,
                                                  cart.note));
                                            }

                                            PlaceOrderBody placeOrderBody =
                                                PlaceOrderBody(
                                              carts,
                                              total,
                                              orderController.selectedMethod,
                                              orderController.orderNote ?? '',
                                              'now',
                                              DateFormat('yyyy-MM-dd')
                                                  .format(dateTime),
                                              0,
                                              0,
                                              cartController.customerName,
                                              cartController.customerEmail,
                                              '${splashController.getBranchId()}',
                                              '',
                                              orderController
                                                      .getOrderSuccessModel()
                                                      ?.first
                                                      .branchTableToken ??
                                                  '',
                                            );

                                            orderController.setPlaceOrderBody =
                                                placeOrderBody;

                                            orderController.placeOrder(
                                              orderController.placeOrderBody!
                                                  .copyWith(
                                                paymentStatus: 'unpaid',
                                                paymentMethod: '',
                                                previousDue: orderController
                                                    .previousDueAmount(),
                                              ),
                                              (bool isSuccess, String message,
                                                  String orderID) async {
                                                //    orderDetailsModel = orderDetailsModel.copyWith(id: orderID);
                                                if (isSuccess) {
                                                  cartController
                                                      .clearCartData();
                                                  orderController
                                                      .updateOrderNote(null);
                                                  orderController
                                                      .setSelectedMethod(
                                                          orderController
                                                              .paymentMethodList
                                                              .first);
                                                  if (orderController
                                                          .getOrderSuccessModel() !=
                                                      null) {
                                                    orderController
                                                        .getCurrentOrder(
                                                            orderController
                                                                .orderSuccessModel!
                                                                .orderId!)
                                                        .then((value) {
                                                      Get.find<
                                                              PrinterController>()
                                                          .printTest();

                                                      Get.off(() =>
                                                          const OrderSuccessScreen(
                                                              fromPlaceOrder:
                                                                  true));
                                                    });
                                                  }
                                                } else {
                                                  showCustomSnackBar(message);
                                                }
                                              },
                                              '0',
                                              0,
                                            );
                                          }
                                          //cartController.clearCartData();
                                        }),
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextField(
                                        borderColor: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.4),
                                        controller: _nameController,
                                        onChanged: (value) {
                                          setState(() {
                                            customerName = value;
                                            cartController.setCustomerName =
                                                customerName;
                                          });
                                        },
                                        onSubmit: (value) {
                                          setState(() {
                                            customerName = value;
                                            cartController.setCustomerName =
                                                customerName;
                                          });
                                        },
                                        //   inputType: TextInputType.number,
                                        //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                        hintText: 'Customer Name/Table No.',
                                        hintStyle: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall + 5),
                                        //  focusNode: _nameFocusNode,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextField(
                                        maxLines: 1,

                                        //  heightSufIcon: 4,
                                        // suffixIcon: 'assets/image/gmail.png',
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Image.asset(
                                              'assets/image/gmail.png',
                                              fit: BoxFit.contain,
                                              height: 10,
                                              width: 20),
                                        ),
                                        borderColor: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.4),
                                        controller: _emailController,
                                        onChanged: (value) {
                                          setState(() {
                                            customerEmail = value;
                                            cartController.setCustomerEmail =
                                                customerEmail;
                                          });
                                        },
                                        onSubmit: (value) {
                                          setState(() {
                                            customerEmail = value;
                                            cartController.setCustomerEmail =
                                                customerEmail;
                                          });
                                        },
                                        // inputType: TextInputType.number,
                                        //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                        hintText: 'Customer Email',
                                        hintStyle: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall + 5),
                                        //  focusNode: _nameFocusNode,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                              ],
                            ),
                      !widget.showButton
                          ? Text(
                              overflow: TextOverflow.ellipsis,
                              '${cartController.customerEmail ?? ''}',
                              style: robotoRegular.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomDivider(
                            color: Theme.of(context).disabledColor),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: cartController.cartList.length,
                            itemBuilder: (context, index) {
                              CartModel cartItem =
                                  cartController.cartList[index];
                              List<Variation>? variationList;
                              List<Widget> variationWidgetList = [];
                              List<Widget> addOnWidgetList = [];
                              bool takeAway = false;

                              if (cartItem.product!.branchProduct != null &&
                                  cartItem
                                      .product!.branchProduct!.isAvailable!) {
                                variationList =
                                    cartItem.product!.branchProduct!.variations;
                              } else {
                                variationList = cartItem.product!.variations;
                              }
                              String? note = cartItem.note;
                              String variationText = '';
                              String addonsName = '';
                              bool showproductPrice = true;
                              // var logger = Logger();
                              cartItem.addOnIds?.forEach((addOn) {
                                if (addOn.is_product == true) {
                                  showproductPrice = false;
                                }
                                addonsName =
                                    '$addonsName${addOn.name} (${addOn.quantity}), ';
                                // logger.i(
                                //     "${addOn.name} qty:${addOn.quantity} price:${addOn.price}");
                                addOnWidgetList.add(Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          addOn.name.toString(),
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .color!,
                                          ),
                                          maxLines: 1,
                                          // overflow: TextOverflow
                                          //     .ellipsis,
                                        )),
                                    Expanded(
                                        // flex: 5,
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeExtraSmall),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        "x ${addOn.quantity}",
                                        textAlign: TextAlign.center,
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .color!),
                                      ),
                                    )),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            // "lmm",
                                            "${PriceConverter.convertPrice(addOn.price ?? 0)}"
                                                .trim(),
                                            textAlign: TextAlign.end,
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color!),
                                            maxLines: 2,
                                          ),
                                        )),
                                  ],
                                ));
                              });
                              // if (addonsName.isNotEmpty) {
                              //   addonsName = addonsName.substring(
                              //       0, addonsName.length - 2);
                              // }

                              if (variationList != null &&
                                  cartItem.variations!.isNotEmpty) {
                                for (int index = 0;
                                    index < cartItem.variations!.length;
                                    index++) {
                                  if (cartItem.variations![index]
                                      .contains(true)) {
                                    // variationText +=
                                    //     "${cartItem.product!.variations![index].name}";
                                    // variationText +=
                                    //     '${variationText.isNotEmpty ? '' : ''}${cartItem.product!.variations![index].name?.replaceAll("optiona", "optional :\n").replaceAll("Choose", "").trimLeft()} ';
                                    for (int i = 0;
                                        i < cartItem.variations![index].length;
                                        i++) {
                                      if (cartItem.variations![index][i]) {
                                        // variationText += variationList[index]
                                        //     .variationValues![i]
                                        //     .level
                                        //     .toString();
                                        // print(
                                        //     "${variationList[index].variationValues![i].level ?? ""}jass");
                                        if (variationList[index]
                                                .variationValues![i]
                                                .level!
                                                .contains("Take away") ||
                                            variationList[index]
                                                .variationValues![i]
                                                .level!
                                                .contains("Dine in")) {
                                          if (variationList[index]
                                              .variationValues![i]
                                              .level!
                                              .contains("Take away")) {
                                            takeAway = true;
                                          }
                                          continue;
                                        }

                                        variationWidgetList.add(
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        replaceNumbersInRange(
                                                                variationList[
                                                                            index]
                                                                        .variationValues![
                                                                            i]
                                                                        .level ??
                                                                    "",
                                                                0,
                                                                2)
                                                            .trimLeft(),
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .color!,
                                                        ),
                                                        maxLines: 5,
                                                        // overflow: TextOverflow
                                                        //     .ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeExtraSmall,
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                  // flex: 5,
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  '${variationList[index].variationValues?[i].level?.replaceAll(RegExp(r'[^0-9]'), '')}',
                                                  textAlign: TextAlign.center,
                                                  style: robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .color!),
                                                ),
                                              )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // "lmm",
                                                      "${PriceConverter.convertPrice(variationList[index].variationValues?[i].optionPrice ?? 0)}"
                                                          .trim(),
                                                      textAlign: TextAlign.end,
                                                      style: robotoRegular
                                                          .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .color!),
                                                      maxLines: 2,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        );

                                        // variationText +=
                                        //     "${variationList[index].variationValues?[i].level} - ${PriceConverter.convertPrice(variationList[index].variationValues?[i].optionPrice ?? 0)}\n";
                                        // variationText +=
                                        //     '${variationText.endsWith('(') ? '' : ','}${variationList[index].variationValues?[i].level} - ${PriceConverter.convertPrice(variationList[index].variationValues?[i].optionPrice ?? 0)}';
                                      }
                                    }
                                    // variationText += ')';
                                  }
                                }
                              }

                              return InkWell(
                                onTap: () => RouteHelper.openDialog(
                                  context,
                                  ProductBottomSheet(
                                    product: cartItem.product!,
                                    cart: cartItem,
                                    cartIndex: index,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          takeAway
                                              ? Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "** Take away **",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "Eat In",
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: const Color.fromARGB(
                                                        255, 7, 165, 12),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              '${cartItem.product!.name ?? ''}',
                                                              style:
                                                                  robotoRegular
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeLarge,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .color!,
                                                              ),
                                                              maxLines: 17,
                                                              // overflow: TextOverflow
                                                              //     .ellipsis,
                                                            ),
                                                          ),
                                                          if (showproductPrice)
                                                            Text(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              "${PriceConverter.convertPrice(cartItem.product!.price ?? 0)}",
                                                              style:
                                                                  robotoRegular
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeLarge,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge!
                                                                    .color!,
                                                              ),
                                                            
                                                              // overflow: TextOverflow
                                                              //     .ellipsis,
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                              // Expanded(
                                              //     child: Padding(
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: Dimensions
                                              //           .paddingSizeExtraSmall),
                                              //   child: Text(
                                              //     overflow:
                                              //         TextOverflow.ellipsis,
                                              //     '${cartItem.quantity}',
                                              //     textAlign: TextAlign.center,
                                              //     style: robotoRegular.copyWith(
                                              //         fontSize: Dimensions
                                              //             .fontSizeLarge,
                                              //         color: Theme.of(context)
                                              //             .textTheme
                                              //             .titleLarge!
                                              //             .color!),
                                              //   ),
                                              // )),
                                              // Expanded(
                                              //     flex: 2,
                                              //     child: Padding(
                                              //       padding: EdgeInsets.symmetric(
                                              //           horizontal: Dimensions
                                              //               .paddingSizeExtraSmall),
                                              //       child: Text(
                                              //         overflow:
                                              //             TextOverflow.ellipsis,
                                              //         PriceConverter
                                              //             .convertPrice(
                                              //           cartItem.price! *
                                              //               cartItem.quantity!,
                                              //         ),
                                              //         textAlign: TextAlign.end,
                                              //         style: robotoRegular
                                              //             .copyWith(
                                              //                 fontSize: Dimensions
                                              //                     .fontSizeLarge,
                                              //                 color: Theme.of(
                                              //                         context)
                                              //                     .textTheme
                                              //                     .titleLarge!
                                              //                     .color!),
                                              //         maxLines: 1,
                                              //       ),
                                              //     )),
                                              Expanded(
                                                  child: IconButton(
                                                onPressed: () {
                                                  cartController
                                                      .removeFromCart(index);
                                                  showCustomSnackBar(
                                                      'cart_item_delete_successfully'
                                                          .tr,
                                                      isError: false);
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                                alignment: Alignment.topRight,
                                                padding: EdgeInsets.zero,
                                                iconSize:
                                                    Dimensions.paddingSizeLarge,
                                              )),
                                            ],
                                          ),
                                          //variationWidgetList.map((e) => e,).toList(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ...variationWidgetList,
                                              ...addOnWidgetList
                                            ],
                                          ),
                                          if (cartItem.note != null)
                                            Text(
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                'Note: ${cartItem.note}',
                                                style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ))
                                        ],
                                      ),
                                    ),

                                    // Text(
                                    //  overflow: TextOverflow.ellipsis,
                                    //   PriceConverter.convertPrice(
                                    //       cartItem.product?.price ?? 0),
                                    //   style: robotoRegular.copyWith(
                                    //     color: Theme.of(context).hintColor,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: Dimensions.paddingSizeExtraSmall,
                                    // ),
                                    // if (addonsName.isNotEmpty)
                                    //   Text(
                                    //       overflow: TextOverflow.ellipsis,
                                    //       '${'addons'.tr}: $addonsName',
                                    //       style: robotoRegular.copyWith(
                                    //         fontSize: Dimensions.fontSizeSmall,
                                    //         color: Theme.of(context).hintColor,
                                    //       )),
                                    Builder(builder: (context) {
                                      bool render = false;
                                      render = cartList.isNotEmpty &&
                                          cartList.length == index + 1;
                                      return !render
                                          ? Column(
                                              children: [
                                                CustomDivider(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall,
                                                ),
                                              ],
                                            )
                                          : ResponsiveHelper.isSmallTab()
                                              ? _calculationView(
                                                  context,
                                                  itemPrice,
                                                  discount,
                                                  tax,
                                                  addOns,
                                                  orderController,
                                                  total,
                                                  itemsCount)
                                              : const SizedBox();
                                    }),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Column(
                        children: [
                          if (!ResponsiveHelper.isSmallTab())
                            _calculationView(context, itemPrice, discount, tax,
                                addOns, orderController, total, itemsCount),
                          if (cartController.cartList.isNotEmpty &&
                              widget.showButton)
                            Row(
                              children: [
                                GetBuilder<PrinterController>(
                                    builder: (printerController) {
                                  return printerController.openDrawer
                                      ? IconButton(
                                          onPressed: printerController
                                              .openDrawerOnClick,
                                          icon: Icon(
                                            Icons.electric_bolt_rounded,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ))
                                      : Container();
                                }),
                                Expanded(
                                    child: CustomButton(
                                  height:
                                      ResponsiveHelper.isSmallTab() ? 40 : 50,
                                  transparent: true,
                                  buttonText: 'clear_cart'.tr,
                                  onPressed: () {
                                    RouteHelper.openDialog(
                                      context,
                                      ConfirmationDialog(
                                        title: '${'clear_cart'.tr} !',
                                        icon: Icons.cleaning_services_rounded,
                                        description: 'are_you_want_to_clear'.tr,
                                        onYesPressed: () {
                                          cartController.clearCartData();
                                          Get.back();
                                        },
                                        onNoPressed: () => Get.back(),
                                      ),
                                    );

                                    //cartController.clearCartData();
                                  },
                                )),
                                const Gap(6),
                                Expanded(
                                  child: CustomButton(
                                    height:
                                        ResponsiveHelper.isSmallTab() ? 40 : 50,
                                    buttonText: 'place_order'.tr,
                                    onPressed: () {
                                      if (cartController.cartList.isEmpty) {
                                        showCustomSnackBar(
                                            'please_add_food_to_order'.tr);
                                      } else {
                                        List<Cart> carts = [];
                                        for (int index = 0;
                                            index <
                                                cartController.cartList.length;
                                            index++) {
                                          CartModel cart =
                                              cartController.cartList[index];
                                          List<int> addOnIdList = [];
                                          List<int> addOnQtyList = [];
                                          List<OrderVariation> variations = [];
                                          cart.addOnIds?.forEach((addOn) {
                                            addOnIdList.add(addOn.id!);
                                            addOnQtyList.add(addOn.quantity!);
                                          });

                                          if (cart.product != null &&
                                              cart.product!.variations !=
                                                  null &&
                                              cart.variations != null) {
                                            for (int i = 0;
                                                i <
                                                    cart.product!.variations!
                                                        .length;
                                                i++) {
                                              if (cart.variations![i]
                                                  .contains(true)) {
                                                variations.add(OrderVariation(
                                                  name: cart.product!
                                                      .variations![i].name,
                                                  values: OrderVariationValue(
                                                      label: []),
                                                ));

                                                if (cart.product!.variations![i]
                                                        .variationValues !=
                                                    null) {
                                                  for (int j = 0;
                                                      j <
                                                          cart
                                                              .product!
                                                              .variations![i]
                                                              .variationValues!
                                                              .length;
                                                      j++) {
                                                    if (cart.variations![i]
                                                        [j]) {
                                                      variations[variations
                                                                  .length -
                                                              1]
                                                          .values
                                                          ?.label
                                                          ?.add(cart
                                                                  .product!
                                                                  .variations![
                                                                      i]
                                                                  .variationValues?[
                                                                      j]
                                                                  .level ??
                                                              '');
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }

                                          carts.add(Cart(
                                              cart.product!.id!.toString(),
                                              cart.discountedPrice.toString(),
                                              '',
                                              variations,
                                              cart.discountAmount!,
                                              cart.quantity!,
                                              cart.taxAmount!,
                                              addOnIdList,
                                              addOnQtyList,
                                              cart.note));
                                        }

                                        PlaceOrderBody placeOrderBody =
                                            PlaceOrderBody(
                                          carts,
                                          total,
                                          Get.find<OrderController>()
                                              .selectedMethod,
                                          Get.find<OrderController>()
                                                  .orderNote ??
                                              '',
                                          DateFormat('hh:mm:ss')
                                              .format(dateTime),
                                          DateFormat('yyyy-MM-dd')
                                              .format(dateTime),
                                          0,
                                          0,
                                          cartController.customerName,
                                          cartController.customerEmail,
                                          '${splashController.getBranchId()}',
                                          '',
                                          Get.find<OrderController>()
                                                  .getOrderSuccessModel()
                                                  ?.first
                                                  .branchTableToken ??
                                              '',
                                        );

                                        Get.find<OrderController>()
                                            .setPlaceOrderBody = placeOrderBody;

                                        Get.to(
                                          const PaymentScreen(),
                                          transition: Transition.leftToRight,
                                          duration:
                                              const Duration(milliseconds: 300),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
          });
        });
      }),
    );
  }

  Column _calculationView(
      BuildContext context,
      double itemPrice,
      double discount,
      double tax,
      double addOns,
      OrderController orderController,
      double total,
      int itemsCount) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GetBuilder<OrderController>(builder: (orderController) {
              return Flexible(
                child: Text.rich(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    children: orderController.orderNote != null
                        ? [
                            TextSpan(
                              text: 'note'.tr,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                            TextSpan(
                              text: ' ${orderController.orderNote!}',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                              ),
                            ),
                          ]
                        : [
                            TextSpan(
                              text: 'add_spacial_note_here'.tr,
                              style: robotoRegular.copyWith(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ],
                  ),
                ),
              );
            }),
            InkWell(
              onTap: () {
                RouteHelper.openDialog(
                    context,
                    OrderNoteView(
                      note: Get.find<OrderController>().orderNote,
                      onChange: (note) {
                        Get.find<OrderController>().updateOrderNote(
                          note.trim().isEmpty ? null : note,
                        );
                      },
                    ));
              },
              child: Image.asset(
                Images.editIcon,
                color: Theme.of(context).secondaryHeaderColor,
                width: Dimensions.paddingSizeExtraLarge,
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.isSmallTab()
              ? Dimensions.paddingSizeSmall
              : Dimensions.paddingSizeDefault,
        ),
        CustomDivider(
          color: Theme.of(context).disabledColor,
        ),
        SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            overflow: TextOverflow.ellipsis,
            "Items Count",
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
            ),
          ),
          Text(
            overflow: TextOverflow.ellipsis,
            '$itemsCount',
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
            ),
          )
        ]),
        // PriceWithType(
        //   type: 'items_price'.tr,
        //   amount: PriceConverter.convertPrice(itemPrice),
        // ),
        // PriceWithType(
        //     type: 'discount'.tr,
        //     amount: '- ${PriceConverter.convertPrice(discount)}'),
        // PriceWithType(
        //     type: 'vat_tax'.tr,
        //     amount: '+ ${PriceConverter.convertPrice(tax)}'),
        // PriceWithType(
        //     type: 'addons'.tr,
        //     amount: '+ ${PriceConverter.convertPrice(addOns)}'),
        // PriceWithType(
        //     type: 'previous_due'.tr,
        //     amount:
        //         '+ ${PriceConverter.convertPrice(orderController.previousDueAmount())}'),
        PriceWithType(
            type: 'total'.tr,
            amount: PriceConverter.convertPrice(total),
            isTotal: true),
        SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
      ],
    );
  }
}

class PriceWithType extends StatelessWidget {
  final String type;
  final String amount;
  final bool isTotal;
  const PriceWithType(
      {Key? key,
      required this.type,
      required this.amount,
      this.isTotal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: ResponsiveHelper.isSmallTab() ? 4 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            overflow: TextOverflow.ellipsis,
            type,
            style: isTotal
                ? robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  )
                : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          Text(
              overflow: TextOverflow.ellipsis,
              amount,
              style: isTotal
                  ? robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    )
                  : robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        ],
      ),
    );
  }
}
