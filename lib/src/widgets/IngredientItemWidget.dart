import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/IngredientsRepository.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/ProductsRepository.dart';

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

  _saveForm() {
    ingredientsRepository.saveIngredient(newIngredient);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
          // dropdownSearchDecoration: InputDecoration(
          //   labelText: "Menu mode",
          //   hintText: "country in menu mode",
          // ),
          // onChanged: print,

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


