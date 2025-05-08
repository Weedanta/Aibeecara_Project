import 'package:flutter/material.dart';
import 'package:my_project/presentation/screens/auth_screen/login_screen.dart';
import 'package:my_project/presentation/screens/auth_screen/onboarding.dart';
import 'package:my_project/presentation/screens/auth_screen/signup_screen.dart';
import 'package:my_project/presentation/screens/cart_screen/cart_screen.dart';
import 'package:my_project/presentation/screens/main_screen/main_screen.dart';
import 'package:my_project/presentation/screens/product_detail_screen/product_detail_screen.dart';
import 'package:my_project/presentation/screens/profile_screen/profile_screen.dart';
import 'package:my_project/presentation/screens/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String profile = '/profile';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      
      case productDetail:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}