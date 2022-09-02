import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'receptTags.g.dart';

@JsonSerializable()
class ReceptTags {
  List<ReceptTag> tags;
  ReceptTags(this.tags);

  factory ReceptTags.fromJson(Map<String, dynamic> json) => _$ReceptTagsFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptTagsToJson(this);
}

@JsonSerializable()
class ReceptTag {
  String? tag;

  ReceptTag(this.tag);

  factory ReceptTag.fromJson(Map<String, dynamic> json) =>
      _$ReceptTagFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptTagToJson(this);
}