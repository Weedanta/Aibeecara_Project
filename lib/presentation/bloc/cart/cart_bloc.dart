import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/domain/entities/cart.dart';
import 'package:my_project/domain/repositories/cart_repository.dart';
import 'package:my_project/domain/repositories/product_repository.dart';
import 'cart_event.dart';
import '../cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository;

  CartBloc({
    required CartRepository cartRepository,
    required ProductRepository productRepository,
  })  : _cartRepository = cartRepository,
        _productRepository = productRepository,
        super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<UpdateProductQuantity>(_onUpdateProductQuantity);
    on<CheckoutCart>(_onCheckoutCart);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartLoading());

      // In a real app, you would get the current user's cart
      // For this demo, we'll use the first cart or create one if it doesn't exist
      List<Cart> userCarts = [];
      try {
        userCarts = await _cartRepository.getUserCarts(event.userId);
      } catch (_) {
        // Ignore error, we'll create a new cart if needed
      }

      Cart cart;
      if (userCarts.isNotEmpty) {
        cart = userCarts.first;
      } else {
        // Create a new cart for the user
        cart = Cart(
          id: 1, // This would be created by the backend normally
          userId: event.userId,
          products: [],
        );
        // Save the new cart
        try {
          cart = await _cartRepository.addCart(cart);
        } catch (_) {
          // Ignore error for demo
        }
      }

      // Load full product details for each cart item
      final enhancedProducts = <CartItem>[];
      for (final item in cart.products) {
        try {
          final product = await _productRepository.getProductById(item.productId);
          enhancedProducts.add(CartItem(
            productId: item.productId,
            quantity: item.quantity,
            price: product.price,
            product: product,
          ));
        } catch (_) {
          // If we can't get product details, use the original item
          enhancedProducts.add(item);
        }
      }

      // Create a new cart with enhanced products
      final enhancedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        products: enhancedProducts,
        date: cart.date,
      );

      emit(CartLoaded(cart: enhancedCart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddProductToCart(
    AddProductToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        emit(CartLoading());

        await _cartRepository.addProductToCart(
          currentState.cart.id,
          event.productId,
          event.quantity,
        );

        add(LoadCart(userId: currentState.cart.userId));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveProductFromCart(
    RemoveProductFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        emit(CartLoading());

        await _cartRepository.removeProductFromCart(
          currentState.cart.id,
          event.productId,
        );

        add(LoadCart(userId: currentState.cart.userId));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProductQuantity(
    UpdateProductQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        emit(CartLoading());

        await _cartRepository.updateProductQuantity(
          currentState.cart.id,
          event.productId,
          event.quantity,
        );

        add(LoadCart(userId: currentState.cart.userId));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onCheckoutCart(
    CheckoutCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        emit(CartProcessing());

        // In a real app, you would process payment here
        // For this demo, we'll simulate a successful checkout
        await Future.delayed(const Duration(seconds: 2));

        // Create a new empty cart after checkout
        final newCart = Cart(
          id: currentState.cart.id,
          userId: currentState.cart.userId,
          products: [],
        );

        await _cartRepository.updateCart(currentState.cart.id, newCart);

        emit(CartCheckoutSuccess());
        
        // Load the new empty cart after a delay
        await Future.delayed(const Duration(seconds: 1));
        add(LoadCart(userId: currentState.cart.userId));
      }
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}