import 'package:flutter/material.dart';
import 'package:health_truck/constants_colors.dart';
import 'package:health_truck/widget/text_labels.dart';
import 'package:get/get.dart';
import '../providers/imc_provider.dart';
import '../widget/button.dart';
import '../widget/default_layout.dart';
import '../widget/snack_bar.dart';
import '../widget/textFormField.dart';

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final imcProvider = Get.put(ImcProvider());

  @override
  void initState() {
    super.initState();
    imcProvider.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Calculadora de IMC',
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              buildText('Peso (kg)'),
              buildTextField(
                controller: imcProvider.weightController,
                keyboardType: TextInputType.number,
                hintText: 'Exemple: 50',
                length: 6,
                onChanged: (value) => imcProvider.validateFields(),
              ),
              buildText('Altura (m)'),
              buildTextField(
                controller: imcProvider.heightController,
                keyboardType: TextInputType.number,
                hintText: 'Exemple: 1.56',
                length: 4,
                onChanged: (value) => imcProvider.validateFields(),
              ),
              buildText('Idade'),
              buildTextField(
                controller: imcProvider.ageController,
                keyboardType: TextInputType.number,
                hintText: '30',
                length: 3,
                onChanged: (value) => imcProvider.validateFields(),
              ),
              const SizedBox(height: 20),
              customElevatedButton(
                context: context,
                text: 'Calcular',
                onPress: () {
                  if (imcProvider.validateFields()) {
                    imcProvider.submitForm();
                  } else {
                    SnackBarApp.error('Preencha todos os campos corretamente');
                  }
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Obx(
                  () {
                    return Container(
                      child: Column(
                        children: [
                          Text(
                            'Seu IMC: ${imcProvider.imcResult}',
                            style: TextStyle(
                                fontSize: 20, color: ColorsDefaults.background),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Último IMC: ${imcProvider.imc}',
                            style: TextStyle(
                                fontSize: 20, color: ColorsDefaults.background),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
