import 'package:flutter/material.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/button.dart';
import 'package:my_project/presentation/widget/Onboarding/onboarding_page.dart';
import 'package:my_project/presentation/widget/Onboarding/page_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to FakeStore',
      'description': 'Discover a wide range of products from electronics to fashion all in one place.',
      'image': 'assets/images/onboarding_1.png',
    },
    {
      'title': 'Browse Categories',
      'description': 'Find what you need easily with our organized product categories and smart search.',
      'image': 'assets/images/onboarding_2.png',
    },
    {
      'title': 'Secure Checkout',
      'description': 'Shop with confidence using our secure and fast checkout process.',
      'image': 'assets/images/onboarding_3.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            
            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                    imagePath: _onboardingData[index]['image']!,
                  );
                },
              ),
            ),
            
            // Indicators and buttons
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page indicator
                  PageIndicator (
                    pageCount: _onboardingData.length,
                    currentPage: _currentPage,
                  ),
                  const SizedBox(height: 32),
                  
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button (visible after first page)
                      _currentPage > 0
                          ? CustomIconButton(
                              icon: Icons.arrow_back,
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            )
                          : const SizedBox(width: 48),
                      
                      // Next or Get Started button
                      CustomButton(
                        text: _currentPage < _onboardingData.length - 1
                            ? 'Next'
                            : 'Get Started',
                        onPressed: _navigateToNextPage,
                        width: 200,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}