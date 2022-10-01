// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<dynamic, dynamic> json) {
  return Post(
    json['title'] as String,
    json['createdBy'] as String,
    json['content'] as String,
    json['groupName'] as String,
  );
}

Map<dynamic, dynamic> _$PostToJson(Post instance) => <dynamic, dynamic>{
      'title': instance.title,
      'createdBy': instance.createdBy,
      'content': instance.content,
      'groupName': instance.groupName,
    };
