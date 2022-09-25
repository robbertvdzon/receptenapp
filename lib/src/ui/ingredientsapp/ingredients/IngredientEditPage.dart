import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/model/ingredients/v1/ingredients.dart';
import '../../../global.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../services/enricher/Enricher.dart';
import '../../../services/repositories/IngredientsRepository.dart';
import '../../../services/repositories/ProductsRepository.dart';

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
  late EnrichedIngredient ingredient;
  late Ingredient newIngredient;
  late List<String> categories = List.empty();
  var ingredientsRepository = getIt<IngredientsRepository>();
  var nutrientsRepository = getIt<ProductsRepository>();
  var enricher = getIt<Enricher>();

  _WidgetState(Ingredient ingredient) {
    this.ingredient = enricher.enrichtIngredient(ingredient);
    this.newIngredient = ingredient;
    this.categories = nutrientsRepository
        .getProducts()
        .products
        .map((e) => e.name ?? "")
        .toList();
  }

  _saveForm() {
    ingredientsRepository.saveIngredient(newIngredient);
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
              initialValue: "${ingredient.uuid}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Name:')),
              initialValue: "${ingredient.name}",
              onChanged: (text) {
                newIngredient.name = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('gramsPerPiece:')),
              initialValue: "${ingredient.gramsPerPiece}",
              onChanged: (text) {
                newIngredient.gramsPerPiece = double.parse(text);
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('recipes:')),
              initialValue:
                  "${ingredient.recipes.map((e) => e?.name).join(",")}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Tags:')),
              initialValue: "${ingredient.tags.map((e) => e?.tag).join(",")}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('kcal:')),
              initialValue: "${ingredient.nutritionalValues.kcal}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Na:')),
              initialValue: "${ingredient.nutritionalValues.na}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('k:')),
              initialValue: "${ingredient.nutritionalValues.k}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('prot:')),
              initialValue: "${ingredient.nutritionalValues.prot}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('fat:')),
              initialValue: "${ingredient.nutritionalValues.fat}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('fe:')),
              initialValue: "${ingredient.nutritionalValues.fe}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('mg:')),
              initialValue: "${ingredient.nutritionalValues.mg}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('nt:')),
              initialValue: "${ingredient.nutritionalValues.nt}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Suiker:')),
              initialValue: "${ingredient.nutritionalValues.sugar}",
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
              selectedItem: "${ingredient.nutrientName ?? ''}",
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
