import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

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
  String directions = "";
  String remark = "";
  int totalCookingTime = 0;
  int preparingTime = 0;
  int dateAdded = 0;
  int nrPersons = 0;
  bool favorite = false;

  List<ReceptIngredient> ingredients;
  List<String> tags = List.empty();

  Recept(this.ingredients, this.name);

  factory Recept.fromJson(Map<String, dynamic> json) => _$ReceptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptToJson(this);

  bool containsIngredient(String name) {
    return this.ingredients.where((element) => element.name==name).isNotEmpty;
  }

  bool containsTag(String? tag) {
    return this.tags.contains(tag);
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
