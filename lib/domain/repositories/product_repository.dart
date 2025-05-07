import 'package:my_project/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();

  Future<Product> getProductById(int id);

  Future<List<Product>> getProductsByCategory(String category);

  Future<List<String>> getAllCategories();

  Future<Product> addProduct(Product product);

  Future<Product> updateProduct(int id, Product product);

  Future<bool> deleteProduct(int id);
}