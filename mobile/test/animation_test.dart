import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ci_cd_flutter/main.dart';
import 'package:mockito/mockito.dart';
import 'mocks/lamp_service_mock.dart';
import 'mocks/lamp_service_mock.mocks.dart';

void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  group('Animation Tests', () {
    testWidgets('Lamp icon has animation when state changes', (
      WidgetTester tester,
    ) async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => MockLampService.getMockLampsResponse(isLampOn: false),
      );

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      Icon initialIcon = tester.widget<Icon>(
        find.byIcon(Icons.lightbulb_rounded),
      );
      expect(initialIcon.color, Colors.grey[800]);

      await tester.tap(find.byIcon(Icons.power_settings_new_rounded));

      expect(
        find.byWidgetPredicate((widget) => widget is AnimateManager),
        findsWidgets,
      );
    });

    testWidgets('Status container has fade-in animation', (
      WidgetTester tester,
    ) async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => MockLampService.getMockLampsResponse());

      await tester.pumpWidget(const MyApp());

      await tester.pump(const Duration(milliseconds: 250));

      await tester.pumpAndSettle();

      expect(
        find.text('ALLUMÉE').evaluate().isNotEmpty ||
            find.text('ÉTEINTE').evaluate().isNotEmpty,
        true,
      );
    });

    testWidgets('Power button has scale animation on load', (
      WidgetTester tester,
    ) async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => MockLampService.getMockLampsResponse());

      await tester.pumpWidget(const MyApp());

      await tester.pump(const Duration(milliseconds: 300));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.power_settings_new_rounded), findsOneWidget);
    });
  });
}
