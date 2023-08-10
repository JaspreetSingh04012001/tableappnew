class ConfigModel {
  String? currencySymbol;
  String? timeFormat;
  int? decimalPointSettings;
  bool? maintenanceMode;
  String? currencySymbolPosition;
  String? restaurantLogo;
  BaseUrls? baseUrls;
  List<Branch>? branch;
  List<PromotionCampaign>? promotionCampaign;
  bool? isVegNonVegActive;

  ConfigModel({
    this.currencySymbol,
    this.timeFormat,
    this.decimalPointSettings,
    this.maintenanceMode,
    this.currencySymbolPosition,
    this.baseUrls,
    this.branch,
    this.promotionCampaign,
    this.restaurantLogo,
  });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    currencySymbol = json['currency_symbol'];
    timeFormat = json['time_format'];
    decimalPointSettings = json['decimal_point_settings'];
    maintenanceMode = json['maintenance_mode'];
    currencySymbolPosition = json['currency_symbol_position'];
    baseUrls =
        json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null;
    if (json['branch'] != null) {
      branch = <Branch>[];
      json['branch'].forEach((v) {
        branch!.add(Branch.fromJson(v));
      });
    }
    if (json['promotion_campaign'] != null) {
      promotionCampaign = <PromotionCampaign>[];
      json['promotion_campaign'].forEach((v) {
        promotionCampaign!.add(PromotionCampaign.fromJson(v));
      });
    }
    restaurantLogo = json['restaurant_logo'];
    isVegNonVegActive = '${json['is_veg_non_veg_active']}'.contains('1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency_symbol'] = currencySymbol;
    data['time_format'] = timeFormat;
    data['decimal_point_settings'] = decimalPointSettings;
    data['maintenance_mode'] = maintenanceMode;
    data['currency_symbol_position'] = currencySymbolPosition;
    if (baseUrls != null) {
      data['base_urls'] = baseUrls!.toJson();
    }
    if (branch != null) {
      data['branch'] = branch!.map((v) => v.toJson()).toList();
    }
    if (promotionCampaign != null) {
      data['promotion_campaign'] =
          promotionCampaign!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BaseUrls {
  String? productImageUrl;
  String? customerImageUrl;
  String? bannerImageUrl;
  String? categoryImageUrl;
  String? categoryBannerImageUrl;
  String? reviewImageUrl;
  String? notificationImageUrl;
  String? restaurantImageUrl;
  String? deliveryManImageUrl;
  String? chatImageUrl;
  String? promotionalUrl;

  BaseUrls(
      {this.productImageUrl,
      this.customerImageUrl,
      this.bannerImageUrl,
      this.categoryImageUrl,
      this.categoryBannerImageUrl,
      this.reviewImageUrl,
      this.notificationImageUrl,
      this.restaurantImageUrl,
      this.deliveryManImageUrl,
      this.chatImageUrl,
      this.promotionalUrl});

  BaseUrls.fromJson(Map<String, dynamic> json) {
    productImageUrl = json['product_image_url'];
    customerImageUrl = json['customer_image_url'];
    bannerImageUrl = json['banner_image_url'];
    categoryImageUrl = json['category_image_url'];
    categoryBannerImageUrl = json['category_banner_image_url'];
    reviewImageUrl = json['review_image_url'];
    notificationImageUrl = json['notification_image_url'];
    restaurantImageUrl = json['restaurant_image_url'];
    deliveryManImageUrl = json['delivery_man_image_url'];
    chatImageUrl = json['chat_image_url'];
    promotionalUrl = json['promotional_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = productImageUrl;
    data['customer_image_url'] = customerImageUrl;
    data['banner_image_url'] = bannerImageUrl;
    data['category_image_url'] = categoryImageUrl;
    data['category_banner_image_url'] = categoryBannerImageUrl;
    data['review_image_url'] = reviewImageUrl;
    data['notification_image_url'] = notificationImageUrl;
    data['restaurant_image_url'] = restaurantImageUrl;
    data['delivery_man_image_url'] = deliveryManImageUrl;
    data['chat_image_url'] = chatImageUrl;
    data['promotional_url'] = promotionalUrl;
    return data;
  }
}

class Branch {
  int? id;
  String? name;
  String? email;
  String? password;
  String? latitude;
  String? longitude;
  String? address;
  int? status;
  int? branchPromotionStatus;
  String? createdAt;
  String? updatedAt;
  int? coverage;
  String? image;
  List<TableModel>? table;

  Branch(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.latitude,
      this.longitude,
      this.address,
      this.status,
      this.branchPromotionStatus,
      this.createdAt,
      this.updatedAt,
      this.coverage,
      this.image,
      this.table});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    status = int.tryParse('${json['status']}');
    branchPromotionStatus = int.tryParse('${json['branch_promotion_status']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverage = json['coverage'];
    image = json['image'];
    if (json['table'] != null) {
      table = [];

      json['table'].forEach((v) {
        table!.add(TableModel.fromJson(v));
      });
      if (table!.isEmpty) {
        table?.add(TableModel(id: -1));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['status'] = status;
    data['branch_promotion_status'] = branchPromotionStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['coverage'] = coverage;
    data['image'] = image;
    if (table != null) {
      data['table'] = table!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableModel {
  int? id;
  int? number;
  int? capacity;
  int? branchId;
  int? isActive;
  int? isAvailable;
  String? createdAt;
  String? updatedAt;

  TableModel(
      {this.id,
      this.number,
      this.capacity,
      this.branchId,
      this.isActive,
      this.isAvailable,
      this.createdAt,
      this.updatedAt});

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = int.parse(json['number']);
    capacity = int.parse(json['capacity']);
    branchId = int.parse(json['branch_id']);
    isActive = int.parse(json['is_active']);
    isAvailable = json['is_available'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['capacity'] = capacity;
    data['branch_id'] = branchId;
    data['is_active'] = isActive;
    data['is_available'] = isAvailable;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PromotionCampaign {
  int? id;
  int? restaurantId;
  String? name;
  String? email;
  String? password;
  String? latitude;
  String? longitude;
  String? address;
  int? status;
  int? branchPromotionStatus;
  String? createdAt;
  String? updatedAt;
  int? coverage;
  String? image;
  List<BranchPromotion>? branchPromotion;

  PromotionCampaign(
      {this.id,
      this.restaurantId,
      this.name,
      this.email,
      this.password,
      this.latitude,
      this.longitude,
      this.address,
      this.status,
      this.branchPromotionStatus,
      this.createdAt,
      this.updatedAt,
      this.coverage,
      this.image,
      this.branchPromotion});

  PromotionCampaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    restaurantId = json['restaurant_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    status = int.tryParse('${json['status']}');
    branchPromotionStatus = int.tryParse('${json['branch_promotion_status']}');
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverage = int.tryParse('${json['coverage']}');
    image = json['image'];
    if (json['branch_promotion'] != null) {
      branchPromotion = <BranchPromotion>[];
      json['branch_promotion'].forEach((v) {
        branchPromotion!.add(BranchPromotion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['status'] = status;
    data['branch_promotion_status'] = branchPromotionStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['coverage'] = coverage;
    data['image'] = image;
    if (branchPromotion != null) {
      data['branch_promotion'] =
          branchPromotion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BranchPromotion {
  int? id;
  int? branchId;
  String? promotionType;
  String? promotionName;
  String? createdAt;
  String? updatedAt;

  BranchPromotion(
      {this.id,
      this.branchId,
      this.promotionType,
      this.promotionName,
      this.createdAt,
      this.updatedAt});

  BranchPromotion.fromJson(Map<String, dynamic> json) {
    id = int.tryParse('${json['id']}');
    branchId = int.tryParse('${json['branch_id']}');
    promotionType = json['promotion_type'];
    promotionName = json['promotion_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['branch_id'] = branchId;
    data['promotion_type'] = promotionType;
    data['promotion_name'] = promotionName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
