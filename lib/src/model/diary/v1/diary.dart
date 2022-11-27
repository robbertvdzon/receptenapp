import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../recipes/v1/recept.dart';
import '../../snacks/v1/snack.dart';

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
  List<FoodEaten> breakfast = List.empty(growable: true);
  List<FoodEaten> morningSnack = List.empty(growable: true);
  List<FoodEaten> lunch = List.empty(growable: true);
  List<FoodEaten> afternoonSnack = List.empty(growable: true);
  List<FoodEaten> diner = List.empty(growable: true);
  List<FoodEaten> eveningSnack = List.empty(growable: true);

  DiaryDay(this.dateAsTimestamp);

  factory DiaryDay.fromJson(Map<String, dynamic> json) =>
      _$DiaryDayFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryDayToJson(this);
}

@JsonSerializable()
class FoodEaten {
  double portions = 0;
  Recept? recept = null;
  Snack? snack = null;

  FoodEaten(this.portions, this.recept, this.snack);

  String getName() {
    if (recept!=null) return recept!.name;
    if (snack!=null) return snack!.name;
    return "unknown";
  }

  factory FoodEaten.fromJson(Map<String, dynamic> json) =>
      _$FoodEatenFromJson(json);

  Map<String, dynamic> toJson() => _$FoodEatenToJson(this);

}