import 'package:flutter/material.dart';
import 'package:health_truck/constants_colors.dart';
import 'package:health_truck/providers/create_user_provider.dart';

import '../widget/button.dart';
import '../widget/textFormField.dart';
import '../widget/text_labels.dart';

class CreateUser extends StatelessWidget {
  const CreateUser({super.key});

  @override
  Widget build(BuildContext context) {
    final createUserProvider = CreateUserProvider();

    return Scaffold(
      backgroundColor: ColorsDefaults.background,
      appBar: AppBar(
        title: buildTexTitle('Crie sua conta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Form(
        key: createUserProvider.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText('Nome'),
                textForm(
                  textInputAction: TextInputAction.next,
                  maxLength: 50,
                  ignoreReg: true,
                  controller: createUserProvider.nameController,
                  textInputType: TextInputType.text,
                  obscureText: false,
                  autofillHints: [AutofillHints.name],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText('Altura'),
                          textForm(
                            textInputAction: TextInputAction.next,
                            maxLength: 3,
                            controller: createUserProvider.heightController,
                            textInputType: TextInputType.number,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 11.0),
                              child: Text('cm', style: TextStyle(color: Colors.black)),
                            ),
                            obscureText: false,
                            autofillHints: [AutofillHints.name],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText('Peso'),
                          textForm(
                            textInputAction: TextInputAction.next,
                            maxLength: 3,
                            controller: createUserProvider.weightController,
                            textInputType: TextInputType.number,
                            obscureText: false,
                            autofillHints: [AutofillHints.name],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                buildText('E-mail'),
                textForm(
                  textInputAction: TextInputAction.next,
                  controller: createUserProvider.emailController,
                  prefixIcon: Icon(Icons.email_outlined),
                  textInputType: TextInputType.emailAddress,
                  obscureText: false,
                  autofillHints: [AutofillHints.username],
                ),
                buildText('Senha'),
                textForm(
                  textInputAction: TextInputAction.next,
                  maxLength: 8,
                  controller: createUserProvider.passwordController,
                  prefixIcon: Icon(Icons.lock_outline),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) => createUserProvider.comparePassword(value),
                  obscureText: false,
                  autofillHints: [AutofillHints.username],
                ),
                buildText('Confirme sua senha'),
                textForm(
                  textInputAction: TextInputAction.next,
                  maxLength: 8,
                  controller: createUserProvider.confirmPasswordController,
                  prefixIcon: Icon(Icons.lock_outline),
                  textInputType: TextInputType.emailAddress,
                  validator: (value) => createUserProvider.comparePassword(value),
                  obscureText: false,
                  autofillHints: [AutofillHints.username],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: customElevatedButton(
                    context: context,
                    text: 'Cadastrar',
                    onPress: () => createUserProvider.createUser(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
