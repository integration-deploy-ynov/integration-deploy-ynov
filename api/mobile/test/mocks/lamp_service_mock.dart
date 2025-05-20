import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'dart:convert';

@GenerateMocks([http.Client])
void main() {}

class MockLampService {
  static http.Response getMockLampsResponse({bool isLampOn = true}) {
    return http.Response(
      jsonEncode([
        {'id': 1, 'name': 'Test Lamp', 'state': isLampOn},
      ]),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  static http.Response getMockToggleLampResponse({bool newState = true}) {
    return http.Response(
      jsonEncode({
        'lamp': {'id': 1, 'name': 'Test Lamp', 'state': newState},
        'message': 'Lamp state updated successfully',
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  static http.Response getMockErrorResponse() {
    return http.Response(
      jsonEncode({'error': 'Server error'}),
      500,
      headers: {'content-type': 'application/json'},
    );
  }

  static Exception getMockConnectionError() {
    return Exception('Failed to connect to the server');
  }
}
