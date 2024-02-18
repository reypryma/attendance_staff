class UserModel {
  final String id;
  final String email;
  final String name;
  final int? department;
  final String? avatar;
  final String employeeId;

  UserModel(
      {required this.id,
      required this.email,
      required this.name,
      this.department,
      required this.employeeId,
      this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        id: data['id'],
        email: data['email'],
        name: data['name'],
        department: data['department'],
        avatar: data['avatar'],
        employeeId: data['employee_id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'department': department,
      'employee_id': employeeId,
      'avatar': (avatar != null) ? avatar : null,
    };
  }
}
