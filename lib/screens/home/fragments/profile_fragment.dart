import 'dart:io';

import 'package:attendance_staff/helper/constant.dart';
import 'package:attendance_staff/helper/utills.dart';
import 'package:attendance_staff/providers/auth_provider.dart';
import 'package:attendance_staff/screens/global/loader.dart';
import 'package:attendance_staff/screens/login_screen.dart';
import 'package:attendance_staff/services/db_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  TextEditingController nameController = TextEditingController();
  final _picker = ImagePicker();
  File? image;
  XFile? xFile;
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);

      if (pickedFile != null) {
        if (kIsWeb) {
          // xFile = XFile(pickedFile.path);
          xFile = pickedFile;
          print("xFile path " + pickedFile.path);
          imageBytes = await xFile!.readAsBytes();
          // imageBytes = await image!.readAsBytes();
        } else {
          image = File(pickedFile.path);
          imageBytes = await image!.readAsBytes();
        }

        if (kDebugMode) {
          print("image changed");
        }
        setState(() {});
      }
    }

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
            : Stack(children: [
                Padding(
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
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .signOut()
                                    .then((value) =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            LoginScreen.route(),
                                            (route) => false));
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text("Sign Out")),
                        ),
                        Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 100,
                            width: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.redAccent),
                            child: Center(
                              child: kIsWeb
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: xFile == null ? commonCacheImageWidget(
                                  dbService.imageUrl ??
                                      Images.personImage,
                                  60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ) : Image.network(xFile!.path, width: 60, height: 60, fit: BoxFit.cover),
                              )
                                  : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: image == null ? Image.asset(Images.personImage, color: Colors.grey, fit: BoxFit.contain).image : Image.file(File(image!.path), fit: BoxFit.cover).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF516dff),
                                    borderRadius: BorderRadius.circular(16)),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                            "Employee ID : ${dbService.userModel?.employeeId}"),
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
                                  value: dbService.employeeDepartment,
                                  items: dbService.departments.map((item) {
                                    return DropdownMenuItem(
                                        value: item.id,
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(fontSize: 20),
                                        ));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    dbService.employeeDepartment =
                                        selectedValue;
                                  },
                                )),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              dbService.isLoading = true;
                              await dbService.updateProfile(
                                  nameController.text.trim(), image, context);
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
                ),
                Container(
                    child: dbService.isLoading
                        ? const Loader(loadingTxt: 'Please wait...')
                        : Container())
              ]));
  }
}
