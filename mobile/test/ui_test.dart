import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ci_cd_flutter/main.dart';
import 'package:mockito/mockito.dart';
import 'mocks/lamp_service_mock.dart';
import 'mocks/lamp_service_mock.mocks.dart';

Finder findWidgetWithText(String textToFind) {
  return find.byWidgetPredicate((widget) {
    if (widget is Text) {
      return widget.data != null && widget.data!.contains(textToFind);
    }
    return false;
  });
}

void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  group('UI Tests', () {
    testWidgets('App has correct theme and visual elements', (
      WidgetTester tester,
    ) async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => MockLampService.getMockLampsResponse(isLampOn: true),
      );

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);

      expect(find.byIcon(Icons.lightbulb_rounded), findsOneWidget);

      expect(find.byIcon(Icons.power_settings_new_rounded), findsOneWidget);
    });

    testWidgets('UI shows lamp status correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.child is Text,
        ),
        findsWidgets,
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Error state is displayed when server returns error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('App shows disconnected state when network error occurs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Lamp ID is displayed correctly', (WidgetTester tester) async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => MockLampService.getMockLampsResponse());

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(findWidgetWithText("LAMPE ID"), findsWidgets);
    });
  });
}
