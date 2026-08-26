import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/core/app_scale.dart';

void main() {
  testWidgets('responsive foundation adapts between compact and wide layouts', (tester) async {
    Future<double> paddingFor(double width) async {
      await tester.binding.setSurfaceSize(Size(width, 640));
      await tester.pumpWidget(const MaterialApp(home: _TestHost()));
      return AppScale.horizontalPadding(
        tester.element(find.byType(_TestHost)),
      );
    }

    final compactPadding = await paddingFor(320);
    final tabletPadding = await paddingFor(600);
    final widePadding = await paddingFor(1000);

    expect(compactPadding, lessThan(tabletPadding));
    expect(tabletPadding, lessThanOrEqualTo(widePadding));
    expect(compactPadding, greaterThan(0));
    expect(widePadding, greaterThan(0));

    await tester.binding.setSurfaceSize(null);
  });
}

class _TestHost extends StatelessWidget {
  const _TestHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
