import 'package:get/get.dart';
import 'package:health_truck/screens/splash.dart';
import '../screens/imc.dart';
import '../screens/agenda.dart';
import '../screens/medication.dart';
import '../screens/bula.dart';
import './routes.dart';

class Pages {
  static final list = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.imc, page: () => const IMCCalculator()),
    GetPage(name: Routes.agendaMedica, page: () => const AgendaMedica()),
    GetPage(name: Routes.medication, page: () => const MedicationReminderApp()),
    GetPage(name: Routes.bula, page: () => const BulaApp())
  ];
}
