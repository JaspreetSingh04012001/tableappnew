

class OrderSuccessModel {
  String? orderId;
  String? branchTableToken;
  double? changeAmount;
  String? tableId;
  String? branchId;

  OrderSuccessModel({this.orderId, this.branchTableToken, this.changeAmount, this.tableId, this.branchId});

  OrderSuccessModel.fromJson(Map<String, dynamic> json) {
    orderId = '${json['order_id']}';
    branchTableToken = json['branch_table_token'];
    // paidAmount = json['paid_amount'];
    changeAmount = json['change_amount'];
    tableId = json['table_id'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['branch_table_token'] = branchTableToken;
    // data['paid_amount'] = this.paidAmount ?? 0.0;
    data['change_amount'] = changeAmount ?? 0.0;
    data['table_id'] = tableId ?? -1;
    data['branch_id'] = branchId ?? -1;
    return data;
  }
}

class OrderSuccessModelList{
  List<OrderSuccessModel>? orderList;

  OrderSuccessModelList({this.orderList});

  OrderSuccessModelList.fromJson(Map<String, dynamic> json) {
    if (json['order_list'] != null) {
      orderList = <OrderSuccessModel>[];
      json['order_list'].forEach((v) {
        orderList!.add(OrderSuccessModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderList != null) {
      data['order_list'] = orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
