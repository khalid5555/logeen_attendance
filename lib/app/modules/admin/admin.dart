import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logeen_attendance/app/modules/login/login_controller.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/widgets/app_text.dart';
import '../employee/EmployeeScreen.dart';
import '../login/auth_page.dart';
import '../screen_for_admin/screen_for_admin_page.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        actions: [
          OutlinedButton(
            child: const App_Text(
              data: 'خروج',
              color: AppColors.kLIGHTGreen,
            ),
            onPressed: () {
              Get.find<LoginController>().box.remove('login_employee');
              Get.find<LoginController>().box.remove('email');
              Get.find<LoginController>().box.remove('login_admin');
              // Get.find<EmployeeController>().box.remove('Email_employee');
              Get.off(() => const AuthPage());
            },
          ),
        ],
        centerTitle: true,
        title: const Text(
          'لوحة تحكم الأدمن  ',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.home_filled),
              label: const App_Text(data: 'الصفحة الرئيسية'),
              onPressed: () {
                Get.to(() => ScreenForAdminPage());
              },
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_comment_outlined),
              label: const App_Text(data: 'اضافة موظف'),
              onPressed: () {
                Get.to(() => EmployeeScreen());
              },
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.receipt_outlined),
              label: const App_Text(data: ' تقارير  '),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: AppColors.kLIGHTGreen,
                      title: const Center(
                          child: App_Text(data: 'تقاريرالموظفين ')),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // App_Text(
                          //     data:
                          //         ' عدد جميع العملاء : ${Get.find<ClientController>().clients.length}'),
                          // App_Text(
                          //     data:
                          //         ' عدد جميع الطلاب : ${Get.find<StudentController>().studentList.length}'),
                          App_Text(
                              data:
                                  ' عدد جميع الموظفين : ${Get.find<LoginController>().employees.length}'),
                        ],
                      ),
                      actions: <Widget>[
                        OutlinedButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
