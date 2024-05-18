// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/employee_model.dart';
class LoginController extends GetxController {
  GetStorage box = GetStorage();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static const employeesCollection = 'employees';
  String lat = '27.442';
  String lon = '30.821';
  // String lat = '27.442';
  // String lon = '30.821';
  String lat2 = "27.441";
  String long2 = "30.822";
  String? latitude;
  String? longitude;
  final _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  // RxList<EmployeeModel> employees2 = <EmployeeModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getEmployees();
    determinePosition();
    print_location();
    getEmployeeEmail();
    // getAllEmployees();
  }
  print_location() async {
    final position = await determinePosition();
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    update();
    printInfo(
        info:
            " lat== ${latitude.toString().substring(0, 6)} + long== ${longitude.toString().substring(0, 6)} ");
  }
  Future<bool> checkEmailExists(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(employeesCollection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
  Future<void> addEmployee(EmployeeModel user) async {
    try {
      // isLoading.value = true;
      final docUser = _firestore.collection(employeesCollection).doc();
      user.id = docUser.id;
      await docUser.set(user.toMap(), SetOptions(merge: true));
      // Get.snackbar('انتبه', 'تم اضافة موظف',
      //     colorText: AppColors.kWhite, backgroundColor: AppColors.signUpBg);
      // isLoading.value = false;
      getEmployees();
    } catch (e) {
      debugPrint('Error adding user: $e');
      isLoading.value = false;
    }
  }
  Future<void> deleteEmployee(String id) async {
    try {
      await _firestore.collection(employeesCollection).doc(id).delete();
      getEmployees();
    } catch (e) {
      debugPrint('Error deleting employee: $e');
    }
  }
  Future<void> updateEmployee(EmployeeModel employee) async {
    try {
      await _firestore
          .collection(employeesCollection)
          .doc(employee.id)
          .set(employee.toMap(), SetOptions(merge: true));
      getEmployees();
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }
  Future<void> getEmployees() async {
    return await _firestore
        .collection(employeesCollection)
        .orderBy('createdAt', descending: true)
        .get()
        .then((snapshot) {
      employees.assignAll(snapshot.docs.map((doc) {
        return EmployeeModel.fromMap(doc.data());
      }));
      update();
    });
  }
  Future<void> getEmployeeEmail() async {
    await getEmployees();
    var email = box.read("email");
    debugPrint('email: $email');
    // printInfo(info: 'employees.first.email: ${employees[1].email}');
    /*  bool test = */ employees.where((element) {
      element.email == email;
      // if (element.email == email) {
      printInfo(info: 'employees.first.email: ${element.email}');
      // }
      return true;
    }
        // printInfo(info: 'employees.first.email: ${element.email}');
        // return true;
        );
    update();
/*     if (test) {
      printInfo(info: 'employees.first.email: $email');
    } else {} */
    /*  for (var i = 0; i < employees.length; i++) {
      printInfo(info: 'controller.employees.length: ${employees.length}');
      if (employees.any((element) {
        element.email == email;
        printInfo(info: 'employees.first.email: ${element.email}');
        return true;
      })) {
        // employeeId!.value = employees[i].id!;
        // nameEmployee = employees[i].name;
        update();
      }
    } */
    // printInfo(info: 'id: $employeeId');
    // printInfo(info: 'name: $nameEmployee');
  }
  /// When the location services are not enabled or permissions
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      printError(info: 'Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        printError(info: 'Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    update();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      // timeLimit: const Duration(seconds: 30),
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
