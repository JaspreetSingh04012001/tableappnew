import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_text_field.dart';

class EmailDialog extends StatefulWidget {
  bool sales;
  EmailDialog({Key? key, this.sales = false}) : super(key: key);

  @override
  _EmailDialogState createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  int? selectedindex;
  Map quater = {
    1: 'Jan - March',
    2: 'April - June',
    3: 'July - September',
    4: 'October - December',
  };
  TextEditingController nameController = TextEditingController();
  TextEditingController yaerController = TextEditingController();
  @override
  void initState() {
    if (!widget.sales) {
      if (Get.find<OrderController>()
              .currentOrderDetails
              ?.order
              ?.customer_email !=
          null) {
        nameController.text = Get.find<OrderController>()
                .currentOrderDetails
                ?.order
                ?.customer_email ??
            '';
      }
    }
    super.initState();
  }

  List<Widget> x = [];
  bool succes = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!succes)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              borderColor: Theme.of(context).hintColor.withOpacity(0.4),
              controller: nameController,
              onChanged: (value) {
                // orderController
                //     .currentOrderDetails!.order?.customer_email;
                // setState(() {
                //   customerName = value;
                // });
              },
              onSubmit: (value) {
                // setState(() {
                //   customerName = value;
                // });
              },
              // inputType: TextInputType.number,
              //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              hintText: 'Enter Email',
              hintStyle:
                  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              //  focusNode: _nameFocusNode,
            ),
          ),
        if (widget.sales && !succes)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              borderColor: Theme.of(context).hintColor.withOpacity(0.4),
              controller: yaerController,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (value) {
                // orderController
                //     .currentOrderDetails!.order?.customer_email;
                // setState(() {
                //   customerName = value;
                // });
              },
              onSubmit: (value) {
                // setState(() {
                //   customerName = value;
                // });
              },
              // inputType: TextInputType.number,
              //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              hintText: 'Enter Year',
              hintStyle:
                  robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              //  focusNode: _nameFocusNode,
            ),
          ),
        // CupertinoPicker(
        //   itemExtent: 20,
        //   onSelectedItemChanged: (value) {},
        //   children: List.generate(100, (index) => Text("${2015 + index}")),
        // ),
        if (widget.sales && !succes)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Select Quarter",
                  style: robotoRegular.copyWith(

                      //  color: Colors.white,
                      fontSize: Dimensions.fontSizeLarge),
                ),
                Text(
                  " ( Optional )",
                  style: robotoRegular.copyWith(
                      color: Colors.red, fontSize: Dimensions.fontSizeDefault),
                ),
              ],
            ),
          ),
        if (widget.sales && !succes)
          Wrap(
              children: List.generate(
                  4,
                  (index) => InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedindex != null) {
                              selectedindex = null;
                            } else {
                              selectedindex = index;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 3),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(4),
                                  color: (index == selectedindex)
                                      ? Theme.of(context).primaryColor
                                      : Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  quater[index + 1],
                                  style: robotoRegular.copyWith(
                                      color: (index == selectedindex)
                                          ? Colors.white
                                          : null,
                                      //  color: Colors.white,
                                      fontSize: Dimensions.fontSizeLarge),
                                ),
                              )),
                        ),
                      ))),
        if (!succes)
          InkWell(
            onTap: () {
              if (!widget.sales) {
                Get.find<OrderController>()
                    .sendEmail(
                        order_id: Get.find<OrderController>()
                                .currentOrderDetails
                                ?.order
                                ?.id
                                .toString() ??
                            '',
                        customer_email: nameController.text)
                    .whenComplete(() => null)
                    .then((value) {
                  print(value.body.toString());

                  if (value.body["email_status"] == "sent") {
                    setState(() {
                      succes = true;
                    });
                  }
                });
              } else {
                Get.find<SalesController>()
                    .sendSales(
                        "2023",
                        (selectedindex != null)
                            ? "${selectedindex! + 1}"
                            : null)
                    .whenComplete(() => null)
                    .then((value) {});
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                // height: 46,
                // width: 140,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "Send Email",
                    style: robotoRegular.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeLarge),
                  ),
                ),
              ),
            ),
          ),
        if (succes)
          Lottie.asset(
            width: 100,
            fit: BoxFit.fitWidth,
            Images.successAnimation,
          ),
        if (succes)
          Text(
            "Email sent to \n${nameController.text}",
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          )
      ],
    );
  }
}
