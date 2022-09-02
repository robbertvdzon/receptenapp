// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receptTags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceptTags _$ReceptTagsFromJson(Map<String, dynamic> json) => ReceptTags(
      (json['tags'] as List<dynamic>)
          .map((e) => ReceptTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReceptTagsToJson(ReceptTags instance) =>
    <String, dynamic>{
      'tags': instance.tags,
    };

ReceptTag _$ReceptTagFromJson(Map<String, dynamic> json) => ReceptTag(
      json['tag'] as String?,
    );

Map<String, dynamic> _$ReceptTagToJson(ReceptTag instance) => <String, dynamic>{
      'tag': instance.tag,
    };
