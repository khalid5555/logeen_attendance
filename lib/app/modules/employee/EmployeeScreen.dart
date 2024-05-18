// manager_view.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logeen_attendance/app/data/models/employee_model.dart';
import 'package:logeen_attendance/app/modules/login/login_controller.dart';

import '../../core/shared/utils/app_colors.dart';
import '../../core/shared/widgets/app_text.dart';
import '../admin/add_employee.dart';

class EmployeeScreen extends StatelessWidget {
  final LoginController employeeController = Get.find();
  EmployeeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // employeeController.getAllEmployees();
    employeeController.getEmployees();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.kTeal,
        title: const App_Text(
          data: "بيانات الموظفين",
          color: AppColors.kLIGHTGreen,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Employee"),
        onPressed: () {
          // Show dialog to add an employee
          Get.to(() => const Add_employee());
        },
      ),
      body: Container(
        color: AppColors.kWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Obx(() {
                return App_Text(
                  data: "عدد الموظفين : ${employeeController.employees.length}",
                  color: AppColors.kBlACK,
                );
              }),
            ),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: employeeController.employees.length,
                  itemBuilder: (context, index) {
                    final employee = employeeController.employees[index];
                    Timestamp timestamp = employee.createdAt!;
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('yyyy-MM-dd  HH:mm a').format(dateTime);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListTile(
                          title: App_Text(
                            data: employee.name!,
                            size: 12,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              App_Text(
                                data: employee.email!,
                                size: 14,
                                maxLine: 3,
                              ),
                              App_Text(
                                data: formattedDate.toString(),
                                maxLine: 1,
                              ),
                              App_Text(
                                data: "id :${employee.id}",
                                maxLine: 1,
                                size: 10,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                color: Colors.blue,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Show dialog to edit an employee
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        EditEmployeeDialog(employee: employee),
                                  );
                                },
                              ),
                              IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Delete the employee
                                  Get.defaultDialog(
                                      onConfirm: () {
                                        employeeController
                                            .deleteEmployee(employee.id!);
                                        Get.back();
                                      },
                                      onCancel: () => Get.back(),
                                      middleText: "هل تريد حذف هذا العميل");
                                  // employeeController
                                  //     .deleteEmployee(employee.id!);
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(thickness: 4)
                      ],
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class EditEmployeeDialog extends StatefulWidget {
  final EmployeeModel employee;
  const EditEmployeeDialog({Key? key, required this.employee})
      : super(key: key);
  @override
  State<EditEmployeeDialog> createState() => _EditEmployeeDialogState();
}

class _EditEmployeeDialogState extends State<EditEmployeeDialog> {
  final LoginController employeeController = Get.find();
  @override
  void initState() {
    super.initState();
    employeeController.name.text = widget.employee.name!;
    employeeController.email.text = widget.employee.email!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Employee"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: employeeController.name,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: employeeController.email,
            decoration: const InputDecoration(labelText: "Email"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Update the employee
            employeeController.updateEmployee(
              EmployeeModel(
                id: widget.employee.id,
                name: employeeController.name.text,
                email: employeeController.email.text,
                createdAt: widget.employee.createdAt,
              ),
            );
            printInfo(info: widget.employee.email.toString());
            Navigator.pop(context);
          },
          child: const Text("Update"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

class ClientCard extends StatelessWidget {
  final EmployeeModel client;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const ClientCard(
      {super.key,
      required this.client,
      required this.onEdit,
      required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.cyan,
      clipBehavior: Clip.hardEdge,
      surfaceTintColor: Colors.lightGreen,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onDoubleTap: () {
          // Get.to(
          // () => ClientDetailPage(client: client);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: App_Text(
                      data: "الاسم : ${client.name}",
                      size: 15,
                      maxLine: 5,
                    ),
                  ),
                  /*   App_Text(data: "الهاتف : ${client.phone}", size: 12),
                  App_Text(data: "حالة العميل : ${client.category}", size: 12),
                  App_Text(data: "المدينة : ${client.city}", size: 12),
                  App_Text(
                    data: "التفاصيل : ${client.desc}",
                    size: 12,
                    color: AppColors.kTeal,
                    maxLine: 6,
                  ),
                  App_Text(data: "الموظف : ${client.employeeId}", size: 12), */
                ],
              ),
              Positioned(
                top: Get.height * .05,
                // left: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      color: Colors.blue,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      color: Colors.red,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
