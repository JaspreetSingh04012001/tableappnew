import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/config_model.dart';
import 'package:get/get.dart';
class PriceConverter {
  static String convertPrice(double price, {double? discount, String? discountType}) {
    ConfigModel? configModel = Get.find<SplashController>().configModel;
    if(discount != null && discountType != null){
      if(discountType == 'amount') {
        price = price - discount;
      }else if(discountType == 'percent') {
        price = price - ((discount / 100) * price);
      }
    }

    return configModel?.currencySymbolPosition == 'left'
        ? '${configModel?.currencySymbol}' '${(price).toStringAsFixed(configModel?.decimalPointSettings ?? 2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',
    )}'
        : '${(price).toStringAsFixed(configModel?.decimalPointSettings ?? 2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},',
    )}' ' ${configModel?.currencySymbol}';
  }

  static double convertWithDiscount(double price, double discount, String discountType) {
    if(discountType == 'amount') {
      price = price - discount;
    }else if(discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }

  static double calculation(double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if(type == 'amount') {
      calculatedAmount = discount * quantity;
    }else if(type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(String price, String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : '\$'} OFF';
  }
}