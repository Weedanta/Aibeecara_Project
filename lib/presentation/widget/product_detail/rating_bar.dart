import 'package:flutter/material.dart';
import 'package:my_project/presentation/themes/color.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int ratingCount;

  const RatingBar({
    Key? key,
    required this.rating,
    required this.ratingCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Star Icons
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isFilled = starValue <= rating;
            final isHalfFilled = !isFilled && starValue - 0.5 <= rating;
            
            IconData iconData;
            if (isFilled) {
              iconData = Icons.star;
            } else if (isHalfFilled) {
              iconData = Icons.star_half;
            } else {
              iconData = Icons.star_border;
            }
            
            return Icon(
              iconData,
              size: 20,
              color: Colors.amber,
            );
          }),
        ),
        const SizedBox(width: 8),
        
        // Rating Value
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        
        // Rating Count
        Text(
          '($ratingCount reviews)',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}