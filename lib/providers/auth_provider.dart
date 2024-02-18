import 'package:attendance_staff/helper/utills.dart';
import 'package:attendance_staff/screens/home/home_screen.dart';
import 'package:attendance_staff/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthProvider {
  Future registerEmployee(String email, String password, BuildContext context);

  Future loginEmployee(String email, String password, BuildContext context);

  Future signOut();
}

class AuthProvider extends ChangeNotifier implements IAuthProvider {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DBService _dbService = DBService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
  }

  @override
  Future loginEmployee(
      String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      if (email == "" || password == "") {
        throw ("All Fields are required");
      }
      AuthResponse response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      if (response.user != null) {
        Navigator.pushAndRemoveUntil(
            context, HomeScreen.route(), (route) => false);
      }

      isLoading = false;
    } catch (e) {
      isLoading = false;
      if (!context.mounted) return;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  @override
  Future registerEmployee(
      String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      if (email == "" || password == "") {
        throw ("All Fields are required");
      }
      final AuthResponse response =
          await _supabase.auth.signUp(email: email, password: password);

      await _dbService.insertNewUser(email, response.user!.id);
      if (!context.mounted) return;
      Utils.showSnackBar("Successfully registered !", context,
          color: Colors.green);
      Navigator.pop(context);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      if (!context.mounted) return;
      Utils.showSnackBar(e.toString(), context, color: Colors.red);
    }
  }

  @override
  Future signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print("errror $e");
    }
    notifyListeners();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
