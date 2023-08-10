import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/data/model/response/order_details_model.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_divider.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/base/product_type_view.dart';
import 'package:efood_table_booking/view/screens/cart/widget/cart_detais.dart';
import 'package:efood_table_booking/view/screens/order/widget/invoice_print_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/custom_button.dart';

class OrderDetailsView extends StatelessWidget {
  int itemCount;
  OrderDetailsView({Key? key, this.itemCount = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return orderController.currentOrderDetails == null
          ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
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
                      (orderDetails.price! * orderDetails.quantity!.toInt());
                  discount = discount +
                      (orderDetails.discountOnProduct! *
                          orderDetails.quantity!.toInt());
                  tax = (tax +
                      (orderDetails.taxAmount! *
                          orderDetails.quantity!.toInt()) +
                      orderDetails.addonTaxAmount!);
                }
              }

              double total = itemsPrice - discount + tax;
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
                    Text(
                      orderController
                              .currentOrderDetails?.order?.customer_name ??
                          '',
                      style: robotoRegular.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                          itemCount: orderController
                              .currentOrderDetails?.details?.length,
                          itemBuilder: (context, index) {
                            itemCount = orderController
                                    .currentOrderDetails?.details?.length ??
                                0;
                            // orderController
                            //     .currentOrderDetails?.details[0].variations;
                            late Details details;
                            String variationText = '';
                            int a = 0;
                            if (orderController.currentOrderDetails?.details !=
                                null) {
                              details = orderController
                                  .currentOrderDetails!.details![index];
                            }

                            String addonsName = '';
                            bool takeAway = false;
                            //orderController.currentOrderDetails.details.
                            Details? orderDetails = orderController
                                .currentOrderDetails?.details?[index];

                            List<AddOns> addons = details.productDetails == null
                                ? []
                                : details.productDetails!.addOns == null
                                    ? []
                                    : details.productDetails!.addOns!;
                            List<int> addQty = details.addOnQtys ?? [];
                            List<int> ids = details.addOnIds ?? [];

                            if (ids.length == details.addOnPrices?.length &&
                                ids.length == details.addOnQtys?.length) {
                              for (int i = 0; i < ids.length; i++) {
                                addOnsPrice = addOnsPrice +
                                    (details.addOnPrices![i] *
                                        details.addOnQtys![i]);
                              }
                            }

                            try {
                              for (AddOns addOn in addons) {
                                if (ids.contains(addOn.id)) {
                                  addonsName = addonsName +
                                      ('${addOn.name} (${(addQty[a])}), ');
                                  a++;
                                }
                              }
                            } catch (e) {
                              debugPrint('order details view -$e');
                            }

                            if (addonsName.isNotEmpty) {
                              addonsName = addonsName.substring(
                                  0, addonsName.length - 2);
                            }
                            // orderDetails!.productDetails.;
                            if (orderDetails != null &&
                                orderDetails.variations != null &&
                                orderDetails.variations!.isNotEmpty) {
                              for (Variation variation
                                  in orderDetails.variations!) {
                                variationText +=
                                    '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
                                for (VariationValue value
                                    in variation.variationValues!) {
                                  variationText +=
                                      '${variationText.endsWith('(') ? '' : ', '}${value.level}';
                                }
                                variationText += ')';
                              }
                            } else if (orderDetails != null &&
                                orderDetails.oldVariations != null &&
                                orderDetails.oldVariations!.isNotEmpty) {
                              List<String> variationTypes =
                                  orderDetails.oldVariations![0].type != null
                                      ? orderDetails.oldVariations![0].type!
                                          .split('-')
                                      : [];

                              if (variationTypes.length ==
                                  orderDetails
                                      .productDetails?.choiceOptions?.length) {
                                int index = 0;
                                orderDetails.productDetails?.choiceOptions
                                    ?.forEach((choice) {
                                  variationText =
                                      '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
                                  index = index + 1;
                                });
                              } else {
                                variationText =
                                    orderDetails.oldVariations?[0].type ?? '';
                              }
                            }
                            if (variationText
                                .contains("Order Type (Take Away)")) {
                              takeAway = true;
                            }
                            variationText = variationText
                                .replaceAll("Choose ()", "")
                                .replaceAll("optiona (", "")
                                .replaceAll("Optiona (", "")
                                .replaceAll("Order Type (Dining)", "")
                                .replaceAll("Order Type (Take Away)", "")
                                .replaceAll("Choose (", "\n")
                                .replaceAll(")", "");
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
                                          ? Text("**Take Away**",
                                              style: robotoRegular.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ))
                                          : Text(
                                              "Eat In",
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
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
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    details.productDetails
                                                            ?.name ??
                                                        '',
                                                    style:
                                                        robotoRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .color!,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                        details.productDetails!
                                                            .price!),
                                                    style:
                                                        robotoRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                    ),
                                                  ),
                                                  if (addonsName.isNotEmpty)
                                                    SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeExtraSmall,
                                                    ),
                                                  if (addonsName.isNotEmpty)
                                                    Text(
                                                        '${'addons'.tr}: $addonsName',
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        )),
                                                  // SizedBox(
                                                  //   height: Dimensions
                                                  //       .paddingSizeExtraSmall,
                                                  // ),
                                                  if (variationText != '')
                                                    Text(variationText,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        )),
                                                ],
                                              )),
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Text(
                                              '${details.quantity}',
                                              textAlign: TextAlign.center,
                                              style: robotoRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .color!),
                                            ),
                                          )),
                                          Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .paddingSizeExtraSmall),
                                                    child: Text(
                                                      PriceConverter
                                                          .convertPrice(
                                                        details.price! *
                                                            details.quantity!,
                                                      ),
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
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  ProductTypeView(
                                                      productType: details
                                                          .productDetails
                                                          ?.productType),
                                                ],
                                              )),
                                        ],
                                      ),
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
                                                children: orderController
                                                            .currentOrderDetails
                                                            ?.order
                                                            ?.orderNote !=
                                                        null
                                                    ? [
                                                        TextSpan(
                                                          text: 'note'.tr,
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
                                                        TextSpan(
                                                          text:
                                                              ' ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
                                                          style: robotoRegular.copyWith(
                                                              fontSize: Dimensions
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
                                              height:
                                                  Dimensions.paddingSizeDefault,
                                            ),
                                            CustomDivider(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.paddingSizeDefault,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Items Count",
                                                    style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$itemCount',
                                                    style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                    ),
                                                  )
                                                ]),
                                            PriceWithType(
                                              type: 'items_price'.tr,
                                              amount:
                                                  PriceConverter.convertPrice(
                                                      itemsPrice),
                                            ),
                                            PriceWithType(
                                                type: 'discount'.tr,
                                                amount:
                                                    '- ${PriceConverter.convertPrice(discount)}'),
                                            PriceWithType(
                                                type: 'vat_tax'.tr,
                                                amount:
                                                    '+ ${PriceConverter.convertPrice(tax)}'),
                                            PriceWithType(
                                                type: 'addons'.tr,
                                                amount:
                                                    '+ ${PriceConverter.convertPrice(addOnsPrice)}'),
                                            PriceWithType(
                                                type: 'total'.tr,
                                                amount:
                                                    PriceConverter.convertPrice(
                                                        total + addOnsPrice),
                                                isTotal: true),
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
                                            PriceWithType(
                                              type: 'change'.tr,
                                              amount: PriceConverter
                                                  .convertPrice(orderController
                                                          .getOrderSuccessModel()
                                                          ?.firstWhere((order) =>
                                                              order.orderId ==
                                                              orderController
                                                                  .currentOrderDetails
                                                                  ?.order
                                                                  ?.id
                                                                  .toString())
                                                          .changeAmount ??
                                                      0),
                                            ),
                                            SizedBox(
                                              height:
                                                  Dimensions.paddingSizeDefault,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            CustomDivider(
                                                color: Theme.of(context)
                                                    .disabledColor),
                                            SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                          ],
                                        );
                                }),
                              ],
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: CustomButton(
                        height: 60,
                        // width: Dimensions.webMaxWidth - 50,
                        transparent: true,
                        onPressed: () {
                          Get.dialog(Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall)),
                            insetPadding: const EdgeInsets.all(20),
                            child: const InVoicePrintScreen(),
                          ));

                          //Get.dialog(const InVoicePrintScreen());
                        },
                        buttonText: "Print Order",
                      ),
                    ),
                  ],
                ),
              );
            });
    });
  }
}
