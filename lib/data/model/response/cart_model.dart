import 'package:efood_table_booking/data/model/response/product_model.dart';

class CartModel {
  String? note;
  double? price;
  double? discountedPrice;
  List<Variation>? variation;
  double? discountAmount;
  int? quantity;
  double? taxAmount;
  List<AddOn>? addOnIds;
  Product? product;
  List<List<bool>>? variations;

  CartModel({
    this.note,
    this.price,
    this.discountedPrice,
    this.variation,
    this.discountAmount,
    this.quantity,
    this.taxAmount,
    this.addOnIds,
    this.product,
    this.variations,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation?.add(Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((v) {
        addOnIds?.add(AddOn.fromJson(v));
      });
    }
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);
    }
    if (json['variations'] != null) {
      variations = [];
      for (int index = 0; index < json['variations'].length; index++) {
        variations?.add([]);
        for (int i = 0; i < json['variations'][index].length; i++) {
          variations?[index].add(json['variations'][index][i]);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    if (variation != null) {
      data['variation'] = variation?.map((v) => v.toJson()).toList();
    }

    data['discount_amount'] = discountAmount;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    if (addOnIds != null) {
      data['add_on_ids'] = addOnIds?.map((v) => v.toJson()).toList();
    }
    data['variations'] = variations;
    data['product'] = product?.toJson();
    return data;
  }
}
