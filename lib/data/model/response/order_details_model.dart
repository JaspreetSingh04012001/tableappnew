import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:get/get.dart';

class OrderDetails {
  Order? order;
  List<Details>? details;

  OrderDetails({this.order, this.details});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        //print(" jass ${v["print_type"]}");
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? id;
  double? orderAmount;
  int? couponDiscountAmount;
  String? couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  int? totalTaxAmount;
  String? paymentMethod;
  String? cash;
  String? card;
  String? createdAt;
  String? updatedAt;
  int? checked;
  String? orderNote;
  String? couponCode;
  String? orderType;
  int? branchId;
  String? deliveryDate;
  String? deliveryTime;
  String? extraDiscount;
  int? preparationTime;
  int? tableId;
  int? numberOfPeople;
  String? customer_name;
  String? customer_email;
  int? tableOrderId;

  Order(
      {this.id,
      this.orderAmount,
      this.couponDiscountAmount,
      this.couponDiscountTitle,
      this.paymentStatus,
      this.orderStatus,
      this.totalTaxAmount,
      this.paymentMethod,
      this.cash,
      this.card,
      this.createdAt,
      this.updatedAt,
      this.checked,
      this.orderNote,
      this.couponCode,
      this.orderType,
      this.branchId,
      this.deliveryDate,
      this.deliveryTime,
      this.extraDiscount,
      this.preparationTime,
      this.tableId,
      this.numberOfPeople,
      this.customer_name,
      this.customer_email,
      this.tableOrderId});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderAmount = double.parse('${json['order_amount']}');
    couponDiscountAmount = json['coupon_discount_amount'];
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = int.tryParse('${json['total_tax_amount']}');
    paymentMethod = json['payment_method'];

    cash = json['cash'];
    card = json['card'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    checked = int.tryParse('${json['checked']}');
    orderNote = json['order_note'];
    couponCode = json['coupon_code'];
    orderType = json['order_type'];
    branchId = int.tryParse('${json['branch_id']}');
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    extraDiscount = json['extra_discount'];
    preparationTime = int.tryParse('${json['preparation_time']}');
    tableId = int.tryParse('${json['table_id']}');
    numberOfPeople = int.tryParse('${json['number_of_people']}');
    customer_name = json['customer_name'];
    customer_email = json['customer_email'];
    tableOrderId = int.tryParse('${json['table_order_id']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['payment_method'] = paymentMethod;
    if (data['payment_method'] == 'split') {
      data['card'] = card;
      data['cash'] = cash;
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['checked'] = checked;
    data['order_note'] = orderNote;
    data['coupon_code'] = couponCode;
    data['order_type'] = orderType;
    data['branch_id'] = branchId;
    data['delivery_date'] = deliveryDate;
    data['delivery_time'] = deliveryTime;
    data['extra_discount'] = extraDiscount;
    data['preparation_time'] = preparationTime;
    data['table_id'] = tableId;
    data['number_of_people'] = numberOfPeople;
    data['customer_name'] = customer_name;
    data['customer_email'] = customer_email;
    data['table_order_id'] = tableOrderId;
    return data;
  }
}

class Details {
  String? note;

  int? id;
  int? productId;
  int? orderId;
  double? price;
  ProductDetails? productDetails;
  List<Variation>? variations;
  List<OldVariation>? oldVariations;
  double? discountOnProduct;
  String? discountType;
  int? quantity;
  double? taxAmount;
  String? createdAt;
  String? updatedAt;
  List<int>? addOnIds;
  List<int>? addOnQtys;
  List<double>? addOnPrices;
  double? addonTaxAmount;

  Details(
      {this.id,
      this.productId,
      this.orderId,
      this.price,
      this.productDetails,
      this.variations,
      this.oldVariations,
      this.discountOnProduct,
      this.discountType,
      this.quantity,
      this.taxAmount,
      this.createdAt,
      this.updatedAt,
      this.addOnIds,
      this.addOnQtys,
      this.addOnPrices,
      this.addonTaxAmount,
      this.note});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    productId = json['product_id'];
    orderId = json['order_id'];
    if (json['price'] != null && json['price'] != 'null') {
      price = double.parse('${json['price']}');
    }
    if (json['note'] != null && json['note'] != 'null') {
      note = json['note'];
    }
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
    if (json['variation'] != null && json['variation'].isNotEmpty) {
      if (json['variation'][0]['values'] != null) {
        variations = [];
        json['variation'].forEach((v) {
          variations?.add(Variation.fromJson(v));
        });
      } else {
        oldVariations = [];
        json['variation'].forEach((v) {
          oldVariations?.add(OldVariation.fromJson(v));
        });
      }
    }
    discountOnProduct = double.parse('${json['discount_on_product']}');
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = double.parse('${json['tax_amount']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((id) {
        try {
          addOnIds!.add(int.parse(id));
        } catch (e) {
          addOnIds!.add(id);
        }
      });
    }

    if (json['add_on_qtys'] != null) {
      addOnQtys = [];
      json['add_on_qtys'].forEach((qun) {
        try {
          addOnQtys!.add(int.parse(qun));
        } catch (e) {
          addOnQtys!.add(qun);
        }
      });
    }

    if (json['add_on_prices'] != null) {
      addOnPrices = [];
      json['add_on_prices'].forEach((qun) {
        try {
          addOnPrices?.add(double.parse('$qun'));
        } catch (e) {
          addOnPrices?.add(qun);
        }
      });
    }
    addonTaxAmount = double.tryParse('${json['add_on_tax_amount']}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['price'] = price;
    data['note'] = note;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    data['variation'] = variations;
    data['discount_on_product'] = discountOnProduct;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['add_on_ids'] = addOnIds;
    data['add_on_qtys'] = addOnQtys;
    data['add_on_tax_amount'] = addonTaxAmount;
    return data;
  }
}

class ProductDetails {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;

  List<AddOns>? addOns;
  num? tax;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<String>? attributes;
  List<CategoryIds>? categoryIds;
  List<ChoiceOptions>? choiceOptions;
  int? discount;
  String? discountType;
  String? taxType;
  int? setMenu;
  int? branchId;
  int? popularityCount;
  String? productType;
  String? printType;
  ProductDetails({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
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
    this.branchId,
    this.popularityCount,
    this.productType,
  });

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    printType = json['print_type'];
    description = json['description'];
    image = json['image'];
    if (json['price'] != null && json['price'] != 'null') {
      price = double.parse('${json['price']}');
    }

    if (json['add_ons'] != null) {
      addOns = <AddOns>[];
      json['add_ons'].forEach((v) {
        addOns!.add(AddOns.fromJson(v));
      });
    }
    tax = json['tax'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      choiceOptions = <ChoiceOptions>[];
      json['choice_options'].forEach((v) {
        choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    discount = json['discount'];
    discountType = json['discount_type'];
    taxType = json['tax_type'];
    setMenu = json['set_menu'];
    branchId = int.parse(json['branch_id']);
    popularityCount = json['popularity_count'];
    productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    if (addOns != null) {
      data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
    }
    data['tax'] = tax;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['attributes'] = attributes;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (choiceOptions != null) {
      data['choice_options'] = choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['tax_type'] = taxType;
    data['set_menu'] = setMenu;
    data['branch_id'] = branchId;
    data['popularity_count'] = popularityCount;
    data['product_type'] = productType;
    return data;
  }
}

class AddOns {
  int? id;
  String? name;
  double? price;
  String? createdAt;
  String? updatedAt;

  AddOns({
    this.id,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    price = double.parse('${json['price']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CategoryIds {
  String? id;
  int? position;

  CategoryIds({this.id, this.position});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['position'] = position;
    return data;
  }
}

class ChoiceOptions {
  String? name;
  String? title;
  List<String>? options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['options'] = options;
    return data;
  }
}

class OrderList {
  List<Order>? order;

  OrderList({this.order});

  OrderList.fromJson(Map<String, dynamic> json) {
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.addIf(
            (Order.fromJson(v).orderStatus != 'canceled'), Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OldVariation {
  String? type;
  double? price;

  OldVariation({this.type, this.price});

  OldVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}
