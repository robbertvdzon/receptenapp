import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../recipes/v1/recept.dart';

part 'diary.g.dart';

var uuid = Uuid();

@JsonSerializable()
class Diary {
  List<DiaryDay> diaryDays = [];
  Diary();

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryToJson(this);
}


@JsonSerializable()
class DiaryDay {
  int dateAsTimestamp;
  List<Recept> breakfast = List.empty(growable: true);
  List<Recept> morningSnack = List.empty(growable: true);
  List<Recept> lunch = List.empty(growable: true);
  List<Recept> afternoonSnack = List.empty(growable: true);
  List<Recept> diner = List.empty(growable: true);
  List<Recept> eveningSnack = List.empty(growable: true);

  DiaryDay(this.dateAsTimestamp);

  factory DiaryDay.fromJson(Map<String, dynamic> json) =>
      _$DiaryDayFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryDayToJson(this);
}

