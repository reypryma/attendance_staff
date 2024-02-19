import 'dart:io';

import 'package:attendance_staff/helper/constant.dart';
import 'package:attendance_staff/helper/utills.dart';
import 'package:attendance_staff/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/department_model.dart';

abstract class IDBService {
  Future<UserModel> getUserData();

  Future<void> getAllDepartments();

  Future updateProfile(String name, File? imageFile, BuildContext context);

  Future insertNewUser(String email, var id);

  Future uploadAvatar(File imageFile, bool isUpdating);
}

class DBService extends ChangeNotifier implements IDBService {
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? userModel;
  String? imageUrl;
  List<DepartmentModel> departments = [];
  int? employeeDepartment;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  Future<void> getAllDepartments() async {
    try {
      final List result =
          await _supabase.from(Constants.departmentTable).select();
      departments = result.map((e) => DepartmentModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Errror DBService getAllDepartments $e");
      }
    }
    notifyListeners();
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      final userData = await _supabase
          .from(Constants.employeeTable)
          .select()
          .eq('id', _supabase.auth.currentUser!.id)
          .single();
      userModel = UserModel.fromJson(userData);
      imageUrl = userModel?.avatar;
    } on Exception catch (e) {
      print("Errror getUserData $e");
    }

    employeeDepartment == null
        ? employeeDepartment = userModel?.department
        : null;
    return userModel!;
  }

  @override
  Future updateProfile(
      String name, File? imageFile, BuildContext context) async {
    if (imageFile != null) {
      await uploadAvatar(imageFile, userModel!.avatar != null);
    }

    await _supabase.from(Constants.employeeTable).update({
      'name': name,
      'department': employeeDepartment,
      'avatar': imageUrl
    }).eq('id', _supabase.auth.currentUser!.id);

    _isLoading = false;
    Utils.showSnackBar("Profile Updated Successfully", context,
        color: Colors.green);

    notifyListeners();
  }

  @override
  Future insertNewUser(String email, id) async {
    try {
      await _supabase.from(Constants.employeeTable).insert(UserModel(
            id: id,
            name: '',
            email: email,
            employeeId: Utils.generateRandomEmployeeId(),
            department: null,
            avatar: null,
          ).toMap());
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Errror insertNewUser $e");
      }
    }
  }

  @override
  Future uploadAvatar(File imageFile, bool isUpdating) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final imagePath = '/${Constants.avatars}/$userId/avatar';
      final imagePublicPath = '${Constants.avatars}/$userId/avatar';
      final fileName = imageFile.path.split('/').last;

      print("Imagepath check $imagePath with filename $fileName");

      final imageExtension = imageFile.path.split(".").last.toLowerCase();
      final imageByte = await imageFile.readAsBytes();

      // Check if folder exists

      await _supabase.storage.from(Constants.profileStorage).uploadBinary(
          imagePath, imageByte,
          fileOptions:
              FileOptions(upsert: true, contentType: 'image/$imageExtension'));

      String imageTemp = _supabase.storage
          .from(Constants.profileStorage)
          .getPublicUrl(imagePublicPath);
      imageUrl = Uri.parse(imageTemp).replace(queryParameters: {
        't': DateTime.now().millisecondsSinceEpoch.toString()
      }).toString();
      print("ImageUrl $imageUrl");
    } on Exception catch (e) {
      print("uploadAvatar error : $e");
    }
  }
}
