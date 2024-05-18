import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logeen_attendance/app/core/shared/utils/app_images.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/constants.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../core/widgets/employee_card.dart';
import 'screen_for_admin_controller.dart';

class ScreenForAdminPage extends GetView<ScreenForAdminController> {
  const ScreenForAdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConst.recolor().withOpacity(.5),
        title: const Text('كشف الحضور والانصراف'),
        centerTitle: true,
      ),
      floatingActionButton: Card(
        // margin: const EdgeInsets.all(10),
        elevation: 20.0,
        color: AppColors.kTeal,
        child: GestureDetector(
          onTap: () {
            Get.bottomSheet(
              StatefulBuilder(
                builder: (_, __) {
                  return CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 2),
                    lastDate: DateTime(DateTime.now().year + 300, 12, 31),
                    onDateChanged: (newDate) {
                      controller.allTime!.value = newDate;
                      controller.getAttendanceToAdminAllDay();
                    },
                  );
                },
              ),
              backgroundColor: Colors.white,
            );
            /*   Get.defaultDialog(
              title: "",
              backgroundColor: AppColors.kWhite,
              content: StatefulBuilder(
                builder: (_, __) {
                  return CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 2),
                    lastDate: DateTime(DateTime.now().year + 300, 12, 31),
                    onDateChanged: (newDate) {
                      controller.allTime!.value = newDate;
                      controller.getAttendanceToAdminAllDay();
                    },
                  );
                },
              ),
            ); */
          },
          child: Image.asset(
            AppImages.calendar,
            fit: BoxFit.contain,
            height: 60.h,
            width: 60.w,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GetBuilder<ScreenForAdminController>(
            init: ScreenForAdminController(),
            builder: (_) {
              return controller.allAdminAttendanceList.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        App_Text(
                            size: 15,
                            data:
                                "عدد الحضور ( ${controller.allAdminAttendanceList.length} )"),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.allAdminAttendanceList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final attendance =
                                  controller.allAdminAttendanceList[index];
                              return EmployeeCard(
                                index: index,
                                attendance: attendance,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 260.h,
                          child: Image.asset(
                            AppImages.no_attendance,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 90.h),
                        const App_Text(data: "لا يوجد كشف غياب لهذا اليوم 😁"),
                        const Spacer(),
                      ],
                    );
            }),
      ),
    );
  }
}
