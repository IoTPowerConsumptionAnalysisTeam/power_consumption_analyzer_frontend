import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

class RequestHandler {
  static RequestHandler get I {
    return GetIt.I<RequestHandler>();
  }

  String _baseUrl = 'http://192.168.1.112:3000/api';

  String get baseUrl => _baseUrl;

  set baseUrl(String baseUrl) {
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    _baseUrl = baseUrl;
  }

  Future<http.Response> get(String path) async {
    debugPrint('GET $_baseUrl$path');
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    debugPrint('POST $_baseUrl$path');
    return await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    debugPrint('PUT $_baseUrl$path');
    return await http.put(
      Uri.parse('$_baseUrl$path'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String path, Map<String, dynamic> body) async {
    debugPrint('PATCH $_baseUrl$path');
    return await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    debugPrint('DELETE $_baseUrl$path');
    return await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
