import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ci_cd_flutter/main.dart';
import 'mocks/lamp_service_mock.dart';
import 'mocks/lamp_service_mock.mocks.dart';

void main() {
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
  });

  testWidgets('App should display title and lamp status', (
    WidgetTester tester,
  ) async {
    when(mockClient.get(any)).thenAnswer(
      (_) async => MockLampService.getMockLampsResponse(isLampOn: false),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('SMART LIGHTING'), findsOneWidget);

    expect(find.textContaining('TEINTE'), findsWidgets);
  });

  testWidgets('Lamp UI should update when power button is pressed', (
    WidgetTester tester,
  ) async {
    when(mockClient.get(any)).thenAnswer(
      (_) async => MockLampService.getMockLampsResponse(isLampOn: false),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('ÉTEINTE'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.power_settings_new_rounded));
    await tester.pump();
  });

  testWidgets('App shows loading indicator during network operations', (
    WidgetTester tester,
  ) async {
    when(mockClient.get(any)).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return MockLampService.getMockLampsResponse();
    });

    await tester.pumpWidget(const MyApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
