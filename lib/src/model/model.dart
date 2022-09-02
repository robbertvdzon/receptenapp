import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

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



@JsonSerializable()
class Ingredients {
  List<Ingredient> ingredients;
  Ingredients(this.ingredients);

  factory Ingredients.fromJson(Map<String, dynamic> json) => _$IngredientsFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientsToJson(this);
}

@JsonSerializable()
class Ingredient {
  String uuid = Uuid().v1();
  String name;
  String? nutrientName;
  int gramsPerPiece = 0;
  List<String> tags = List.empty();

  Ingredient(this.name);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}

@JsonSerializable()
class Products {
  List<Product> products;
  Products(this.products);

  factory Products.fromJson(Map<String, dynamic> json) => _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);

}


@JsonSerializable()
class Product {
  String? name;
  String? category;
  int? nevoCode;
  String? quantity;
  String? kcal;
  String? prot;
  String? nt;
  String? fat;
  String? sugar;
  String? na;
  String? k;
  String? fe;
  String? mg;
  bool? customNutrient = false;

  Product(this.name);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}


@JsonSerializable()
class IngredientTags {
  List<IngredientTag> tags;
  IngredientTags(this.tags);

  factory IngredientTags.fromJson(Map<String, dynamic> json) => _$IngredientTagsFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagsToJson(this);
}

@JsonSerializable()
class IngredientTag {
  String? tag;

  IngredientTag(this.tag);

  factory IngredientTag.fromJson(Map<String, dynamic> json) =>
      _$IngredientTagFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientTagToJson(this);
}

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