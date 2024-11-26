

class ModelHistory{
  var id;
  String remark;
  String date;
  String time;
  String type;
  String finalAmount;
  List<ModelPrice> itemList;

  ModelHistory({this.id, required this.finalAmount, required this.type, required this.remark, required this.date, required this.time, required this.itemList});

}

class ModelPrice{
  num price;
  num amount;
  int qty;

  ModelPrice({required this.price, required this.qty, required this.amount});

  Map<String, dynamic> toJson() => {
    'price': price,
    'amount': amount,
    'qty': qty,
  };

  factory ModelPrice.fromJson(Map<String, dynamic> json) {
    return ModelPrice(
      price: json['price'],
      amount: json['amount'],
      qty: json['qty'],
    );
  }
}