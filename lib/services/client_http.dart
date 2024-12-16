import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_model.dart';
import '../widget/snack_bar.dart';

class ClientHttp extends GetConnect {
  final accessToken = ''.obs;
  final refreshToken = ''.obs;
  final String baseUrl;

  ClientHttp({required this.baseUrl}) {
    httpClient.baseUrl = baseUrl;

    // Timeout padrão
    httpClient.timeout = const Duration(seconds: 30);

    // Configurar manipuladores de erros e respostas
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        _handleUnauthorized();
      }
      return response;
    });

    // Carregar o token do armazenamento persistente
    _loadToken();
  }

  // Método GET genérico
  Future<Response> getData(String endpoint,
      {Map<String, dynamic>? query}) async {
    try {
      return await get(endpoint, query: query);
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Erro na requisição: $e');
    }
  }

  // Método POST genérico
  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      return await post(endpoint, data);
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Erro na requisição: $e');
    }
  }

  // Método para salvar o token no armazenamento persistente
  Future<void> saveToken(TokenResponse tokenResponse) async {
    final prefs = await SharedPreferences.getInstance();
    accessToken.value = tokenResponse.access;
    refreshToken.value = tokenResponse.refresh;

    await prefs.setString('access', tokenResponse.access);
    await prefs.setString('refresh', tokenResponse.refresh);
  }

  // Método para carregar o token do armazenamento persistente
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken.value = prefs.getString('access') ?? '';
    refreshToken.value = prefs.getString('refresh') ?? '';
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');

    accessToken.value = '';
    refreshToken.value = '';
    Get.toNamed('/login');
  }

  Future<void> _refreshToken() async {
    if (refreshToken.value.isNotEmpty) {
      final response = await postData('/auth/refresh', {'refresh': refreshToken.value});
      if (response.statusCode == 200) {
        final newToken = TokenResponse.fromJson(response.body);
        await saveToken(newToken);
      } else {
        _handleUnauthorized();
      }
    } else {
      _handleUnauthorized();
    }
  }

  // Método para tratar erros 401 (não autorizado)
  void _handleUnauthorized() {
    clearToken();
    Get.offAllNamed('/login');
    SnackBarApp.error('Usuário não autorizado, faça login novamente!');
  }
}
