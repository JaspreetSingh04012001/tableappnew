class PlaceOrderBody {
  final List<Cart>? _cart;
  double? _orderAmount;

  List<Cart>? get cart => _cart;
  String? _paymentMethod;
  String? _card;
  String? _cash;

  final String? _orderNote;
  final String? _deliveryTime;
  final String? _deliveryDate;
  final String? _branchId;
  final int? _tableNumber;
  final int? _peopleNumber;
  final String? _customerName;
  final String? _customerEmail;
  String? _paymentStatus;
  String? _branchTableToken;

  PlaceOrderBody(
    this._cart,
    this._orderAmount,
    this._paymentMethod,
    // this._card,
    // this._cash,
    this._orderNote,
    this._deliveryTime,
    this._deliveryDate,
    this._tableNumber,
    this._peopleNumber,
    this._customerName,
    this._customerEmail,
    this._branchId,
    this._paymentStatus,
    this._branchTableToken,
  );

  PlaceOrderBody copyWith(
      {String? paymentStatus,
      String? paymentMethod,
      String? card,
      String? cash,
      String? token,
      double? previousDue}) {
    if (paymentStatus != null) {
      _paymentStatus = paymentStatus;
    }
    if (paymentMethod != null) {
      _paymentMethod = paymentMethod;

      _card = card;
      _cash = cash;
    }
    if (token != null) {
      _branchTableToken = token;
    }
    if (previousDue != null) {
      _orderAmount = _orderAmount!;
    }
    return this;
  }

  // PlaceOrderBody.fromJson(Map<String, dynamic> json) {
  //   if (json['cart'] != null) {
  //     _cart = [];
  //     json['cart'].forEach((v) {
  //       _cart?.add(Cart.fromJson(v));
  //     });
  //   }
  //   _orderAmount = json['order_amount'];
  //   _paymentMethod = json['payment_method'];

  //   _cash = json['cash'];
  //   _card = json['card'];

  //   _orderNote = json['order_note'];
  //   _deliveryTime = json['delivery_time'];
  //   _deliveryDate = json['delivery_date'];
  //   _tableNumber = int.tryParse('${json['table_id']}');
  //   _peopleNumber = int.tryParse('${json['number_of_people']}');
  //   _branchId = json['branch_id'];
  //   _paymentStatus = json['payment_status'];
  //   _branchTableToken = json['branch_table_token'];
  //   _customerName = json['customer_name'];
  //   _customerEmail = json['customer_email'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_cart != null) {
      data['cart'] = _cart?.map((v) => v.toJson()).toList();
    }

    data['order_amount'] = _orderAmount;
    data['payment_method'] = _paymentMethod;

    data['card'] = _card;
    data['cash'] = _cash;

    data['order_note'] = _orderNote;
    data['delivery_time'] = _deliveryTime;
    data['delivery_date'] = _deliveryDate;
    data['table_id'] = _tableNumber;
    data['number_of_people'] = _peopleNumber;
    data['branch_id'] = _branchId;
    data['payment_status'] = _paymentStatus;
    data['branch_table_token'] = _branchTableToken;
    data['customer_name'] = _customerName;
    data['customer_email'] = _customerEmail;

    return data;
  }

  double? get orderAmount => _orderAmount;

  String? get paymentMethod => _paymentMethod;

  String? get orderNote => _orderNote;
  String? get deliveryTime => _deliveryTime;
  String? get deliveryDate => _deliveryDate;
  int? get tableNumber => _tableNumber;
  int? get peopleNumber => _peopleNumber;
  String? get customerName => _customerName;
  String? get paymentStatus => _paymentStatus;
  String? get cash => _cash;
  String? get card => _card;
  String? get branchTableToken => _branchTableToken;
}

class Cart {
  String? _productId;
  String? _price;
  String? _note;
  String? _variant;
  List<OrderVariation>? _variation;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  List<int>? _addOnIds;
  List<int>? _addOnQtys;

  Cart(
      String productId,
      String price,
      String variant,
      List<OrderVariation> variation,
      double discountAmount,
      int quantity,
      double taxAmount,
      List<int> addOnIds,
      List<int> addOnQtys,
      String? note) {
    _productId = productId;
    _price = price;
    _variant = variant;
    _variation = variation;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _addOnIds = addOnIds;
    _addOnQtys = addOnQtys;
    _note = note;
  }

  String? get productId => _productId;
  String? get price => _price;
  String? get note => _note;
  String? get variant => _variant;
  List<OrderVariation>? get variation => _variation;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  List<int>? get addOnIds => _addOnIds;
  List<int>? get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'];
    _note = json['note'];
    _variant = json['variant'];
    if (json['variations'] != null) {
      _variation = [];
      json['variations'].forEach((v) {
        _variation?.add(OrderVariation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = _productId;
    data['price'] = _price;
    data['note'] = _note;
    data['variant'] = _variant;
    if (_variation != null) {
      data['variations'] = _variation?.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['add_on_ids'] = _addOnIds;
    data['add_on_qtys'] = _addOnQtys;
    return data;
  }
}

class OrderVariation {
  String? name;
  OrderVariationValue? values;

  OrderVariation({this.name, this.values});

  OrderVariation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    values = json['values'] != null
        ? OrderVariationValue.fromJson(json['values'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (values != null) {
      data['values'] = values?.toJson();
    }
    return data;
  }
}

class OrderVariationValue {
  List<String>? label;

  OrderVariationValue({this.label});

  OrderVariationValue.fromJson(Map<String, dynamic> json) {
    label = json['label'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    return data;
  }
}
