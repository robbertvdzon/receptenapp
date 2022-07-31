import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/ReceptenRepository.dart';
import '../global.dart';
import '../model/model.dart';
import '../services/NutrientsRepository.dart';

class IngredientItemWidget extends StatefulWidget {
  IngredientItemWidget({Key? key, required this.ingredient})
      : super(key: key) {}

  final Ingredient ingredient;

  @override
  State<IngredientItemWidget> createState() => _WidgetState(ingredient);
}

class _WidgetState extends State<IngredientItemWidget> {
  late Ingredient ingredient;
  late Ingredient newIngredient;
  List<String> categories = ["One","Two","","groente", "Four","Three"];
  var receptenRepository = getIt<ReceptenRepository>();
  var nutrientsRepository = getIt<NutrientsRepository>();

  _WidgetState(Ingredient ingredient) {
    this.ingredient = ingredient;
    this.newIngredient = ingredient;
    // final r = await nutrientsRepository.loadNutrients();

    nutrientsRepository.loadNutrients().then((value) => {
      setState(() {
        categories = value.nutrients.map((e) => e.category??"").toSet().toList();
      })
    });

  }



  _saveForm() {
    receptenRepository
        .loadReceptenbook()
        .then((value) => saveIngredient(value, newIngredient));
  }

  saveIngredient(ReceptenBoek receptenBoek, Ingredient newIngredient) {
    // receptenBoek.ingredienten.remove(ingredient);
    receptenBoek.ingredienten
        .where((element) => element.uuid == ingredient.uuid)
        .forEach((element) {
      element.name = newIngredient.name;
      element.nutrientName = newIngredient.nutrientName;
    });
    receptenRepository.saveReceptenBoek(receptenBoek);
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
        // TextFormField(
        //   decoration: InputDecoration(label: Text('Voedingsmiddel:')),
        //   initialValue: "${ingredient.nutrientName}",
        //   onChanged: (text) {
        //     newIngredient.nutrientName = text;
        //   },
        // ),
        DropdownButton<String>(
          value: "${ingredient.nutrientName??''}",
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              newIngredient.nutrientName = newValue;
            });
          },
          items: buildList(),
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