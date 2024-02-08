class AttendanceModel {
  final String id;
  final String date;
  final String checkIn;
  final String? checkOut;
  final DateTime createdAt;
  final Map? checkInLocation;
  final Map? checkOutLocation;

  AttendanceModel(
      {required this.id,
      required this.date,
      required this.checkIn,
      required this.checkOut,
      required this.createdAt,
      required this.checkInLocation,
      required this.checkOutLocation});

  factory AttendanceModel.fromJson(Map<String, dynamic> data) {
    return AttendanceModel(
      id: data['employee_id'],
      date: data['date'],
      checkIn: data['check_in'],
      checkOut: data['check_out'],
      createdAt: DateTime.parse(data['created_at']),
      checkInLocation: data['check_in_location'],
      checkOutLocation: data['check_out_location'],
    );
  }

  static Map<String, dynamic> toMapCheckIn(
      String id, String date, String checkIn, String checkInLocation) {
    return {
      'employee_id': id,
      'date': date,
      'check_in': checkIn,
      'check_in_location': checkInLocation,
    };
  }

  static Map<String, dynamic> toMapCheckOut(
      {required String checkOut, required String getLocation}) {
    return {
      'check_out': checkOut,
      'check_out_location': getLocation,
    };
  }
}
