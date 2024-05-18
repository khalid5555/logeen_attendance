import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/attendance_model.dart';
import '../../data/models/employee_model.dart';
import '../login/login_controller.dart';

class ScreenForAdminController extends GetxController {
  GetStorage box = GetStorage();
  static const attendanceCollection = 'attendance_employees';
  LoginController controller = Get.find<LoginController>();
  // String lat = '27.442';
  // String lon = '30.821';
  final _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxList<AttendanceModel> adminAttendanceList = <AttendanceModel>[].obs;
  RxList<AttendanceModel> allAdminAttendanceList = <AttendanceModel>[].obs;
  RxString? employeeId = "".obs;
  List? atte;
  String? nameEmployee;
  Rx<DateTime> time = DateTime.now().obs;
  Rx<DateTime>? allTime = DateTime.now().obs;
  DateTime? checkIn;
  DateTime? checkOut;
  String? checkOut2 = '00:00';
  @override
  void onInit() {
    super.onInit();
    getAttendanceToAdmin();
    getAttendanceToAdminAllDay();
  }

  Future<void> getAttendanceToAdmin() async {
    return await _firestore
        .collection(attendanceCollection)
        .doc(time.value.toString().split(' ')[0])
        .collection("today")
        .orderBy("createAt", descending: true)
        .get()
        .then((snapshot) async {
      adminAttendanceList.assignAll(snapshot.docs.map((doc) {
        update();
        return AttendanceModel.fromMap(doc.data());
      }));
      // printInfo(
      //     info: 'adminAttendanceList.length: ${adminAttendanceList.length}');
      // printInfo(info: 'attendance: ${adminAttendanceList.last.email}');
      update();
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<void> getAttendanceToAdminAllDay() async {
    return await _firestore
        .collection(attendanceCollection)
        .doc(allTime!.value.toString().split(' ')[0])
        .collection("today")
        .orderBy("createAt", descending: true)
        .get()
        .then((snapshot) async {
      allAdminAttendanceList.assignAll(snapshot.docs.map((doc) {
        update();
        return AttendanceModel.fromMap(doc.data());
      }));
      printInfo(
          info:
              'getAttendanceToAdminAllDay_allAdminAttendanceList: ${allAdminAttendanceList.length}');
      update();
    }).catchError((error) {
      print(error.toString());
    });
  }
}

  /* Future<void> getAttendanceToAdmin() async {
    try {
      final snapshot = await _firestore
          .collection(attendanceCollection)
          .doc(time.value.toString().split(' ')[0])
          .collection("today")
          .get();
      final length = snapshot.docs.length;
      print('adminAttendanceList.length: $length');
      adminAttendanceList.clear(); // Clear the list before adding new documents
      for (final doc in snapshot.docs) {
        final email = doc.id;
        print('Document ID: ${doc.id}');
        print(
            'Document Data: ${doc.data()}'); // Retrieve the email address from the document ID
        print('Email: $email');
        adminAttendanceList.add(AttendanceModel.fromMap(doc.data()));
      }
      update();
    } catch (error) {
      print(error.toString());
    }
  }
 */
  /*  Future<void> getAttendanceToAdmin() async {
    List atte = [];
    await _firestore
        .collection(attendanceCollection)
        // .doc()
        .doc(time.value.toString().split(' ')[0])
        // .collection('today')
        .get()
        .then((value) {
      // atte.addAll(value.data());
      atte.add(value);
    });
    // printInfo(info: "dd.toString() ${atte.length}");
    // printInfo(info: "dd.toString() ${value.docs.length}")
    // try {
    /* await _firestore
        .collection(attendanceCollection)
        .doc(time.value.toString().split(' ')[0])
        .collection("today")
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          print('${querySnapshot.docs.length} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    ); */
    /*   final snapshot = await _firestore
          .collection(attendanceCollection)
          .doc(time.value.toString().split(' ')[0])
          .collection("today")
          .orderBy("createAt", descending: true)
          .get();
      final length = snapshot.docs;
      print('adminAttendanceList.length: $length');
      adminAttendanceList.clear(); // Clear the list before adding new documents
      for (var doc in snapshot.docs) {
        final email = doc.id; // Retrieve the email address from the document ID
        print('Email: $email');
        adminAttendanceList.add(AttendanceModel.fromMap(doc.data()));
      }
      update();
    } catch (error) {
      print(error.toString());
    } */
  }
 */
