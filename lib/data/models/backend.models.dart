import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SignUpData {
  final String email;
  final String? username;
  final String? password;

  SignUpData({required this.email, this.username, this.password});
}

