import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_truck/widget/text_labels.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/button.dart';
import '../widget/default_layout.dart';
import '../widget/textFormField.dart';

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _weightController =
      TextEditingController(text: "");
  final TextEditingController _heightController =
      TextEditingController(text: "");
  final TextEditingController _ageController = TextEditingController(text: "");
  double _imc = 0.0;
  String _imcResult = '';

  @override
  void initState() {
    super.initState();
    _loadData();
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
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    hintText: 'Exemple: 50'),
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Altura (m)', hintText: 'Exemple: 1.56'),
                inputFormatters: [LengthLimitingTextInputFormatter(4)],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Idade', hintText: 'Exemple: 30'),
                inputFormatters: [LengthLimitingTextInputFormatter(3)],
              ),
              const SizedBox(height: 20),
              customElevatedButton(
                context: context,
                text: 'Calcular',
                onPress: () {
                  if (_validateFields()) {
                    _calculateIMC();
                    _saveData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, preencha todos os campos!'),
                      ),
                    );
                  }
                },
                color: Colors.black12,
              ),
              const SizedBox(height: 20),
              Text(
                'Seu IMC: $_imcResult',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Último IMC: $_imc',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    return _weightController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _ageController.text.isNotEmpty;
  }

  void _calculateIMC() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);
    double heightSquared = height * height;
    double imc = weight / heightSquared;
    String result = _calculateResult(imc);

    setState(() {
      _imc = double.parse(imc.toStringAsFixed(1));
      _imcResult = result;
    });
  }

  String _calculateResult(double imc) {
    if (imc == 0.0) return '';
    if (imc < 18.5) {
      return 'Abaixo do peso';
    } else if (imc >= 18.5 && imc < 24.9) {
      return 'Peso Normal';
    } else if (imc >= 25 && imc < 29.9) {
      return 'Sobrepeso';
    } else {
      return 'Obesidade';
    }
  }

  void _saveData() async {
    //TODO: Salva na memória do telefone
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', double.parse(_weightController.text));
    await prefs.setDouble('height', double.parse(_heightController.text));
    await prefs.setInt('age', int.parse(_ageController.text));
    await prefs.setDouble('lastIMC', _imc);
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('weight')) return;
    setState(() {
      _weightController.text = prefs.getDouble('weight').toString();
      _heightController.text = prefs.getDouble('height').toString();
      _ageController.text = prefs.getInt('age').toString();
      _imc = prefs.getDouble('lastIMC') ?? 0.0;
      _imcResult = _calculateResult(_imc);
    });
  }
}
