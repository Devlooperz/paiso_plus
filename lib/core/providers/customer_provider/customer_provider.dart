import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/database/my_database.dart';

class CustomerProvider extends StateNotifier<List<Customer>> {
  CustomerProvider() : super([]) {
    getAllCustomers();
  }

  Future<void> getAllCustomers() async {
    final data = await MyDatabase().customersDao.getAllCustomers();
    state = data;
  }

  Future<void> addCustomer(String name, String address,
      [String? phoneNumber]) async {
    await MyDatabase().customersDao.addCustomer(CustomersCompanion(
        name: Value<String>(name),
        address: Value<String>(address),
        mobileNumber: Value<int?>(int.tryParse(phoneNumber ?? "dd"))));
  }
}

final customerProvider =
    StateNotifierProvider<CustomerProvider, List<Customer>>(
  (ref) => CustomerProvider(),
);
