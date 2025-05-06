import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/button.dart';
import 'package:my_project/presentation/widget/formfield.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate login delay
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically authenticate with your API
      // For now, we'll just simulate success
      
      setState(() {
        _isLoading = false;
      });

      // Navigate to home after login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        // Here you would navigate to the home screen
        // Navigator.pushReplacementNamed(context, AppRoutes.home);
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
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue shopping',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
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
                  
                  // Password field
                  CustomFormField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixIconPressed: _togglePasswordVisibility,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    validator: _validatePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password screen
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login button
                  CustomButton(
                    text: 'Login',
                    onPressed: _login,
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
                  
                  // Social login buttons
                  CustomButton(
                    text: 'Continue with Google',
                    onPressed: () {
                      // Implement Google sign in
                    },
                    isOutlined: true,
                    icon: Icons.g_mobiledata,
                  ),
                  const SizedBox(height: 40),
                  
                  // Sign up text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to sign up screen
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