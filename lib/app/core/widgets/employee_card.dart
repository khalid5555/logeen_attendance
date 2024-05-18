import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../data/models/attendance_model.dart';
import '../shared/utils/app_colors.dart';
import '../shared/utils/app_images.dart';
import '../shared/widgets/app_text.dart';

class EmployeeCard extends StatelessWidget {
  final int? index;
  final AttendanceModel attendance;
  const EmployeeCard({Key? key, this.index = 0, required this.attendance})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.only(top: 8, bottom: 0),
      height: 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: index!.isEven
            ? AppColors.kTeal.withOpacity(.7)
            : AppColors.signUpBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.kCyan,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          App_Text(data: attendance.name.toString()),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const App_Text(data: "وقت الحضور"),
                  SizedBox(height: 6.h),
                  App_Text(
                    // data: timeFormat.value,
                    data:
                        (attendance.checkIn == null || attendance.checkIn == "")
                            ? '00:00:00'
                            : DateFormat('hh:mm:ss a', "ar")
                                .format(attendance.checkIn!)
                                .toString(),
                    size: 15,
                    color: AppColors.kWhite,
                    // paddingHorizontal: 10,
                    // paddingVertical: 8,
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
                child: Image.asset(
                  AppImages.calendar_admin,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  const App_Text(data: "وقت الانصراف"),
                  SizedBox(height: 8.h),
                  App_Text(
                    data: (attendance.checkOut == null ||
                            attendance.checkOut == "")
                        ? '00:00:00'
                        : DateFormat(' hh:mm:ss a', "ar")
                            .format(attendance.checkOut!)
                            .toString(),
                    // data: homeCtrl.checkOut.toString(),
                    size: 15,
                    color: AppColors.kWhite,
                    // direction: TextDirection.ltr,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          App_Text(
            data: attendance.email.toString(),
            size: 10,
          ),
          App_Text(
            data: DateFormat('dd /MM /yyyy', "ar")
                .format(attendance.createAt!.toDate())
                .toString(),
            size: 16,
          ),
        ],
      ),
    );
  }
}
