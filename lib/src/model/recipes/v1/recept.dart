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
  List<ReceptIngredient> ingredients;
  List<String> tags = List.empty();

  Recept(this.ingredients, this.name);

  factory Recept.fromJson(Map<String, dynamic> json) => _$ReceptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptToJson(this);
}

@JsonSerializable()
class ReceptIngredient {
  String name;
  // ReceptIngredientAmount amount; TODO: use interface!
  ReceptIngredientAmountGrams? amountGrams = null;
  ReceptIngredientAmountItems? amountItems = null;


  ReceptIngredient(this.name, {ReceptIngredientAmountGrams? amountGrams: null, ReceptIngredientAmountItems? amountItems: null}){
    this.amountGrams = amountGrams;
    this.amountItems = amountItems;
  }

  factory ReceptIngredient.fromJson(Map<String, dynamic> json) =>
      _$ReceptIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptIngredientToJson(this);
}

abstract class ReceptIngredientAmount {}

@JsonSerializable()
class ReceptIngredientAmountGrams implements ReceptIngredientAmount{
  int grams = 0;

  ReceptIngredientAmountGrams(this.grams);

  factory ReceptIngredientAmountGrams.fromJson(Map<String, dynamic> json) =>
      _$ReceptIngredientAmountGramsFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptIngredientAmountGramsToJson(this);
}

@JsonSerializable()
class ReceptIngredientAmountItems implements ReceptIngredientAmount{
  double items = 0;

  ReceptIngredientAmountItems(this.items);

  factory ReceptIngredientAmountItems.fromJson(Map<String, dynamic> json) =>
      _$ReceptIngredientAmountItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ReceptIngredientAmountItemsToJson(this);
}