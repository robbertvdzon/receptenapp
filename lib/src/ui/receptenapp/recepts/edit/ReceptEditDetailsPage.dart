import 'dart:async';
import 'dart:typed_data';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pasteboard/pasteboard.dart';

import '../../../../GetItDependencies.dart';
import '../../../../events/ReceptChangedEvent.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/recipes/v1/recept.dart';
import '../../../../services/ImageStorageService.dart';
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
  var _eventBus = getIt<EventBus>();
  var _recipesService = getIt<RecipesService>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? receptImage = null;

  _WidgetState(EnrichedRecept recept, bool insertMode) {
    this._recept = recept;
    this._newRecept = recept.recept;
    this._insertMode = insertMode;
  }

  @override
  void initState() {
    _eventStreamSub = _eventBus
        .on<ReceptChangedEvent>()
        .listen((event) => _processEvent(event));
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _processEvent(ReceptChangedEvent event) {
    if (event.recept.uuid == _recept.recept.uuid) {
      setState(() {
        // only clear the image when there is an update (this update is because we pasted the image from clipboard)
          receptImage = null;
      });
    }
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

  void _updateImageFromClipboard() async {
    Uint8List? bytes = await Pasteboard.image;
    if (bytes != null) {
      _imageStorageService.storeImage(this._recept.recept, bytes);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (receptImage == null) {
      final Future<Image> data =
      _imageStorageService.get300x300(_recept.recept.uuid);
      data
          .then((value) => setState(() {
        receptImage = value;
      }))
          .catchError((e) => print(e));
    }
    var img = receptImage != null
        ? receptImage
        : Image.asset("assets/images/transparant300x300.png",
        height: 300, width: 300, fit: BoxFit.cover);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft, // use aligment
                padding: EdgeInsets.only(
                    left: 0, bottom: 0, right: 20, top: 0),
                child: img),
            Text(''),
            ElevatedButton(
              child: Text('Load image from clipboard'),
              onPressed: () {
                _updateImageFromClipboard();
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
