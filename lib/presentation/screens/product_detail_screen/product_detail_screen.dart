import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/di/container.dart';
import 'package:my_project/domain/entities/product.dart';
import 'package:my_project/presentation/bloc/cart/cart_bloc.dart';
import 'package:my_project/presentation/bloc/cart/cart_event.dart';
import 'package:my_project/presentation/bloc/product/product_bloc.dart';
import 'package:my_project/presentation/bloc/product/product_event.dart';
import 'package:my_project/presentation/bloc/product/product_state.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/product_detail/add_to_cart_button.dart';
import 'package:my_project/presentation/widget/product_detail/product_image_slider.dart';
import 'package:my_project/presentation/widget/product_detail/rating_bar.dart';


class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductBloc _productBloc;
  late CartBloc _cartBloc;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _productBloc = getIt<ProductBloc>();
    _cartBloc = getIt<CartBloc>();
    _productBloc.add(LoadProductDetails(productId: widget.productId));
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

 

  Widget _buildProductDetail(Product product) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 50,
          pinned: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                // Add to favorites
              },
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.cart);
              },
            ),
          ],
        ),
        
        // Product Image
        SliverToBoxAdapter(
          child: ProductImageSlider(
            imageUrl: product.image,
          ),
        ),
        
        // Product Info
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 100,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title and Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Rating
                if (product.rating != null)
                  RatingBar(
                    rating: product.rating!.rate,
                    ratingCount: product.rating!.count,
                  ),
                const SizedBox(height: 24),
                
                // Description
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Quantity Selector
                Row(
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 16,
                              color: _quantity > 1
                                  ? AppColors.textPrimary
                                  : AppColors.textLight,
                            ),
                            onPressed: _decreaseQuantity,
                          ),
                          Text(
                            _quantity.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: _increaseQuantity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      // Add to Cart Button
      // We use a separate widget below for the fixed positioned button
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => _productBloc,
        child: Stack(
          children: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductDetailsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
    
                if (state is ProductDetailsLoaded) {
                  return _buildProductDetail(state.product);
                }
    
                if (state is ProductsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading product details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            _productBloc.add(
                              LoadProductDetails(productId: widget.productId),
                            );
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
    
                return const Center(
                  child: Text('Product not found'),
                );
              },
            ),
            
            // Fixed Add to Cart Button
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductDetailsLoaded) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AddToCartButton(
                      onPressed: () {
                        _cartBloc.add(AddProductToCart(
                          productId: state.product.id,
                          quantity: _quantity,
                        ));
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${state.product.title} added to cart!',
                            ),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.cart);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}