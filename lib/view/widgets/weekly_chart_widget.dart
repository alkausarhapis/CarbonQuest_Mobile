import 'package:flutter/material.dart';

import '../../core/styles/app_color.dart';

class WeeklyChartWidget extends StatefulWidget {
  final List<ChartData> data;

  const WeeklyChartWidget({super.key, required this.data});

  @override
  State<WeeklyChartWidget> createState() => _WeeklyChartWidgetState();
}

class _WeeklyChartWidgetState extends State<WeeklyChartWidget> {
  int? selectedIndex;
  late List<bool> defaultHighlights;

  @override
  void initState() {
    super.initState();
    defaultHighlights = widget.data.map((item) => item.isHighlighted).toList();
  }

  void _handleBarTap(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null;
      } else {
        selectedIndex = index;
      }
    });
  }

  bool _isHighlighted(int index) {
    if (selectedIndex != null) {
      return selectedIndex == index;
    }
    return defaultHighlights[index];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'History Mingguan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.data.length,
                (index) => _ChartBar(
                  value: widget.data[index].value,
                  label: widget.data[index].label,
                  isHighlighted: _isHighlighted(index),
                  onTap: () => _handleBarTap(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double value;
  final String label;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _ChartBar({
    required this.value,
    required this.label,
    required this.isHighlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedHeight = (value / 100) * 120;
    final displayHeight = normalizedHeight.clamp(0.0, 120.0);

    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isHighlighted)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.primary.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${value.toInt()}kg',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColor.primary.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (!isHighlighted) const SizedBox(height: 18),
            Container(
              width: 20,
              height: displayHeight,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColor.primary.color
                    : AppColor.primary.color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final double value;
  final String label;
  final bool isHighlighted;

  ChartData({
    required this.value,
    required this.label,
    this.isHighlighted = false,
  });
}
