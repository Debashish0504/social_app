import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  Post(this.title, this.createdBy, this.content, this.groupName);

  factory Post.fromJson(Map<dynamic, dynamic> json) => _$PostFromJson(json);

  Map<dynamic, dynamic> toJson() => _$PostToJson(this);

  String title;
  String createdBy;
  String content;
  String groupName;

  @override
  String toString() {
    return 'Post{title: $title, createdBy: $createdBy, content: $content, groupName: $groupName}';
  }
}
