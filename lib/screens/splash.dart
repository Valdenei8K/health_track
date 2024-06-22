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
                Color(0xFF008000),//verde escuro
                Color(0xFF00FF00),//verde claro
                //Color.fromARGB(255, 26, 26, 21), Marrom
                //Color.fromARGB(59, 130, 273, 0) Marrom
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
                    color: Colors.white, fontWeight: FontWeight.bold
                  ),),
                // Substitua o AssetImage pelo caminho da sua imagem
                SvgPicture.asset(
                  'assets/images/fitness.svg', // Caminho da sua imagem HT
                  width: 150,
                  height: 150,
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
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/imc'),
                    child: const Text('Calcular IMC'),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/medication'),
                    child: const Text('Lembrete de Medicamentos',style: TextStyle(
                      fontSize: 16, //tamanho da fonte
                    ),),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.grey.shade300),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/agenda_medica'),
                    child: const Text('Agendar Consultas'),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text('Sair'),
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
