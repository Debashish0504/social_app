import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  Group(this.createdBy, this.groupId, this.posts);

  factory Group.fromJson(Map<dynamic, dynamic> json) => _$GroupFromJson(json);

  Map<dynamic, dynamic> toJson() => _$GroupToJson(this);

  String createdBy;
  String groupId;
  Map<dynamic, Post> posts;

  @override
  String toString() {
    return 'Group{createdBy: $createdBy, groupId: $groupId, posts: $posts}';
  }
}

@JsonSerializable()
class Post {
  Post(this.title, this.createdBy, this.content);

  factory Post.fromJson(Map<dynamic, dynamic> json) => _$PostFromJson(json);

  Map<dynamic, dynamic> toJson() => _$PostToJson(this);

  String title;
  String createdBy;
  String content;

  @override
  String toString() {
    return 'Post{title: $title, createdBy: $createdBy, content: $content}';
  }
}
