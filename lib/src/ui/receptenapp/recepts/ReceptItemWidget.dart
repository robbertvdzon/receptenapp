import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../services/Enricher.dart';
import '../../../services/ImageStorageService.dart';
import '../../Icons.dart';
import 'ReceptDetailsPage.dart';
import 'package:flutter/widgets.dart';

class ReceptItemWidget extends StatefulWidget {
  ReceptItemWidget({Key? key, required this.recept}) : super(key: key) {}

  final EnrichedRecept recept;

  @override
  State<ReceptItemWidget> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptItemWidget> {
  late EnrichedRecept _recept;
  final _eventBus = getIt<EventBus>();
  var _enricher = getIt<Enricher>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? receptImage = null;

  _WidgetState(EnrichedRecept recept) {
    this._recept = recept;
  }

  @override
  void initState() {
    _eventStreamSub = _eventBus.on<ReceptChangedEvent>().listen((event) => _processEvent(event));
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _processEvent(ReceptChangedEvent event) {
    if (event.recept.uuid == _recept.recept.uuid) {
      setState(() {
        _recept = _enricher.enrichRecipe(event.recept);
        receptImage = null;
      });
    }
  }

  _openRecept() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReceptDetailsPage(title: 'Recept', recept: _recept)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (receptImage==null) {
      final Future<Image> data = _imageStorageService.get120x120(_recept.recept.uuid);
      data.then((value) =>
          setState(() {
            receptImage = value;
          })
      );
    }
    var img = receptImage != null ? receptImage : Image.asset("assets/images/loading120x120.jpg", height: 120, width: 120, fit: BoxFit.cover);


    return InkWell(
        onTap: () {
          _openRecept();
        }, // Handle your callback
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              _recept.recept.name,
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft, // use aligment
                  padding:
                      EdgeInsets.only(left: 0, bottom: 0, right: 20, top: 0),
                  child: img
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_recept.recept.favorite)
                      new Icon(ICON_YELLOW_STAR, size: 20.0, color: Colors.yellow),
                    Text(_recept.recept.preparingTime.toString() +
                        "/" +
                        _recept.recept.totalCookingTime.toString() +
                        " minuten "),
                    Text(_recept.recept.remark),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
