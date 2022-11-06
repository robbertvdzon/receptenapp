import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pasteboard/pasteboard.dart';

import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/RecipesService.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import '../../../ui/receptenapp/recepts/ImageTool.dart';
import 'package:http/http.dart' as http;

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
  String _textValue = '';
  String? importImageFromUrl = null;
  var _recipesService = getIt<RecipesService>();

  _WidgetState(EnrichedRecept recept) {
    this._recept = recept;
    this._newRecept = recept.recept;
  }

  _saveRecept() {
    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context));
  }

  Future<Uint8List> networkImageToBase64(String imageUrl) async {
    var uri = Uri.parse(imageUrl);
    print(uri);
    http.Response response = await http.get(uri);
    Uint8List r = response.bodyBytes;
    return r;
  }

  storeImage(Uint8List value) {
    print("--1");
    String base64Image = base64Encode(value);
    print("--2");
    var resizedBase64String = resizeImage(base64Image);
    print("--3");
    this._newRecept.base64Image80pixels = resizedBase64String;
    print("--4");
    _saveRecept();
  }

  void _updateImageData() {
    if (importImageFromUrl != null) {
      print("--01");
      Future<Uint8List> imageBytes = networkImageToBase64(importImageFromUrl!);
      print("--02");
      imageBytes.then((value) => storeImage(value)).onError(
          (error, stackTrace) =>
              print(error.toString() + " " + stackTrace.toString()));
      print("--03");
    }
  }


  void _getClipboard() async {
    Uint8List? bytes = await Pasteboard.image;
    if (bytes!=null){
      var data = base64Encode(bytes!);
      _textValue = data;
      this._newRecept.base64Image80pixels = data;
      _saveRecept();

    }
    else{
      _textValue = "No image found on clipboard";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(label: Text('uuid:')),
              initialValue: "${_recept.recept.uuid}",
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
              decoration: InputDecoration(label: Text('Image data:')),
              initialValue: "${_recept.recept.base64Image80pixels}",
              onChanged: (text) {
                _newRecept.base64Image80pixels = text;
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
            TextFormField(
              decoration: InputDecoration(label: Text('Image from url:')),
              initialValue: "",
              onChanged: (text) {
                importImageFromUrl = text;
              },
            ),
            ElevatedButton(
              child: Text('Update image'),
              onPressed: () {
                _updateImageData();
              },
            ),

            ElevatedButton(
              child: Text('Get Data'),
              onPressed: () {
                _getClipboard();
              },
            ),
            Text('Clipboard Value : $_textValue'),

          ],
        )));
  }
}
