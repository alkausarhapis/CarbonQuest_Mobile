import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  Color backgroundColor = const Color(0xFF303030),
  Color colorText = Colors.white,
  Duration duration = const Duration(seconds: 2),
  EdgeInsets margin = const EdgeInsets.all(20),
}) {
  OverlayEntry? entry;
  entry = OverlayEntry(
    builder: (context) => _CustomSnackbarWidget(
      title: title,
      message: message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      duration: duration,
      margin: margin,
      onDismiss: () => entry?.remove(),
    ),
  );
  Overlay.of(Get.overlayContext!).insert(entry);
}

class _CustomSnackbarWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color colorText;
  final Duration duration;
  final EdgeInsets margin;
  final VoidCallback onDismiss;

  const _CustomSnackbarWidget({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.colorText,
    required this.duration,
    required this.margin,
    required this.onDismiss,
  });

  @override
  State<_CustomSnackbarWidget> createState() => _CustomSnackbarWidgetState();
}

class _CustomSnackbarWidgetState extends State<_CustomSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onDismiss();
      }
    });
    Timer(widget.duration, () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: () => _controller.reverse(),
        child: Container(
          alignment: Alignment.bottomCenter,
          margin: widget.margin,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: widget.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.colorText,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        if (widget.message.isNotEmpty)
                          Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.colorText,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _controller.reverse(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.close,
                        color: widget.colorText.withValues(alpha: 0.7),
                        size: 18,
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
