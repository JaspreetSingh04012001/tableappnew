import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/data/model/response/order_details_model.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/body_template.dart';
import 'package:efood_table_booking/view/base/custom_app_bar.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/screens/order/widget/order_screen.dart';
import 'package:efood_table_booking/view/screens/root/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../controller/printer_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../base/custom_text_field.dart';
import '../../home/widget/filter_button_widget.dart';

class OrderSuccessScreen extends StatefulWidget {
  final bool fromPlaceOrder;

  const OrderSuccessScreen({
    Key? key,
    this.fromPlaceOrder = false,
  }) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  int currentMinute = 0;
  int selectedindex = 0;
  bool focusshow = false;
  final double _changeAmount = 0;
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _splitCardamountTextController =
      TextEditingController();
  @override
  void initState() {
    // print('order success call');
    // Get.find<OrderController>().getOrderSuccessModel();
    Get.find<OrderController>().setCurrentOrderId = null;

    Get.find<OrderController>().getOrderList().then((List<Order>? list) {
      if (list != null && list.isNotEmpty) {
        Get.find<OrderController>().getCurrentOrder('${list.first.id}').then(
              (value) => Get.find<OrderController>().countDownTimer(),
            );
      } else {
        Get.find<OrderController>().getCurrentOrder(null);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    Get.find<OrderController>().cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: !widget.fromPlaceOrder ? orderBody() : Container(),
      appBar: ResponsiveHelper.isTab(context)
          ? null
          : const CustomAppBar(
              isBackButtonExist: false,
              onBackPressed: null,
              showCart: true,
            ),
      body: !ResponsiveHelper.isTab(context)
          ? _body(context)
          : BodyTemplate(
              body: Flexible(child: _body(context)),
              isOrderDetails: true,
            ),
    );
  }

  GetBuilder<OrderController> orderBody() {
    return GetBuilder<OrderController>(builder: (orderController) {
      List<String> orderIdList = [];
      orderController.orderList
          ?.map((order) => orderIdList.add('${'order'.tr}# ${order.id}'))
          .toList();

      return orderController.isLoading || orderController.orderList == null
          ? Container()
          : orderController.orderList!.isNotEmpty && !focusshow
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilterButtonWidget(
                      isPayment: true,
                      type: orderController.currentOrderId == null
                          ? orderIdList.first
                          : orderController.currentOrderId!,
                      onSelected: (id) {
                        orderController.setCurrentOrderId = id;
                        orderController
                            .getCurrentOrder(
                          id.replaceAll('${'order'.tr}# ', ''),
                        )
                            .then((value) {
                          Get.find<OrderController>().cancelTimer();
                          Get.find<OrderController>().countDownTimer();
                        });
                      },
                      items: orderIdList,
                      isBorder: true,
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                )
              : Container();
    });
  }

  Center _body(BuildContext context) {
    return Center(
      child: GetBuilder<OrderController>(builder: (orderController) {
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
                (orderDetails.taxAmount! * orderDetails.quantity!.toInt()) +
                orderDetails.addonTaxAmount!);
          }
        }

        double total = itemsPrice - discount + tax;
        final TextEditingController nameController = TextEditingController();
        int days = 0, hours = 0, minutes = 0;
        days = orderController.duration.inDays;
        hours = orderController.duration.inHours - days * 24;
        minutes = orderController.duration.inMinutes -
            (24 * days * 60) -
            (hours * 60);

        return orderController.isLoading
            ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
            : orderController.currentOrderDetails == null &&
                    !orderController.isLoading
                ? NoDataScreen(text: 'you_hove_no_order'.tr)
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top + 55,
                        ),
                        Column(
                          children: [
                            orderController.currentOrderDetails != null
                                ? Text(
                                    overflow: TextOverflow.ellipsis,
                                    // minutes < 5
                                    // ?
                                    'be_prepared_your_food'.tr,
                                    // : 'your_food_delivery'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).hintColor),
                                    maxLines: 1,
                                    //  overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    overflow: TextOverflow.ellipsis,
                                    'your_order_has_been_received'.tr,
                                    style: robotoRegular.copyWith(
                                        fontSize:
                                            Dimensions.fontSizeExtraLarge),
                                  ),
                            if (widget.fromPlaceOrder == true)
                              Lottie.asset(
                                width: 100,
                                fit: BoxFit.fitWidth,
                                Images.successAnimation,
                              ),
                            if (widget.fromPlaceOrder == false &&
                                orderController.currentOrderDetails!.order!
                                        .paymentStatus !=
                                    "unpaid")
                              Text(
                                overflow: TextOverflow.ellipsis,
                                'estimated_serving_time'.tr,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .color,
                                ),
                              ),
                            if (widget.fromPlaceOrder == false &&
                                orderController.currentOrderDetails!.order!
                                        .paymentStatus !=
                                    "unpaid")
                              SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                            if (widget.fromPlaceOrder == false &&
                                orderController.currentOrderDetails!.order!
                                        .paymentStatus !=
                                    "unpaid")
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    '${minutes < 5 ? 0 : minutes - 5} - ${minutes < 5 ? 5 : minutes}',
                                    style: robotoBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 35,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.paddingSizeSmall,
                                  ),
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    'min_s'.tr,
                                    style: robotoBold.copyWith(
                                      fontSize: 35,
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            if (widget.fromPlaceOrder == false &&
                                orderController.currentOrderDetails!.order!
                                        .paymentStatus ==
                                    "unpaid")
                              Column(
                                children: [
                                  if (orderController.selectedMethod ==
                                          'cash' ||
                                      orderController.selectedMethod == 'split')
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Wrap(
                                          children: List.generate(
                                              20,
                                              (index) => InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        // if (selectedindex != null) {
                                                        // selectedindex = null;
                                                        //  _amountTextController.
                                                        // _amountTextController
                                                        //     .text = (double.parse(
                                                        //             _amountTextController
                                                        //                 .text) +
                                                        //         double.parse(
                                                        //             "${(index + 1) * 10}"))
                                                        //     .toString();
                                                        // if (double.parse(
                                                        //         _amountTextController.text) >
                                                        //     Get.find<CartController>()
                                                        //         .totalAmount) {
                                                        //   _changeAmount = (Get.find<
                                                        //                   CartController>()
                                                        //               .totalAmount -
                                                        //           double.parse(
                                                        //               _amountTextController
                                                        //                   .text)) *
                                                        //       -1.0;
                                                        // } else {
                                                        //   _changeAmount = 0;
                                                        // }
                                                        // orderController.update();
                                                        //   } else {
                                                        selectedindex = index;
                                                        _amountTextController
                                                                .text =
                                                            "${(index + 1) * 5}";
                                                        // if (double.parse(
                                                        //         _amountTextController
                                                        //             .text) >
                                                        //     Get.find<CartController>()
                                                        //         .totalAmount) {
                                                        //   _changeAmount = (Get.find<
                                                        //                   CartController>()
                                                        //               .totalAmount -
                                                        //           double.parse(
                                                        //               _amountTextController
                                                        //                   .text)) *
                                                        -1.0;
                                                        // } else {
                                                        // //  _changeAmount = 0;
                                                        // }
                                                        orderController
                                                            .update();
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 7,
                                                          horizontal: 7),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1.5,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: (index ==
                                                                      selectedindex)
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : null),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              "\$${(index + 1) * 5}",
                                                              style: robotoRegular
                                                                  .copyWith(
                                                                      color: (index ==
                                                                              selectedindex)
                                                                          ? Colors
                                                                              .white
                                                                          : null,
                                                                      //  color: Colors.white,
                                                                      fontSize:
                                                                          Dimensions.fontSizeExtraLarge +
                                                                              2),
                                                            ),
                                                          )),
                                                    ),
                                                  ))),
                                    ),
                                  FilterButtonWidget(
                                      isSmall: Get.width < 390,
                                      items: orderController.paymentMethodList,
                                      type: orderController.selectedMethod,
                                      isBorder: true,
                                      onSelected: (method) {
                                        if (method == 'card') {
                                          // _amountTextController.text =
                                          //     PriceConverter.convertPrice(
                                          //         orderController.placeOrderBody!.orderAmount!);
                                        } else {
                                          // _splitCardamountTextController.clear();
                                          // _amountTextController.clear();
                                          // _changeAmount = 0;
                                        }
                                        orderController
                                            .setSelectedMethod(method);
                                      }),
                                  Padding(
                                    padding: ResponsiveHelper.isTab(context)
                                        ? EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.04)
                                        : EdgeInsets.all(
                                            Dimensions.paddingSizeDefault),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.paddingSizeDefault,
                                          horizontal:
                                              Dimensions.paddingSizeDefault),
                                      margin: EdgeInsets.only(
                                          bottom:
                                              Dimensions.paddingSizeExtraLarge),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                                .withOpacity(0.05),
                                            offset: const Offset(0, 2.75),
                                            blurRadius: 6.86,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          // if (ResponsiveHelper.isTab(context))
                                          // SizedBox(
                                          //   height: Dimensions.paddingSizeExtraLarge,
                                          // ),
                                          if (orderController.selectedMethod ==
                                                  'cash' ||
                                              orderController.selectedMethod ==
                                                  'split')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeLarge,
                                                  vertical: 10),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          'cash'.tr)),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeLarge),
                                                  Expanded(
                                                    child: Focus(
                                                      onFocusChange: (focus) {
                                                        setState(() {
                                                          focusshow = true;
                                                        });
                                                        print("focus: $focus");
                                                      },
                                                      child: CustomTextField(
                                                        borderColor: Theme.of(
                                                                context)
                                                            .primaryColor
                                                            .withOpacity(0.4),
                                                        hintText:
                                                            'enter_amount'.tr,
                                                        controller:
                                                            _amountTextController,
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  "[0-9]")),
                                                          LengthLimitingTextInputFormatter(
                                                              10),
                                                        ],
                                                        hintStyle: robotoRegular
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                        onChanged: (value) {},
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          if (orderController.selectedMethod ==
                                              'split')
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .paddingSizeLarge),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          "Card")),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .paddingSizeLarge),
                                                  Expanded(
                                                    child: Focus(
                                                      onFocusChange: (focus) {
                                                        setState(() {
                                                          focusshow = true;
                                                        });
                                                        print("focus: $focus");
                                                      },
                                                      child: CustomTextField(
                                                        borderColor: Theme.of(
                                                                context)
                                                            .primaryColor
                                                            .withOpacity(0.4),
                                                        hintText:
                                                            'enter_amount'.tr,
                                                        controller:
                                                            _splitCardamountTextController,
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  "[0-9]")),
                                                          LengthLimitingTextInputFormatter(
                                                              10),
                                                        ],
                                                        hintStyle: robotoRegular
                                                            .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall),
                                                        onChanged: (value) {
                                                          print(
                                                              total.toString());
                                                          // if ((double.parse(value) +
                                                          //         double.parse(
                                                          //             _amountTextController
                                                          //                 .text)) >
                                                          //     Get.find<CartController>()
                                                          //         .totalAmount) {
                                                          //   _changeAmount = (Get.find<
                                                          //                   CartController>()
                                                          //               .totalAmount -
                                                          //           (double.parse(value) +
                                                          //               double.parse(
                                                          //                   _amountTextController
                                                          //                       .text))) *
                                                          //       -1.0;
                                                          // } else {
                                                          //   _changeAmount = 0;
                                                          // }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          !ResponsiveHelper.isTab(context)
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeLarge),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                          child: SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  'current_amount'
                                                                      .tr))),
                                                      SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraLarge),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //       overflow: TextOverflow.ellipsis,
                                                      //       PriceConverter.convertPrice(
                                                      //           _currentAmount)),
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),

                                          !ResponsiveHelper.isTab(context)
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                          child: SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  'payable_amount'
                                                                      .tr))),
                                                      SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraLarge),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //       overflow: TextOverflow.ellipsis,
                                                      //       PriceConverter.convertPrice(
                                                      //           _payableAmount)),
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),

                                          //  const SizedBox(),
                                          SizedBox(
                                            height: Dimensions
                                                .paddingSizeExtraLarge,
                                          ),
                                          orderController.isLoading
                                              ? Center(
                                                  child: CustomLoader(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                )
                                              : Row(
                                                  children: [
                                                    GetBuilder<
                                                            PrinterController>(
                                                        builder:
                                                            (printerController) {
                                                      return printerController
                                                              .connected
                                                          ? IconButton(
                                                              onPressed:
                                                                  printerController
                                                                      .openDrawerOnClick,
                                                              icon: Icon(
                                                                Icons
                                                                    .electric_bolt_rounded,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ))
                                                          : Container();
                                                    }),
                                                    Expanded(
                                                      child: CustomButton(
                                                        height: ResponsiveHelper
                                                                .isSmallTab()
                                                            ? 40
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 50
                                                                : 40,
                                                        buttonText:
                                                            'confirm_payment'
                                                                .tr,
                                                        fontSize:
                                                            Get.width < 390
                                                                ? 12
                                                                : null,
                                                        onPressed: () {
                                                          if ((orderController
                                                                          .selectedMethod ==
                                                                      'cash' ||
                                                                  orderController
                                                                          .selectedMethod ==
                                                                      'split') &&
                                                              _amountTextController
                                                                  .text.isEmpty) {
                                                            // showCustomSnackBar(
                                                            //     'please_enter_your_amount'
                                                            //         .tr);
                                                          } else if (orderController
                                                                      .selectedMethod ==
                                                                  'cash' &&
                                                              total >
                                                                  int.parse(
                                                                      _amountTextController
                                                                          .text)) {
                                                            // showCustomSnackBar(
                                                            //     'you_need_pay_more_amount'
                                                            //         .tr);
                                                          } else if (orderController
                                                                      .selectedMethod ==
                                                                  'split' &&
                                                              _amountTextController
                                                                  .text
                                                                  .isEmpty &&
                                                              _splitCardamountTextController
                                                                  .text
                                                                  .isEmpty) {
                                                          } else if (orderController
                                                                      .selectedMethod ==
                                                                  'split' &&
                                                              total >
                                                                  (double.parse(
                                                                          _amountTextController.text ??
                                                                              "0") +
                                                                      double.parse(
                                                                          _splitCardamountTextController.text ??
                                                                              "0"))) {
                                                          } else {
                                                            setState(() {
                                                              focusshow = false;
                                                            });
                                                            orderController
                                                                .updateOrderStatus(
                                                                    order_id: orderController
                                                                            .currentOrderDetails
                                                                            ?.order
                                                                            ?.id ??
                                                                        0,
                                                                    payment_status:
                                                                        "paid",
                                                                    yo: [
                                                                      orderController
                                                                          .selectedMethod,
                                                                      _splitCardamountTextController
                                                                              .text
                                                                              .isEmpty
                                                                          ? null
                                                                          : int.parse(
                                                                              _splitCardamountTextController.text),
                                                                      _amountTextController
                                                                              .text
                                                                              .isEmpty
                                                                          ? null
                                                                          : int.parse(
                                                                              _amountTextController.text)
                                                                    ])
                                                                .whenComplete(
                                                                    () => null)
                                                                .then((value) {
                                                                  if (value
                                                                          .statusCode ==
                                                                      200) {
                                                                    orderController
                                                                        .getCurrentOrder(value
                                                                            .body["order"][
                                                                                "id"]
                                                                            .toString())
                                                                        .then(
                                                                            (value) {
                                                                      Get.find<
                                                                              PrinterController>()
                                                                          .printTest();
                                                                    });
                                                                    orderController
                                                                        .getOrderList();
                                                                    Get.off(() =>
                                                                        const OrderSuccessScreen(
                                                                            fromPlaceOrder:
                                                                                true));
                                                                  }
                                                                });
                                                            // orderController
                                                            //     .getCurrentOrder(
                                                            //         orderController
                                                            //             .currentOrderId);

                                                            // orderController.placeOrder(
                                                            //   orderController.placeOrderBody!
                                                            //       .copyWith(
                                                            //     paymentStatus: 'paid',
                                                            //     paymentMethod: orderController
                                                            //         .selectedMethod,
                                                            //     card:
                                                            //         _splitCardamountTextController
                                                            //             .text,
                                                            //     cash: _amountTextController.text,
                                                            //     previousDue: orderController
                                                            //         .previousDueAmount(),
                                                            //   ),
                                                            //   callback,
                                                            //   _amountTextController.text,
                                                            //   _changeAmount,
                                                            // );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          if (ResponsiveHelper.isTab(context))
                                            SizedBox(
                                              height: Dimensions
                                                  .paddingSizeExtraLarge,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                ],
                              ),
                            CustomButton(
                              height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                              width: 300,
                              transparent: true,
                              buttonText: 'back_to_home'.tr,
                              fontSize: Dimensions.fontSizeDefault,
                              onPressed: () => Get.offAllNamed(
                                RouteHelper.home,
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.paddingSizeDefault,
                            ),
                            if (!ResponsiveHelper.isTab(context))
                              CustomButton(
                                width: 300,
                                height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                                buttonText: 'order_details'.tr,
                                fontSize: Dimensions.fontSizeDefault,
                                onPressed: () => Get.to(() => const OrderScreen(
                                      isOrderDetails: true,
                                    )),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
      }),
    );
  }
}
