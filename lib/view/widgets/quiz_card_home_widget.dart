import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../core/styles/app_color.dart';

class QuizCardHomeWidget extends StatelessWidget {
  final String title;
  final String points;
  final VoidCallback onTap;
  final bool isCompleted;

  const QuizCardHomeWidget({
    super.key,
    required this.title,
    required this.points,
    required this.onTap,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.grey.withValues(alpha: 0.5)
              : AppColor.primary.color.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusBold.message_time,
              color: isCompleted ? Colors.grey[600] : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isCompleted ? Colors.grey[600] : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  points,
                  style: TextStyle(
                    color: isCompleted
                        ? Colors.grey[500]
                        : Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
                if (isCompleted) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.check_circle, color: Colors.green[700], size: 14),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
