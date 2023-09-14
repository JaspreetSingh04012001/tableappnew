import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/sales_controller.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../../base/custom_text_field.dart';
import '../../order/widget/order_details_view.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  String customerName = "";

  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(initState: (state) {
      Get.find<SalesController>().getSales();
    }, builder: (salesController) {
      // salesController.getSales();
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Sales",
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ),
        body: Center(
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Get Sales Report for desired timeline",
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Start :",
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        TimePickerSpinnerPopUp(
                          mode: CupertinoDatePickerMode.date,
                          initTime: DateTime.now(),
                          // minTime: DateTime.now().subtract(const Duration(days: 1)),
                          //  maxTime: DateTime.now().add(const Duration(days: 665)),
                          barrierColor:
                              Colors.black12, //Barrier Color when pop up show
                          minuteInterval: 1,
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          cancelText: 'Cancel',
                          confirmText: 'OK',
                          pressType: PressType.singlePress,
                          timeFormat: 'dd/MM/yyyy',
                          // Customize your time widget
                          // timeWidgetBuilder: (dateTime) {},
                          onChange: (dateTime) {
                            final DateFormat formatter =
                                DateFormat('dd/MM/yyyy');
                            final String formatted =
                                formatter.format(dateTime).replaceAll("/", '-');

                            salesController.from = formatted;
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "End :",
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        TimePickerSpinnerPopUp(
                          mode: CupertinoDatePickerMode.date,
                          initTime: DateTime.now(),
                          //  minTime: DateTime.now().subtract(const Duration(days: 10)),
                          //  maxTime: DateTime.now().add(const Duration(days: 10)),
                          barrierColor:
                              Colors.black12, //Barrier Color when pop up show
                          minuteInterval: 1,
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          cancelText: 'Cancel',
                          confirmText: 'OK',
                          pressType: PressType.singlePress,
                          timeFormat: 'dd/MM/yyyy',
                          // Customize your time widget
                          // timeWidgetBuilder: (dateTime) {},
                          onChange: (dateTime) {
                            final DateFormat formatter =
                                DateFormat('dd/MM/yyyy');
                            final String formatted =
                                formatter.format(dateTime).replaceAll("/", '-');

                            salesController.to = formatted;
                            salesController.getSales();
                            // Implement your logic with select dateTime
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: CustomTextField(
                    //           borderColor:
                    //               Theme.of(context).hintColor.withOpacity(0.4),
                    //           controller: _nameController,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               customerName = value;
                    //             });
                    //           },
                    //           onSubmit: (value) {
                    //             setState(() {
                    //               customerName = value;
                    //             });
                    //           },
                    //           // inputType: TextInputType.number,
                    //           //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                    //           hintText: 'Enter Email',
                    //           hintStyle: robotoRegular.copyWith(
                    //               fontSize: Dimensions.fontSizeSmall),
                    //           //  focusNode: _nameFocusNode,
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Container(
                    //         alignment: Alignment.center,
                    //         height: 46,
                    //         width: 140,
                    //         decoration: BoxDecoration(
                    //             color: Theme.of(context).primaryColor,
                    //             borderRadius: BorderRadius.circular(12)),
                    //         child: Text(
                    //           "Send Email",
                    //           style: robotoRegular.copyWith(
                    //               color: Colors.white,
                    //               fontSize: Dimensions.fontSizeLarge),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    InkWell(
                      onTap: () {
                        salesController.getSales();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 160,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Search Sales",
                            style: robotoRegular.copyWith(
                                color: Colors.white,
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              "Order Id",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              "Payment",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              "Status",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              "Amount",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              "Date and Time",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    salesController.sales.isNotEmpty
                        ? GetBuilder<OrderController>(
                            builder: (orderController) {
                            return Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    salesController.sales.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        salesController.selectedIndex = index;
                                        salesController.selectedSale =
                                            salesController.sales[index];
                                        salesController.update();
                                        orderController.setCurrentOrderId =
                                            salesController.sales[index]
                                                    ["order_id"]
                                                .toString();
                                        orderController.getCurrentOrder(
                                          salesController.sales[index]
                                                  ["order_id"]
                                              .toString()
                                              .replaceAll(
                                                  '${'order'.tr}# ', ''),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: (salesController
                                                              .selectedIndex !=
                                                          null &&
                                                      salesController
                                                              .selectedIndex ==
                                                          index)
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        255, 225, 224, 224),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 4))
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      "${salesController.sales[index]["order_id"]}",
                                                      style: robotoMedium.copyWith(
                                                          color: (salesController
                                                                          .selectedIndex !=
                                                                      null &&
                                                                  salesController
                                                                          .selectedIndex ==
                                                                      index)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      "${salesController.sales[index]["payment_status"] ?? ''}",
                                                      style: robotoMedium.copyWith(
                                                          color: (salesController
                                                                          .selectedIndex !=
                                                                      null &&
                                                                  salesController
                                                                          .selectedIndex ==
                                                                      index)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      "${salesController.sales[index]["order_status"]}",
                                                      style: robotoMedium.copyWith(
                                                          color: (salesController
                                                                          .selectedIndex !=
                                                                      null &&
                                                                  salesController
                                                                          .selectedIndex ==
                                                                      index)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      "\$ ${salesController.sales[index]["order_amount"]}",
                                                      style: robotoMedium.copyWith(
                                                          color: (salesController
                                                                          .selectedIndex !=
                                                                      null &&
                                                                  salesController
                                                                          .selectedIndex ==
                                                                      index)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      "${salesController.sales[index]["delivery_date"]} ${salesController.sales[index]["delivery_time"]}",
                                                      style: robotoMedium.copyWith(
                                                          color: (salesController
                                                                          .selectedIndex !=
                                                                      null &&
                                                                  salesController
                                                                          .selectedIndex ==
                                                                      index)
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                        : Expanded(
                            child: Center(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                "No sales to report",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              ),
                            ),
                          )
                  ],
                ),
              ),
              if (salesController.selectedSale != null)
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: OrderDetailsView(isSales: true),
                    ))
            ],
          ),
        ),
      );
    });
  }
}
