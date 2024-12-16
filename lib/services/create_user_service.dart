import 'package:get/get.dart';

import '../widget/snack_bar.dart';
import 'client_http.dart';

class CreateUserService extends GetxController {
  final ClientHttp apiClient = Get.find<ClientHttp>();

  Future<void> createUser(
      {required String name,
      required String height,
      required String weight,
      required String email,
      required String password}) async {
    final response = await apiClient.postData(
      'api/users/',
      {
        'password': password,
        'username': email,
        'first_name': name,
        'last_name': name,
        'height': height,
        'weight': weight,
        'email': email,
      },
    );

    if (response.statusCode == 201) {
      SnackBarApp.success('Usuário criado com sucesso');
      Get.toNamed('/home');
    } else {
      SnackBarApp.error('Erro ao criar usuário: ${response.bodyString}');
      throw Exception('Erro ao criar usuário: ${response.bodyString}');
    }
  }
}
