import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/core/app_scale.dart';

void main() {
  testWidgets('responsive foundation stays usable on a compact screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));

    await tester.pumpWidget(const MaterialApp(home: _TestHost()));

    final context = tester.element(find.byType(_TestHost));
    expect(AppScale.horizontalPadding(context), 20);
    expect(AppScale.fontScale(context), 0.92);

    await tester.binding.setSurfaceSize(null);
  });
}

class _TestHost extends StatelessWidget {
  const _TestHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
