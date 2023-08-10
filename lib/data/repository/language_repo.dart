import 'package:efood_table_booking/data/model/response/language_model.dart';
import 'package:efood_table_booking/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({required BuildContext context}) {
    return AppConstants.languages;
  }
}
