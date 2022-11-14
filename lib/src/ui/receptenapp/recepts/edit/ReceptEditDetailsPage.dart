import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../GetItDependencies.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/recipes/v1/recept.dart';
import '../../../../services/RecipesService.dart';
import 'ReceptEditIngredientsPage.dart';

class ReceptEditDetailsPage extends StatefulWidget {

  ReceptEditDetailsPage({Key? key, required this.title, required this.recept, required this.insertMode})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;
  final bool insertMode;

  @override
  State<ReceptEditDetailsPage> createState() => _WidgetState(recept, insertMode);
}

class _WidgetState extends State<ReceptEditDetailsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  late bool _insertMode;
  var _recipesService = getIt<RecipesService>();

  _WidgetState(EnrichedRecept recept, bool insertMode) {
    this._recept = recept;
    this._newRecept = recept.recept;
    this._insertMode = insertMode;
  }

  _saveRecept() {
    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context));
  }

  _newReceptNextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReceptEditIngredientsPage(
              title: 'Setup ingredients', recept: _recept, insertMode: true,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(label: Text('Name:')),
              initialValue: "${_recept.recept.name}",
              onChanged: (text) {
                _newRecept.name = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Opmerking:')),
              initialValue: "${_recept.recept.remark}",
              onChanged: (text) {
                _newRecept.remark = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Voorbereidingstijd:')),
              initialValue: "${_recept.recept.preparingTime}",
              onChanged: (text) {
                _newRecept.preparingTime = int.parse(text);
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Totale kooktijd:')),
              initialValue: "${_recept.recept.totalCookingTime}",
              onChanged: (text) {
                _newRecept.totalCookingTime = int.parse(text);
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Aantal personen:')),
              initialValue: "${_recept.recept.nrPersons}",
              onChanged: (text) {
                _newRecept.nrPersons = int.parse(text);
              },
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
              },
            ),
          ],
        ))));
  }
}
