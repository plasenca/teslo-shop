import 'package:teslo_shop/features/auth/domain/domain.dart' show User;

class UserMapper {
  static userJsonToEntity(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'],
    );
  }
}
