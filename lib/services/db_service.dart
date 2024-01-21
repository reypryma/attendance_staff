import 'package:attendance_staff/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/department_model.dart';

abstract class IDBService{
  Future<UserModel> getUserData();
  Future<void> getAllDepartments();
  Future updateProfile(String name, BuildContext context);
  Future insertNewUser(String email, var id);
}

class DBService extends ChangeNotifier implements IDBService{
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? userModel;
  List<DepartmentModel> allDepartments = [];
  int? employeeDepartment;

  @override
  Future<void> getAllDepartments() {
    // TODO: implement getAllDepartments
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserData() {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

  @override
  Future updateProfile(String name, BuildContext context) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future insertNewUser(String email, id) {
    // TODO: implement insertNewUser
    throw UnimplementedError();
  }

}