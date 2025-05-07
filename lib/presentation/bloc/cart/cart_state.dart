import 'package:my_project/domain/entities/cart.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  
  CartLoaded({required this.cart});
}

class CartProcessing extends CartState {}

class CartCheckoutSuccess extends CartState {}

class CartError extends CartState {
  final String message;
  
  CartError({required this.message});
}