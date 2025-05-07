abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadProductDetails extends ProductEvent {
  final int productId;
  
  LoadProductDetails({required this.productId});
}

class LoadProductsByCategory extends ProductEvent {
  final String category;
  
  LoadProductsByCategory({required this.category});
}

class LoadCategories extends ProductEvent {}