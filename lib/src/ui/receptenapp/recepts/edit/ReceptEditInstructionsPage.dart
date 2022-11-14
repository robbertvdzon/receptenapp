import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:collection/collection.dart';
import 'package:receptenapp/src/ui/receptenapp/recepts/edit/ReceptEditTagsPage.dart';

import '../../../../GetItDependencies.dart';
import '../../../../events/ReceptChangedEvent.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/recipes/v1/recept.dart';
import '../../../../services/AppStateService.dart';
import '../../../../services/Enricher.dart';
import '../../../../services/ImageStorageService.dart';
import '../../../../services/RecipesService.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class ReceptEditInstructionsPage extends StatefulWidget {
  ReceptEditInstructionsPage({Key? key, required this.title, required this.recept, required this.insertMode})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;
  final bool insertMode;

  @override
  State<ReceptEditInstructionsPage> createState() => _WidgetState(recept, insertMode);
}

class _WidgetState extends State<ReceptEditInstructionsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  late bool _insertMode;
  var _recipesService = getIt<RecipesService>();
  final TextEditingController _textEditingController = TextEditingController();

  _WidgetState(EnrichedRecept recept, bool insertMode) {
    this._recept = recept;
    this._newRecept = recept.recept;
    this._insertMode = insertMode;
  }

  _saveRecept() {
    _newRecept.instructions =  _textEditingController.text;
    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context));
  }

  _newReceptNextStep() {
    _recept.recept.instructions = _textEditingController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ReceptEditTagsPage(
            title: 'Setup tags', recept: _recept, insertMode: true,)),
    );
  }


  @override
  Widget build(BuildContext context) {
    _textEditingController.text = _recept.recept.instructions;

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
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              minLines: 1,//Normal textInputField will be displayed
              maxLines: 20,// when user presses enter it will adapt to it
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
