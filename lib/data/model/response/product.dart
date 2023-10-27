import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.variations,
    this.addOns,
    this.tax,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.attributes,
    this.categoryIds,
    this.choiceOptions,
    this.discount,
    this.discountType,
    this.taxType,
    this.setMenu,
    this.popularityCount,
    this.rating,
    this.productType,
    this.branchProduct,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? image;
  @HiveField(4)
  double? price;
  @HiveField(5)
  List<Variation>? variations;
  @HiveField(6)
  List<AddOn>? addOns;
  @HiveField(7)
  double? tax;
  @HiveField(8)
  String? availableTimeStarts;
  @HiveField(9)
  String? availableTimeEnds;
  @HiveField(10)
  int? status;
  @HiveField(11)
  DateTime? createdAt;
  @HiveField(12)
  DateTime? updatedAt;
  @HiveField(13)
  List<String>? attributes;
  @HiveField(14)
  List<CategoryId>? categoryIds;
  @HiveField(15)
  List<ChoiceOption>? choiceOptions;
  @HiveField(16)
  double? discount;
  @HiveField(17)
  String? discountType;
  @HiveField(18)
  String? taxType;
  @HiveField(19)
  int? setMenu;
  @HiveField(20)
  int? popularityCount;
  @HiveField(21)
  List<Rating>? rating;
  @HiveField(22)
  String? productType;
  @HiveField(23)
  BranchProduct? branchProduct;

  // factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"] ?? '',
        image: json["image"],
        price: double.parse('${json["price"]}'),
        variations: json["variations"] != null &&
                json["variations"].length > 0 &&
                !json["variations"][0].containsKey('price')
            ? List<Variation>.from(
                json["variations"].map((x) => Variation.fromJson(x)))
            : [
                // Variation(
                //     name: "Take food home",
                //     max: 1,
                //     min: 1,
                //     isRequired: true,
                //     isMultiSelect: false,
                //     variationValues: [
                //       VariationValue(level: "yes", optionPrice: 0),
                //       VariationValue(level: "no", optionPrice: 0)
                //     ])
              ],
        addOns: List<AddOn>.from(json["add_ons"].map((x) => AddOn.fromJson(x))),
        tax: json["tax"].toDouble(),
        availableTimeStarts: json["available_time_starts"],
        availableTimeEnds: json["available_time_ends"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        attributes: List<String>.from(json["attributes"].map((x) => x)),
        categoryIds: List<CategoryId>.from(
            json["category_ids"].map((x) => CategoryId.fromJson(x))),
        choiceOptions: List<ChoiceOption>.from(
            json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
        discount: double.parse('${json["discount"]}'),
        discountType: json["discount_type"],
        taxType: json["tax_type"],
        setMenu: json["set_menu"],
        popularityCount: int.tryParse('${json["popularity_count"]}'),
        rating:
            List<Rating>.from(json["rating"].map((x) => Rating.fromJson(x))),
        productType: json["product_type"],
        branchProduct: json['branch_product'] != null
            ? BranchProduct.fromJson(json['branch_product'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "variations": List<dynamic>.from(variations!.map((x) => x.toJson())),
        "add_ons": List<dynamic>.from(addOns!.map((x) => x.toJson())),
        "tax": tax,
        "available_time_starts": availableTimeStarts,
        "available_time_ends": availableTimeEnds,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "attributes": List<dynamic>.from(attributes!.map((x) => x)),
        "category_ids": List<dynamic>.from(categoryIds!.map((x) => x.toJson())),
        "choice_options":
            List<dynamic>.from(choiceOptions!.map((x) => x.toJson())),
        "discount": discount,
        "discount_type": discountType,
        "tax_type": taxType,
        "set_menu": setMenu,
        "popularity_count": popularityCount,
        "rating": rating != null
            ? List<dynamic>.from(rating!.map((x) => x.toJson()))
            : null,
        "product_type": productType,
      };
}
