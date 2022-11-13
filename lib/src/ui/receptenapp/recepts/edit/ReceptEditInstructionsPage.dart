import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:collection/collection.dart';

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
  ReceptEditInstructionsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;

  @override
  State<ReceptEditInstructionsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptEditInstructionsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  var _recipesService = getIt<RecipesService>();
  final TextEditingController _textEditingController = TextEditingController();

  _WidgetState(EnrichedRecept recept) {
    this._recept = recept;
    this._newRecept = recept.recept;
  }

  _saveRecept() {
    _newRecept.instructions =  _textEditingController.text;
    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context));
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
              controller: _textEditingController,
              keyboardType: TextInputType.multiline,
              minLines: 1,//Normal textInputField will be displayed
              maxLines: 20,// when user presses enter it will adapt to it
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                _saveRecept();
              },
            ),
          ],
        ))));
  }

}
