import 'package:flutter/material.dart';

enum AppColor {
  primary("Primary", Color(0xFF6EC9E0)),
  cyan("Cyan", Color(0xFF3E8799));

  const AppColor(this.name, this.color);
  final String name;
  final Color color;
}
