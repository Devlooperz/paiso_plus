import 'package:nepali_date_picker/nepali_date_picker.dart';

import 'package:paiso_plus/core/database/my_database.dart';

class TransactionModel {
  final int id;
  Product product;
  double rate;
  int quantity;
  NepaliDateTime nepaliDateTime;
  TransactionModel({
    required this.id,
    required this.product,
    required this.rate,
    required this.quantity,
    required this.nepaliDateTime,
  });

  TransactionModel copyWith({
    int? id,
    Product? product,
    double? rate,
    int? quantity,
    NepaliDateTime? nepaliDateTime,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      product: product ?? this.product,
      rate: rate ?? this.rate,
      quantity: quantity ?? this.quantity,
      nepaliDateTime: nepaliDateTime ?? this.nepaliDateTime,
    );
  }

  factory TransactionModel.fromDatabase(Map<String, dynamic> data) {
    return TransactionModel(
        id: data["id"],
        product:
            Product(id: data["product_id"], name: data["name"], quanity: 0),
        rate: data['amount'],
        quantity: data["quntity"],
        nepaliDateTime:
            DateTime.fromMillisecondsSinceEpoch(data["transactiondate"] * 1000)
                .toNepaliDateTime());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionModel &&
        other.id == id &&
        other.product == product &&
        other.rate == rate &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^ product.hashCode ^ rate.hashCode ^ quantity.hashCode;
  }
}
