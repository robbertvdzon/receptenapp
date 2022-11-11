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

class ReceptEditPage extends StatefulWidget {
  ReceptEditPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;

  @override
  State<ReceptEditPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptEditPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  var _recipesService = getIt<RecipesService>();
  var _imageStorageService = getIt<ImageStorageService>();
  var _eventBus = getIt<EventBus>();
  var _appStateService = getIt<AppStateService>();
  var _enricher = getIt<Enricher>();
  StreamSubscription? _eventStreamSub;
  Image? receptImage = null;

  _WidgetState(EnrichedRecept recept) {
    this._recept = recept;
    this._newRecept = recept.recept;
  }

  _saveRecept() {
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


  void _getClipboard() async {
    Uint8List? bytes = await Pasteboard.image;
    if (bytes != null) {
      _imageStorageService.storeImage(this._recept.recept.uuid, bytes).whenComplete(() =>
          _eventBus.fire(ReceptChangedEvent(this._recept.recept))
      );
    }
  }

  @override
  Widget build(BuildContext context) {

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
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
              child: img
            ),
            ElevatedButton(
              child: Text('Load image from clipboard'),
              onPressed: () {
                _getClipboard();
              },
            ),
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
            TextFormField(
              decoration: InputDecoration(label: Text('Nt:')),
              initialValue: "${_recept.nutritionalValues.nt}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Kcal:')),
              initialValue: "${_recept.nutritionalValues.kcal}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Fat:')),
              initialValue: "${_recept.nutritionalValues.fat}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Ingredients:')),
              initialValue:
                  "${_recept.ingredienten.map((e) => e?.toTextString()).join(",")}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Tags:')),
              initialValue: "${_recept.tags.map((e) => e?.tag).join(",")}",
            ),
            ElevatedButton(
              child: Text('SAVE!'),
              onPressed: () {
                _saveRecept();
              },
            ),
          ],
        )));
  }

}
