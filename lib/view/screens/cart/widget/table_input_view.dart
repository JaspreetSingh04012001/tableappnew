import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/config_model.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TableInputView extends StatefulWidget {
  const TableInputView({Key? key}) : super(key: key);

  @override
  State<TableInputView> createState() => _TableInputViewState();
}

class _TableInputViewState extends State<TableInputView> {
  final TextEditingController _peopleNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _peopleNumberFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  List<String> _errorText = [];

  @override
  void initState() {
    final SplashController splashController = Get.find<SplashController>();
    TableModel? table = splashController.getTable(splashController.getTableId(),
        branchId: splashController.getBranchId());
    Get.find<SplashController>().updateTableId(
      Get.find<SplashController>().getTableId() < 0 || table == null
          ? null
          : Get.find<SplashController>().getTableId(),
      isUpdate: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _peopleNumberController.dispose();
    _peopleNumberFocusNode.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return GetBuilder<CartController>(builder: (cartController) {
        if (cartController.peopleNumber != null && _errorText.isEmpty) {
          _peopleNumberController.text = cartController.peopleNumber.toString();
        }
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              color: Theme.of(context).colorScheme.background,
            ),
            width: 650,
            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                Text(overflow: TextOverflow.ellipsis, 'table_number'.tr),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                IgnorePointer(
                  ignoring: splashController.getIsFixTable(),
                  child: Container(
                    height: ResponsiveHelper.isSmallTab()
                        ? 40
                        : ResponsiveHelper.isTab(context)
                            ? 50
                            : 40,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(
                            color: Theme.of(context).hintColor.withOpacity(0.4))
                        // boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                        ),
                    child: DropdownButton<int>(
                      menuMaxHeight: Get.height * 0.5,
                      hint: Text(
                        overflow: TextOverflow.ellipsis,
                        'set_your_table_number'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                      value: splashController.selectedTableId,
                      items: splashController.configModel?.branch
                          ?.firstWhere((branch) =>
                              branch.id == splashController.getBranchId())
                          .table
                          ?.map((value) {
                        return DropdownMenuItem<int>(
                          value: value.id,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            '${value.id == -1 ? 'no_table_available'.tr : value.number}',
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        splashController.updateTableId(
                            value == -1 ? null : value,
                            isUpdate: true);
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                Row(
                  children: [
                    Text(
                        overflow: TextOverflow.ellipsis, 'number_of_people'.tr),
                    SizedBox(
                      width: Dimensions.paddingSizeExtraSmall,
                    ),
                    if (splashController.selectedTableId != null)
                      Text(
                        overflow: TextOverflow.ellipsis,
                        '( ${'max_capacity'.tr} : ${splashController.getTable(splashController.selectedTableId)?.capacity})',
                        style: robotoRegular.copyWith(
                            color: Theme.of(context).hintColor),
                      ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                SizedBox(
                  height: ResponsiveHelper.isSmallTab()
                      ? 40
                      : ResponsiveHelper.isTab(context)
                          ? 50
                          : 40,
                  child: CustomTextField(
                    borderColor: Theme.of(context).hintColor.withOpacity(0.4),
                    controller: _peopleNumberController,
                    inputType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                    hintText: '${'ex'.tr}: 3',
                    hintStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                    focusNode: _peopleNumberFocusNode,
                  ),
                ),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                const Text(
                    overflow: TextOverflow.ellipsis, 'Enter name of customer'),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                SizedBox(
                  height: ResponsiveHelper.isSmallTab()
                      ? 40
                      : ResponsiveHelper.isTab(context)
                          ? 50
                          : 40,
                  child: CustomTextField(
                    borderColor: Theme.of(context).hintColor.withOpacity(0.4),
                    controller: _nameController,
                    // inputType: TextInputType.number,
                    //inputFormatter:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                    hintText: 'Enter name of customer',
                    hintStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                    focusNode: _nameFocusNode,
                  ),
                ),
                SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                if (_errorText.isNotEmpty)
                  Text(
                      overflow: TextOverflow.ellipsis,
                      _errorText.first,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).colorScheme.error,
                      )),
                CustomButton(
                  buttonText: 'save'.tr,
                  width: 300,
                  height: ResponsiveHelper.isSmallTab() ? 40 : 50,
                  onPressed: () {
                    if (splashController.selectedTableId != null &&
                        _peopleNumberController.text.isNotEmpty &&
                        _nameController.text.isNotEmpty) {
                      // if(Get.find<OrderController>().orderTableNumber != -1 && Get.find<OrderController>().orderTableNumber != splashController.selectedTableId!) {
                      //
                      // }
                      if (splashController
                              .getTable(splashController.selectedTableId)!
                              .capacity! <
                          int.parse(_peopleNumberController.text)) {
                        _errorText = [];
                        _errorText.add('you_reach_max_capacity'.tr);
                      } else {
                        splashController
                            .setTableId(splashController.selectedTableId!);
                        cartController.setPeopleNumber =
                            int.parse(_peopleNumberController.text);
                        cartController.setCustomerName = _nameController.text;
                        cartController.update();
                        Get.back();
                      }
                    } else {
                      _errorText = [];
                      if (_nameController.text.isEmpty) {
                        _errorText.add('set name of customer');
                      }
                      _errorText.add(
                        splashController.selectedTableId == null
                            ? 'set_your_table_number'.tr
                            : 'set_people_number'.tr,
                      );
                    }
                    splashController.update();
                  },
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
