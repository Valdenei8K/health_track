import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_truck/providers/imc_provider.dart';
import 'package:health_truck/routes/pages.dart';
import 'package:health_truck/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ImcProvider>(
          create: (_) => ImcProvider(),
        )
      ],
      child: const HealthTruck(),
    ),
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
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splash,
          getPages: Pages.list,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1)),
              child: child!,
            );
          },
        );
      },
    );
  }
}
