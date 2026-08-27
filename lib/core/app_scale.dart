import 'package:flutter/widgets.dart';

/// Small responsive helpers used by child-facing layouts.
class AppScale {
  AppScale._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w >= 900) return 48;
    if (w >= 600) return 32;
    return 20;
  }

  static double contentMaxWidth(BuildContext context) {
    final w = width(context);
    return w >= 900 ? 860 : double.infinity;
  }

  static double fontScale(BuildContext context) {
    final w = width(context);
    if (w >= 900) return 1.08;
    if (w < 360) return 0.92;
    return 1;
  }
}
