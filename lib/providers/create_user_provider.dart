import 'package:flutter/cupertino.dart';

class CreateUserProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;


  dynamic comparePassword(String? value) {
    if (passwordController.text.isNotEmpty &&  confirmPasswordController.text.isNotEmpty && passwordController.text != confirmPasswordController.text) {
     return 'As senhas não são iguais';
    }
    if(passwordController.text.isEmpty || confirmPasswordController.text.isEmpty){
      return 'Preencha os campos de senha';
    }
    return null;
  }

  void createUser() {
    if (_formKey.currentState!.validate()) {
      print('Validated');

      }
  }

}