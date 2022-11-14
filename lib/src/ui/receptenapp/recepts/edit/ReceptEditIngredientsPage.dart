import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../GetItDependencies.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/recipes/v1/recept.dart';
import '../../../../services/RecipesService.dart';
import 'ReceptEditInstructionsPage.dart';

class ReceptEditIngredientsPage extends StatefulWidget {
  ReceptEditIngredientsPage(
      {Key? key, required this.title, required this.recept, required this.insertMode})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;
  final bool insertMode;

  @override
  State<ReceptEditIngredientsPage> createState() => _WidgetState(recept, insertMode);
}

class _WidgetState extends State<ReceptEditIngredientsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  late bool _insertMode;
  var ingredientsString = "";
  String importErrors = "";

  var _recipesService = getIt<RecipesService>();
  final TextEditingController _textEditingController = TextEditingController();

  _WidgetState(EnrichedRecept recept, bool insertMode) {
    this._recept = recept;
    this._newRecept = recept.recept;
    this._insertMode = insertMode;
    ingredientsString =
        _recept.ingredienten.map((e) => e.toTextString()).join("\n");
  }

  _saveRecept() {
    if (importErrors.isEmpty){
      _newRecept.ingredients = verifyText(_textEditingController.text);
      _recipesService
          .saveRecept(_newRecept)
          .whenComplete(() => Navigator.pop(context));
    }
    else{
      showDialog(context: context, builder: (context) {
        return new SimpleDialog(
            children: <Widget>[
              new Center(child: new Container(child: new Text(importErrors)))
            ]);
      });
    }
  }

  _newReceptNextStep() {
    if (importErrors.isEmpty){
      _recept.recept.ingredients = verifyText(_textEditingController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReceptEditInstructionsPage(
              title: 'Setup instructions', recept: _recept, insertMode: true,)),
      );
    }
    else{
      showDialog(context: context, builder: (context) {
        return new SimpleDialog(
            children: <Widget>[
              new Center(child: new Container(child: new Text(importErrors)))
            ]);
      });
    }
  }


  List<ReceptIngredient> verifyText(String text) {
    // setState(() {
      List<ReceptIngredient> ingredients = [];

      LineSplitter ls = new LineSplitter();
      List<String> lines = ls.convert(text);
      String error = "";
      for (var i = 0; i < lines.length; i++) {
        print('Line $i: ${lines[i]}');

        List<String> parts = lines[i].split(" ");
        if (parts.length<=2){
          error = error + "Line $i is invalid ";
        }
        else{
          String nrString = parts[0];
          String unit = parts[1];
          String ingredient = parts[2];
          double? nr = double.tryParse(nrString);
          if (nr==null){
            error = error + "Line $i: $nrString is not a number";
          }
          else{
            print('valid!  nr: $nr unit:$unit ingredient:$ingredient');
            var amount = ReceptIngredientAmount(nr, unit);
            var ri = ReceptIngredient(ingredient);
            ri.amount = amount;
            ingredients.add(ri);
          }
        }
      }

      importErrors = error;
      return ingredients;
    // });
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = ingredientsString;

    // var button = (importErrors.isEmpty)? ElevatedButton(child: Text('SAVE'),onPressed: () {_saveRecept();},) : Text(importErrors!);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                verifyText(text);
              },
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              //Normal textInputField will be displayed
              maxLines: 20, // when user presses enter it will adapt to it
            ),
            ElevatedButton(
              child: _insertMode?Text('Next'):Text('Save'),
              onPressed: () {
              if (_insertMode){
                _newReceptNextStep();
              }
              else{
                _saveRecept();
              }


              },)
            // button,
          ],
        ))));
  }
}
