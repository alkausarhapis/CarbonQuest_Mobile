import 'package:flutter/material.dart';

import '../../core/styles/app_color.dart';

class CategoryIconWidget extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryIconWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<CategoryIconWidget> createState() => _CategoryIconWidgetState();
}

class _CategoryIconWidgetState extends State<CategoryIconWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.primary.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.icon, color: AppColor.primary.color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                color: AppColor.primary.color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
