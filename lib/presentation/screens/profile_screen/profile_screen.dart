import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/di/container.dart';
import 'package:my_project/domain/entities/user.dart';
import 'package:my_project/presentation/bloc/auth/auth_bloc.dart';
import 'package:my_project/presentation/bloc/auth/auth_event.dart';
import 'package:my_project/presentation/bloc/auth/auth_state.dart';
import 'package:my_project/presentation/route/app_route.dart';
import 'package:my_project/presentation/themes/color.dart';
import 'package:my_project/presentation/widget/profile/profile_header.dart';
import 'package:my_project/presentation/widget/profile/profile_menu_item.dart';
import 'package:my_project/presentation/widget/profile/profile_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _authBloc.add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => _authBloc,
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is Authenticated) {
              return _buildProfileContent(state.user);
            }

            return const Center(
              child: Text('Please log in to view your profile'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(User user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Header
        ProfileHeader(user: user),
        const SizedBox(height: 24),
        
        // Account Settings Section
        ProfileSection(
          title: 'Account Settings',
          children: [
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {
                // Navigate to edit profile screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {
                // Navigate to change password screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              onTap: () {
                // Navigate to addresses screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () {
                // Navigate to payment methods screen
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Orders Section
        ProfileSection(
          title: 'My Orders',
          children: [
            ProfileMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Order History',
              onTap: () {
                // Navigate to order history screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.local_shipping_outlined,
              title: 'Track Orders',
              onTap: () {
                // Navigate to track orders screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.refresh,
              title: 'Returns & Refunds',
              onTap: () {
                // Navigate to returns screen
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Preferences Section
        ProfileSection(
          title: 'Preferences',
          children: [
            ProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notification Settings',
              onTap: () {
                // Navigate to notification settings screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.language_outlined,
              title: 'Language',
              trailing: Text(
                'English',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                // Show language selector
              },
            ),
            ProfileMenuItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // Toggle dark mode
                },
                activeColor: AppColors.primary,
              ),
              onTap: () {
                // Do nothing, the switch handles the tap
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Support Section
        ProfileSection(
          title: 'Support',
          children: [
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                // Navigate to help center screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.headset_mic_outlined,
              title: 'Contact Us',
              onTap: () {
                // Navigate to contact us screen
              },
            ),
            ProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                // Navigate to privacy policy screen
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Logout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _authBloc.add(Logout());
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red.shade400),
              foregroundColor: Colors.red.shade400,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  size: 20,
                  color: Colors.red.shade400,
                ),
                const SizedBox(width: 8),
                Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}