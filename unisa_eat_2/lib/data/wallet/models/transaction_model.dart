class TransactionModel {
  double? amount;
  String? createdAt;
  int? id;
  String? paymentMethod;
  String? type;
  int? userId;

  TransactionModel(
      {this.amount,
      this.createdAt,
      this.id,
      this.paymentMethod,
      this.type,
      this.userId});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    createdAt = json['created_at'];
    id = json['id'];
    paymentMethod = json['payment_method'];
    type = json['type'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['payment_method'] = this.paymentMethod;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    return data;
  }
}