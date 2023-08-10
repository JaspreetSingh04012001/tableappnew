import 'dart:convert';

import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/controller/promotional_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/config_model.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/helper/route_helper.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:efood_table_booking/view/base/custom_button.dart';
import 'package:efood_table_booking/view/screens/promotional_page/promotional_page_screen.dart';
import 'package:efood_table_booking/view/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ModernTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  TextEditingController email;

  ModernTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.email,
    this.obscureText = true,
    this.validator,
  }) : super(key: key);

  bool obscureText1 = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: email,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}

class ModernTextField1 extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  TextEditingController password;

  ModernTextField1({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.password,
    this.obscureText = true,
    this.validator,
  }) : super(key: key);

  @override
  State<ModernTextField1> createState() => _ModernTextFieldState1();
}

class _ModernTextFieldState1 extends State<ModernTextField1> {
  bool obscureText1 = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.password,
      obscureText: obscureText1,
      style: const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.obscureText
            ? InkWell(
                onTap: () {
                  setState(() {
                    obscureText1 = !obscureText1;
                  });
                },
                child: Icon(
                    !obscureText1
                        ? Icons.remove_red_eye_sharp
                        : Icons.visibility_off,
                    color: Colors.grey),
              )
            : null,
        hintText: widget.hintText,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: widget.validator,
    );
  }
}

class SettingWidget extends StatefulWidget {
  final bool formSplash;
  const SettingWidget({Key? key, required this.formSplash}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  List<String> _errorText = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordValid = true;
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  late SharedPreferences sharedPreferences;

  void j() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    j();
    final splashController = Get.find<SplashController>();

    if (splashController.getBranchId() < 1) {
      splashController.updateBranchId(null, isUpdate: false);
    } else {
      splashController.updateBranchId(splashController.getBranchId(),
          isUpdate: false);
    }
    TableModel? table = splashController.getTable(splashController.getTableId(),
        branchId: splashController.getBranchId());

    if (table == null || splashController.getTableId() < 1) {
      splashController.updateFixTable(false, false);
      splashController.updateTableId(null, isUpdate: false);
    } else {
      splashController.updateTableId(splashController.getTableId(),
          isUpdate: false);
      splashController.updateFixTable(true, false);
    }
    splashController.updateFixTable(splashController.getIsFixTable(), false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<SplashController>(builder: (splashController) {
        bool isAvailable = false;
        // splashController.configModel?.branch?.map((Branch value) {
        //   if(value.id == splashController.selectedBranchId){
        //     isAvailable = true;
        //   }
        // });

        if (splashController.configModel != null &&
            splashController.configModel!.branch != null) {
          for (int i = 0;
              i < splashController.configModel!.branch!.length;
              i++) {
            if (splashController.configModel!.branch![i].id ==
                splashController.selectedBranchId) {
              isAvailable = true;
            }
          }
        }

        if (!isAvailable) {
          splashController.setBranch(-1);
        }

        return Container(
          width: Get.width * 0.4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius:
                const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          ),
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeExtraLarge,
              horizontal: Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.formSplash ? 'login'.tr : 'logout'.tr,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      widget.formSplash
                          ? ModernTextField(
                              email: email,
                              hintText: 'Email',
                              prefixIcon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email.';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                            )
                          : Container(),
                      widget.formSplash
                          ? const SizedBox(height: 16.0)
                          : Container(),
                      widget.formSplash
                          ? ModernTextField1(
                              password: password,
                              hintText: 'Password',
                              prefixIcon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password.';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                if (!isPasswordValid) {
                                  return 'Incorrect password.';
                                }
                                return null;
                              },
                            )
                          : Container()
                      // const SizedBox(height: 16.0),
                      // ElevatedButton(
                      //   onPressed: () async {},
                      //   child: const Text('Login'),
                      // ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: 40,
              //   padding: EdgeInsets.symmetric(
              //     horizontal: Dimensions.paddingSizeDefault,
              //   ),
              //   decoration: BoxDecoration(
              //       color: Theme.of(context).cardColor,
              //       borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              //       border: Border.all(
              //           color: Theme.of(context).primaryColor.withOpacity(0.4))
              //       // boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
              //       ),
              //   child: DropdownButton<int>(
              //     menuMaxHeight: Get.height * 0.5,
              //     hint: Text(
              //       'select_your_branch'.tr,
              //       style: robotoRegular.copyWith(
              //           fontSize: Dimensions.fontSizeSmall),
              //     ),
              //     value: splashController.selectedBranchId,
              //     items:
              //         splashController.configModel?.branch?.map((Branch value) {
              //       print(value.name);
              //       return DropdownMenuItem<int>(
              //         value: value.id,
              //         child: Text(
              //           value.name ?? 'no branch',
              //           style: robotoRegular.copyWith(
              //               fontSize: Dimensions.fontSizeSmall),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       _errorText = [];
              //       splashController.updateBranchId(value!);
              //       splashController.updateTableId(null);
              //     },
              //     isExpanded: true,
              //     underline: const SizedBox(),
              //   ),
              // ),
              // SizedBox(height: Dimensions.paddingSizeDefault),
              // Text(
              //   'set_fix_table_number'.tr,
              //   style: robotoRegular.copyWith(
              //       fontSize: Dimensions.fontSizeDefault),
              // ),
              // SizedBox(height: Dimensions.paddingSizeDefault),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     SizedBox(
              //       width: 100,
              //       child: RadioListTile(
              //         activeColor: Theme.of(context).primaryColor,
              //         contentPadding: EdgeInsets.zero,
              //         dense: true,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity,
              //         ),
              //         title: Text('yes'.tr, style: robotoRegular),
              //         value: true,
              //         groupValue: splashController.isFixTable,
              //         onChanged: (bool? value) {
              //           if (splashController.selectedBranchId != null) {
              //             splashController.updateFixTable(true, true);
              //           } else {
              //             splashController.updateFixTable(true, true);
              //             Future.delayed(const Duration(milliseconds: 300))
              //                 .then((value) {
              //               _errorText = [];
              //               _errorText.add('please_select_your_branch'.tr);
              //               splashController.updateFixTable(false, true);
              //             });
              //           }
              //           splashController.updateTableId(null);
              //         },
              //       ),
              //     ),
              //     SizedBox(
              //       width: 100,
              //       child: RadioListTile(
              //         activeColor: Theme.of(context).primaryColor,
              //         contentPadding: EdgeInsets.zero,
              //         dense: true,
              //         visualDensity: const VisualDensity(
              //           horizontal: VisualDensity.minimumDensity,
              //           vertical: VisualDensity.minimumDensity,
              //         ),
              //         title: Text('no'.tr, style: robotoRegular),
              //         value: splashController.isFixTable,
              //         groupValue: false,
              //         onChanged: (bool? value) =>
              //             splashController.updateFixTable(false, true),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              //   if (splashController.isFixTable
              //  // && splashController.selectedBranchId != null
              //   )
              //     Container(
              //       height: 40,
              //       padding: EdgeInsets.symmetric(
              //         horizontal: Dimensions.paddingSizeDefault,
              //       ),
              //       decoration: BoxDecoration(
              //           color: Theme.of(context).cardColor,
              //           borderRadius:
              //               BorderRadius.circular(Dimensions.radiusSmall),
              //           border: Border.all(
              //               color:
              //                   Theme.of(context).primaryColor.withOpacity(0.4))
              //           // boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
              //           ),
              //       child: DropdownButton<int>(
              //         menuMaxHeight: Get.height * 0.5,
              //         borderRadius:
              //             BorderRadius.circular(Dimensions.radiusDefault),
              //         hint: Text(
              //           'set_your_table_number'.tr,
              //           style: robotoRegular.copyWith(
              //               fontSize: Dimensions.fontSizeSmall),
              //         ),
              //         value: splashController.selectedTableId,
              //         items: splashController.configModel?.branch
              //             ?.firstWhere((branch) =>
              //                 branch.id == splashController.selectedBranchId)
              //             .table
              //             ?.map((value) {
              //           return DropdownMenuItem<int>(
              //             value: value.id,
              //             child: Text(
              //               '${value.id == -1 ? 'no_table_available'.tr : value.number}',
              //               style: robotoRegular.copyWith(
              //                   fontSize: Dimensions.fontSizeSmall),
              //             ),
              //           );
              //         }).toList(),
              //         onChanged: (value) {
              //           splashController.updateTableId(value == -1 ? null : value,
              //               isUpdate: true);
              //         },
              //         isExpanded: true,
              //         underline: const SizedBox(),
              //       ),
              //     ),
              if (_errorText.isNotEmpty)
                Text(_errorText.first,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).colorScheme.error,
                    )),
              SizedBox(height: Dimensions.paddingSizeDefault),
              widget.formSplash
                  ? CustomButton(
                      height: 40,
                      width: 200,
                      buttonText: 'login'.tr,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          http.Response response = await http.post(
                            Uri.parse(AppConstants.baseUrl +
                                AppConstants.branchLogInUri),
                            body: {
                              "email": email.text,
                              //"cs@d2home.com.au",
                              "password": password.text
                              //"12345678"
                            },
                            // headers: headers ?? _mainHeaders,
                          ).timeout(const Duration(seconds: 30));

                          Map data = await jsonDecode(response.body);
                          print(data["success"].toString());
                          print(data);
                          if (data.containsKey("success")) {
                            setState(() {
                              isPasswordValid = true;
                            });
                            _formKey.currentState!.validate();
                            splashController.configModel?.branch
                                ?.forEach((Branch value) async {
                              if (data["data"]["name"] == value.name) {
                                sharedPreferences.setString(
                                    "branchName", value.name.toString());
                                splashController.updateBranchId(value.id);
                              }
                            });
                          } else {
                            setState(() {
                              isPasswordValid = false;
                            });
                            _formKey.currentState!.validate();
                            setState(() {
                              isPasswordValid = true;
                            });
                          }

                          // Form is valid, perform login or further actions
                        }

                        if (splashController.selectedTableId == null &&
                            splashController.isFixTable) {
                          _errorText = [];
                          // _errorText.add('set_your_table_number'.tr);
                          splashController.update();
                        } else if (splashController.selectedBranchId == null) {
                          _errorText = [];
                          // _errorText.add('please_select_your_branch'.tr);
                          splashController.update();
                        } else {
                          if (splashController.isFixTable) {
                            splashController.setFixTable(true);
                            splashController
                                .setTableId(splashController.selectedTableId!);
                          } else {
                            splashController.setFixTable(false);
                            splashController.setTableId(-1);
                          }
                          splashController
                              .setBranch(splashController.selectedBranchId!);

                          if (widget.formSplash) {
                            if (ResponsiveHelper.isTab(context) &&
                                (Get.find<PromotionalController>()
                                    .getPromotion('', all: true)
                                    .isNotEmpty)) {
                              Get.offAll(() => const PromotionalPageScreen());
                            } else {
                              Get.offAllNamed(RouteHelper.home);
                            }
                          } else {
                            Get.find<ProductController>()
                                .getProductList(true, true);
                            Get.find<PromotionalController>().update();
                            Get.back();
                          }
                        }
                      },
                    )
                  : Container(),
              if (!widget.formSplash)
                CustomButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.clear();
                      Get.offAll(const SplashScreen());
                    },
                    height: 40,
                    width: 200,
                    buttonText: "logout".tr)
            ],
          ),
        );
      }),
    );
  }
}
