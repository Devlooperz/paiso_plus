import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:paiso_plus/core/database/customer/customer_db.dart';
import 'package:paiso_plus/core/database/payment/payment_db.dart';
import 'package:paiso_plus/core/database/products/product_db.dart';
import 'package:paiso_plus/core/database/transaction/transaction_db.dart';
import 'package:path/path.dart' as p;

part 'my_database.g.dart';

@DriftDatabase(
    tables: [Products, Customers, Transactions, Payments],
    daos: [ProductsDao, CustomersDao, TransactionsDao, PaymentsDao])
class MyDatabase extends _$MyDatabase {
  static MyDatabase? db;

  MyDatabase._() : super(_openConnection());

  factory MyDatabase() {
    db ??= MyDatabase._();
    return db!;
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File(p.join('./database/', 'plus.db'));
    return NativeDatabase(
      file,
      logStatements: true,
    );
  });
}
