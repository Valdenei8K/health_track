import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../services/client_http.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
  initialPage();
    super.initState();
  }

  Future<void> initialPage() async {
    await Future.delayed(const Duration(seconds: 3));
    final access = Get.find<ClientHttp>().accessToken.value;
    final refresh = Get.find<ClientHttp>().refreshToken.value;
    if (access.isNotEmpty && refresh.isNotEmpty) {
      Get.toNamed(Routes.home);
    } else {
      Get.toNamed(Routes.login);
    }
  }

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
