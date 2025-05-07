import 'package:my_project/data/api/api_config.dart';
import 'package:my_project/domain/entities/cart.dart';
import 'package:my_project/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  @override
  Future<List<Cart>> getAllCarts() async {
    try {
      final response = await ApiConfig.get(ApiConfig.cartsEndpoint);
      
      if (response is List) {
        return response.map((item) => Cart.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get carts: $e');
    }
  }

  @override
  Future<Cart> getCartById(int id) async {
    try {
      final response = await ApiConfig.get('${ApiConfig.cartsEndpoint}/$id');
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get cart with id $id: $e');
    }
  }

  @override
  Future<List<Cart>> getUserCarts(int userId) async {
    try {
      final endpoint = '${ApiConfig.cartsEndpoint}/user/$userId';
      final response = await ApiConfig.get(endpoint);
      
      if (response is List) {
        return response.map((item) => Cart.fromJson(item)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get carts for user $userId: $e');
    }
  }

  @override
  Future<Cart> addCart(Cart cart) async {
    try {
      final response = await ApiConfig.post(
        ApiConfig.cartsEndpoint,
        cart.toJson(),
      );
      
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add cart: $e');
    }
  }

  @override
  Future<Cart> updateCart(int id, Cart cart) async {
    try {
      final endpoint = '${ApiConfig.cartsEndpoint}/$id';
      final response = await ApiConfig.put(
        endpoint,
        cart.toJson(),
      );
      
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update cart with id $id: $e');
    }
  }

  @override
  Future<bool> deleteCart(int id) async {
    try {
      final endpoint = '${ApiConfig.cartsEndpoint}/$id';
      await ApiConfig.delete(endpoint);
      return true;
    } catch (e) {
      throw Exception('Failed to delete cart with id $id: $e');
    }
  }

  @override
  Future<Cart> addProductToCart(int cartId, int productId, int quantity) async {
    try {
      final cart = await getCartById(cartId);
      
      final existingProductIndex = cart.products.indexWhere(
        (item) => item.productId == productId,
      );
      
      final updatedProducts = [...cart.products];
      
      if (existingProductIndex >= 0) {
        final existingItem = updatedProducts[existingProductIndex];
        updatedProducts[existingProductIndex] = CartItem(
          productId: existingItem.productId,
          quantity: existingItem.quantity + quantity,
          price: existingItem.price,
        );
      } else {
        updatedProducts.add(CartItem(
          productId: productId,
          quantity: quantity,
          price: 0, 
        ));
      }

      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        products: updatedProducts,
        date: cart.date,
      );

      return updateCart(cartId, updatedCart);
    } catch (e) {
      throw Exception('Failed to add product to cart: $e');
    }
  }

  @override
  Future<Cart> removeProductFromCart(int cartId, int productId) async {
    try {
      final cart = await getCartById(cartId);

      final updatedProducts = cart.products
          .where((item) => item.productId != productId)
          .toList();

      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        products: updatedProducts,
        date: cart.date,
      );

      return updateCart(cartId, updatedCart);
    } catch (e) {
      throw Exception('Failed to remove product from cart: $e');
    }
  }

  @override
  Future<Cart> updateProductQuantity(int cartId, int productId, int quantity) async {
    try {
      final cart = await getCartById(cartId);

      final existingProductIndex = cart.products.indexWhere(
        (item) => item.productId == productId,
      );
      
      if (existingProductIndex < 0) {
        throw Exception('Product not found in cart');
      }
      
      final updatedProducts = [...cart.products];
      final existingItem = updatedProducts[existingProductIndex];
      
      if (quantity <= 0) {
        updatedProducts.removeAt(existingProductIndex);
      } else {
        updatedProducts[existingProductIndex] = CartItem(
          productId: existingItem.productId,
          quantity: quantity,
          price: existingItem.price,
        );
      }
      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        products: updatedProducts,
        date: cart.date,
      );
      
      return updateCart(cartId, updatedCart);
    } catch (e) {
      throw Exception('Failed to update product quantity: $e');
    }
  }
}