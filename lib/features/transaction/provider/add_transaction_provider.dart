import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:paiso_plus/core/database/my_database.dart';
import 'package:paiso_plus/core/providers/customer_provider/customer_provider.dart';
import 'package:paiso_plus/core/providers/product_provider/product_provider.dart';
import 'package:paiso_plus/features/transaction/model/transaction_model.dart';

class AddTransactionProvider extends StateNotifier<List<TransactionModel>> {
  AddTransactionProvider(this.customers, this.products) : super([]);

  List<Customer> customers;
  List<Product> products;

  Customer? customer;
  Product? product;
  final TextEditingController rateEditingController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  void changeCustomer(Customer? customer) {
    this.customer = customer;
    state = [];
  }

  void changeProduct(Product? product) {
    this.product = product;
  }

  void addNewTransaction(NepaliDateTime nepaliDateTime) {
    int? productAlreadyExists = _isProductAlreadyExists();

    if (productAlreadyExists == null) {
      final data = TransactionModel(
          id: state.length,
          product: product!,
          rate: double.parse(rateEditingController.text),
          quantity: int.parse(quantityController.text),
          nepaliDateTime: nepaliDateTime);

      state = [data, ...state];
      reset();
    } else {
      throw ("Transaction with this Product Already Existes. Please Update Transaction");
    }
  }

  int? _isProductAlreadyExists() {
    final productData =
        state.where((element) => element.product.id == product!.id);
    if (productData.isEmpty) {
      return null;
    }
    return productData.first.id;
  }

  void submitTransaction() async {
    if (state.isEmpty) return;
    for (TransactionModel element in state) {
      await MyDatabase().transactionsDao.addTransaction(TransactionsCompanion(
          amount: Value<double>(element.rate),
          customer: Value<int>(customer!.id),
          product: Value<int>(element.product.id),
          quntity: Value<int>(element.quantity),
          transactiondate:
              Value<DateTime>(element.nepaliDateTime.toDateTime())));
    }
  }

  void reset() {
    product = null;
    rateEditingController.clear();
    quantityController.clear();
  }

  Future<void> addTransactionToDatabase() async {}

  @override
  void dispose() {
    super.dispose();
    rateEditingController.dispose();
    quantityController.dispose();
    product = null;
    customer = null;
  }
}

final addTransactionProvider = StateNotifierProvider.autoDispose<
    AddTransactionProvider, List<TransactionModel>>((ref) {
  final List<Customer> customers = ref.read(customerProvider);
  final List<Product> products = ref.read(productProvider);
  return AddTransactionProvider(customers, products);
});
