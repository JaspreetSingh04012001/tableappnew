import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/sales_controller.dart';
import 'package:efood_table_booking/data/model/response/order_details_model.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_divider.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/base/product_type_view.dart';
import 'package:efood_table_booking/view/screens/cart/widget/cart_detais.dart';
import 'package:efood_table_booking/view/screens/order/widget/emailDialog.dart';
import 'package:efood_table_booking/view/screens/order/widget/invoice_print_screen.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/config_model.dart';
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
  String removeEmptyLines(String input) {
    return input
        .replaceAll(RegExp(r'^\s*$\n', multiLine: true), '')
        .split('\n')
        .map((line) => line.trimLeft())
        .join('\n');
  }

  Future<List<int>> testTicket() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.drawer(pin: PosDrawer.pin2);
    bytes += generator.drawer();

    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    OrderController orderController = Get.find<OrderController>();
    SplashController splashController = Get.find<SplashController>();

//orderController.currentOrderDetails.details;
    double itemsPrice = 0;
    double discount = 0;
    double tax = 0;
    double addOnsPrice = 0;
    late String date;
    String? name;
    //SharedPreferences sharedPref//erences = await SharedPreferences.getInstance();
    // sharedPreferences.setString("branchName", value.name.toString());
    name = sharedPreferences.getString("branchName");

    splashController.configModel?.branch?.forEach((Branch value) async {
      if (splashController.selectedBranchId == value.id) {
        name = value.name;
        //splashController.updateBranchId(value.id);
      }
    });
    List<Details> orderDetails =
        orderController.currentOrderDetails?.details ?? [];
    if (orderController.currentOrderDetails?.details != null) {
      for (Details orderDetails in orderDetails) {
        itemCount += orderDetails.quantity!.toInt();
        itemsPrice =
            itemsPrice + (orderDetails.price! * orderDetails.quantity!.toInt());
        discount = discount +
            (orderDetails.discountOnProduct! * orderDetails.quantity!.toInt());
        tax = (tax +
            (orderDetails.taxAmount! * orderDetails.quantity!.toInt()) +
            orderDetails.addonTaxAmount!);
        date = orderDetails.createdAt!.replaceAll("T", " ");
      }
    }

    double total = itemsPrice - discount + tax;

    // widget.order;
    // widget.orderDetails;
    // var date =
    //     DateConverter.dateTimeStringToMonthAndTime(widget.order!.createdAt!);

    // bytes += generator.text("EFood",
    //     styles: const PosStyles(
    //         bold: true,
    //         align: PosAlign.center,
    //         height: PosTextSize.size3,
    //         width: PosTextSize.size3));

    bytes += generator.text(name ?? " ",
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.text('order_summary'.tr,
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.text(
        '${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text(date,
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    // bytes += generator.text(
    //     '${'table'.tr} ${Get.find<SplashController>().getTable(
    //           orderController.currentOrderDetails?.order?.tableId,
    //           branchId: orderController.currentOrderDetails?.order?.branchId,
    //         )?.number} |',
    //     styles: const PosStyles(
    //         bold: true, align: PosAlign.center, height: PosTextSize.size1));
    // bytes += generator.text(
    //     '${orderController.currentOrderDetails?.order?.numberOfPeople ?? 'add'.tr} ${'people'.tr}',
    //     styles: const PosStyles(
    //         bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text(
        orderController.currentOrderDetails?.order?.customer_name ?? '',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text("Qty x Item info = Price");
    bytes += generator.hr(ch: "-");

    orderController.currentOrderDetails?.details?.forEach((details) {
      String variationText = '';
      int a = 0;
      String addonsName = '';
      bool takeAway = false;

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
          addOnsPrice =
              addOnsPrice + (details.addOnPrices![i] * details.addOnQtys![i]);
        }
      }
      try {
        for (AddOns addOn in addons) {
          if (ids.contains(addOn.id)) {
            addonsName = addonsName + ('${addOn.name} (${(addQty[a])}), ');
            a++;
          }
        }
      } catch (e) {
        debugPrint('order details view -$e');
      }
      if (details.variations != null && details.variations!.isNotEmpty) {
        for (Variation variation in details.variations!) {
          variationText +=
              '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
          for (VariationValue value in variation.variationValues!) {
            variationText +=
                '${variationText.endsWith('(') ? '' : ', '}${value.level}';
          }
          variationText += ')';
        }
      } else if (details.oldVariations != null &&
          details.oldVariations!.isNotEmpty) {
        List<String> variationTypes = details.oldVariations![0].type != null
            ? details.oldVariations![0].type!.split('-')
            : [];

        if (variationTypes.length ==
            details.productDetails?.choiceOptions?.length) {
          int index = 0;
          details.productDetails?.choiceOptions?.forEach((choice) {
            // choice.
            variationText =
                '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
            index = index + 1;
          });
        } else {
          variationText = details.oldVariations?[0].type ?? '';
        }
      }
      if (variationText.contains("Order Type (Take Away)")) {
        takeAway = true;
      }
      print("Jass $variationText");
      variationText = variationText
          .replaceAll("Choose ()", "")
          .replaceAll("optiona (", "")
          .replaceAll("Order Type (Dining)", "")
          .replaceAll("Order Type (Take Away)", "")
          .replaceAll("Choose (", "\n")
          .replaceAll("Choose One (", "\n")
          .replaceAll(")", "")
          .replaceAll(",", "\n");
      variationText = removeEmptyLines(variationText);
      // variationText.

      bytes += generator.text(takeAway ? "** Take Away **" : "* Eat In *",
          styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size2,
              align: PosAlign.center));

      bytes += generator.text(
          "${details.quantity} x ${details.productDetails?.name ?? ''} : ${PriceConverter.convertPrice(details.price! * details.quantity!)}",
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size2,
          ));

      if (addonsName.isNotEmpty) {
        bytes += generator.text('${'addons'.tr}: $addonsName',
            styles: const PosStyles(bold: true, height: PosTextSize.size1));
      }
      if (variationText != '') {
        bytes += generator.text(variationText,
            styles: const PosStyles(bold: true, height: PosTextSize.size1));
      }
      bytes += generator.hr(ch: "-");
    });

    orderController.currentOrderDetails?.order?.orderNote != null
        ? bytes += generator.text(
            'Note : ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size2,
                bold: true))
        : null;
    bytes += generator.text("${'Item Count'} : $itemCount",
        styles: const PosStyles(
            height: PosTextSize.size1, width: PosTextSize.size2));
    bytes += generator.text(
        "${'item_price'.tr} : ${PriceConverter.convertPrice(itemsPrice)}");
    // bytes += generator
    //     .text("${'discount'.tr} : -${PriceConverter.convertPrice(discount)}");

    // bytes += generator
    //     .text("${'vat_tax'.tr} : +${PriceConverter.convertPrice(tax)}");
    bytes += generator
        .text("${'add_ons'.tr} : +${PriceConverter.convertPrice(addOnsPrice)}");
    bytes += generator.text(
        "${'total'.tr} : ${PriceConverter.convertPrice(total + addOnsPrice)}",
        styles: const PosStyles(
            height: PosTextSize.size2, width: PosTextSize.size2));

    bytes += generator.text(
        styles: const PosStyles(
            height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
        "${'${'paid_amount'.tr}${orderController.currentOrderDetails?.order?.paymentMethod != null ?
            //'(${orderController.currentOrderDetails?.order?.paymentMethod})' : ' (${'un_paid'.tr}) '}',
            '(${orderController.currentOrderDetails?.order?.paymentMethod})' : ''}'} : ${PriceConverter.convertPrice(orderController.currentOrderDetails?.order?.paymentStatus != 'unpaid' ? orderController.currentOrderDetails?.order?.orderAmount ?? 0 : 0)}");
    // bytes +=
    //     generator.text("${'vat_tax'.tr} : \$${widget.order!.totalTaxAmount!}");
    bytes += generator.text(
        styles: const PosStyles(
            height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
        "${'change'.tr} : ${PriceConverter.convertPrice(orderController.getOrderSuccessModel()?.firstWhere((order) => order.orderId == orderController.currentOrderDetails?.order?.id.toString()).changeAmount ?? 0)}");
    bytes += generator.drawer();
    bytes += generator.drawer(pin: PosDrawer.pin5);
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  Future<void> printTest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int printCount = 1;
    // if(pref.getInt("printCount") == null){
    printCount = pref.getInt("printCount") ?? 1;
    // }
    //pref.getInt("printCount");
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      for (int i = 0; i < printCount; i++) {
        PrintBluetoothThermal.writeBytes(ticket);
      }
    } else {
      //no conectado, reconecte
    }
  }

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
                    Text(
                      overflow: TextOverflow.ellipsis,
                      orderController
                              .currentOrderDetails?.order?.customer_name ??
                          '',
                      style: robotoRegular.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      orderController
                              .currentOrderDetails?.order?.customer_email ??
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
                                          ? Text(
                                              overflow: TextOverflow.ellipsis,
                                              "**Take Away**",
                                              style: robotoRegular.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ))
                                          : Text(
                                              overflow: TextOverflow.ellipsis,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall,
                                                  ),
                                                  Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                    Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        variationText,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        )),
                                                  if (orderController
                                                          .currentOrderDetails!
                                                          .details![index]
                                                          .note !=
                                                      null)
                                                    Text(
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        'Note: ${orderController.currentOrderDetails!.details![index].note}',
                                                        style: robotoRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ))
                                                ],
                                              )),
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall),
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    "Items Count",
                                                    style: robotoBold.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeLarge,
                                                    ),
                                                  ),
                                                  Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Status",
                            style: robotoRegular.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          if (orderController
                                  .currentOrderDetails?.order?.paymentStatus ==
                              "paid")
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      const Color.fromARGB(255, 24, 112, 27)),
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
                          if (orderController
                                  .currentOrderDetails?.order?.paymentStatus ==
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
                          if (orderController
                                  .currentOrderDetails?.order?.paymentStatus ==
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
                                            fontSize: Dimensions.fontSizeLarge),
                                      ),
                                      content: const EmailDialog(),
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
                            child: CustomButton(
                              height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                              buttonText: "Print Order",
                              onPressed: () async {
                                bool conexionStatus =
                                    await PrintBluetoothThermal
                                        .connectionStatus;
                                if (conexionStatus) {
                                  printTest();
                                } else {
                                  Get.dialog(Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall)),
                                    insetPadding: const EdgeInsets.all(20),
                                    child: const InvoicePrintScreen(),
                                  ));
                                }

                                //Get.dialog(const InVoicePrintScreen());
                              },
                            ),
                          ),

                          // CustomRoundedButton(onTap: (){}, image: Images.edit_icon, widget: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                    if (orderController
                            .currentOrderDetails?.order?.paymentStatus ==
                        "unpaid")
                      CustomButton(
                        height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                        transparent: true,
                        buttonText: 'Clear payment',
                        onPressed: () {
                          RouteHelper.openDialog(
                            context,
                            ConfirmationDialog(
                              title: 'Payment Recieved ?',
                              icon: Icons.money_rounded,
                              description: 'Paymemt received for this order',
                              onYesPressed: () {
                                orderController.updateOrderStatus(
                                    order_id: orderController
                                            .currentOrderDetails?.order?.id ??
                                        0,
                                    payment_status: "paid");
                                orderController.getCurrentOrder(orderController
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
                                            .currentOrderDetails?.order?.id ??
                                        0,
                                    payment_status: "refund");

                                orderController.getCurrentOrder(orderController
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
    });
  }
}
