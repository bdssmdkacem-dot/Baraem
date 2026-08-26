import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/core/app_scale.dart';

void main() {
  testWidgets(
    'responsive foundation adapts to compact, tablet and wide layouts',
    (tester) async {
      Future<double> paddingFor(double width) async {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 640)),
            child: const MaterialApp(home: _TestHost()),
          ),
        );

        return AppScale.horizontalPadding(
          tester.element(find.byType(_TestHost)),
        );
      }

      final compactPadding = await paddingFor(320);
      final tabletPadding = await paddingFor(600);
      final widePadding = await paddingFor(1000);

      expect(compactPadding, equals(20));
      expect(tabletPadding, equals(32));
      expect(widePadding, equals(48));
      expect(compactPadding, lessThan(tabletPadding));
      expect(tabletPadding, lessThan(widePadding));
    },
  );
}

class _TestHost extends StatelessWidget {
  const _TestHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
