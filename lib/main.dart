import 'package:flutter/material.dart';
import 'package:my_project/page/onboarding/onboarding.dart';
import 'package:my_project/presentation/screens/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}

