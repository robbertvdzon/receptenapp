import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/RecipesRepository.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/ProductsRepository.dart';
import 'ReceptDetailsPage.dart';

class ReceptItemWidget extends StatefulWidget {
  ReceptItemWidget({Key? key, required this.recept})
      : super(key: key) {}

  final Recept recept;

  @override
  State<ReceptItemWidget> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptItemWidget> {
  late Recept recept;
  late Recept newRecept;
  var recipesRepository = getIt<RecipesRepository>();

  _WidgetState(Recept recept) {
    this.recept = recept;
    this.newRecept = recept;
  }

  _saveForm() {
    recipesRepository
        .loadRecipes()
        .then((value) => saveRecept(value, newRecept));
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReceptDetailsPage(title: 'Recept', recept: recept)),
    );
  }

  saveRecept(Recipes recipes, Recept newRecept) {
    // receptenBoek.recepten.remove(recept);
    recipes.recipes
        .where((element) => element.uuid == recept.uuid)
        .forEach((element) {
      element.name = newRecept.name;
    });
    recipesRepository.saveRecipes(recipes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextButton(
          onPressed: () {
            _openForm();
          },
          child: new Text(recept.name),
        )
      ],
    );
  }

}


