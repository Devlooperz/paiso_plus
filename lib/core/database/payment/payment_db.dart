import 'package:drift/drift.dart';
import 'package:paiso_plus/core/database/customer/customer_db.dart';
import 'package:paiso_plus/core/database/my_database.dart';

part 'payment_db.g.dart';

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get paidDate => dateTime()();
}

@DriftAccessor(tables: [Payments])
class PaymentsDao extends DatabaseAccessor<MyDatabase> with _$PaymentsDaoMixin {
  PaymentsDao(MyDatabase db) : super(db);

  Future<int> addPayment(
      int customerId, double amount, DateTime paidDate) async {
    return await into(payments).insert(PaymentsCompanion(
        amount: Value<double>(amount),
        customerId: Value<int>(customerId),
        paidDate: Value<DateTime>(paidDate)));
  }

  Future<void> deletePayment(int paymentId) async {
    await (delete(payments)..where((tbl) => tbl.id.equals(paymentId))).go();
  }

  Future<int> updatePayment(
      PaymentsCompanion paymentsCompanion, int paymentId) async {
    return await (update(payments)..where((tbl) => tbl.id.equals(paymentId)))
        .write(paymentsCompanion);
  }
}
