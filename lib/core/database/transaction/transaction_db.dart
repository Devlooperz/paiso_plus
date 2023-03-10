import 'package:drift/drift.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:paiso_plus/core/database/customer/customer_db.dart';
import 'package:paiso_plus/core/database/my_database.dart';
import 'package:paiso_plus/core/database/products/product_db.dart';
import 'package:paiso_plus/features/transaction/model/transaction_model.dart';

part 'transaction_db.g.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get quntity => integer()();
  RealColumn get amount => real()();
  IntColumn get product => integer().references(Products, #id)();
  IntColumn get customer => integer().references(Customers, #id)();
  DateTimeColumn get transactiondate =>
      dateTime().withDefault(Constant(DateTime.now()))();
}

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<MyDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(MyDatabase db) : super(db);

  Future<void> addTransaction(TransactionsCompanion transaction) async {
    await into(transactions).insert(transaction);
  }

  Future<List<TransactionModel>> getAllTransaction() async {
    final query = await customSelect(
            '''SELECT transactions.id,transactions.amount,transactions.quntity,products.name,products.id as product_id,transactions.transactiondate from transactions 
inner join products on transactions.product = products.id''')
        .get();
    final transactionData = query
        .map((e) => TransactionModel(
            id: e.data["id"],
            product: Product(
                id: e.data["product_id"], name: e.data['name'], quanity: 0),
            rate: e.data['amount'],
            quantity: e.data['quntity'],
            nepaliDateTime: DateTime.fromMillisecondsSinceEpoch(
                    e.data['transactiondate'] * 1000)
                .toNepaliDateTime()))
        .toList();
    return transactionData;
  }

  Future<void> deleteTransaction(int transactionId) async {
    (delete(transactions)..where((tbl) => tbl.id.equals(transactionId))).go();
  }

  Future<int> updateTransaction(
      TransactionsCompanion transactionsCompanion, int transactionId) async {
    return await (update(transactions)
          ..where((tbl) => tbl.id.equals(transactionId)))
        .write(transactionsCompanion);
  }
}
