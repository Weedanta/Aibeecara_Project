import 'package:flutter/material.dart';
import 'package:my_project/presentation/themes/color.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        
        // Section Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _buildSectionItems(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSectionItems() {
    final List<Widget> sectionItems = [];
    
    for (int i = 0; i < children.length; i++) {
      sectionItems.add(children[i]);
      
      // Add divider between items, but not after the last item
      if (i < children.length - 1) {
        sectionItems.add(Divider(
          height: 1,
          thickness: 1,
          indent: 72,
          endIndent: 16,
          color: AppColors.divider,
        ));
      }
    }
    
    return sectionItems;
  }
}