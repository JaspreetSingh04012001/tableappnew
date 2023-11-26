import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/sales_controller.dart';
import 'package:efood_table_booking/data/model/response/order_details_model.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_divider.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/screens/cart/widget/cart_detais.dart';
import 'package:efood_table_booking/view/screens/order/widget/emailDialog.dart';
import 'package:efood_table_booking/view/screens/order/widget/invoice_print_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../controller/printer_controller.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../base/animated_dialog.dart';
import '../../../base/confirmation_dialog.dart';
import '../../../base/custom_button.dart';

class OrderDetailsView extends StatelessWidget {
  bool isSales = false;
  int itemCount;
  OrderDetailsView({Key? key, this.itemCount = 0, this.isSales = false})
      : super(key: key);
  final DateFormat formatter = DateFormat();
  // String removeEmptyLines(String input) {
  //   print("JassVar$input");
  //   return input;
  //   // .replaceAll(RegExp(r'^\s*$\n', multiLine: true), '')
  //   // .split('\n')
  //   // .map((line) => line.trimLeft())
  //   // .join('\n');
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<OrderController>(builder: (orderController) {
          return orderController.currentOrderDetails == null
              ? Center(
                  child: CustomLoader(color: Theme.of(context).primaryColor))
              : Builder(builder: (context) {
                  double itemsPrice = 0;
                  double discount = 0;
                  double tax = 0;
                  double addOnsPrice = 0;
                  List<Details> orderDetails =
                      orderController.currentOrderDetails?.details ?? [];
                  if (orderController.currentOrderDetails?.details != null) {
                    for (Details orderDetails in orderDetails) {
                      itemsPrice = itemsPrice +
                          (orderDetails.price! *
                              orderDetails.quantity!.toInt());
                      discount = discount +
                          (orderDetails.discountOnProduct! *
                              orderDetails.quantity!.toInt());
                      tax = (tax +
                          (orderDetails.taxAmount! *
                              orderDetails.quantity!.toInt()) +
                          orderDetails.addonTaxAmount!);
                    }
                  }

                  double total =
                      orderController.currentOrderDetails!.order?.orderAmount ??
                          0;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        'order_summary'.tr,
                                        style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimensions.paddingSizeSmall,
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        '${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}',
                                        style: robotoBold.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text.rich(
                                  //   TextSpan(
                                  //     children: [
                                  //       TextSpan(
                                  //         text:
                                  //             '${'table'.tr} ${Get.find<SplashController>().getTable(
                                  //                   orderController
                                  //                       .currentOrderDetails
                                  //                       ?.order
                                  //                       ?.tableId,
                                  //                   branchId: orderController
                                  //                       .currentOrderDetails
                                  //                       ?.order
                                  //                       ?.branchId,
                                  //                 )?.number} |',
                                  //         style: robotoMedium.copyWith(
                                  //           fontSize: Dimensions.fontSizeLarge,
                                  //           color: Theme.of(context)
                                  //               .textTheme
                                  //               .bodyLarge!
                                  //               .color,
                                  //         ),
                                  //       ),
                                  //       TextSpan(
                                  //         text:
                                  //             '${orderController.currentOrderDetails?.order?.numberOfPeople ?? 'add'.tr} ${'people'.tr}',
                                  //         style: robotoRegular.copyWith(
                                  //           fontSize: Dimensions.fontSizeLarge,
                                  //           color: Theme.of(context)
                                  //               .textTheme
                                  //               .bodyLarge!
                                  //               .color,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (orderController
                                .currentOrderDetails?.order?.createdAt !=
                            null)
                          Text(
                            overflow: TextOverflow.ellipsis,
                            formatter.format(DateTime.parse(orderController
                                        .currentOrderDetails
                                        ?.order!
                                        .createdAt ??
                                    "")) ??
                                '',
                            style: robotoRegular.copyWith(
                              // fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeDefault,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        if (orderController
                                .currentOrderDetails?.order?.customer_name !=
                            null)
                          Text(
                            overflow: TextOverflow.ellipsis,
                            orderController.currentOrderDetails?.order
                                    ?.customer_name ??
                                '',
                            style: robotoRegular.copyWith(
                              // fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        if (orderController
                                .currentOrderDetails?.order?.customer_email !=
                            null)
                          Text(
                            overflow: TextOverflow.ellipsis,
                            orderController.currentOrderDetails?.order
                                    ?.customer_email ??
                                '',
                            style: robotoRegular.copyWith(
                              //  fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                              itemCount: orderController
                                  .currentOrderDetails?.details?.length,
                              itemBuilder: (context, index) {
                                // itemCount += orderController
                                //         .currentOrderDetails?.details?.length ??
                                //     0;
                                orderController.currentOrderDetails?.details
                                    ?.forEach((element) {
                                  itemCount += element.quantity ?? 0;
                                });
                                // orderController
                                //     .currentOrderDetails?.details[0].variations;
                                late Details details;
                                String variationText = '';
                                // int a = 0;
                                if (orderController
                                        .currentOrderDetails?.details !=
                                    null) {
                                  details = orderController
                                      .currentOrderDetails!.details![index];
                                }

                                String addonsName = '';
                                List<Widget> addOnWidgetList = [];
                                bool takeAway = false;
                                //orderController.currentOrderDetails.details.
                                Details? orderDetails = orderController
                                    .currentOrderDetails?.details?[index];

                                List<AddOns> addons =
                                    details.productDetails == null
                                        ? []
                                        : details.productDetails!.addOns == null
                                            ? []
                                            : details.productDetails!.addOns!;
                                List<int> addQty = details.addOnQtys ?? [];
                                List<int> ids = details.addOnIds ?? [];

                                // if (ids.length == details.addOnPrices?.length &&
                                //     ids.length == details.addOnQtys?.length) {
                                //   for (int i = 0; i < ids.length; i++) {
                                //     addOnsPrice = addOnsPrice +
                                //         (details.addOnPrices![i] *
                                //             details.addOnQtys![i]);
                                //   }
                                // }
                                if (ids.length == details.addOnPrices?.length &&
                                    ids.length == details.addOnQtys?.length) {
                                  for (int j = 0; j < ids.length; j++) {
                                    int id = ids[j];

                                    for (var addOn in addons) {
                                      if (addOn.id == id) {
                                        Logger().i(
                                            "$id ${addOn.name} ${addQty[j]}");
                                      
                                      
                                      
                                      
                                        addOnWidgetList.add(Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  addOn.name.toString(),
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
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
                                                  horizontal: Dimensions
                                                      .paddingSizeExtraSmall),
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                addQty[j].toString(),
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
                                                    PriceConverter.convertPrice(
                                                            (addOn.price! *
                                                                    addQty[
                                                                        j]) ??
                                                                0)
                                                        .trim(),
                                                    textAlign: TextAlign.end,
                                                    style:
                                                        robotoRegular.copyWith(
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
                                        ));
                                      }
                                    }
                                    // if(){}
                                  }
                                }

                                //  ids.forEach((id) {    });

                                // try {
                                //   for (AddOns addOn in addons) {
                                //     if (ids.contains(addOn.id)) {

                                //       // addonsName = addonsName +
                                //       //     ('${addOn.name} (${(addQty[a])}), ');
                                //       // a++;
                                //     }
                                //   }
                                // } catch (e) {
                                //   debugPrint('order details view -$e');
                                // }

                                // if (addonsName.isNotEmpty) {
                                //   addonsName = addonsName.substring(
                                //       0, addonsName.length - 2);
                                // }
                                // orderDetails!.productDetails.;
                                if (orderDetails != null &&
                                    orderDetails.variations != null &&
                                    orderDetails.variations!.isNotEmpty) {
                                  for (Variation variation
                                      in orderDetails.variations!) {
                                    variationText +=
                                        '${variationText.isNotEmpty ? ',' : ''}${variation.name} (';
                                    for (VariationValue value
                                        in variation.variationValues!) {
                                      variationText += '${value.level}';
                                      //   '${variationText.endsWith('(') ? '' : ', '}${value.level}';
                                    }
                                    variationText += ')';
                                  }
                                } else if (orderDetails != null &&
                                    orderDetails.oldVariations != null &&
                                    orderDetails.oldVariations!.isNotEmpty) {
                                  List<String> variationTypes =
                                      orderDetails.oldVariations![0].type !=
                                              null
                                          ? orderDetails.oldVariations![0].type!
                                              .split('-')
                                          : [];

                                  if (variationTypes.length ==
                                      orderDetails.productDetails?.choiceOptions
                                          ?.length) {
                                    int index = 0;
                                    orderDetails.productDetails?.choiceOptions
                                        ?.forEach((choice) {
                                      variationText =
                                          '$variationText${(index == 0) ? '' : ''}${choice.title} - ${variationTypes[index]}';
                                      index = index + 1;
                                    });
                                  } else {
                                    variationText =
                                        orderDetails.oldVariations?[0].type ??
                                            '';
                                  }
                                }
                                if (variationText
                                    .contains("Order Type (Take away)")) {
                                  takeAway = true;
                                }
                                variationText = variationText
                                    // .replaceAll("Choose ()", "")
                                    // .replaceAll("optiona (", "")
                                    //  .replaceAll(", ", "")
                                    .replaceAll("Order Type (Dine in)", "")
                                    .replaceAll("Order Type (Take away)", "")
                                    .replaceAll(",", "\n")
                                    .trimLeft();
                                // .replaceAll("Choose (", "\n")
                                // .replaceAll(")", "");
                                // orderController.
                                //orderDetails.pr
                                return Column(
                                  children: [
                                    Container(
                                      // color: takeAway
                                      //     ? const Color.fromARGB(255, 255, 209, 70)
                                      //     : null,
                                      child: Column(
                                        children: [
                                          takeAway
                                              ? Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "**Take away**",
                                                  style: robotoRegular.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ))
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
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 3,
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
                                                        details.productDetails
                                                                ?.name ??
                                                            '',
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
                                                        maxLines: 2,
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeExtraSmall),
                                                child: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  '${details.quantity}',
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
                                            ],
                                          ),
                                          if (variationText != '')
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  textAlign: TextAlign.left,
                                                  maxLines: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  variationText,
                                                  style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: Theme.of(context)
                                                        .hintColor,
                                                  )),
                                            ),
                                          if (ids.isNotEmpty)
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Add on :",
                                                      style: robotoRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .color!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ...addOnWidgetList
                                              ],
                                            ),
                                          if (orderController
                                                      .currentOrderDetails!
                                                      .details![index]
                                                      .note !=
                                                  null &&
                                              orderController
                                                      .currentOrderDetails!
                                                      .details![index]
                                                      .note !=
                                                  "null" &&
                                              orderController
                                                      .currentOrderDetails!
                                                      .details![index]
                                                      .note !=
                                                  "")
                                            Text(
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                                'Note: ${orderController.currentOrderDetails!.details![index].note}',
                                                style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.paddingSizeSmall,
                                    ),
                                    Builder(builder: (context) {
                                      bool render = false;
                                      if (orderController
                                              .currentOrderDetails?.details !=
                                          null) {
                                        render = orderController
                                                .currentOrderDetails!
                                                .details!
                                                .isNotEmpty &&
                                            orderController.currentOrderDetails!
                                                    .details!.length ==
                                                index + 1;
                                      }

                                      return render
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 50,
                                                ),
                                                Text.rich(
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  TextSpan(
                                                    children: orderController.currentOrderDetails?.order
                                                                    ?.orderNote !=
                                                                null ||
                                                            orderController
                                                                    .currentOrderDetails
                                                                    ?.order
                                                                    ?.orderNote ==
                                                                "null" ||
                                                            orderController
                                                                    .currentOrderDetails
                                                                    ?.order
                                                                    ?.orderNote ==
                                                                " "
                                                        ? [
                                                            TextSpan(
                                                              text: 'note'.tr,
                                                              style:
                                                                  robotoMedium
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
                                                            TextSpan(
                                                              text:
                                                                  ' ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
                                                              style: robotoRegular.copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .color,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          ]
                                                        : [],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                                CustomDivider(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                ),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        "Items Count",
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                        ),
                                                      ),
                                                      Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        '$itemCount',
                                                        style:
                                                            robotoBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                        ),
                                                      )
                                                    ]),
                                                // PriceWithType(
                                                //   type: 'items_price'.tr,
                                                //   amount: PriceConverter
                                                //       .convertPrice(itemsPrice),
                                                // ),
                                                // PriceWithType(
                                                //     type: 'discount'.tr,
                                                //     amount:
                                                //         '- ${PriceConverter.convertPrice(discount)}'),
                                                // PriceWithType(
                                                //     type: 'vat_tax'.tr,
                                                //     amount:
                                                //         '+ ${PriceConverter.convertPrice(tax)}'),
                                                // PriceWithType(
                                                //     type: 'addons'.tr,
                                                //     amount:
                                                //         '+ ${PriceConverter.convertPrice(addOnsPrice)}'),
                                                PriceWithType(
                                                    type: 'total'.tr,
                                                    amount: PriceConverter
                                                        .convertPrice(total),
                                                    isTotal: true),
                                                if (orderController
                                                        .currentOrderDetails
                                                        ?.order
                                                        ?.paymentMethod ==
                                                    "card")
                                                  PriceWithType(
                                                    type: '${'paid_amount'.tr}${orderController.currentOrderDetails?.order?.paymentMethod != null ?
                                                        //'(${orderController.currentOrderDetails?.order?.paymentMethod})' : ' (${'un_paid'.tr}) '}',
                                                        '(${orderController.currentOrderDetails?.order?.paymentMethod})' : ''}',
                                                    amount: PriceConverter
                                                        .convertPrice(orderController
                                                                    .currentOrderDetails
                                                                    ?.order
                                                                    ?.paymentStatus !=
                                                                'unpaid'
                                                            ? orderController
                                                                    .currentOrderDetails
                                                                    ?.order
                                                                    ?.orderAmount ??
                                                                0
                                                            : 0),
                                                  ),
                                                if (orderController
                                                        .currentOrderDetails
                                                        ?.order
                                                        ?.paymentMethod ==
                                                    "split")
                                                  PriceWithType(
                                                    type: 'Card',
                                                    amount: PriceConverter
                                                        .convertPrice(double.parse(
                                                                orderController
                                                                        .currentOrderDetails
                                                                        ?.order
                                                                        ?.card ??
                                                                    "0") ??
                                                            0),
                                                  ),
                                                if (orderController
                                                        .currentOrderDetails
                                                        ?.order
                                                        ?.paymentMethod ==
                                                    "cash")
                                                  PriceWithType(
                                                    type: 'Cash',
                                                    amount: PriceConverter
                                                        .convertPrice(double.parse(
                                                                orderController
                                                                        .currentOrderDetails
                                                                        ?.order
                                                                        ?.cash ??
                                                                    "0") ??
                                                            0),
                                                  ),
                                                if (orderController
                                                        .currentOrderDetails
                                                        ?.order
                                                        ?.paymentMethod ==
                                                    "split")
                                                  PriceWithType(
                                                    type: 'Cash',
                                                    amount: PriceConverter
                                                        .convertPrice(double.parse(
                                                                orderController
                                                                        .currentOrderDetails
                                                                        ?.order
                                                                        ?.cash ??
                                                                    "0") ??
                                                            0),
                                                  ),

                                                if (orderController
                                                        .currentOrderDetails
                                                        ?.order
                                                        ?.paymentMethod ==
                                                    "cash")
                                                  PriceWithType(
                                                    type: 'change'.tr,
                                                    amount: PriceConverter
                                                        .convertPrice((double.parse(
                                                                (orderController
                                                                        .currentOrderDetails
                                                                        ?.order
                                                                        ?.cash ??
                                                                    "0")) -
                                                            (total))),
                                                  ),
                                                if (orderController
                                                        .currentOrderDetails
                                                        ?.order
                                                        ?.paymentMethod ==
                                                    "split")
                                                  PriceWithType(
                                                    type: 'change'.tr,
                                                    amount: PriceConverter
                                                        .convertPrice((double.parse(
                                                                (orderController
                                                                        .currentOrderDetails
                                                                        ?.order
                                                                        ?.cash ??
                                                                    "0")) +
                                                            double.parse(
                                                                (orderController
                                                                        .currentOrderDetails
                                                                        ?.order
                                                                        ?.card ??
                                                                    "0")) -
                                                            (total))),
                                                  ),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault,
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                CustomDivider(
                                                    color: Theme.of(context)
                                                        .disabledColor),
                                                SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall,
                                                ),
                                              ],
                                            );
                                    }),
                                  ],
                                );
                              }),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Payment Status",
                                style: robotoRegular.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                              if (orderController.currentOrderDetails?.order
                                      ?.paymentStatus ==
                                  "paid")
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color.fromARGB(
                                          255, 24, 112, 27)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      orderController.currentOrderDetails?.order
                                              ?.paymentStatus ??
                                          "",
                                      style: robotoRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if (orderController.currentOrderDetails?.order
                                      ?.paymentStatus ==
                                  "unpaid")
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      orderController.currentOrderDetails?.order
                                              ?.paymentStatus ??
                                          "",
                                      style: robotoRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if (orderController.currentOrderDetails?.order
                                      ?.paymentStatus ==
                                  "refund")
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.indigo[900]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${orderController.currentOrderDetails?.order?.paymentStatus ?? ""}ed",
                                      style: robotoRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ]),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomButton(
                                height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                                transparent: true,
                                buttonText: 'Email Order',
                                onPressed: () {
                                  showAnimatedDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            overflow: TextOverflow.ellipsis,
                                            'Send Order Details',
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge),
                                          ),
                                          content: EmailDialog(),
                                          actionsPadding: EdgeInsets.zero,
                                          actions: const [],
                                        );
                                      });

                                  //cartController.clearCartData();
                                },
                              )),

                              if (orderController.currentOrderDetails?.order
                                          ?.paymentStatus ==
                                      "paid" ||
                                  orderController.currentOrderDetails?.order
                                          ?.paymentStatus ==
                                      "unpaid")
                                const SizedBox(width: 8),
                              Expanded(
                                child: GetBuilder<PrinterController>(
                                    builder: (printerController) {
                                  return CustomButton(
                                    height:
                                        ResponsiveHelper.isSmallTab() ? 40 : 50,
                                    buttonText: "Print Order",
                                    onPressed: () async {
                                      // Get.dialog(Dialog(
                                      //   shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(
                                      //           Dimensions.radiusSmall)),
                                      //   insetPadding: const EdgeInsets.all(20),
                                      //   child: const InvoicePrintScreen(),
                                      // ));

                                      if (printerController.connected) {
                                        printerController.printTest();
                                      } else {
                                        Get.dialog(Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall)),
                                          insetPadding:
                                              const EdgeInsets.all(20),
                                          child: InvoicePrintScreen(),
                                        ));
                                      }

                                      //Get.dialog(const InVoicePrintScreen());
                                    },
                                  );
                                }),
                              ),

                              // CustomRoundedButton(onTap: (){}, image: Images.edit_icon, widget: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                        // if (orderController
                        //         .currentOrderDetails?.order?.paymentStatus ==
                        //     "unpaid")
                        //   CustomButton(
                        //     height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                        //     transparent: true,
                        //     buttonText: 'Clear payment',
                        //     onPressed: () {
                        //       RouteHelper.openDialog(
                        //         context,
                        //         ConfirmationDialog(
                        //           title: 'Payment Recieved ?',
                        //           icon: Icons.money_rounded,
                        //           description: 'Paymemt received for this order',
                        //           onYesPressed: () {
                        //             orderController.updateOrderStatus(
                        //                 order_id: orderController
                        //                         .currentOrderDetails?.order?.id ??
                        //                     0,
                        //                 payment_status: "paid");
                        //             orderController.getCurrentOrder(orderController
                        //                     .currentOrderDetails?.order?.id
                        //                     .toString() ??
                        //                 '');
                        //             if (isSales) {
                        //               Get.find<SalesController>().getSales();
                        //             }
                        //             Get.back();
                        //           },
                        //           onNoPressed: () => Get.back(),
                        //         ),
                        //       );

                        //       //cartController.clearCartData();
                        //     },
                        //   ),

                        if (orderController
                                .currentOrderDetails?.order?.paymentStatus ==
                            "paid")
                          CustomButton(
                            height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                            transparent: true,
                            buttonText: 'Refund payment',
                            onPressed: () {
                              RouteHelper.openDialog(
                                context,
                                ConfirmationDialog(
                                  title: 'Refund Payment ?',
                                  icon: Icons.money_rounded,
                                  description:
                                      'Are you sure you want to refund the payment',
                                  onYesPressed: () {
                                    orderController.updateOrderStatus(
                                        order_id: orderController
                                                .currentOrderDetails
                                                ?.order
                                                ?.id ??
                                            0,
                                        payment_status: "refund");

                                    orderController.getCurrentOrder(
                                        orderController
                                                .currentOrderDetails?.order?.id
                                                .toString() ??
                                            '');
                                    if (isSales) {
                                      Get.find<SalesController>().getSales();
                                    }
                                    Get.back();
                                  },
                                  onNoPressed: () => Get.back(),
                                ),
                              );

                              //cartController.clearCartData();
                            },
                          ),
                        const SizedBox(height: 60) // Padding(
                        //   padding: const EdgeInsets.only(bottom: 60),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         flex: 1,
                        //         child: CustomButton(
                        //           height: 60,

                        //           // width: Dimensions.webMaxWidth - 50,
                        //           transparent: true,
                        //           onPressed: () async {
                        //             bool conexionStatus =
                        //                 await PrintBluetoothThermal
                        //                     .connectionStatus;
                        //             if (conexionStatus) {
                        //               printTest();
                        //             } else {
                        //               Get.dialog(Dialog(
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius: BorderRadius.circular(
                        //                         Dimensions.radiusSmall)),
                        //                 insetPadding: const EdgeInsets.all(20),
                        //                 child: const InvoicePrintScreen(),
                        //               ));
                        //             }

                        //             //Get.dialog(const InVoicePrintScreen());
                        //           },
                        //           buttonText: "Print Order",
                        //         ),
                        //       ),
                        //       Expanded(
                        //         flex: 1,
                        //         child: CustomButton(
                        //           height: 60,

                        //           // width: Dimensions.webMaxWidth - 50,
                        //           transparent: true,
                        //           onPressed: () async {
                        //             bool conexionStatus =
                        //                 await PrintBluetoothThermal
                        //                     .connectionStatus;
                        //             if (conexionStatus) {
                        //               printTest();
                        //             } else {
                        //               Get.dialog(Dialog(
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius: BorderRadius.circular(
                        //                         Dimensions.radiusSmall)),
                        //                 insetPadding: const EdgeInsets.all(20),
                        //                 child: const InvoicePrintScreen(),
                        //               ));
                        //             }

                        //             //Get.dialog(const InVoicePrintScreen());
                        //           },
                        //           buttonText: "Print Order",
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  );
                });
        }),
      ),
    );
  }
}
