import 'package:attendance_staff/providers/auth_provider.dart';
import 'package:attendance_staff/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DBService>(context);
    // Using below conditions because build can be called multiple times
    dbService.departments.isEmpty ? dbService.getAllDepartments() : null;
    nameController.text.isEmpty
        ? nameController.text = dbService.userModel?.name ?? ''
        : null;

    return Scaffold(
        body: dbService.userModel == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                            onPressed: () {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .signOut();
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text("Sign Out")),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text("Employee ID : ${dbService.userModel?.employeeId}"),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            label: Text("Full name"),
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      dbService.departments.isEmpty
                          ? const LinearProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: DropdownButtonFormField(
                                items: dbService.departments.map((item) {
                                  return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(
                                    item.title,
                                    style: const TextStyle(fontSize: 20),
                                  ));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  dbService.employeeDepartment = selectedValue;
                                },
                              )),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            dbService.updateProfile(
                                nameController.text.trim(), context);
                          },
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
