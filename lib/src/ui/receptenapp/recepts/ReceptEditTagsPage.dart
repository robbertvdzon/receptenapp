import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:collection/collection.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Enricher.dart';
import '../../../services/ImageStorageService.dart';
import '../../../services/RecipesService.dart';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class ReceptEditTagsPage extends StatefulWidget {
  ReceptEditTagsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;

  @override
  State<ReceptEditTagsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptEditTagsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  var _recipesService = getIt<RecipesService>();
  var _imageStorageService = getIt<ImageStorageService>();
  var _eventBus = getIt<EventBus>();
  var _appStateService = getIt<AppStateService>();
  var _enricher = getIt<Enricher>();
  StreamSubscription? _eventStreamSub;
  Image? receptImage = null;
  final TextEditingController _textEditingController = TextEditingController();

  _WidgetState(EnrichedRecept recept) {
    this._recept = recept;
    this._newRecept = recept.recept;
  }

  _saveRecept() {
    _newRecept.directions =  _textEditingController.text;

    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context));
  }

  @override
  void initState() {
    _eventStreamSub = _eventBus.on<ReceptChangedEvent>().listen((event) => _processEvent(event));
  }

  void _processEvent(ReceptChangedEvent event) {
    if (event.recept.uuid == _recept.recept.uuid) {
      setState(() {
        Recept? updatedRecept = _appStateService.getRecipes().firstWhereOrNull((element) => element.uuid==_recept.recept.uuid);
        if (updatedRecept != null) {
          _recept = _enricher.enrichRecipe(updatedRecept);
          receptImage = null;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    _textEditingController.text = _recept.recept.directions;

    if (receptImage==null) {
      final Future<Image> data = _imageStorageService.get300x300(_recept.recept.uuid);
      data.then((value) =>
          setState(() {
            receptImage = value;
          })
      ).catchError((e) =>
          print(e)
      );
    }

    var img = receptImage != null ? receptImage : Image.asset("assets/images/transparant300x300.png", height: 300, width: 300, fit: BoxFit.cover);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
              child: img
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Tags:')),
              initialValue: "${_recept.tags.map((e) => e?.tag).join(",")}",
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
