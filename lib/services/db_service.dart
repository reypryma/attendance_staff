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

  Future updateProfile(String name, BuildContext context);

  Future insertNewUser(String email, var id);
}

class DBService extends ChangeNotifier implements IDBService {
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? userModel;
  List<DepartmentModel> departments = [];
  int? employeeDepartment;

  @override
  Future<void> getAllDepartments() async {
    final List result =
        await _supabase.from(Constants.departmentTable).select();
    departments = result.map((e) => DepartmentModel.fromJson(e)).toList();
    notifyListeners();
  }

  @override
  Future<UserModel> getUserData() async {
    final userData = await _supabase
        .from(Constants.employeeTable)
        .select()
        .eq('id', _supabase.auth.currentUser!.id)
        .single();
    userModel = UserModel.fromJson(userData);
    employeeDepartment == null
        ? employeeDepartment = userModel?.department
        : null;
    return userModel!;
  }

  @override
  Future updateProfile(String name, BuildContext context) {
    // TODO: implement updateProfile
    throw UnimplementedError();
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
          ).toMap());
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error insertNewUser $e");
      }
    }
  }
}
