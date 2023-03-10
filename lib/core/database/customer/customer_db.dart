import 'package:drift/drift.dart';
import 'package:paiso_plus/core/database/my_database.dart';

part 'customer_db.g.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  IntColumn get mobileNumber => integer().nullable()();
  RealColumn get amountPaid => real().withDefault(const Constant(0.0))();
}

@DriftAccessor(tables: [Customers])
class CustomersDao extends DatabaseAccessor<MyDatabase>
    with _$CustomersDaoMixin {
  CustomersDao(MyDatabase db) : super(db);

  Future<int> addCustomer(CustomersCompanion customer) async {
    return await into(customers).insert(customer);
  }

  Future<List<Customer>> getAllCustomers() async {
    return await select(customers).get();
  }
}
