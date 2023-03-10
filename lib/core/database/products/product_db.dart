import 'package:drift/drift.dart';
import 'package:paiso_plus/core/database/my_database.dart';

part 'product_db.g.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get quanity => integer()();
}

@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<MyDatabase> with _$ProductsDaoMixin {
  ProductsDao(MyDatabase db) : super(db);

  Future<List<Product>> getAllProducts() async {
    return await select(products).get();
  }

  Future<int> addNewProduct(ProductsCompanion product) async {
    return await into(products).insert(product);
  }

  Future<void> deleteProduct(int productId) async {
    await (delete(products)..where((tbl) => tbl.id.equals(productId))).go();
  }

  Future<int> updateProduct(
      ProductsCompanion productsCompanion, int paymentId) async {
    return await (update(products)..where((tbl) => tbl.id.equals(paymentId)))
        .write(productsCompanion);
  }
}
