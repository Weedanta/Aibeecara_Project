import 'package:my_project/domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final String? currentCategory;
  
  ProductsLoaded({
    required this.products,
    this.currentCategory,
  });
}

class ProductDetailsLoading extends ProductState {}

class ProductDetailsLoaded extends ProductState {
  final Product product;
  
  ProductDetailsLoaded({required this.product});
}

class CategoriesLoading extends ProductState {}

class CategoriesLoaded extends ProductState {
  final List<String> categories;
  
  CategoriesLoaded({required this.categories});
}

class ProductsError extends ProductState {
  final String message;
  
  ProductsError({required this.message});
}