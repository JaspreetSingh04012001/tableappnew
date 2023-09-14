import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_text_field.dart';

class EmailDialog extends StatefulWidget {
  const EmailDialog({Key? key}) : super(key: key);

  @override
  _EmailDialogState createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
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
        if (!succes)
          InkWell(
            onTap: () {
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
