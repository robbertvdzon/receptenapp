import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../services/Filter.dart';
import '../../recipes/v1/recept.dart';

part 'snack.g.dart';

var uuid = Uuid();

@JsonSerializable()
class Snacks {
  List<Snack> snacks;

  Snacks(this.snacks);

  factory Snacks.fromJson(Map<String, dynamic> json) =>
      _$SnacksFromJson(json);

  Map<String, dynamic> toJson() => _$SnacksToJson(this);
}

@JsonSerializable()
class Snack {
  String uuid = Uuid().v1();
  String name;
  List<ReceptIngredient> ingredients;

  Snack(this.ingredients, this.name);

  factory Snack.fromJson(Map<String, dynamic> json) => _$SnackFromJson(json);

  Map<String, dynamic> toJson() => _$SnackToJson(this);

  bool containsIngredient(String name, {bool excactMatch = false}) {
    if (excactMatch) {
      return this.ingredients
          .where((element) => element.name == name)
          .isNotEmpty;
    }
    return this.ingredients.any((ingredient) => ingredient.name.toLowerCase().contains(name.toLowerCase()));
  }

  bool matchFilter(Filter filter){
    bool match = true;

    if (filter.ingredientsFilter.isNotEmpty){
      List<String> ingredients = filter.ingredientsFilter.split(",");
      ingredients.forEach((element) {
        if (!containsIngredient(element)){
          match = false;
        }
      });
    }

    if (filter.nameFilter.isNotEmpty){
      if (!name.toLowerCase().contains(filter.nameFilter.toLowerCase())){
        match = false;
      }
    }
    return match;

  }

}
