import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/modules/home/home_controller.dart';
import 'app/modules/login/login_bindings.dart';
import 'app/modules/login/login_controller.dart';
import 'app/modules/screen_for_admin/screen_for_admin_controller.dart';
import 'app/routes/screen_for_admin_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    Get.put(LoginController());
    Get.put(HomeController());
    Get.put(ScreenForAdminController());
    return ScreenUtilInit(
        designSize: const Size(360.0, 729.3333333333334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'كشف الحضور',
            theme: ThemeData(
              // brightness: Brightness.dark,
              useMaterial3: true,
            ),
            initialBinding: LoginBindings(),
            // home: const SplashPage(),
            getPages: ScreenForAdminRoutes.routes,
            // home: const Admin(),
            // home: const HomePage(),
          );
        });
  }
}
