import 'package:my_project/data/api/api_config.dart';
import 'package:my_project/domain/entities/product.dart';
import 'package:my_project/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await ApiConfig.get(ApiConfig.productsEndpoint);
      
      if (response is List) {
        return response.map((item) => Product.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final response = await ApiConfig.get('${ApiConfig.productsEndpoint}/$id');
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get product with id $id: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final endpoint = '${ApiConfig.productsEndpoint}/category/$category';
      final response = await ApiConfig.get(endpoint);
      
      if (response is List) {
        return response.map((item) => Product.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get products in category $category: $e');
    }
  }

  @override
  Future<List<String>> getAllCategories() async {
    try {
      final response = await ApiConfig.get(ApiConfig.categoriesEndpoint);
      
      if (response is List) {
        return response.map((item) => item.toString()).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final response = await ApiConfig.post(
        ApiConfig.productsEndpoint,
        product.toJson(),
      );
      
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<Product> updateProduct(int id, Product product) async {
    try {
      final endpoint = '${ApiConfig.productsEndpoint}/$id';
      final response = await ApiConfig.put(
        endpoint,
        product.toJson(),
      );
      
      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product with id $id: $e');
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    try {
      final endpoint = '${ApiConfig.productsEndpoint}/$id';
      await ApiConfig.delete(endpoint);
      return true;
    } catch (e) {
      throw Exception('Failed to delete product with id $id: $e');
    }
  }
}