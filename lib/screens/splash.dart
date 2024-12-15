import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF248C85), // Verde escuro
                Color(0xFF79F1D5), // Verde claro
              ],
            )),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bem-vindo ao',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SvgPicture.asset(
                  'assets/images/fitness.svg', // Caminho da sua imagem
                  width: 150,
                  height: 150,
                  allowDrawingOutsideViewBox: true,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Meu Bem',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Saúde Equilibrada',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.blueGrey.shade800),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/imc'),
                    child: const Text(
                      'Calcular IMC',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // Tamanho da fonte
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.blueGrey.shade800),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/medication'),
                    child: const Text(
                      'Lembrete de Medicamentos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // Tamanho da fonte
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.blueGrey.shade800),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/agenda_medica'),
                    child: const Text(
                      'Lembrete de Consultas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // Tamanho da fonte
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.blueGrey.shade800),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/bula'),
                    child: const Text(
                      'Buscar Bula',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // Tamanho da fonte
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () => {
                      if (Platform.isAndroid)
                        {SystemNavigator.pop()}
                      else if (Platform.isIOS)
                        {exit(0)}
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white),
                    child: const Text(
                      'Sair',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
