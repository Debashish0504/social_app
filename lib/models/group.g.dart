// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<dynamic, dynamic> json) {
  return Group(
    json['createdBy'] as String,
    json['groupId'] as String,
    (json['posts'] as Map<dynamic, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Post.fromJson(e as Map<dynamic, dynamic>)),
    ),
  );
}

Map<dynamic, dynamic> _$GroupToJson(Group instance) => <dynamic, dynamic>{
      'createdBy': instance.createdBy,
      'groupId': instance.groupId,
      'posts': instance.posts,
    };

Post _$PostFromJson(Map<dynamic, dynamic> json) {
  return Post(
    json['title'] as String,
    json['createdBy'] as String,
    json['content'] as String,
  );
}

Map<dynamic, dynamic> _$PostToJson(Post instance) => <dynamic, dynamic>{
      'title': instance.title,
      'createdBy': instance.createdBy,
      'content': instance.content,
    };
