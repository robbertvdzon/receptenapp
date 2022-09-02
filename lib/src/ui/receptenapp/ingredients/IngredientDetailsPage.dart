import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/model/ingredients/v1/ingredients.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import '../../../global.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/repositories/IngredientsRepository.dart';
import '../../../services/repositories/ProductsRepository.dart';

class IngredientDetailsPage extends StatefulWidget {
  IngredientDetailsPage({Key? key, required this.title, required this.ingredient, required this.categories}) : super(key: key) {}

  final Ingredient ingredient;
  final List<String> categories;
  final String title;

  @override
  State<IngredientDetailsPage> createState() => _WidgetState(ingredient, categories);
}

class _WidgetState extends State<IngredientDetailsPage> {
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

  _saveForm() {
    ingredientsRepository.saveIngredient(newIngredient);
  }

  // saveRecept(Recipes recipes, Recept newRecept) {
  //   // receptenBoek.recepten.remove(recept);
  //   recipes.recipes
  //       .where((element) => element.uuid == recept.uuid)
  //       .forEach((element) {
  //     element.name = newRecept.name;
  //   });
  //   recipesRepository.saveRecipes(recipes);
  // }

  @override
  Widget build(BuildContext context) {

    /*
    Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
     */

    return
      Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(

              child:Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(label: Text('uuid:')),
                    initialValue: "${ingredient.uuid}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('Name:')),
                    initialValue: "${ingredient.name}",
                    onChanged: (text) {
                      newIngredient.name = text;
                    },
                  ),

                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                    ),
                    items: categories,
                    onChanged: (String? newValue) {
                      setState(() {
                        newIngredient.nutrientName = newValue;
                      });
                    },
                    selectedItem: "${ingredient.nutrientName??''}",
                  ),

                  ElevatedButton(
                    child: Text('SAVE'),
                    onPressed: () {
                      _saveForm();
                    },
                  )

                ],
              )

          ))
    ;
  }

}


