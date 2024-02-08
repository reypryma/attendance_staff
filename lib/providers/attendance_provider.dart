import 'package:attendance_staff/helper/utills.dart';
import 'package:attendance_staff/models/attendance_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


abstract class IAttendanceProvider{
  Future getTodayAttendance();
  Future markAttendance(BuildContext context);
  Future<List<AttendanceModel>> getAttendanceHistory();
}

class AttendanceProvider extends ChangeNotifier implements IAttendanceProvider{
  final SupabaseClient _supabase = Supabase.instance.client;
  AttendanceModel? attendanceModel;

  bool _isLoading = false;
  String _attendanceHistoryMonth = Utils.getCurrentDate();


  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory() {
    // TODO: implement getAttendanceHistory
    throw UnimplementedError();
  }

  @override
  Future getTodayAttendance() {
    // TODO: implement getTodayAttendance
    throw UnimplementedError();
  }

  @override
  Future markAttendance(BuildContext context) async{
    // Map? getLocation = await LocationService()
  }

  String get attendanceHistoryMonth => _attendanceHistoryMonth;

  set attendanceHistoryMonth(String value) {
    _attendanceHistoryMonth = value;
    notifyListeners();
  }
}