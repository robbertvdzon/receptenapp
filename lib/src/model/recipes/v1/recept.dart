import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../services/Filter.dart';

part 'recept.g.dart';

var uuid = Uuid();

@JsonSerializable()
class Recipes {
  List<Recept> recipes;

  Recipes(this.recipes);

  factory Recipes.fromJson(Map<String, dynamic> json) =>
      _$RecipesFromJson(json);

  Map<String, dynamic> toJson() => _$RecipesToJson(this);
}

@JsonSerializable()
class Recept {
  String uuid = Uuid().v1();
  String name;
  String instructions = "";
  String remark = "";
  int totalCookingTime = 0;
  int preparingTime = 0;
  int dateAdded = 0;
  int nrPersons = 0;
  bool favorite = false;

  List<ReceptIngredient> ingredients;
  List<String> tags = List.empty(growable: true);

  Recept(this.ingredients, this.name);

  factory Recept.fromJson(Map<String, dynamic> json) => _$ReceptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptToJson(this);

  bool containsIngredient(String name, {bool excactMatch = false}) {
    if (excactMatch) {
      return this.ingredients
          .where((element) => element.name == name)
          .isNotEmpty;
    }
    return this.ingredients.any((ingredient) => ingredient.name.toLowerCase().contains(name.toLowerCase()));
  }

  bool containsTag(String? tag) {
    return this.tags.contains(tag);
  }

  bool matchFilter(Filter filter){
    bool match = true;
    print("start filter for : #${name}# with tags: ${tags}");

    if (filter.favorite){
      if (!favorite) match = false;
    }

    if (filter.maxCoockTime.isNotEmpty){
      int? maxCoockTime = int.tryParse(filter.maxCoockTime);
      if (maxCoockTime!=null){
        if (totalCookingTime>maxCoockTime){
          match = false;
        }
      }
    }

    if (filter.tagFilter.isNotEmpty){
      List<String> filterTags = filter.tagFilter.split(",");
      filterTags.forEach((element) {
        if (element.isNotEmpty) {
          if (!containsTag(element.trim())) {
            match = false;
          }
        }
      });
    }

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

    print("filter Recept $name : $match");
    return match;

  }

}


@JsonSerializable()
class ReceptIngredient {
  String name;
  // ReceptIngredientAmount amount; TODO: use interface!
  ReceptIngredientAmount? amount = null;

  ReceptIngredient(this.name, {ReceptIngredientAmount? amount: null}){
    this.amount = amount;
  }

  factory ReceptIngredient.fromJson(Map<String, dynamic> json) =>
      _$ReceptIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptIngredientToJson(this);
}

@JsonSerializable()
class ReceptIngredientAmount{
  double nrUnit = 0;
  String unit = "";

  ReceptIngredientAmount(this.nrUnit, this.unit);

  factory ReceptIngredientAmount.fromJson(Map<String, dynamic> json) =>
      _$ReceptIngredientAmountFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptIngredientAmountToJson(this);
}
