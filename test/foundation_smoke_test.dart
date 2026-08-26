import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/core/app_scale.dart';

void main() {
  testWidgets(
    'responsive foundation adapts across compact, phone, tablet and wide layouts',
    (tester) async {
      Future<(double padding, double fontScale)> metricsFor(double width) async {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 640)),
            child: const MaterialApp(home: _TestHost()),
          ),
        );

        final context = tester.element(find.byType(_TestHost));
        return (
          AppScale.horizontalPadding(context),
          AppScale.fontScale(context),
        );
      }

      final compact = await metricsFor(320);
      final phone = await metricsFor(400);
      final tablet = await metricsFor(600);
      final wide = await metricsFor(1000);

      expect(compact.padding, equals(20));
      expect(phone.padding, equals(20));
      expect(tablet.padding, equals(32));
      expect(wide.padding, equals(48));

      expect(compact.fontScale, equals(0.92));
      expect(phone.fontScale, equals(1));
      expect(tablet.fontScale, equals(1));
      expect(wide.fontScale, equals(1.08));

      expect(compact.padding, lessThan(tablet.padding));
      expect(tablet.padding, lessThan(wide.padding));
      expect(compact.fontScale, lessThan(phone.fontScale));
      expect(phone.fontScale, lessThan(wide.fontScale));
    },
  );
}

class _TestHost extends StatelessWidget {
  const _TestHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
