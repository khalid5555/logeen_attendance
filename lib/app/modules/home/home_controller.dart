import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/employee_model.dart';
import '../login/login_controller.dart';

class HomeController extends GetxController {
  GetStorage box = GetStorage();
  static const attendanceCollection = 'attendance_employees';
  // LoginController controller = Get.find<LoginController>();
  // String lat = '27.442';
  // String lon = '30.821';
  final _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxList<AttendanceModel> attendanceList = <AttendanceModel>[].obs;
  // RxList allDayList = [].obs;
  RxString? employeeId = "".obs;
  String? nameEmployee;
  Rx<DateTime> time = DateTime.now().obs;
  DateTime? checkIn;
  DateTime? checkOut;
  String? checkOut2 = '00:00';
  @override
  void onInit() {
    getEmployeeId();
    // getAttendanceId();
    getAttendanceToDay();
    getEmployees();
    // getAttendance();
    // getAllDocuments();
    // methodName();
    super.onInit();
    // printInfo(info: 'attendance: ${attendance.length}');
  }

  Future<void> getEmployeeId() async {
    await getEmployees();
    var email = box.read("email");
    debugPrint('email: $email');
    for (var i = 0; i < employees.length; i++) {
      printInfo(info: 'controller.employees.length: ${employees.length}');
      if (email == employees[i].email) {
        employeeId!.value = employees[i].id!;
        nameEmployee = employees[i].name;
        update();
      }
      // employee.addIf(
      //     email == controller.employees[i].email, controller.employees[i].id);
    }
    printInfo(info: 'id: $employeeId');
    printInfo(info: 'name: $nameEmployee');
  }


 /* Future<void> getAttendanceId() async {
//getAttendanceToDay();
    var email = box.read("email");
    debugPrint('email getAttendanceId : $email');
    for (var i = 0; i < attendanceList.length; i++) {
      if (email == attendanceList[i].email) {
        // employeeId = attendanceList[i].id;
        checkIn!.value = attendanceList[i].checkIn!;
        checkOut!.value = attendanceList[i].checkOut!;
        // checkIn!.value =
        //     DateFormat.jms('ar').format(attendanceList[i].checkIn!);
        checkOut2 = attendanceList[i].checkOut.toString();
        update();
        // checkOut2 =
        //     attendanceList[i].checkOut.toString().split(' ')[1].split('.')[0];
        printInfo(info: 'checkIn1: $checkIn');
        printInfo(info: 'checkOut: $checkOut');
        printInfo(info: 'checkOut2: $checkOut2');
      }
      printInfo(info: 'checkIn: $checkIn');
      printInfo(info: 'checkOut: $checkOut');
      // employee.addIf(
      //     email == controller.employees[i].email, controller.employees[i].id);
    }
    printInfo(info: 'checkIn: $checkIn');
    printInfo(info: 'checkOut: $checkOut');
    // await getEmployeeId();
    update();
  }
 */
  Future<void> getCheckInAndOut() async {
    var email = box.read("email");
    debugPrint('email getAttendanceId : $email');
    var attendanceData = attendanceList.firstWhere(
        (attendance) => attendance.email == email,
        orElse: () => AttendanceModel());
    checkIn = attendanceData.checkIn!;
    checkOut = attendanceData.checkOut!;
    checkOut2 = attendanceData.checkOut.toString();
    update();
    printInfo(info: 'checkIn1: $checkIn');
    printInfo(info: 'checkOut: $checkOut');
    // printInfo(info: 'checkOut2: $checkOut2');
  }

  Future<void> addCheckIn(AttendanceModel attendanceModel) async {
    // attendanceModel.id = employee!.toString();
    try {
      isLoading.value = true;
      await _firestore
          .collection(attendanceCollection)
          .doc(time.value.toString().split(' ')[0])
          .collection("today")
          .doc(box.read("email"))
          .set(
            attendanceModel.toMap(),
            SetOptions(merge: true),
          );
      Get.snackbar('انتبه', 'تم تسجيل الحضور ',
          colorText: AppColors.kWhite, backgroundColor: AppColors.signUpBg);
      // await getAttendanceToDay();
      await getCheckInAndOut();
      isLoading.value = false;
      update();
      // getEmployees();
    } catch (e) {
      debugPrint('Error adding user: $e');
      // isLoading.value = false;
    }
  }

  Future<void> addCheckOut(AttendanceModel attendanceModel) async {
    // attendanceModel.id = employee!.toString();
    try {
      isLoading.value = true;
      await _firestore
          .collection(attendanceCollection)
          .doc(time.value.toString().split(' ')[0])
          .collection("today")
          .doc(box.read("email"))
          .set(
            attendanceModel.toMap(),
            SetOptions(merge: true),
          );
      // update();
      Get.snackbar('انتبه', 'تم تسجيل الانصراف ',
          colorText: AppColors.kWhite, backgroundColor: AppColors.signUpBg);
      isLoading.value = false;
      await getCheckInAndOut();
      update();
      // getEmployees();
    } catch (e) {
      debugPrint('Error adding user: $e');
      // isLoading.value = false;
    }
  }

  Future<void> getAttendanceToDay() async {
    return await _firestore
        .collection(attendanceCollection)
        // .doc(box.read("email"))
        .doc(time.value.toString().split(' ')[0])
        .collection("today")
        .get()
        .then((snapshot) async {
      attendanceList.assignAll(snapshot.docs.map((doc) {
        update();
        return AttendanceModel.fromMap(doc.data());
      }));
      // getEmployees();
      // getEmployeeId();
      await getCheckInAndOut();
      printInfo(info: 'attendance: ${attendanceList.length}');
      // printInfo(info: 'attendance 2222: ${attendanceList.first.id}');
      update();
    }).catchError((error) {
      print(error.toString());
    });
  }

  /* Future getAllDocuments() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(attendanceCollection)
        .doc(time.value.toString().split(' ')[0].substring(5, 7))
        // .where(time.value.toString().split(' ')[0].substring(5, 7),
        //     isEqualTo: '11')
        .get();
    return snapshot;
  } */
  /* void methodName() async {
    List<DocumentSnapshot<Map<String, dynamic>>> documents =
        await getAllDocuments();
    printInfo(
        info:
            'documents: ${documents.length}'); // List<String> documentNames = await getAttendance2();
    // printInfo(
    //     info:
    //         "printInfo(info: ${time.value.toString().split(' ')[0].substring(5, 7)}");
  } */
  /* Future<void> getAttendance() async {
    await _firestore
        .collection(attendanceCollection)
        // .doc()
        // .collection("today")
        .get()
        .then((value) {
      value.size;
      printInfo(info: 'allDayList get: ${value.size}');
    });
    /*  .then((snapshot) {
      allDayList.assignAll(snapshot.docs.map((doc) {
        printInfo(info: 'allDayList: $doc');
        return AttendanceModel.fromMap(doc.data());
      }));
      printInfo(info: 'allDayList getAttendance(): ${allDayList.length}');
    }); */
  } */
  Future<void> getEmployees() async {
    return await _firestore
        .collection(LoginController.employeesCollection)
        .get()
        .then((snapshot) {
      employees.assignAll(snapshot.docs.map((doc) {
        return EmployeeModel.fromMap(doc.data());
      }));
    });
  }
}
