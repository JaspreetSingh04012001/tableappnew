import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderNoteView extends StatefulWidget {
  final String? note;
  final Function(String) onChange;
  const OrderNoteView({Key? key, required this.onChange, this.note}) : super(key: key);

  @override
  State<OrderNoteView> createState() => _OrderNoteViewState();
}

class _OrderNoteViewState extends State<OrderNoteView> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    if(widget.note != null) {
      _noteController.text = widget.note!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: Get.width * 0.4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        ),
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge,  horizontal: Dimensions.paddingSizeExtraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: Dimensions.paddingSizeLarge,),

            SizedBox(
              child: CustomTextField(
                borderColor: Theme.of(context).primaryColor.withOpacity(0.3),
                controller: _noteController,
                maxLines: 5,
                hintText: 'add_spacial_note_here'.tr,
                hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                isEnabled: true,
              ),
            ),
            SizedBox(height: Dimensions.paddingSizeDefault,),

            CustomButton(
              height: 40, width: 200,
              buttonText: 'save'.tr, onPressed:() {
              widget.onChange(_noteController.text);
              Get.back();
              }
            ),
          ],
        ),
      ),
    );
  }
}
