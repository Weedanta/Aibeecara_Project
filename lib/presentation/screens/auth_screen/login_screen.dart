import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/di/container.dart';
import 'package:my_project/presentation/bloc/auth/auth_bloc.dart';
import 'package:my_project/presentation/bloc/auth/auth_event.dart';
import 'package:my_project/presentation/bloc/auth/auth_state.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/button.dart';
import 'package:my_project/presentation/widget/formfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    
    // Pre-fill with test user credentials for demo purposes
    _usernameController.text = 'johnd';
    _passwordController.text = 'm38rmF\$';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      _authBloc.add(Login(
        username: username,
        password: password,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // Show loading indicator if needed
          } else if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful!')),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            
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
                          
                          // Username field
                          CustomFormField(
                            label: 'Username',
                            hintText: 'Enter your username',
                            prefixIcon: Icons.person_outline,
                            controller: _usernameController,
                            validator: _validateUsername,
                            keyboardType: TextInputType.text,
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
                          
                          const SizedBox(height: 24),
                          
                          // Login button
                          CustomButton(
                            text: 'Login',
                            onPressed: _login,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 24),
                         
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
                                        Navigator.pushNamed(
                                          context, 
                                          AppRoutes.signup
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Demo credentials info
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Demo Credentials:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Username: johnd\nPassword: m38rmF\$',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}