import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/utils/app_images.dart';
import '../../core/shared/utils/constants.dart';
import '../../core/shared/utils/show_loading.dart';
import '../../core/shared/widgets/app_text.dart';
import '../../data/models/attendance_model.dart';
import '../../modules/home/home_controller.dart';
import '../../modules/login/login_controller.dart';
import '../login/auth_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  LoginController controller = Get.find<LoginController>();
  HomeController homeCtrl = Get.find<HomeController>();
  Rx<DateTime> time = DateTime.now().obs;
  RxString dateFormat = RxString('');
  RxList shuffledData = [].obs;
  RxBool isLoading = false.obs;
  // RxString timeFormat = RxString('00:00:00');
  @override
  void initState() {
    // homeCtrl.getAttendanceId();
    dateFormat.value = DateFormat('EEE , d /M /y ', 'ar').format(time.value);
    // timeFormat.value = DateFormat.jms('ar').format(time.value);
    // timeFormat.value =
    //     DateFormat.jms('ar').format(homeCtrl.checkIn!).toString();
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   time.value = DateTime.now();
    //   dateFormat.value = DateFormat('EEE , d /M /y ', 'ar').format(time.value);
    //   timeFormat.value = DateFormat.jms('ar').format(time.value);
    setState(() {});
    // });
    loadAndShuffleJson();
    super.initState();
  }
  Future<void> loadAndShuffleJson() async {
    try {
      isLoading.value = true;
      String jsonString = await rootBundle.loadString(AppImages.quotesJson);
      List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        jsonData.shuffle();
        shuffledData.value = jsonData;
      });
      // printInfo(info: "shuffledData.length ${shuffledData.first['text']}");
      // printInfo(info: "shuffledData.length ${shuffledData.first['author']}");
      isLoading.value = false;
    } catch (e) {
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /* systemOverlayStyle: const SystemUiOverlayStyle(
            // statusBarColor: AppColors.kTeal,
            // systemNavigationBarColor: AppConst.recolor().withOpacity(.3),
            ), */
        backgroundColor: AppConst.recolor().withOpacity(.3),
        centerTitle: true,
        title: App_Text(
          data:
              "مرحباََ بك يا !   ${controller.box.read('email').split('@')[0]}",
          size: 15,
          color: AppColors.kBlue,
        ),
        /*  actions: [
          controller.box.read("email") == "khalidgamal@gmail.com"
              ? OutlinedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(0),
                  )),
                  onPressed: () {
                    Get.find<LoginController>().box.remove('login_employee');
                    Get.find<LoginController>().box.remove('email');
                    Get.find<LoginController>().box.remove('login_admin');
                    // Get.find<EmployeeController>().box.remove('Email_employee');
                    Get.off(() => const AuthPage());
                  },
                  child: const App_Text(
                    data: 'خروج',
                    size: 12,
                    color: AppColors.kBlACK,
                  ),
                )
              : const SizedBox()
        ],*/
        leading: controller.box.read("email") != "khalidgamal@gmail.com"
            ? Image.asset(AppImages.logeen_logo)
            : GestureDetector(
                onTap: () {
                  Get.find<LoginController>().box.remove('login_employee');
                  Get.find<LoginController>().box.remove('email');
                  Get.find<LoginController>().box.remove('login_admin');
                  // Get.find<EmployeeController>().box.remove('Email_employee');
                  Get.off(() => const AuthPage());
                },
                child: Image.asset(AppImages.logeen_logo),
              ),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(() {
          return
              /* (shuffledData.first['text'] == null ||
                    shuffledData.first['text'] == "" ||
                    shuffledData.first['author'] == null ||
                    shuffledData.first['author'] == "")
                ? const ShowLoading()
                : */
              Column(
            children: [
              Center(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        // color: AppColors.kCyan,
                        // offset: Offset(0, 2),
                        color: AppColors.kTeal,
                        offset: Offset(5, -5),
                        spreadRadius: 2,
                      ),
                    ],
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: App_Text(
                    data: dateFormat.value,
                    size: 20,
                    color: AppColors.kBlACK,
                    paddingHorizontal: 20,
                    paddingVertical: 10,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kTeal,
                      offset: Offset(0, 5),
                      // spreadRadius: 1,
                    ),
                  ],
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: DigitalClock(
                  is24HourTimeFormat: false,
                  amPmDigitTextStyle: const TextStyle(
                      locale: Locale('ar', 'AR'),
                      color: AppColors.kTeal,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  hourMinuteDigitTextStyle: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: Colors.black),
                  colon: const App_Text(
                    data: ':',
                    size: 30,
                    color: AppColors.kTeal,
                  ),
                  hourDigitDecoration: BoxDecoration(
                      color: AppColors.kTeal.withOpacity(.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.kLightBlue)),
                  // minuteDigitDecoration: BoxDecoration(
                  //     color: Colors.yellow,
                  //     border: Border.all(color: Colors.red, width: 2)),
                  secondDigitDecoration: BoxDecoration(
                      color: AppColors.kCyan,
                      border: Border.all(color: Colors.blue),
                      shape: BoxShape.circle),
                  secondDigitTextStyle: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: AppColors.kBlACK),
                ),
              ),
              SizedBox(height: 30.h),
              GetBuilder<HomeController>(
                  init: HomeController(),
                  builder: (_) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.kTeal,
                                    offset: Offset(0, 1),
                                    spreadRadius: 2,
                                  ),
                                ],
                                color: AppColors.kCyan,
                                borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(30),
                                  // bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: App_Text(
                                data: "وقت الحضور",
                                size: 15,
                                paddingHorizontal: 11,
                                paddingVertical: 3,
                                // direction: TextDirection.ltr,
                              ),
                            ),
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.kCyan,
                                    offset: Offset(0, 1),
                                    spreadRadius: 2,
                                  ),
                                ],
                                color: AppColors.kTeal,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  // bottomLeft: Radius.circular(40),
                                  // topRight: Radius.circular(10),
                                ),
                              ),
                              child: App_Text(
                                // data: timeFormat.value,
                                data: (homeCtrl.checkIn == null ||
                                        homeCtrl.checkIn == "")
                                    ? '00:00:00'
                                    : DateFormat('hh:mm:ss a', "ar")
                                        .format(homeCtrl.checkIn!)
                                        .toString(),
                                // data: homeCtrl.attendanceList[0].checkIn
                                //     .toString()
                                //     .split(" ")[1]
                                //     .split(".")[0],
                                size: 15,
                                color: AppColors.kWhite,
                                paddingHorizontal: 22.5,
                                paddingVertical: 8,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Image.asset(
                            AppImages.home,
                            fit: BoxFit.contain,
                            width: 100.w,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.kTeal,
                                    offset: Offset(0, 1),
                                    spreadRadius: 2,
                                  ),
                                ],
                                color: AppColors.kCyan,
                                borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(30),
                                  // bottomRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: App_Text(
                                data: "وقت الانصراف ",
                                size: 15,
                                paddingHorizontal: 6,
                                paddingVertical: 3,
                                // direction: TextDirection.ltr,
                              ),
                            ),
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.kCyan,
                                    offset: Offset(0, 1),
                                    spreadRadius: 2,
                                  ),
                                ],
                                color: AppColors.kTeal,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  // bottomLeft: Radius.circular(40),
                                  // topRight: Radius.circular(10),
                                ),
                              ),
                              child: App_Text(
                                data: (homeCtrl.checkOut == null ||
                                        homeCtrl.checkOut == "")
                                    ? '00:00:00'
                                    : DateFormat(' hh:mm:ss a', "ar")
                                        .format(homeCtrl.checkOut!)
                                        .toString(),
                                // data: homeCtrl.checkOut.toString(),
                                size: 15,
                                color: AppColors.kWhite,
                                paddingHorizontal: 22.5,
                                paddingVertical: 8,
                                // direction: TextDirection.ltr,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              SizedBox(height: 25.h),
              GetBuilder<LoginController>(
                init: LoginController(),
                builder: (_) {
                  return GetBuilder<HomeController>(
                      init: HomeController(),
                      builder: (homeCtrl) {
                        return controller.latitude == null &&
                                controller.longitude == null
                            ? const ShowLoading()
                            : ((controller.latitude
                                                .toString()
                                                .substring(0, 6) ==
                                            controller.lat ||
                                        controller.latitude
                                                .toString()
                                                .substring(0, 6) ==
                                            controller.lat2) &&
                                    (controller.longitude
                                                .toString()
                                                .substring(0, 6) ==
                                            controller.lon ||
                                        controller.longitude
                                                .toString()
                                                .substring(0, 6) ==
                                            controller.long2))
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      (homeCtrl.checkIn == null ||
                                              homeCtrl.checkIn == "")
                                          ? homeCtrl.isLoading.value == true
                                              ? const ShowLoading()
                                              : GestureDetector(
                                                  onTap: () async {
                                                    homeCtrl.getCheckInAndOut();
                                                    homeCtrl.getEmployeeId();
                                                    homeCtrl.addCheckIn(
                                                      AttendanceModel(
                                                        id: homeCtrl.employeeId!
                                                            .toString(),
                                                        name: homeCtrl
                                                            .nameEmployee!,
                                                        checkIn: DateTime.now(),
                                                        checkOut: null,
                                                        isPresent: true,
                                                        email: controller.box
                                                            .read('email'),
                                                        createAt:
                                                            Timestamp.now(),
                                                        latitude:
                                                            controller.latitude,
                                                        longitude: controller
                                                            .longitude,
                                                      ),
                                                    );
                                                    homeCtrl
                                                        .getAttendanceToDay();
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        AppColors.kWhite,
                                                    radius: 70,
                                                    child: Image.asset(
                                                      AppImages.check_in,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                )
                                          : CircleAvatar(
                                              backgroundColor: AppColors.kTeal,
                                              radius: 70,
                                              child: Image.asset(
                                                AppImages.check_in2,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                      // (homeCtrl.checkOut2!.isEmpty ||
                                      //         homeCtrl.checkOut2 == null)
                                      (homeCtrl.checkOut == null ||
                                              homeCtrl.checkOut == "")
                                          ? GestureDetector(
                                              onTap: () async {
                                                homeCtrl.getCheckInAndOut();
                                                await homeCtrl
                                                    .getAttendanceToDay();
                                                homeCtrl.addCheckOut(
                                                  AttendanceModel(
                                                    // id: homeCtrl.employeeId!.toString(),
                                                    // name: homeCtrl.nameEmployee!,
                                                    checkOut: DateTime.now(),
                                                    // isPresent: true,
                                                    // email: controller.box.read('email'),
                                                    // createAt: Timestamp.now(),
                                                    // latitude: controller.latitude,
                                                    // longitude: controller.longitude,
                                                  ),
                                                );
                                                await homeCtrl
                                                    .getAttendanceToDay();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.kWhite,
                                                radius: 70,
                                                child: Image.asset(
                                                  AppImages.check_in,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: AppColors.kTeal,
                                              radius: 70,
                                              child: Image.asset(
                                                AppImages.check_in2,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                    ],
                                  )
                                : controller.isLoading.value == true
                                    ? const ShowLoading()
                                    : Column(
                                        children: [
                                          Image.asset(
                                            AppImages.location,
                                            fit: BoxFit.contain,
                                            width: 150.w,
                                            // height: 120.h,
                                          ),
                                          OutlinedButton(
                                            onPressed: () async {
                                              controller.isLoading.value = true;
                                              await controller
                                                  .determinePosition();
                                              await controller.print_location();
                                              controller.isLoading.value =
                                                  false;
                                            },
                                            child: const App_Text(
                                              size: 12,
                                              data:
                                                  " انت غير موجود بالموقع \n اضغط هنا لتحديث الموقع ",
                                              maxLine: 2,
                                            ),
                                          ),
                                        ],
                                      );
                      });
                },
              ),
              /* controller.latitude == null && controller.longitude == null
                                        ? const ShowLoading()
                                        : (controller.latitude.toString().substring(0, 6) ==
                                                    homeCtrl.lat &&
                                                controller.longitude
                                                        .toString()
                                                        .substring(0, 6) ==
                                                    homeCtrl.lon)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  homeCtrl.employeeId!.isEmpty
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            homeCtrl.getEmployeeId();
                                                            homeCtrl.addCheckIn(
                                                              AttendanceModel(
                                                                id: homeCtrl.employeeId!
                                                                    .toString(),
                                                                name: homeCtrl.nameEmployee!,
                                                                checkIn: DateTime.now(),
                                                                checkOut: null,
                                                                isPresent: true,
                                                                email: controller.box
                                                                    .read('email'),
                                                                createAt: Timestamp.now(),
                                                                latitude: controller.latitude,
                                                                longitude: controller.longitude,
                                                              ),
                                                            );
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: AppColors.kWhite,
                                                            radius: 70,
                                                            child: Image.asset(
                                                              AppImages.check_in,
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ))
                                                      : const CircleAvatar(
                                                          backgroundColor: AppColors.kTeal,
                                                          radius: 70,
                                                          child: Icon(
                                                            Icons.check,
                                                            size: 90,
                                                          ),
                                                        ),
                                                  homeCtrl.checkOut2!.isEmpty
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            homeCtrl.getAttendanceToDay();
                                                            homeCtrl.addCheckOut(
                                                              AttendanceModel(
                                                                // id: homeCtrl.employeeId!.toString(),
                                                                // name: homeCtrl.nameEmployee!,
                                                                checkOut: DateTime.now(),
                                                                // isPresent: true,
                                                                // email: controller.box.read('email'),
                                                                // createAt: Timestamp.now(),
                                                                // latitude: controller.latitude,
                                                                // longitude: controller.longitude,
                                                              ),
                                                            );
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: AppColors.kWhite,
                                                            radius: 70,
                                                            child: Image.asset(
                                                              AppImages.logeen_logo,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        )
                                                      : const CircleAvatar(
                                                          backgroundColor: AppColors.kTeal,
                                                          radius: 70,
                                                          child: Icon(
                                                            Icons.check,
                                                            size: 90,
                                                          ),
                                                        ),
                                                ],
                                              ) */
              /*  : OutlinedButton(
                                                onPressed: () {
                                                  controller.determinePosition();
                                                  controller.print_location();
                                                },
                                                child:
                                                    const App_Text(data: "no location found"),
                                              ), */
              // SizedBox(height: 15.h),
              /* (shuffledData.first['text'] == null ||
                                      shuffledData.first['text'] == "" ||
                                      shuffledData.first['author'] == null ||
                                      shuffledData.first['author'] == "")
                                  ? const ShowLoading()
                                  : */
              const Spacer(),
              isLoading.value == true
                  ? const ShowLoading()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.topRight,
                          child: App_Text(
                            size: 11,
                            data: "“حكمة اليوم“",
                            color: AppColors.kbiNK,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 95.h,
                            maxWidth: 325.w,
                          ),
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.kTeal,
                                    offset: Offset(2, -4),
                                  ),
                                  BoxShadow(
                                    color: AppColors.kTeal,
                                    offset: Offset(1, 0),
                                  ),
                                  BoxShadow(
                                    color: AppColors.kTeal,
                                    offset: Offset(-4, 1),
                                  )
                                ]),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: App_Text(
                                size: 12,
                                paddingHorizontal: 4,
                                paddingVertical: 4,
                                data: " ”  ${shuffledData[0]['text']} “",
                                maxLine: 1000,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Align(
                          alignment: Alignment.topLeft,
                          child: App_Text(
                            size: 11,
                            data: "” ${shuffledData.first['author']}“",
                            maxLine: 3,
                            color: AppColors.kTeal,
                          ),
                        ),
                        // SizedBox(height: 9.h),
                      ],
                    ),
            ],
          );
        }),
      ),
    );
  }
}
/* class QuotesCard extends StatelessWidget {
  // RxList<dynamic>? shuffledData = [].obs;
  final RxList? shuffledData;
  const QuotesCard({super.key, this.shuffledData});
  // Future<void> loadAndShuffleJson() async {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: const BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kTeal,
                    offset: Offset(0, -2),
                  ),
                  BoxShadow(
                    color: AppColors.kTeal,
                    offset: Offset(-5, 2),
                  )
                ]),
            child: (shuffledData!.first['text'] == null ||
                    shuffledData!.first['text'] == "" ||
                    shuffledData!.first['author'] == null ||
                    shuffledData!.first['author'] == "")
                ? const ShowLoading()
                : Expanded(
                    child: App_Text(
                      size: 12,
                      paddingHorizontal: 4,
                      paddingVertical: 4,
                      data: (shuffledData!.first['text'] == null ||
                              shuffledData!.first['text'] == "")
                          ? ""
                          : " ”  ${shuffledData!.first['text']}  “",
                      maxLine: 10,
                    ),
                  ),
          ),
          SizedBox(height: 9.h),
          App_Text(
            size: 11,
            data: (shuffledData!.first['author'] == null ||
                    shuffledData!.first['author'] == "")
                ? ""
                : "” ${shuffledData!.first['author']} “",
            maxLine: 3,
            color: AppColors.kTeal,
          ),
        ],
      ),
    );
  }
}
 */