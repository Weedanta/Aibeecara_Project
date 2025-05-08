import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/di/container.dart';
import 'package:my_project/domain/entities/user.dart';
import 'package:my_project/presentation/bloc/auth/auth_bloc.dart';
import 'package:my_project/presentation/bloc/auth/auth_event.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/button.dart';
import 'package:my_project/presentation/widget/formfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 4) {
      return 'Username must be at least 4 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms & Conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate signup delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would register the user with your API
      // For this demo, we'll simulate a successful registration
      
      setState(() {
        _isLoading = false;
      });

      // Show success message and navigate to login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to login screen
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Header section
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Full Name field
                  CustomFormField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,
                    validator: _validateName,
                  ),
                  const SizedBox(height: 20),
                  
                  // Email field
                  CustomFormField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  
                  // Username field
                  CustomFormField(
                    label: 'Username',
                    hintText: 'Choose a username',
                    prefixIcon: Icons.account_circle_outlined,
                    controller: _usernameController,
                    validator: _validateUsername,
                  ),
                  const SizedBox(height: 20),
                  
                  // Password field
                  CustomFormField(
                    label: 'Password',
                    hintText: 'Create a password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixIconPressed: _togglePasswordVisibility,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password field
                  CustomFormField(
                    label: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixIconPressed: _toggleConfirmPasswordVisibility,
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordController,
                    validator: _validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  
                  // Terms and Conditions checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Show terms and conditions
                                  },
                              ),
                              const TextSpan(
                                text: ' and ',
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Show privacy policy
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up button
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: _signUp,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColors.divider),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColors.divider),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Social signup button
                  CustomButton(
                    text: 'Continue with Google',
                    onPressed: () {
                      // Implement Google sign up
                    },
                    isOutlined: true,
                    icon: Icons.g_mobiledata,
                  ),
                  const SizedBox(height: 32),
                  
                  // Login text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}