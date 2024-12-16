import 'package:flutter/material.dart';
import 'package:health_truck/providers/login_provider.dart';
import 'package:get/get.dart';

import '../widget/button.dart';
import '../widget/textFormField.dart';
import '../widget/text_labels.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Get.put(LoginProvider());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: loginProvider.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 45),
                  child: Image.asset(
                    'assets/images/icon.png',
                    width: 250,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 492,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildTexTitle('Faça seu acesso'),
                        buildText('Email'),
                        textForm(
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined),
                          controller: loginProvider.emailController,
                          textInputType: TextInputType.emailAddress,
                          obscureText: false,
                          autofillHints: [AutofillHints.username],
                        ),
                        buildText('Senha'),
                        textForm(
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.vpn_key),
                          controller: loginProvider.passwordController,
                          textInputType: TextInputType.visiblePassword,
                          obscureText: true,
                          autofillHints: [AutofillHints.password],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: SizedBox(
                            height: 50,
                            child: customElevatedButton(
                              context: context,
                              text: 'Login',
                              onPress: () => loginProvider.login(),
                              onLoad: loginProvider.isLogin?.isTrue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: SizedBox(
                            width: 10,
                            child: customElevatedButton(
                              context: context,
                              text: 'Criar minha conta',
                              onPress: () => loginProvider.goToCreateUser(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
