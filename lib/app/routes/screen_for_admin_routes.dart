import 'package:get/get.dart';
import 'package:logeen_attendance/app/modules/login/auth_page.dart';
import 'package:logeen_attendance/app/modules/login/login_bindings.dart';
import 'package:logeen_attendance/app/modules/splash_view.dart';

import '../modules/admin/add_employee.dart';
import '../modules/employee/EmployeeScreen.dart';
import '../modules/home/home_page.dart';
import '../modules/screen_for_admin/screen_for_admin_page.dart';

class ScreenForAdminRoutes {
  ScreenForAdminRoutes._();
  static const screenForAdmin = '/screen-for-admin';
  static const splashPage = '/';
  static const authPage = '/authPage';
  static const employeeScreen = '/employeeScreen';
  static const addEmployee = '/addEmployee';
  static const homePage = '/homePage';
  static final routes = [
    GetPage(
      name: screenForAdmin,
      page: () => ScreenForAdminPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: splashPage,
      page: () => const SplashPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: authPage,
      page: () => const AuthPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: homePage,
      page: () => const HomePage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: employeeScreen,
      page: () => EmployeeScreen(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: addEmployee,
      page: () => const Add_employee(),
      binding: LoginBindings(),
    ),
  ];
}
