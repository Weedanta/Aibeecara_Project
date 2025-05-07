import 'package:my_project/domain/entities/cart.dart';

abstract class CartRepository {
  Future<List<Cart>> getAllCarts();

  Future<Cart> getCartById(int id);

  Future<List<Cart>> getUserCarts(int userId);
  
  Future<Cart> addCart(Cart cart);
  
  Future<Cart> updateCart(int id, Cart cart);
  
  Future<bool> deleteCart(int id);
  
  Future<Cart> addProductToCart(int cartId, int productId, int quantity);
  
  Future<Cart> removeProductFromCart(int cartId, int productId);
  
  Future<Cart> updateProductQuantity(int cartId, int productId, int quantity);
}