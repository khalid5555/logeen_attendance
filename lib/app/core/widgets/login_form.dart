import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../shared/widgets/app_text_field.dart';
import '../../modules/login/login_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Padding(
      padding: EdgeInsets.only(right: 15.w, left: 15.w),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(flex: 1),
            AppTextField(
              myController: controller.name,
              hint: 'ادخل الاسم',
              icon: Icons.person_3_outlined,
              color: Colors.black,
            ),
            SizedBox(height: 15.h),
            AppTextField(
              myController: controller.email,
              hint: 'ادخل الايميل',
              icon: Icons.email_outlined,
              color: Colors.black,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15.h),
            AppTextField(
              myController: controller.password,
              obscureText: true,
              color: Colors.black,
              hint: 'أدخل الرقم السري',
              icon: Icons.password_rounded,
              textInputType: TextInputType.number,
            ),
            // const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
