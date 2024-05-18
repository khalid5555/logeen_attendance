import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logeen_attendance/app/modules/home/home_controller.dart';
import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/app_images.dart';
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../core/widgets/login_form.dart';
import '../admin/admin.dart';
import '../home/home_page.dart';
import 'login_controller.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  final controller = Get.put(LoginController());
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 55),
              SizedBox(
                height: 290.h,
                width: 290.w,
                child: Image.asset(
                  AppImages.login_logo,
                  fit: BoxFit.cover,
                  // height: 290.h,
                  // width: 270.w,
                ),
              ),
              const LoginForm(),
              // Text  login
              const SizedBox(height: 25),
              Obx(() {
                return controller.isLoading.value == true
                    ? const ShowLoading()
                    : Container(
                        padding: const EdgeInsetsDirectional.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.kTeal,
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.r),
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            controller.isLoading.value = true;
                            // await Future.delayed(const Duration(seconds: 5));
                            await controller.print_location();
                            if (controller.name.text.trim().isEmpty ||
                                controller.email.text.trim().isEmpty ||
                                controller.password.text.trim().isEmpty) {
                              Get.snackbar(
                                'تنبية',
                                'الرجاء ملىء الحقل',
                                icon: const Icon(Icons.error_outline_outlined),
                                colorText: AppColors.kRED,
                              );
                              // controller.isLoading.value = false;
                            } else if (controller.email.text.trim() ==
                                'mahmoud_admin_logeen_attendance@gmail.com') {
                              controller.isLoading.value = true;
                              Get.off(() => const Admin());
                              controller.box.write("login_admin", true);
                              // controller.print_location();
                              controller.isLoading.value = false;
                            } else {
                              controller.isLoading.value = true;
                              bool isConnected =
                                  await controller.checkInternetConnection();
                              if (isConnected) {
                                bool emailExists =
                                    await controller.checkEmailExists(
                                        controller.email.text.trim());
                                if (emailExists) {
                                  await controller.box.write(
                                      "email", controller.email.text.trim());
                                  await controller.box
                                      .write("login_employee", true);
                                  Get.off(() => const HomePage());
                                  await homeController.getCheckInAndOut();
                                  controller.isLoading.value = false;
                                } else {
                                  Get.snackbar(
                                    'غير موجود',
                                    "حاول مرة اخري قد يكون بسبب النت",
                                  );
                                  Get.off(() => const AuthPage());
                                }
                              } else {
                                Get.snackbar(
                                  'تنبيه',
                                  'لا يوجد اتصال بالإنترنت',
                                  icon:
                                      const Icon(Icons.error_outline_outlined),
                                  colorText: AppColors.kRED,
                                );
                              }
                              controller.print_location();
                              controller.isLoading.value = false;
                            }
                          },
                          /*  onTap: () async {
                            controller.isLoading.value = true;
                            // await Future.delayed(const Duration(seconds: 5));
                            await controller.print_location();
                            if (controller.name.text.trim().isEmpty ||
                                controller.email.text.trim().isEmpty ||
                                controller.password.text.trim().isEmpty) {
                              Get.snackbar(
                                'تنبية',
                                'الرجاء ملىء الحقل',
                                icon: const Icon(Icons.error_outline_outlined),
                                colorText: AppColors.kRED,
                              );
                              controller.isLoading.value = false;
                            } else if (controller.email.text.trim() ==
                                'mahmoud_admin_logeen_attendance@gmail.com') {
                              controller.isLoading.value = true;
                              Get.off(() => const Admin());
                              controller.box.write("login_admin", true);
                              // controller.print_location();
                              controller.isLoading.value = false;
                            } else {
                              controller.isLoading.value = true;
                              bool emailExists =
                                  await controller.checkEmailExists(
                                      controller.email.text.trim());
                              if (emailExists) {
                                controller.box.write(
                                    "email", controller.email.text.trim());
                                controller.box.write("login_employee", true);
                                await Get.off(() => const HomePage());
                                // box.write("login_employee", true);
                                // printInfo(
                                //   info:
                                //       "employee[i].email= ${controller.employees[i].email}",
                                // );
                              } else {
                                Get.snackbar(
                                  'غير موجود',
                                  "حاول مرة اخري قد يكون بسبب النت",
                                );
                                Get.off(() => const AuthPage());
                              }
                              controller.print_location();
                              controller.isLoading.value = false;
                            }
                          }, */
                          /*  onTap: () async {
                             controller.isLoading.value = true;
                            // await Future.delayed(const Duration(seconds: 5));
                            await controller.print_location();
                            if (controller.name.text.trim().isEmpty ||
                                controller.email.text.trim().isEmpty ||
                                controller.password.text.trim().isEmpty) {
                              Get.snackbar(
                                'تنبية',
                                'الرجاء ملىء الحقل',
                                icon: const Icon(Icons.error_outline_outlined),
                                colorText: AppColors.kRED,
                              );
                              controller.isLoading.value = false;
                            } else if (controller.email.text.trim() ==
                                'mahmoud_admin_logeen_attendance@gmail.com') {
                              controller.isLoading.value = true;
                              // controller.addEmployee(
                              //   EmployeeModel(
                              //     name: controller.name.text.trim(),
                              //     email: controller.email.text.trim(),
                              //     passWord: controller.password.text.trim(),
                              //   ),
                              // );
                              Get.off(() => const Admin());
                              controller.box.write("login_admin", true);
                              // controller.print_location();
                              controller.isLoading.value = false;
                            } else {
                              controller.isLoading.value = true;
                              for (var i = 0;
                                  i < controller.employees.length;
                                  i++) {
                                if (controller.email.text.trim() ==
                                    controller.employees[i].email) {
                                  await controller.box.write(
                                      "email", controller.email.text.trim());
                                  await controller.box
                                      .write("login_employee", true);
                                  await Get.off(() => const HomePage());
                                  // box.write("login_employee", true);
                                  printInfo(
                                      info:
                                          "employee[i].email= ${controller.employees[i].email}");
                                }
                                /* else if (email.text.trim() ==
                                      'admin_employee@gmail.com') {
                                    box.write("email", email.text);
                                    Get.off(() => const Admin());
                                    box.write("Email_employee", email.text);
                                    printInfo(
                                        info:
                                            "my email  ${employeeController.box.read('email')}");
                                  } */
                                else {
                                  Get.snackbar('غير موجود',
                                      "حاول مرة اخري قد يكون بسبب النت");
                                  Get.off(() => const AuthPage());
                                }
                              }
                              controller.print_location();
                              controller.isLoading.value = false;
                            } 
                          },*/
                          child: const App_Text(
                            data: "تسجيل الدخول",
                            color: AppColors.kWhite,
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
