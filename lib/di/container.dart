import 'package:get_it/get_it.dart';
import 'package:my_project/data/repositories/cart_repository_impl.dart';
import 'package:my_project/data/repositories/product_repository_impl.dart';
import 'package:my_project/data/repositories/user_repository_impl.dart';
import 'package:my_project/domain/repositories/cart_repository.dart';
import 'package:my_project/domain/repositories/product_repository.dart';
import 'package:my_project/domain/repositories/user_repository.dart';
import 'package:my_project/presentation/bloc/auth/auth_bloc.dart';
import 'package:my_project/presentation/bloc/cart/cart_bloc.dart';
import 'package:my_project/presentation/bloc/product/product_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(),
  );
  
  // BLoCs
  getIt.registerFactory(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );
  
  getIt.registerFactory(
    () => CartBloc(
      cartRepository: getIt<CartRepository>(),
      productRepository: getIt<ProductRepository>(),
    ),
  );
  
  getIt.registerFactory(
    () => AuthBloc(userRepository: getIt<UserRepository>()),
  );
}