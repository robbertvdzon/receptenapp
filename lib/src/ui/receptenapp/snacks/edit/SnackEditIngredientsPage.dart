import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../GetItDependencies.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/recipes/v1/recept.dart';
import '../../../../model/snacks/v1/snack.dart';
import '../../../../services/SnacksService.dart';

class SnackEditIngredientsPage extends StatefulWidget {
  SnackEditIngredientsPage(
      {Key? key, required this.title, required this.snack, required this.insertMode})
      : super(key: key) {}

  final EnrichedSnack snack;
  final String title;
  final bool insertMode;

  @override
  State<SnackEditIngredientsPage> createState() => _WidgetState(snack, insertMode);
}

class _WidgetState extends State<SnackEditIngredientsPage> {
  late EnrichedSnack _snack;
  late Snack _newSnack;
  late bool _insertMode;
  var ingredientsString = "";
  String importErrors = "";

  var _snacksService = getIt<SnacksService>();
  final TextEditingController _textEditingController = TextEditingController();

  _WidgetState(EnrichedSnack snack, bool insertMode) {
    this._snack = snack;
    this._newSnack = snack.snack;
    this._insertMode = insertMode;
    ingredientsString =
        _snack.ingredienten.map((e) => e.toTextString()).join("\n");
  }

  _saveSnack() {
    if (importErrors.isEmpty){
      _newSnack.ingredients = verifyText(_textEditingController.text);
      _snacksService
          .saveSnack(_newSnack)
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

  // _saveSnack() {
  //   _snacksService
  //       .saveSnack(_newSnack)
  //       .whenComplete(() => Navigator.pop(context))
  //   ;
  // }


  _newReceptNextStep() {
    _saveSnack();
    // pop 3 extra times (all other edit fields!)
    Navigator.pop(context);
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

    // var button = (importErrors.isEmpty)? ElevatedButton(child: Text('SAVE'),onPressed: () {_saveSnack();},) : Text(importErrors!);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
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
              child: _insertMode?Text('Add recept'):Text('Save'),
              onPressed: () {
                if (_insertMode){
                  _newReceptNextStep();
                }
                else{
                  _saveSnack();
                }
              },
            ),            // button,
          ],
        ))));
  }
}
