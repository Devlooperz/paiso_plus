import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/database/my_database.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]) {
    getAllProducts();
  }

  Future<void> getAllProducts() async {
    final data = await MyDatabase().productsDao.getAllProducts();
    state = data;
  }

  Future<void> addProduct(String name, int quantity) async {
    await MyDatabase().productsDao.addNewProduct(ProductsCompanion(
        name: Value<String>(name), quanity: Value<int>(quantity)));
  }
}

final productProvider = StateNotifierProvider<ProductProvider, List<Product>>(
  (ref) => ProductProvider(),
);
