import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://edvocacademy.in/common/all-staff";

  Future<Map<String, dynamic>> fetchStaffData(
    String? url, {
    int pageSize = 10,
  }) async {
    final Uri requestUri;
    if (url != null) {
      requestUri = Uri.parse(url);
    } else {
      requestUri = Uri.parse(baseUrl);
    }

    final response = await http.post(
      requestUri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"page_size": pageSize.toString()}),
    );

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw Exception("Failed to parse JSON: $e");
      }
    } else {
      throw Exception("Failed to load staff data: ${response.statusCode}");
    }
  }
}
