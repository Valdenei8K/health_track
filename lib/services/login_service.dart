import 'package:get/get.dart';

import '../models/login_model.dart';
import 'client_http.dart';


class AuthService extends GetxController {
  final ClientHttp apiClient = Get.find<ClientHttp>();

  Future<void> login(String username, String password) async {
    final response = await await apiClient.postData('api/token/', {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final tokenResponse = TokenResponse.fromJson(response.body);
      await apiClient.saveToken(tokenResponse);
      print('Login bem-sucedido! Access: ${tokenResponse.access}');
      Get.toNamed('/home');
    } else {
      throw Exception('Erro no login: ${response.bodyString}');
    }
  }
}

