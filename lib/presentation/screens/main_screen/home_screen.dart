import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/di/container.dart';
import 'package:my_project/domain/entities/product.dart';
import 'package:my_project/presentation/bloc/product/product_bloc.dart';
import 'package:my_project/presentation/bloc/product/product_event.dart';
import 'package:my_project/presentation/bloc/product/product_state.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/home_screen/product_grid_item.dart';
import 'package:my_project/presentation/widget/home_screen/category_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductBloc _productBloc;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productBloc = getIt<ProductBloc>();
    _productBloc.add(LoadProducts());
    _productBloc.add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => _productBloc,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildCategorySection(),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primary,
      title: const Text(
        'FakeStore',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Implement search functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.cart);
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search products...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textLight,
                ),
                hintStyle: TextStyle(
                  color: AppColors.textLight,
                ),
              ),
              onSubmitted: (value) {
                // Implement search functionality
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SliverToBoxAdapter(
      child: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) =>
            current is CategoriesLoaded || current is CategoriesLoading,
        builder: (context, state) {
          if (state is CategoriesLoaded) {
            return CategorySelector(
              categories: ['All', ...state.categories],
              selectedCategory: _selectedCategory ?? 'All',
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category == 'All' ? null : category;
                });
                
                if (category == 'All') {
                  _productBloc.add(LoadProducts());
                } else {
                  _productBloc.add(LoadProductsByCategory(category: category));
                }
              },
            );
          }
          
          return const SizedBox(height: 80);
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) =>
          current is ProductsLoaded || current is ProductsLoading,
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (state is ProductsLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = state.products[index];
                  return ProductGridItem(
                    product: product,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetail,
                        arguments: product.id,
                      );
                    },
                  );
                },
                childCount: state.products.length,
              ),
            ),
          );
        }
        
        if (state is ProductsError) {
          return SliverFillRemaining(
            child: Center(
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
                    'Error loading products',
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
                      _productBloc.add(LoadProducts());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }
        
        return const SliverFillRemaining(
          child: Center(
            child: Text('No products found'),
          ),
        );
      },
    );
  }
}