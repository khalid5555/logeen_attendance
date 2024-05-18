import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../screen_for_admin/screen_for_admin_controller.dart';
import './login_controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ScreenForAdminController>(() => ScreenForAdminController());
  }
}
