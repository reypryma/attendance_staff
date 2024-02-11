import 'package:attendance_staff/helper/constant.dart';
import 'package:attendance_staff/helper/utills.dart';
import 'package:attendance_staff/models/attendance_model.dart';
import 'package:attendance_staff/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAttendanceProvider {
  Future getTodayAttendance();

  Future markAttendance(BuildContext context);

  Future<List<AttendanceModel>> getAttendanceHistory();
}

class AttendanceProvider extends ChangeNotifier implements IAttendanceProvider {
  final SupabaseClient _supabase = Supabase.instance.client;

  String todayDate = Utils.getCurrentDate();
  AttendanceModel? attendanceModel;

  bool _isLoading = false;
  String _attendanceHistoryMonth = Utils.getCurrentMonth();

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final List data = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq('employee_id', _supabase.auth.currentUser!.id)
        .textSearch('date', "'$_attendanceHistoryMonth'", config: 'english')
        .order('created_at', ascending: false);
    return data
        .map((attendance) => AttendanceModel.fromJson(attendance))
        .toList();
  }

  @override
  Future getTodayAttendance() async {
    final List result = await _supabase
        .from(Constants.attendancetable)
        .select()
        .eq("employee_id", _supabase.auth.currentUser!.id)
        .eq('date', todayDate);
    if (result.isNotEmpty) {
      attendanceModel = AttendanceModel.fromJson(result.first);
    }
    notifyListeners();
  }

  @override
  Future markAttendance(BuildContext context) async {
    Map? getLocation =
        await LocationService().initializeAndGetLocation(context);

    if (kDebugMode) {
      print("Location Data: $getLocation");
    }
    if(!context.mounted) return;
    if (getLocation != null) {
      if (attendanceModel?.checkIn == null) {
        try {
          await _supabase.from(Constants.attendancetable).insert(
              AttendanceModel.toMapCheckIn(
                  _supabase.auth.currentUser!.id,
                  Utils.getCurrentDate(),
                  Utils.getCurrentHourMinute(),
                  getLocation));
        } on Exception catch (e) {
          if (kDebugMode) {
            print("Errror markAttendance: CheckIn $e");
          }
        }
      } else if (attendanceModel?.checkOut == null) {
        try {
          await _supabase
              .from(Constants.attendancetable)
              .update(AttendanceModel.toMapCheckOut(
                  checkOut: Utils.getCurrentHourMinute(),
                  getLocation: getLocation))
              .eq('employee_id', _supabase.auth.currentUser!.id)
              .eq('date', todayDate);
        } on Exception catch (e) {
          if (kDebugMode) {
            print("Errror markAttendance: CheckOut $e");
          }
        }
      } else {
        Utils.showSnackBar("You have already checked out today!", context);
      }
      getTodayAttendance();
    } else {
      Utils.showSnackBar("Not able to get your Location", context,
          color: Colors.red);
      getTodayAttendance();
    }
  }
}
