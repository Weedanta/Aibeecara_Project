import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/di/container.dart';
import 'package:my_project/domain/entities/cart.dart';
import 'package:my_project/presentation/bloc/cart/cart_bloc.dart';
import 'package:my_project/presentation/bloc/cart/cart_event.dart';
import 'package:my_project/presentation/bloc/cart/cart_state.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/cart/cart_item_card.dart';
import 'package:my_project/presentation/widget/cart/cart_summary.dart';
import 'package:my_project/presentation/widget/cart/empty_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = getIt<CartBloc>();
    // For demo purposes, we're using a hardcoded user ID (1)
    // In a real app, you would get the current user's ID from authentication
    _cartBloc.add(LoadCart(userId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => _cartBloc,
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is CartCheckoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading || state is CartProcessing) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      state is CartProcessing
                          ? 'Processing your order...'
                          : 'Loading your cart...',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is CartLoaded) {
              final cart = state.cart;
              
              if (cart.products.isEmpty) {
                return EmptyCart(
                  onContinueShopping: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                );
              }
              
              return Stack(
                children: [
                  // Cart items list
                  Padding(
                    padding: const EdgeInsets.only(bottom: 180),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.products.length,
                      itemBuilder: (context, index) {
                        final cartItem = cart.products[index];
                        return CartItemCard(
                          cartItem: cartItem,
                          onRemove: () {
                            _cartBloc.add(RemoveProductFromCart(
                              productId: cartItem.productId,
                            ));
                          },
                          onQuantityChanged: (quantity) {
                            _cartBloc.add(UpdateProductQuantity(
                              productId: cartItem.productId,
                              quantity: quantity,
                            ));
                          },
                        );
                      },
                    ),
                  ),
                  
                  // Cart summary
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CartSummary(
                      cart: cart,
                      onCheckout: () {
                        _cartBloc.add(CheckoutCart());
                      },
                    ),
                  ),
                ],
              );
            }

            // Default state
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}