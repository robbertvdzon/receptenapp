import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:pasteboard/pasteboard.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../repositories/RecipesRepository.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Enricher.dart';
import '../../../services/ImageStorageService.dart';
import '../../../services/RecipesService.dart';
import '../../Icons.dart';
import 'edit/ReceptEditDetailsPage.dart';
import 'edit/ReceptEditIngredientsPage.dart';
import 'edit/ReceptEditInstructionsPage.dart';
import 'edit/ReceptEditTagsPage.dart';
import 'ReceptIngredientItemWidget.dart';

class ReceptDetailsPage extends StatefulWidget {
  ReceptDetailsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;

  @override
  State<ReceptDetailsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptDetailsPage> {
  var _recipesService = getIt<RecipesService>();
  var _appStateService = getIt<AppStateService>();

  late EnrichedRecept _enrichedRecept;
  var _enricher = getIt<Enricher>();
  var _eventBus = getIt<EventBus>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? receptImage = null;

  _WidgetState(EnrichedRecept recept) {
    this._enrichedRecept = recept;
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
    if (event.recept.uuid == _enrichedRecept.recept.uuid) {
      setState(() {
        Recept? updatedRecept = _appStateService.getRecipes().firstWhereOrNull(
            (element) => element.uuid == _enrichedRecept.recept.uuid);
        if (updatedRecept != null) {
          _enrichedRecept = _enricher.enrichRecipe(updatedRecept);
          receptImage = null;
        }
      });
    }
  }

  void _nextRecept() {
    Recept newRecept = _getNextRecept(_enrichedRecept.recept);
    _enrichedRecept = _enricher.enrichRecipe(newRecept);
    receptImage = null;
    setState(() {});
  }

  void _prevRecept() {
    Recept newRecept = _getPreviousRecept(_enrichedRecept.recept);
    _enrichedRecept = _enricher.enrichRecipe(newRecept);
    receptImage = null;
    setState(() {});
  }

  Recept _getNextRecept(Recept recept) {
    int currentIndex = _appStateService.getFilteredRecipes().indexOf(recept);
    int newIndex = currentIndex + 1;
    if (newIndex < _appStateService.getFilteredRecipes().length) {
      return _appStateService.getFilteredRecipes().elementAt(newIndex);
    } else {
      return _appStateService.getFilteredRecipes().last;
    }
  }

  Recept _getPreviousRecept(Recept recept) {
    int currentIndex = _appStateService.getFilteredRecipes().indexOf(recept);
    if (currentIndex == 0) return recept;
    if (currentIndex > _appStateService.getFilteredRecipes().length) {
      return _appStateService.getFilteredRecipes().last;
    }
    return _appStateService.getFilteredRecipes().elementAt(currentIndex - 1);
  }

  void _setFavorite(bool favorite) {
    Recept recept = _enrichedRecept.recept;
    recept.favorite = favorite;
    _recipesService.saveRecept(recept);
  }

  void updateImageFromClipboard() async {
    Uint8List? bytes = await Pasteboard.image;
    if (bytes != null) {
      _imageStorageService.storeImage(this._enrichedRecept.recept, bytes);
    }
  }

  void removeRecept() async {
    Recept currentRecept = _enrichedRecept.recept;
    Recept nextRecept = _getNextRecept(_enrichedRecept.recept);
    if (nextRecept==currentRecept){
      // this is the last recept, close this page when removed
      _recipesService.removeRecept(currentRecept);
      Navigator.pop(context);
    }
    else{
      _recipesService.removeRecept(currentRecept);
      _enrichedRecept = _enricher.enrichRecipe(nextRecept);
      receptImage = null;
      setState(() {});
    }


  }

  Table tableWithValues() {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(200),
        1: FixedColumnWidth(10),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          Text("Favoriet"),
          Text(":"),
          Text("${_enrichedRecept.recept.favorite}"),
        ]),
        TableRow(children: [
          Text("Voorbereidingstijd"),
          Text(":"),
          Text("${_enrichedRecept.recept.preparingTime}"),
        ]),
        TableRow(children: [
          Text("Totale kooktijd"),
          Text(":"),
          Text("${_enrichedRecept.recept.totalCookingTime}"),
        ]),
        TableRow(children: [
          Text("Kcal"),
          Text(":"),
          Text("${_enrichedRecept.nutritionalValues.kcal}"),
        ]),
        TableRow(children: [
          Text("Vet"),
          Text(":"),
          Text("${_enrichedRecept.nutritionalValues.fat}"),
        ]),
        TableRow(children: [
          Text("Proteine"),
          Text(":"),
          Text("${_enrichedRecept.nutritionalValues.prot}"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection;

    if (receptImage == null) {
      final Future<Image> data =
          _imageStorageService.get300x300(_enrichedRecept.recept.uuid);
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
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Edit recept details"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Edit ingredients"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Edit instructions"),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Text("Edit tags"),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Text("Update image from clipboard"),
                ),
                PopupMenuItem<int>(
                  value: 5,
                  child: Text("Remove recept"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceptEditDetailsPage(
                          title: 'Edit', recept: _enrichedRecept, insertMode: false)),
                );
              } else if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceptEditIngredientsPage(
                          title: 'Edit', recept: _enrichedRecept, insertMode: false)),
                );
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceptEditInstructionsPage(
                          title: 'Edit', recept: _enrichedRecept, insertMode: false)),
                );
              } else if (value == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceptEditTagsPage(
                          title: 'Edit', recept: _enrichedRecept, insertMode: false)),
                );
              } else if (value == 4) {
                updateImageFromClipboard();
              } else if (value == 5) {
                removeRecept();
              }
            }),
          ],
        ),
        body: GestureDetector(
            onPanUpdate: (details) {
              swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
            },
            onPanEnd: (details) {
              if (swipeDirection == null) {
                return;
              }
              if (swipeDirection == 'left') {
                _nextRecept();
              }
              if (swipeDirection == 'right') {
                _prevRecept();
              }
            },
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Text(_enrichedRecept.recept.name,
                        style: TextStyle(fontSize: 25.0)),
                    Container(
                        alignment: Alignment.topLeft, // use aligment
                        padding: EdgeInsets.only(
                            left: 0, bottom: 0, right: 20, top: 0),
                        child: img),
                    if (_enrichedRecept.recept.favorite)
                      new Icon(ICON_YELLOW_STAR,
                          size: 20.0, color: Colors.yellow),
                    Text(''),
                    ElevatedButton(
                      child: Text('Voeg toe aan planner'),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ReceptEditDetailsPage(
                        //           title: 'Edit', recept: _enrichedRecept)),
                        // );
                      },
                    ),
                    Text(''),
                    if (!_enrichedRecept.recept.favorite)
                      ElevatedButton(
                        child: Text('Voeg toe aan favorieten'),
                        onPressed: () {
                          _setFavorite(true);
                        },
                      ),
                    if (_enrichedRecept.recept.favorite)
                      ElevatedButton(
                        child: Text('Verwijder van favorieten'),
                        onPressed: () {
                          _setFavorite(false);
                        },
                      ),
                    Text(''),
                    Text('Opmerkingen:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(_enrichedRecept.recept.remark),
                    Text(''),
                    Text('Toegevoegd op:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(DateFormat('yyyy-MM-dd')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            _enrichedRecept.recept.dateAdded))
                        .toString()),
                    Text(''),
                    Text('Aantal personen:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(_enrichedRecept.recept.nrPersons.toString()),
                    Text(''),
                    Text('Ingredienten:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ] +
                  _enrichedRecept.ingredienten.map((item) {
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints.expand(
                              height: 20.0,
                            ),
                            alignment: Alignment.topLeft,
                            child: ReceptIngredientItemWidget(
                                ingredient: item, key: ObjectKey(item)),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(0),
                    );
                  }).toList() +
                  [
                    Text(''),
                    Text('Instructions:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    MarkdownBody(
                      data: _enrichedRecept.recept.instructions ?? "",
                    ),
                    Text(''),
                    Text('Details:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Container(
                      alignment: Alignment.center, // use aligment
                      padding: EdgeInsets.only(
                          left: 0, bottom: 0, right: 20, top: 0),
                      child: tableWithValues(),
                    ),
                    Text(''),
                    Text('Tags:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Text(
                        "${_enrichedRecept.tags.map((e) => e?.tag).join("\n")}"),
                  ],
            ))));
  }
}
