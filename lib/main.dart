import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_truck/routes/pages.dart';
import 'package:health_truck/routes/routes.dart';
import 'package:health_truck/services/create_user_service.dart';
import 'package:health_truck/services/login_service.dart';

import 'services/client_http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ClientHttp(baseUrl: 'http://143.244.189.35:8000/');
  Get.put(apiClient);
  runApp(
    HealthTruck(),
  );
}

class HealthTruck extends StatelessWidget {

  const HealthTruck({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(409, 885.62),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Health Truck',
          theme: ThemeData.dark().copyWith(
            textTheme: Typography().white.apply(fontFamily: 'TitilliumWeb'),
          ),
          initialBinding: BindingsBuilder(() {
            Get.put(AuthService());
            Get.put(CreateUserService());
          }),
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splash,
          getPages: Pages.list,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            );
          },
        );
      },
    );
  }
}
