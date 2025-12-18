import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://carbonquest-api.bintangap.my.id';

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(url, headers: headers);
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.StreamedResponse> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('PUT', url);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final file = File(filePath);
    final stream = http.ByteStream(file.openRead());
    final length = await file.length();

    final multipartFile = http.MultipartFile(
      fieldName,
      stream,
      length,
      filename: file.path.split('/').last,
    );

    request.files.add(multipartFile);

    try {
      return await request.send();
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }
}
