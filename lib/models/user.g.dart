// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<dynamic, dynamic> json) {
  return User(
    json['firstName'] as String,
    json['lastName'] as String,
    json['userName'] as String,
    json['email'] as String,
  );
}

Map<dynamic, dynamic> _$UserToJson(User instance) => <dynamic, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'email': instance.email,
    };
