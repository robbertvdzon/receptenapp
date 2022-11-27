import 'dart:async';
import 'dart:typed_data';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pasteboard/pasteboard.dart';

import '../../../../GetItDependencies.dart';
import '../../../../events/SnackChangedEvent.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/snacks/v1/snack.dart';
import '../../../../services/ImageStorageService.dart';
import '../../../../services/SnacksService.dart';
import 'SnackEditIngredientsPage.dart';

class SnackEditDetailsPage extends StatefulWidget {

  SnackEditDetailsPage({Key? key, required this.title, required this.snack, required this.insertMode})
      : super(key: key) {}

  final EnrichedSnack snack;
  final String title;
  final bool insertMode;

  @override
  State<SnackEditDetailsPage> createState() => _WidgetState(snack, insertMode);
}

class _WidgetState extends State<SnackEditDetailsPage> {
  late EnrichedSnack _snack;
  late Snack _newSnack;
  late bool _insertMode;
  var _eventBus = getIt<EventBus>();
  var _snacksService = getIt<SnacksService>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? snackImage = null;

  _WidgetState(EnrichedSnack snack, bool insertMode) {
    this._snack = snack;
    this._newSnack = snack.snack;
    this._insertMode = insertMode;
  }

  @override
  void initState() {
    _eventStreamSub = _eventBus
        .on<SnackChangedEvent>()
        .listen((event) => _processEvent(event));
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _processEvent(SnackChangedEvent event) {
    if (event.snack.uuid == _snack.snack.uuid) {
      setState(() {
        // only clear the image when there is an update (this update is because we pasted the image from clipboard)
          snackImage = null;
      });
    }
  }

  _saveSnack() {
    _snacksService
        .saveSnack(_newSnack)
        .whenComplete(() => Navigator.pop(context));
  }

  _newSnackNextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SnackEditIngredientsPage(
              title: 'Setup ingredients', snack: _snack, insertMode: true,)),
    );
  }

  void _updateImageFromClipboard() async {
    Uint8List? bytes = await Pasteboard.image;
    if (bytes != null) {
      _imageStorageService.storeSnackImage(this._snack.snack, bytes);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (snackImage == null) {
      final Future<Image> data =
      _imageStorageService.get300x300(_snack.snack.uuid);
      data
          .then((value) => setState(() {
        snackImage = value;
      }))
          .catchError((e) => print(e));
    }
    var img = snackImage != null
        ? snackImage
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
              autofocus: true,
              decoration: InputDecoration(label: Text('Name:')),
              initialValue: "${_snack.snack.name}",
              onChanged: (text) {
                _newSnack.name = text;
              },
            ),
            ElevatedButton(
              child: _insertMode?Text('Next'):Text('Save'),
              onPressed: () {
                if (_insertMode){
                  _newSnackNextStep();
                }
                else{
                  _saveSnack();
                }
              },
            ),
          ],
        ))));
  }
}
