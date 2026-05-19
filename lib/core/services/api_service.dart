import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'local_storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final token = await LocalStorageService.getString(AppConstants.tokenKey);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client
          .get(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(),
      )
          .timeout(const Duration(seconds: AppConstants.receiveTimeout));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on FormatException {
      throw ApiException('Invalid data format received from server.');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client
          .post(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(const Duration(seconds: AppConstants.receiveTimeout));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on FormatException {
      throw ApiException('Invalid data format received from server.');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw ApiException('Bad request', statusCode: 400);
      case 401:
        throw ApiException('Unauthorized', statusCode: 401);
      case 404:
        throw ApiException('Not found', statusCode: 404);
      case 500:
        throw ApiException('Server error', statusCode: 500);
      default:
        throw ApiException(
          'Something went wrong',
          statusCode: response.statusCode,
        );
    }
  }
}