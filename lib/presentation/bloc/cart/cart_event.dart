abstract class CartEvent {}

class LoadCart extends CartEvent {
  final int userId;
  
  LoadCart({required this.userId});
}

class AddProductToCart extends CartEvent {
  final int productId;
  final int quantity;
  
  AddProductToCart({
    required this.productId,
    this.quantity = 1,
  });
}

class RemoveProductFromCart extends CartEvent {
  final int productId;
  
  RemoveProductFromCart({required this.productId});
}

class UpdateProductQuantity extends CartEvent {
  final int productId;
  final int quantity;
  
  UpdateProductQuantity({
    required this.productId,
    required this.quantity,
  });
}

class CheckoutCart extends CartEvent {}