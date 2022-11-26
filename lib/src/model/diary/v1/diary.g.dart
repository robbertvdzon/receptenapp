// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Diary _$DiaryFromJson(Map<String, dynamic> json) => Diary()
  ..diaryDays = (json['diaryDays'] as List<dynamic>)
      .map((e) => DiaryDay.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$DiaryToJson(Diary instance) => <String, dynamic>{
      'diaryDays': instance.diaryDays,
    };

DiaryDay _$DiaryDayFromJson(Map<String, dynamic> json) => DiaryDay(
      json['dateAsTimestamp'] as int,
    )
      ..breakfast = (json['breakfast'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList()
      ..morningSnack = (json['morningSnack'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList()
      ..lunch = (json['lunch'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList()
      ..afternoonSnack = (json['afternoonSnack'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList()
      ..diner = (json['diner'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList()
      ..eveningSnack = (json['eveningSnack'] as List<dynamic>)
          .map((e) => Recept.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$DiaryDayToJson(DiaryDay instance) => <String, dynamic>{
      'dateAsTimestamp': instance.dateAsTimestamp,
      'breakfast': instance.breakfast,
      'morningSnack': instance.morningSnack,
      'lunch': instance.lunch,
      'afternoonSnack': instance.afternoonSnack,
      'diner': instance.diner,
      'eveningSnack': instance.eveningSnack,
    };
