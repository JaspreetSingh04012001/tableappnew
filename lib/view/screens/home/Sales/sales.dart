import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/sales_controller.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../../../helper/route_helper.dart';
import '../../../base/animated_dialog.dart';
import '../../../base/custom_loader.dart';
import '../../order/widget/emailDialog.dart';
import '../../order/widget/order_details_view.dart';

class Sales extends StatefulWidget {
  bool isMobile;
  Sales({Key? key, this.isMobile = false}) : super(key: key);

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  String customerName = "";
  int? selectedIndex = 2;
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(initState: (state) {
      Get.find<SalesController>().getSales();
    }, builder: (salesController) {
      // salesController.getSales();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.offAllNamed(
              RouteHelper.home,
            ),
            icon: const Icon(Icons.arrow_back),
          ),
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
                          padding: EdgeInsets.all(widget.isMobile ? 4 : 8.0),
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
                        SizedBox(
                          width: widget.isMobile ? 5 : 10,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: widget.isMobile ? 4 : 8),
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
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedIndex = null;
                            });
                            salesController.getSales();
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

                    Wrap(
                      alignment: WrapAlignment.center,
                      children: List.generate(3, (index) {
                        String text = "";
                        if (index == 0) {
                          text = 'Last 7 months';
                        } else if (index == 1) {
                          text = 'Last Week';
                        } else if (index == 2) {
                          text = 'Today';
                        }
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              if (index == 2) {
                                salesController.today();
                              }
                              if (index == 1) {
                                salesController.week();
                              }
                              if (index == 0) {
                                salesController.months();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? Theme.of(context).primaryColor
                                      : null,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  // color: Theme.of(context).,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  text,
                                  style: robotoRegular.copyWith(
                                      color: selectedIndex == index
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontSize: Dimensions.fontSizeLarge),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    InkWell(
                      onTap: () {
                        showAnimatedDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  overflow: TextOverflow.ellipsis,
                                  'Send Yearly Report',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge),
                                ),
                                content: EmailDialog(
                                  sales: true,
                                ),
                                actionsPadding: EdgeInsets.zero,
                                actions: const [],
                              );
                            });
                        //  salesController.getSales();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 160,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            "Send Yearly Report",
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
                              child: salesController.loading
                                  ? Center(
                                      child: CustomLoader(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )
                                  : SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          salesController.sales.length,
                                          (index) => InkWell(
                                            onTap: () {
                                              salesController.selectedIndex =
                                                  index;
                                              salesController.selectedSale =
                                                  salesController.sales[index];
                                              salesController.update();
                                              orderController
                                                      .setCurrentOrderId =
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
                                              if (widget.isMobile) {
                                                Get.to(OrderDetailsView(
                                                    isSales: true));
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                        : null,
                                                    boxShadow: const [
                                                      // BoxShadow(
                                                      //     color: Color.fromARGB(
                                                      //         255, 225, 224, 224),
                                                      //     spreadRadius: 1,
                                                      //     blurRadius: 5,
                                                      //     offset: Offset(0, 4))
                                                    ]),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            "${salesController.sales[index]["order_id"]}",
                                                            style: robotoMedium.copyWith(
                                                                color: (salesController.selectedIndex !=
                                                                            null &&
                                                                        salesController.selectedIndex ==
                                                                            index)
                                                                    ? Colors
                                                                        .white
                                                                    : null,
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          color: salesController
                                                                              .sales[
                                                                          index]
                                                                      [
                                                                      "payment_status"] ==
                                                                  "refund"
                                                              ? Colors
                                                                  .indigo[900]
                                                              : null,
                                                          child: Center(
                                                            child: salesController
                                                                            .sales[index]
                                                                        [
                                                                        "payment_status"] ==
                                                                    "refund"
                                                                ? Text(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    "${salesController.sales[index]["payment_status"] ?? ''}",
                                                                    style: robotoMedium.copyWith(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            Dimensions.fontSizeDefault),
                                                                  )
                                                                : Text(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    "${salesController.sales[index]["payment_status"] ?? ''}",
                                                                    style: robotoMedium.copyWith(
                                                                        color: (salesController.selectedIndex != null && salesController.selectedIndex == index)
                                                                            ? Colors
                                                                                .white
                                                                            : null,
                                                                        fontSize:
                                                                            Dimensions.fontSizeDefault),
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Center(
                                                          child: Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            "${salesController.sales[index]["order_status"]}",
                                                            style: robotoMedium.copyWith(
                                                                color: (salesController.selectedIndex !=
                                                                            null &&
                                                                        salesController.selectedIndex ==
                                                                            index)
                                                                    ? Colors
                                                                        .white
                                                                    : null,
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
                                                                TextOverflow
                                                                    .ellipsis,
                                                            "\$ ${salesController.sales[index]["order_amount"]}",
                                                            style: robotoMedium.copyWith(
                                                                color: (salesController.selectedIndex !=
                                                                            null &&
                                                                        salesController.selectedIndex ==
                                                                            index)
                                                                    ? Colors
                                                                        .white
                                                                    : null,
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
                                                                TextOverflow
                                                                    .ellipsis,
                                                            "${salesController.sales[index]["delivery_date"]} ${salesController.sales[index]["delivery_time"]}",
                                                            style: robotoMedium.copyWith(
                                                                color: (salesController.selectedIndex !=
                                                                            null &&
                                                                        salesController.selectedIndex ==
                                                                            index)
                                                                    ? Colors
                                                                        .white
                                                                    : null,
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
              if (salesController.selectedSale != null &&
                  widget.isMobile == false)
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
