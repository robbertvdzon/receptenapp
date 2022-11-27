import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:pasteboard/pasteboard.dart';

import '../../../GetItDependencies.dart';
import '../../../events/SnackChangedEvent.dart';
import '../../../model/diary/v1/diary.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/snacks/v1/snack.dart';
import '../../../repositories/DiaryRepository.dart';
import '../../../repositories/SnacksRepository.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Enricher.dart';
import '../../../services/ImageStorageService.dart';
import '../../../services/SnacksService.dart';
import '../../Icons.dart';
import '../recepts/ReceptIngredientItemWidget.dart';
import 'edit/SnackEditDetailsPage.dart';
import 'edit/SnackEditIngredientsPage.dart';

class SnackDetailsPage extends StatefulWidget {
  SnackDetailsPage({Key? key, required this.title, required this.snack})
      : super(key: key) {}

  final EnrichedSnack snack;
  final String title;

  @override
  State<SnackDetailsPage> createState() => _WidgetState(snack);
}

class _WidgetState extends State<SnackDetailsPage> {
  var _snacksService = getIt<SnacksService>();
  var _diaryRepository = getIt<DiaryRepository>(); // TODO: via service!
  var _appStateService = getIt<AppStateService>();

  late EnrichedSnack _enrichedSnack;
  var _enricher = getIt<Enricher>();
  var _eventBus = getIt<EventBus>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? snackImage = null;

  _WidgetState(EnrichedSnack snack) {
    this._enrichedSnack = snack;
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
    if (event.snack.uuid == _enrichedSnack.snack.uuid) {
      setState(() {
        Snack? updatedSnack = _appStateService.getSnacks().firstWhereOrNull(
            (element) => element.uuid == _enrichedSnack.snack.uuid);
        if (updatedSnack != null) {
          _enrichedSnack = _enricher.enrichSnack(updatedSnack);
          snackImage = null;
        }
      });
    }
  }

  void _nextSnack() {
    Snack newSnack = _getNextSnack(_enrichedSnack.snack);
    _enrichedSnack = _enricher.enrichSnack(newSnack);
    snackImage = null;
    setState(() {});
  }

  void _prevSnack() {
    Snack newSnack = _getPreviousSnack(_enrichedSnack.snack);
    _enrichedSnack = _enricher.enrichSnack(newSnack);
    snackImage = null;
    setState(() {});
  }

  Snack _getNextSnack(Snack snack) {
    int currentIndex = _appStateService.getFilteredSnacks().indexOf(snack);
    int newIndex = currentIndex + 1;
    if (newIndex < _appStateService.getFilteredSnacks().length) {
      return _appStateService.getFilteredSnacks().elementAt(newIndex);
    } else {
      return _appStateService.getFilteredSnacks().last;
    }
  }

  Snack _getPreviousSnack(Snack snack) {
    int currentIndex = _appStateService.getFilteredSnacks().indexOf(snack);
    if (currentIndex == 0) return snack;
    if (currentIndex > _appStateService.getFilteredSnacks().length) {
      return _appStateService.getFilteredSnacks().last;
    }
    return _appStateService.getFilteredSnacks().elementAt(currentIndex - 1);
  }

  void updateImageFromClipboard() async {
    Uint8List? bytes = await Pasteboard.image;
    if (bytes != null) {
      _imageStorageService.storeSnackImage(this._enrichedSnack.snack, bytes);
    }
  }

  void removeSnack() async {
    Snack currentSnack = _enrichedSnack.snack;
    Snack nextSnack = _getNextSnack(_enrichedSnack.snack);
    if (nextSnack == currentSnack) {
      // this is the last snack, close this page when removed
      _snacksService.removeSnack(currentSnack);
      Navigator.pop(context);
    } else {
      _snacksService.removeSnack(currentSnack);
      _enrichedSnack = _enricher.enrichSnack(nextSnack);
      snackImage = null;
      setState(() {});
    }
  }

  void addToDiary(String selectedDay, String partOfDay) async {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    var offsetDays = 0;
    // TODO: Get this list from a predefined set!
    if (selectedDay=="3 dagen geleden") offsetDays = -3;
    if (selectedDay=="Eergisteren") offsetDays = -2;
    if (selectedDay=="Gisteren") offsetDays = -1;
    if (selectedDay=="Vandaag") offsetDays = 0;
    if (selectedDay=="Morgen") offsetDays = 1;
    if (selectedDay=="Overmorgen") offsetDays = 2;
    if (selectedDay=="Over 3 dagen") offsetDays = 3;
    if (selectedDay=="Over 4 dagen") offsetDays = 4;
    DateTime selectedDate =  today.add(new Duration(days: offsetDays));
    int selectedDateInMsec = selectedDate.millisecondsSinceEpoch;

    DiaryDay? diaryDay = _diaryRepository.getDay(selectedDateInMsec);
    var snack = _enrichedSnack.snack;
    var foodEaten = FoodEaten(1,null, snack);

    if (diaryDay == null) {
      diaryDay = DiaryDay(selectedDateInMsec);
    }

    if (partOfDay=="breakfast") diaryDay.breakfast.add(foodEaten);
    if (partOfDay=="morningSnack") diaryDay.morningSnack.add(foodEaten);
    if (partOfDay=="lunch") diaryDay.lunch.add(foodEaten);
    if (partOfDay=="afternoonSnack") diaryDay.afternoonSnack.add(foodEaten);
    if (partOfDay=="diner") diaryDay.diner.add(foodEaten);
    if (partOfDay=="eveningSnack") diaryDay.eveningSnack.add(foodEaten);

    _diaryRepository.saveDiaryDay(diaryDay);
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
          Text("Kcal"),
          Text(":"),
          Text("${_enrichedSnack.nutritionalValues.kcal}"),
        ]),
        TableRow(children: [
          Text("Vet"),
          Text(":"),
          Text("${_enrichedSnack.nutritionalValues.fat}"),
        ]),
        TableRow(children: [
          Text("Proteine"),
          Text(":"),
          Text("${_enrichedSnack.nutritionalValues.prot}"),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection;

    if (snackImage == null) {
      final Future<Image> data =
          _imageStorageService.get300x300(_enrichedSnack.snack.uuid);
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
          actions: [
            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Edit snack details"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Edit ingredients"),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Text("Update image from clipboard"),
                ),
                PopupMenuItem<int>(
                  value: 5,
                  child: Text("Remove snack"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SnackEditDetailsPage(
                          title: 'Edit',
                          snack: _enrichedSnack,
                          insertMode: false)),
                );
              } else if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SnackEditIngredientsPage(
                          title: 'Edit',
                          snack: _enrichedSnack,
                          insertMode: false)),
                );
              } else if (value == 4) {
                updateImageFromClipboard();
              } else if (value == 5) {
                removeSnack();
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
                _nextSnack();
              }
              if (swipeDirection == 'right') {
                _prevSnack();
              }
            },
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Text(_enrichedSnack.snack.name,
                        style: TextStyle(fontSize: 25.0)),
                    Container(
                        alignment: Alignment.topLeft, // use aligment
                        padding: EdgeInsets.only(
                            left: 0, bottom: 0, right: 20, top: 0),
                        child: img),
                    ElevatedButton(
                      child: Text('Voeg toe aan dagboek'),
                      onPressed: () {
                        showAddToDiaryDialogSelectDay(context);
                      },
                    ),
                    Text(''),
                    Text('Ingredienten:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ] +
                  _enrichedSnack.ingredienten.map((item) {
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
                    Text('Details:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Container(
                      alignment: Alignment.center, // use aligment
                      padding: EdgeInsets.only(
                          left: 0, bottom: 0, right: 20, top: 0),
                      child: tableWithValues(),
                    ),
                  ],
            ))));
  }

  void showAddToDiaryDialogSelectDay(BuildContext context) {
    // TODO: Get this list from a predefined set!
    const List<String> list = <String>['3 dagen geleden', 'Eergisteren', 'Gisteren', 'Vandaag', 'Morgen', 'Overmorgen', "Over 3 dagen", "Over 4 dagen"];
    String selectedDay = 'Vandaag';
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Voeg maaltijd toe aan dagboek'),
        content: const Text('Voor welke dag?'),
        actions: <Widget>[
          DropdownButton<String>(
            value: selectedDay,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            underline: Container(
              height: 2,
            ),
            onChanged: (String? value) {
              setState(() {
                selectedDay = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showAddToDiaryDialogPageSelectPartOfDay(context, selectedDay);
            },
            child: const Text('Volgende'),
          ),
        ],
      ),
    );
  }

  void showAddToDiaryDialogPageSelectPartOfDay(BuildContext context, String selectedDay) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Voeg maaltijd toe aan dagboek'),
        content: const Text('Voor welk dagdeel?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addToDiary(selectedDay, 'breakfast');
            },
            child: const Text('Ontbijt'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addToDiary(selectedDay, 'morningSnack');
            },
            child: const Text('Ochtendsnack'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addToDiary(selectedDay, 'lunch');
            },
            child: const Text('Lunch'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addToDiary(selectedDay, 'afternoonSnack');
            },
            child: const Text('Middagsnack'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addToDiary(selectedDay, 'diner');
            },
            child: const Text('Avondeten'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addToDiary(selectedDay, 'eveningSnack');
            },
            child: const Text('Avondsnack'),
          ),
        ],
      ),
    );
  }
}
