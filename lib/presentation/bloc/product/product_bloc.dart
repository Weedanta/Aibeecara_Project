import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/product.dart';
import 'package:my_project/domain/repositories/product_repository.dart';
import '../product/product_event.dart';
import '../product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductsLoading());
      final products = await _productRepository.getAllProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductDetailsLoading());
      final product = await _productRepository.getProductById(event.productId);
      emit(ProductDetailsLoaded(product: product));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductsLoading());
      final products =
          await _productRepository.getProductsByCategory(event.category);
      emit(ProductsLoaded(
        products: products,
        currentCategory: event.category,
      ));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(CategoriesLoading());
      final categories = await _productRepository.getAllCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }
}