import 'package:flutter/material.dart';
import 'package:my_project/presentation/widget/OnBoarding/onboarding_content.dart';
import 'package:my_project/presentation/widget/OnBoarding/onboarding_image.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: const [
          Expanded(flex: 2, child: OnboardingImage()),
          OnboardingContent(),
        ],
      ),
    );
  }
}
