import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/core/app_scale.dart';

void main() {
  testWidgets(
    'responsive foundation adapts across compact, phone, tablet and wide layouts',
    (tester) async {
      Future<List<double>> metricsFor(double width) async {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: Size(width, 640)),
            child: const MaterialApp(home: _TestHost()),
          ),
        );

        final context = tester.element(find.byType(_TestHost));
        return <double>[
          AppScale.horizontalPadding(context),
          AppScale.fontScale(context),
        ];
      }

      final compact = await metricsFor(320);
      final phone = await metricsFor(400);
      final tablet = await metricsFor(600);
      final wide = await metricsFor(1000);

      expect(compact[0], equals(20));
      expect(phone[0], equals(20));
      expect(tablet[0], equals(32));
      expect(wide[0], equals(48));

      expect(compact[1], equals(0.92));
      expect(phone[1], equals(1));
      expect(tablet[1], equals(1));
      expect(wide[1], equals(1.08));

      expect(compact[0], lessThan(tablet[0]));
      expect(tablet[0], lessThan(wide[0]));
      expect(compact[1], lessThan(phone[1]));
      expect(phone[1], lessThan(wide[1]));
    },
  );
}

class _TestHost extends StatelessWidget {
  const _TestHost();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
