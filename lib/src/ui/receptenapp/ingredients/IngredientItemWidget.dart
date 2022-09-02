import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/repositories/IngredientsRepository.dart';
import '../../../global.dart';
import '../../../model/ingredients/v1/ingredients.dart';
import '../../../services/repositories/ProductsRepository.dart';
import 'IngredientDetailsPage.dart';

class IngredientItemWidget extends StatefulWidget {
  IngredientItemWidget({Key? key, required this.ingredient, required this.categories})
      : super(key: key) {}

  final Ingredient ingredient;
  final List<String> categories;

  @override
  State<IngredientItemWidget> createState() => _WidgetState(ingredient, categories);
}

class _WidgetState extends State<IngredientItemWidget> {
  late Ingredient ingredient;
  late Ingredient newIngredient;
  late List<String> categories;
  var ingredientsRepository = getIt<IngredientsRepository>();
  var nutrientsRepository = getIt<ProductsRepository>();

  _WidgetState(Ingredient ingredient, List<String> categories) {
    this.ingredient = ingredient;
    this.newIngredient = ingredient;
    this.categories= categories;
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              IngredientDetailsPage(title: 'Ingredient', ingredient: ingredient, categories: categories,)),
    );
  }


  _saveForm() {
    ingredientsRepository.saveIngredient(newIngredient);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextButton(
          onPressed: () {
            _openForm();
          },
          child: new Text(ingredient.name+" ("+(ingredient.nutrientName??"")+")"),
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> buildList() {
    return categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
  }
}


