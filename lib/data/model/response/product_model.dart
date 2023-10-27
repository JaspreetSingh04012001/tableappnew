// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:efood_table_booking/data/model/response/product.dart';
import 'package:hive/hive.dart';
  part 'product_model.g.dart';
class ProductModel {
  ProductModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.products,
  });

  int? totalSize;
  String? limit;
  String? offset;

  List<Product>? products;

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 2)
class AddOn extends HiveObject {
  AddOn({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.tax,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  double? price;
  @HiveField(3)
  int? quantity;
  @HiveField(4)
  double? tax;

  factory AddOn.fromRawJson(String str) => AddOn.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json["id"],
      name: json["name"],
      price: double.tryParse('${json["price"]}'),
      tax: double.tryParse('${json["tax"]}'),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "tax": tax,
      };
}

@HiveType(typeId: 3)
class CategoryId extends HiveObject {
  CategoryId({
    this.id,
    this.position,
  });

  @HiveField(0)
  String? id;
  @HiveField(1)
  int? position;

  factory CategoryId.fromRawJson(String str) =>
      CategoryId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["id"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
      };
}

@HiveType(typeId: 4)
class ChoiceOption extends HiveObject {
  ChoiceOption({
    this.name,
    this.title,
    this.options,
  });
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? title;
  @HiveField(2)
  List<String>? options;

  factory ChoiceOption.fromRawJson(String str) =>
      ChoiceOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        name: json["name"],
        title: json["title"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "options":
            options != null ? List<dynamic>.from(options!.map((x) => x)) : null,
      };
}

class Rating {
  Rating({
    this.average,
    this.productId,
  });

  double? average;
  int? productId;

  factory Rating.fromRawJson(String str) => Rating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        average: double.tryParse('${json["average"]}'),
        productId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "product_id": productId,
      };
}

@HiveType(typeId: 1)
class Variation extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  int? min;
  @HiveField(2)
  int? max;
  @HiveField(3)
  bool? isRequired;
  @HiveField(4)
  bool? isMultiSelect;
  @HiveField(5)
  List<VariationValue>? variationValues;

  Variation({
    this.name,
    this.min,
    this.max,
    this.isRequired,
    this.variationValues,
    this.isMultiSelect,
  });

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isMultiSelect = '${json['type']}' == 'multi';
    min = isMultiSelect! ? int.parse(json['min'].toString()) : 0;
    max = isMultiSelect! ? int.parse(json['max'].toString()) : 0;
    isRequired = '${json['required']}' == 'on';
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues?.add(VariationValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = isMultiSelect! ? 'multi' : 'single';
    data['min'] = min;
    data['max'] = max;
    data['required'] = isRequired! ? 'on' : 'off';
    if (variationValues != null) {
      data['values'] = variationValues?.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

@HiveType(typeId: 5)
class VariationValue extends HiveObject {
  @HiveField(0)
  String? level;
  @HiveField(1)
  double? optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = double.parse(json['optionPrice'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = level;
    data['optionPrice'] = optionPrice;
    return data;
  }
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

@HiveType(typeId: 6)
class BranchProduct extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? productId;
  @HiveField(2)
  int? branchId;
  @HiveField(3)
  bool? isAvailable;
  @HiveField(4)
  List<Variation>? variations;
  @HiveField(5)
  double? price;
  @HiveField(6)
  double? discount;
  @HiveField(7)
  String? discountType;

  BranchProduct({
    this.id,
    this.productId,
    this.branchId,
    this.isAvailable,
    this.variations,
    this.price,
    this.discountType,
    this.discount,
  });

  BranchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = int.tryParse('${json['product_id']}');
    branchId = int.tryParse('${json['branch_id']}');
    isAvailable = '${json['is_available']}' == '1';
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        if (!v.containsKey('price')) {
          variations?.add(Variation.fromJson(v));
        }
      });
    }
    discount = double.tryParse('${json['discount']}');
    price = double.tryParse('${json['price']}');
    discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['branch_id'] = branchId;
    data['is_available'] = isAvailable;
    data['variations'] = variations;
    return data;
  }
}
