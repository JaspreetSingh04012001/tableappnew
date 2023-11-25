import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/printer_controller.dart';
import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/body_template.dart';
import 'package:efood_table_booking/view/base/custom_app_bar.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_loader.dart';
import 'package:efood_table_booking/view/base/custom_snackbar.dart';
import 'package:efood_table_booking/view/base/custom_text_field.dart';
import 'package:efood_table_booking/view/screens/home/widget/filter_button_widget.dart';
import 'package:efood_table_booking/view/screens/order/widget/order_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _splitCardamountTextController =
      TextEditingController();
  double _changeAmount = 0;
  double _currentAmount = 0;
  double _payableAmount = 0;
  int? selectedindex;
  var logger = Logger();
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _amountTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final orderController = Get.find<OrderController>();
    orderController.isLoadingUpdate = false;
    orderController.setSelectedMethod(
        Get.find<OrderController>().paymentMethodList.first,
        isUpdate: false);
    _currentAmount = orderController.placeOrderBody!.orderAmount! -
        Get.find<OrderController>().previousDueAmount();

    _payableAmount = orderController.placeOrderBody!.orderAmount!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      OrderDetailsModel orderDetailsModel = OrderDetailsModel(
        orderID: 'no_id',
        paymentMethod: orderController.selectedMethod,
        cartList: Get.find<CartController>().cartList,
        paidAmount: double.tryParse(_amountTextController.text),
        change: _changeAmount,
      );

      void callBack(bool isSuccess, String message, String orderID) async {
        orderDetailsModel = orderDetailsModel.copyWith(id: orderID);
        if (isSuccess) {
          Get.find<CartController>().clearCartData();
          Get.find<OrderController>().updateOrderNote(null);
          orderController
              .setSelectedMethod(orderController.paymentMethodList.first);
          if (orderController.getOrderSuccessModel() != null) {
            orderController
                .getCurrentOrder(orderController.orderSuccessModel!.orderId!)
                .then((value) {
              Get.find<PrinterController>().printTest();

              Get.off(() => const OrderSuccessScreen(fromPlaceOrder: true));
            });
          }
        } else {
          showCustomSnackBar(message);
        }
      }

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ResponsiveHelper.isTab(context)
            ? null
            : const CustomAppBar(
                isBackButtonExist: true,
                onBackPressed: null,
                showCart: true,
              ),
        body: ResponsiveHelper.isTab(context)
            ? BodyTemplate(
                //isOrderDetails: true,
                body:
                    Flexible(child: _body(orderController, context, callBack)))
            : _body(orderController, context, callBack),
      );
    });
  }

  Widget _body(
    OrderController orderController,
    BuildContext context,
    void Function(bool isSuccess, String message, String orderID) callback,
  ) {
    List<int> x = [10, 20, 50, 70, 100];
    void amountCheck() {
      double total = Get.find<CartController>().totalAmount;
      double cashAmount = double.parse(_amountTextController.text.isEmpty
          ? "0"
          : _amountTextController.text);

      double cardAmount = double.parse(
          _splitCardamountTextController.text.isEmpty
              ? "0"
              : _splitCardamountTextController.text);
      if ((cashAmount + cardAmount) > total) {
        _changeAmount = (cashAmount + cardAmount) - total;
      } else {
        _splitCardamountTextController.text = (total - cashAmount).toString();
        _changeAmount = 0;
      }
      cashAmount = cashAmount.toPrecision(2);
      cardAmount = cardAmount.toPrecision(2);
    }

    if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
      scrollToBottom();
    }

    return orderController.isLoading
        ? Center(
            child: CustomLoader(color: Theme.of(context).primaryColor),
          )
        : SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(height: Dimensions.paddingSizeExtraLarge),
                CustomButton(
                  icon: Icons.arrow_back_ios,
                  height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                  width: 200,
                  transparent: true,
                  buttonText: 'back_to_home'.tr,
                  fontSize: Dimensions.fontSizeDefault,
                  onPressed: () => Get.offAllNamed(
                    RouteHelper.home,
                  ),
                ),
                const Gap(10),
                Text(
                  overflow: TextOverflow.ellipsis,
                  'paid_by'.tr,
                  style: robotoRegular,
                ),
                FilterButtonWidget(
                    isSmall: Get.width < 390,
                    items: orderController.paymentMethodList,
                    type: orderController.selectedMethod,
                    isBorder: true,
                    onSelected: (method) {
                      if (method == 'card') {
                        _amountTextController.text =
                            PriceConverter.convertPrice(
                                orderController.placeOrderBody!.orderAmount!);
                      } else {
                        selectedindex = null;
                        _splitCardamountTextController.clear();
                        _amountTextController.clear();
                        _changeAmount = 0;
                      }
                      orderController.setSelectedMethod(method);
                    }),
                if (orderController.selectedMethod == 'card')
                  Image.asset(Images.possImage, height: Get.height * 0.2),
                SizedBox(
                  height: Dimensions.paddingSizeLarge,
                ),
                Text(
                    overflow: TextOverflow.ellipsis,
                    'payment_pending'.tr,
                    style: robotoRegular),
                SizedBox(
                  height: Dimensions.paddingSizeLarge,
                ),
                Padding(
                  padding: ResponsiveHelper.isTab(context)
                      ? EdgeInsets.symmetric(horizontal: Get.width * 0.04)
                      : EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeDefault,
                        horizontal: Dimensions.paddingSizeDefault),
                    margin: EdgeInsets.only(
                        bottom: Dimensions.paddingSizeExtraLarge),
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
                        if (orderController.selectedMethod == 'cash' ||
                            orderController.selectedMethod == 'split')
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Wrap(
                                children: List.generate(
                                    x.length,
                                    (index) => InkWell(
                                          onTap: () {
                                            if (orderController
                                                        .selectedMethod ==
                                                    'split' &&
                                                x[index] >
                                                    Get.find<CartController>()
                                                        .totalAmount) {
                                              showCustomSnackBar(
                                                  "Cash amount cannot exceed total in Split method");
                                              return;
                                            }
                                            if (orderController
                                                        .selectedMethod ==
                                                    'cash' &&
                                                x[index] <
                                                    Get.find<CartController>()
                                                        .totalAmount) {
                                              showCustomSnackBar(
                                                  "Please select more than price");
                                              return;
                                            }
                                            if (selectedindex == index) {
                                              setState(() {
                                                _amountTextController.clear();
                                                _splitCardamountTextController
                                                    .clear();
                                                _changeAmount = 0;
                                                selectedindex = null;
                                              });
                                              return;
                                            }

                                            selectedindex = index;
                                            _amountTextController.text =
                                                "${x[index]}.0";
                                            if (orderController
                                                    .selectedMethod ==
                                                'split') {
                                              _splitCardamountTextController
                                                  .clear();
                                              amountCheck();
                                            } else {
                                              if (double.parse(
                                                      _amountTextController
                                                          .text) >
                                                  Get.find<CartController>()
                                                      .totalAmount) {
                                                _changeAmount = (Get.find<
                                                                CartController>()
                                                            .totalAmount -
                                                        double.parse(
                                                            _amountTextController
                                                                .text)) *
                                                    -1.0;
                                              } else {
                                                _changeAmount = 0;
                                              }
                                            }

                                            orderController.update();
                                            //  });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 7),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1.5,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color:
                                                        (index == selectedindex)
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : null),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  child: Text(
                                                    "\$${x[index]}",
                                                    style:
                                                        robotoRegular.copyWith(
                                                            color: (index ==
                                                                    selectedindex)
                                                                ? Colors.white
                                                                : null,
                                                            //  color: Colors.white,
                                                            fontSize: Dimensions
                                                                    .fontSizeExtraLarge +
                                                                2),
                                                  ),
                                                )),
                                          ),
                                        ))),
                          ),
                        if (orderController.selectedMethod == 'cash' ||
                            orderController.selectedMethod == 'card')
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        'paid_amount'.tr)),
                                SizedBox(width: Dimensions.paddingSizeLarge),
                                Expanded(
                                  child: SizedBox(
                                    height: Get.width < 390
                                        ? 30
                                        : ResponsiveHelper.isSmallTab()
                                            ? 40
                                            : ResponsiveHelper.isTab(context)
                                                ? 50
                                                : 40,
                                    child: IgnorePointer(
                                      ignoring:
                                          orderController.selectedMethod !=
                                              'cash',
                                      child: CustomTextField(
                                        borderColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.4),
                                        hintText: 'enter_amount'.tr,
                                        controller: _amountTextController,
                                        inputType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatter: [
                                          NumberTextInputFormatter(
                                            integerDigits: 10,
                                            decimalDigits: 1,
                                            maxValue: '1000000000.00',
                                            decimalSeparator: '.',
                                            groupDigits: 3,
                                            groupSeparator: ',',
                                            allowNegative: false,
                                            overrideDecimalPoint: true,
                                            insertDecimalPoint: false,
                                            insertDecimalDigits: true,
                                          ),
                                        ],
                                        hintStyle: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                        onChanged: (value) {
                                          selectedindex = null;
                                          if (double.parse(value) >
                                              Get.find<CartController>()
                                                  .totalAmount) {
                                            _changeAmount =
                                                (Get.find<CartController>()
                                                            .totalAmount -
                                                        double.parse(value)) *
                                                    -1.0;
                                          } else {
                                            _changeAmount = 0;
                                          }
                                          orderController.update();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (orderController.selectedMethod == 'split')
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge),
                            child: Row(
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        "Cash")),
                                SizedBox(width: Dimensions.paddingSizeLarge),
                                Expanded(
                                  child: SizedBox(
                                    height: Get.width < 390
                                        ? 30
                                        : ResponsiveHelper.isSmallTab()
                                            ? 40
                                            : ResponsiveHelper.isTab(context)
                                                ? 50
                                                : 40,
                                    child: CustomTextField(
                                      inputType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      borderColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
                                      hintText: 'enter_amount'.tr,
                                      controller: _amountTextController,
                                      inputFormatter: [
                                        NumberTextInputFormatter(
                                          integerDigits: 10,
                                          decimalDigits: 1,
                                          maxValue: '1000000000.00',
                                          decimalSeparator: '.',
                                          groupDigits: 3,
                                          groupSeparator: ',',
                                          allowNegative: false,
                                          overrideDecimalPoint: true,
                                          insertDecimalPoint: false,
                                          insertDecimalDigits: true,
                                        ),
                                        // FilteringTextInputFormatter.allow(
                                        //     RegExp("[0-9]")),
                                        // LengthLimitingTextInputFormatter(10),
                                      ],
                                      hintStyle: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                      onChanged: (value) {
                                        selectedindex = null;
                                        _splitCardamountTextController.clear();
                                        amountCheck();
                                        orderController.update();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: Dimensions.paddingSizeLarge),
                        if (orderController.selectedMethod == 'split')
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge),
                            child: Row(
                              children: [
                                const SizedBox(
                                    width: 100,
                                    child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        "Card")),
                                SizedBox(width: Dimensions.paddingSizeLarge),
                                Expanded(
                                  child: SizedBox(
                                    height: Get.width < 390
                                        ? 30
                                        : ResponsiveHelper.isSmallTab()
                                            ? 40
                                            : ResponsiveHelper.isTab(context)
                                                ? 50
                                                : 40,
                                    child: CustomTextField(
                                      inputType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      borderColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
                                      hintText: 'enter_amount'.tr,
                                      controller:
                                          _splitCardamountTextController,
                                      inputFormatter: [
                                        NumberTextInputFormatter(
                                          integerDigits: 10,
                                          decimalDigits: 1,
                                          maxValue: '1000000000.00',
                                          decimalSeparator: '.',
                                          groupDigits: 3,
                                          groupSeparator: ',',
                                          allowNegative: false,
                                          overrideDecimalPoint: true,
                                          insertDecimalPoint: false,
                                          insertDecimalDigits: true,
                                        ),
                                      ],
                                      hintStyle: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                      onChanged: (value) {
                                        selectedindex = null;
                                        amountCheck();
                                        orderController.update();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!ResponsiveHelper.isTab(context))
                          SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                        !ResponsiveHelper.isTab(context)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: SizedBox(
                                            width: 100,
                                            child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                'previous_due'.tr))),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraLarge),
                                    Expanded(
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          PriceConverter.convertPrice(
                                              orderController
                                                  .previousDueAmount())),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        if (!ResponsiveHelper.isTab(context))
                          SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                        !ResponsiveHelper.isTab(context)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: SizedBox(
                                            width: 100,
                                            child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                'current_amount'.tr))),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraLarge),
                                    Expanded(
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          PriceConverter.convertPrice(
                                              _currentAmount)),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        if (!ResponsiveHelper.isTab(context))
                          SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                        !ResponsiveHelper.isTab(context)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: SizedBox(
                                            width: 100,
                                            child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                'payable_amount'.tr))),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraLarge),
                                    Expanded(
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          PriceConverter.convertPrice(
                                              _payableAmount)),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: Dimensions.paddingSizeDefault,
                        ),
                        orderController.selectedMethod == 'cash' ||
                                orderController.selectedMethod == 'split'
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: SizedBox(
                                            width: 100,
                                            child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                'change'.tr))),
                                    SizedBox(
                                        width:
                                            Dimensions.paddingSizeExtraLarge),
                                    Expanded(
                                      child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          PriceConverter.convertPrice(
                                              _changeAmount)),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: Dimensions.paddingSizeExtraLarge,
                        ),
                        orderController.isLoading
                            ? Center(
                                child: CustomLoader(
                                    color: Theme.of(context).primaryColor),
                              )
                            : Row(
                                children: [
                                  GetBuilder<PrinterController>(
                                      builder: (printerController) {
                                    return printerController.connected
                                        ? IconButton(
                                            onPressed: printerController
                                                .openDrawerOnClick,
                                            icon: Icon(
                                              Icons.electric_bolt_rounded,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ))
                                        : Container();
                                  }),
                                  Expanded(
                                    child: CustomButton(
                                      height: ResponsiveHelper.isSmallTab()
                                          ? 40
                                          : ResponsiveHelper.isTab(context)
                                              ? 50
                                              : 40,
                                      transparent: true,
                                      buttonText: 'pay_after_eating'.tr,
                                      fontSize: Get.width < 390 ? 12 : null,
                                      onPressed: () {
                                        orderController.placeOrder(
                                          orderController.placeOrderBody!
                                              .copyWith(
                                            paymentStatus: 'unpaid',
                                            paymentMethod: '',
                                            previousDue: orderController
                                                .previousDueAmount(),
                                          ),
                                          callback,
                                          '0',
                                          0,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.paddingSizeLarge,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      height: ResponsiveHelper.isSmallTab()
                                          ? 40
                                          : ResponsiveHelper.isTab(context)
                                              ? 50
                                              : 40,
                                      buttonText: 'confirm_payment'.tr,
                                      fontSize: Get.width < 390 ? 12 : null,
                                      onPressed: () {
                                        if (orderController.selectedMethod ==
                                            'card') {
                                          orderController.placeOrder(
                                            orderController.placeOrderBody!
                                                .copyWith(
                                              paymentStatus: 'paid',
                                              paymentMethod: orderController
                                                  .selectedMethod,
                                              card: _amountTextController.text
                                                  .replaceAll("\$", ""),
                                              // cash: _amountTextController.text,
                                              previousDue: orderController
                                                  .previousDueAmount(),
                                            ),
                                            callback,
                                            _amountTextController.text,
                                            _changeAmount,
                                          );
                                          return;
                                        }
                                        if (orderController.selectedMethod ==
                                                'cash' &&
                                            _amountTextController
                                                .text.isEmpty) {
                                          showCustomSnackBar(
                                              'please_enter_your_amount'.tr);
                                          return;
                                        }
                                        if (orderController.selectedMethod ==
                                                'split' &&
                                            (_amountTextController
                                                    .text.isEmpty ||
                                                _splitCardamountTextController
                                                    .text.isEmpty)) {
                                          showCustomSnackBar(
                                              'please_enter_your_amount'.tr);
                                          return;
                                        }
                                        double cashAmount = double.parse(
                                            _amountTextController.text.isEmpty
                                                ? "0"
                                                : _amountTextController.text);
                                        double cardAmount = double.parse(
                                            _splitCardamountTextController
                                                    .text.isEmpty
                                                ? "0"
                                                : _splitCardamountTextController
                                                    .text);

                                        if (orderController.selectedMethod ==
                                                'cash' &&
                                            orderController.placeOrderBody!
                                                    .orderAmount! >
                                                cashAmount) {
                                          showCustomSnackBar(
                                              'you_need_pay_more_amount'.tr);
                                          return;
                                        }
                                        if (orderController.selectedMethod ==
                                            'cash') {
                                          orderController.placeOrder(
                                            orderController.placeOrderBody!
                                                .copyWith(
                                              paymentStatus: 'paid',
                                              paymentMethod: orderController
                                                  .selectedMethod,
                                              cash: cashAmount.toString(),
                                              previousDue: orderController
                                                  .previousDueAmount(),
                                            ),
                                            callback,
                                            _amountTextController.text,
                                            _changeAmount,
                                          );
                                          return;
                                        }
                                        if (orderController.selectedMethod ==
                                                'split' &&
                                            orderController.placeOrderBody!
                                                    .orderAmount! >
                                                (cashAmount + cardAmount)) {
                                          showCustomSnackBar(
                                              'you_need_pay_more_amount'.tr);
                                          return;
                                        }
                                        if (orderController.selectedMethod ==
                                            'split') {
                                          orderController.placeOrder(
                                            orderController.placeOrderBody!
                                                .copyWith(
                                              paymentStatus: 'paid',
                                              paymentMethod: orderController
                                                  .selectedMethod,
                                              cash: cashAmount.toString(),
                                              card: cardAmount.toString(),
                                              previousDue: orderController
                                                  .previousDueAmount(),
                                            ),
                                            callback,
                                            _amountTextController.text,
                                            _changeAmount,
                                          );
                                          return;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        if (ResponsiveHelper.isTab(context))
                          SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
                if (MediaQuery.of(context).viewInsets.bottom != 0.0)
                  const Gap(120),
              ],
            ),
          );
  }
}

class OrderDetailsModel {
  String orderID;
  double? paidAmount;
  double? change;
  String paymentMethod;
  List<CartModel> cartList;

  OrderDetailsModel({
    required this.orderID,
    this.paidAmount,
    this.change,
    required this.paymentMethod,
    required this.cartList,
  });

  OrderDetailsModel copyWith({required String id}) {
    orderID = id;
    return this;
  }
}
