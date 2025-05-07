import 'package:my_project/domain/entities/product.dart';

class Cart {
  final int id;
  final int userId;
  final List<CartItem> products;
  final String? date;

  const Cart({
    required this.id,
    required this.userId,
    required this.products,
    this.date,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      products: (json['products'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'products': products.map((item) => item.toJson()).toList(),
      if (date != null) 'date': date,
    };
  }

  double get totalPrice {
    return products.fold(
        0, (total, item) => total + (item.price * item.quantity));
  }

  int get itemCount {
    return products.fold(0, (count, item) => count + item.quantity);
  }
}

class CartItem {
  final int productId;
  final int quantity;
  final double price;
  Product? product; 

  CartItem({
    required this.productId,
    required this.quantity,
    required this.price,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? json['id'],
      quantity: json['quantity'],
      price: json['price'] != null
          ? (json['price'] is int)
              ? (json['price'] as int).toDouble()
              : json['price']
          : 0.0,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      if (price > 0) 'price': price,
    };
  }
}