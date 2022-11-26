import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/model/ingredients/v1/ingredients.dart';

import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Enricher.dart';
import '../../../services/IngredientsService.dart';

class IngredientEditPage extends StatefulWidget {
  IngredientEditPage(
      {Key? key,
      required this.title,
      required this.ingredient})
      : super(key: key) {}

  final Ingredient ingredient;
  final String title;

  @override
  State<IngredientEditPage> createState() =>
      _WidgetState(ingredient);
}

class _WidgetState extends State<IngredientEditPage> {
  late EnrichedIngredient _ingredient;
  late Ingredient _newIngredient;
  late List<String> _categories = List.empty(growable: true);
  var _ingredientService = getIt<IngredientsService>();
  var _enricher = getIt<Enricher>();
  var _appStateService = getIt<AppStateService>();

  _WidgetState(Ingredient ingredient) {
    this._ingredient = _enricher.enrichtIngredient(ingredient);
    this._newIngredient = ingredient;
    this._categories = _appStateService.getProducts().map((e) => e.name ?? "").toList();
  }

  _saveForm() {
    _ingredientService
        .saveIngredient(_newIngredient)
        .whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(label: Text('uuid:')),
              initialValue: "${_ingredient.uuid}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Name:')),
              initialValue: "${_ingredient.name}",
              onChanged: (text) {
                _newIngredient.name = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('gramsPerPiece:')),
              initialValue: "${_ingredient.gramsPerPiece}",
              onChanged: (text) {
                _newIngredient.gramsPerPiece = double.parse(text);
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('recipes:')),
              initialValue:
                  "${_ingredient.recipes.map((e) => e?.name).join(",")}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Tags:')),
              initialValue: "${_ingredient.tags.map((e) => e?.tag).join(",")}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('kcal:')),
              initialValue: "${_ingredient.nutritionalValues.kcal}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Na:')),
              initialValue: "${_ingredient.nutritionalValues.na}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('k:')),
              initialValue: "${_ingredient.nutritionalValues.k}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('prot:')),
              initialValue: "${_ingredient.nutritionalValues.prot}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('fat:')),
              initialValue: "${_ingredient.nutritionalValues.fat}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('fe:')),
              initialValue: "${_ingredient.nutritionalValues.fe}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('mg:')),
              initialValue: "${_ingredient.nutritionalValues.mg}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('nt:')),
              initialValue: "${_ingredient.nutritionalValues.nt}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Suiker:')),
              initialValue: "${_ingredient.nutritionalValues.sugar}",
            ),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
              ),
              items: _categories,
              onChanged: (String? newValue) {
                setState(() {
                  _newIngredient.productName = newValue;
                });
              },
              selectedItem: "${_ingredient.productName ?? ''}",
            ),
            ElevatedButton(
              child: Text('SAVE'),
              onPressed: () {
                _saveForm();
              },
            )
          ],
        ))));
  }
}
