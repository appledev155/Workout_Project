import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id, emailVerified, phoneVerified;
  final String? name, email, number, profileImage, roleId;
  final String? token;

  static const empty = UserModel(id: 0, token: '');
  const UserModel(
      {this.id,
      this.emailVerified,
      this.phoneVerified,
      this.name,
      this.email,
      this.number,
      this.profileImage,
      this.roleId,
      this.token});

  @override
  List<Object> get props => [
        id!,
        emailVerified.toString(),
        phoneVerified.toString(),
        name.toString(),
        email.toString(),
        number.toString(),
        profileImage.toString(),
        roleId.toString(),
        token!
      ];

  factory UserModel.recJson(Map<String, dynamic> rec) {
    return UserModel(
      id: rec['id'],
      emailVerified: rec['emailVerified'],
      phoneVerified: int.parse('${rec['phoneVerified']}'),
      name: rec['displayName'] ?? "Name",
      email: rec['email'],
      number: (rec['phoneNumber'] == null) ? "-" : rec['phoneNumber'],
      profileImage: rec['photo_url'] ?? '',
      roleId: rec['role_id'].toString(),
      token: rec['token'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'name': name,
      'email': email,
      'number': number,
      'profileImage': profileImage,
      'roleId': roleId,
      'token': token
    };
  }

  @override
  String toString() =>
      '{id: $id, emailVerified: $emailVerified, name: $name,  email: $email, number: $number, profileImage: $profileImage, roleId: $roleId, token: $token}';
}
