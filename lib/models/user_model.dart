// models/user_model.dart
class UserModel {
  final int id;
  final String email;
  final String avatar;
  final String firstName;
  final String lastName;

  UserModel({
    required this.id,
    required this.email,
    required this.avatar,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
