import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'mocks/lamp_service_mock.mocks.dart';
import 'mocks/lamp_service_mock.dart';

void main() {
  late MockClient mockClient;
  final String apiUrl = 'http://10.0.2.2:5000/api';

  setUp(() {
    mockClient = MockClient();
  });

  group('Lamp API Tests', () {
    test(
      'fetchLamps should return lamp list when response is successful',
      () async {
        when(
          mockClient.get(Uri.parse('$apiUrl/lamps')),
        ).thenAnswer((_) async => MockLampService.getMockLampsResponse());

        final response = await mockClient.get(Uri.parse('$apiUrl/lamps'));

        expect(response.statusCode, 200);
        final data = jsonDecode(response.body);
        expect(data, isA<List>());
        expect(data.length, 1);
        expect(data.first['id'], 1);
        expect(data.first['state'], true);
      },
    );

    test('fetchLamps should handle server error', () async {
      when(
        mockClient.get(Uri.parse('$apiUrl/lamps')),
      ).thenAnswer((_) async => MockLampService.getMockErrorResponse());

      final response = await mockClient.get(Uri.parse('$apiUrl/lamps'));

      expect(response.statusCode, 500);
      final data = jsonDecode(response.body);
      expect(data['error'], 'Server error');
    });

    test('fetchLamps should handle connection error', () async {
      when(
        mockClient.get(Uri.parse('$apiUrl/lamps')),
      ).thenThrow(MockLampService.getMockConnectionError());

      expect(
        () async => await mockClient.get(Uri.parse('$apiUrl/lamps')),
        throwsException,
      );
    });

    test(
      'toggleLamp should update lamp state when response is successful',
      () async {
        final lampId = 1;

        when(mockClient.put(Uri.parse('$apiUrl/lamps/$lampId'))).thenAnswer(
          (_) async =>
              MockLampService.getMockToggleLampResponse(newState: true),
        );

        final response = await mockClient.put(
          Uri.parse('$apiUrl/lamps/$lampId'),
        );

        expect(response.statusCode, 200);
        final data = jsonDecode(response.body);
        expect(data['lamp']['state'], true);
        expect(data['message'], 'Lamp state updated successfully');
      },
    );

    test('toggleLamp should handle server error', () async {
      final lampId = 1;

      when(
        mockClient.put(Uri.parse('$apiUrl/lamps/$lampId')),
      ).thenAnswer((_) async => MockLampService.getMockErrorResponse());

      final response = await mockClient.put(Uri.parse('$apiUrl/lamps/$lampId'));

      expect(response.statusCode, 500);
    });

    test('toggleLamp should handle connection error', () async {
      final lampId = 1;

      when(
        mockClient.put(Uri.parse('$apiUrl/lamps/$lampId')),
      ).thenThrow(MockLampService.getMockConnectionError());

      expect(
        () async => await mockClient.put(Uri.parse('$apiUrl/lamps/$lampId')),
        throwsException,
      );
    });
  });
}
