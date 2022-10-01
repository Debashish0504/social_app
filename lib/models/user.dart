import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.firstName, this.lastName, this.userName, this.email);

  factory User.fromJson(Map<dynamic, dynamic> json) => _$UserFromJson(json);

  Map<dynamic, dynamic> toJson() => _$UserToJson(this);

  String firstName;
  String lastName;
  String userName;
  String email;
}
