import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/ImageStorageService.dart';
import '../../Icons.dart';

class ReceptItemWidgetCard extends StatefulWidget {
  ReceptItemWidgetCard({Key? key, required this.recept}) : super(key: key) {}

  final Recept recept;

  @override
  State<ReceptItemWidgetCard> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptItemWidgetCard> {
  late Recept _recept;
  final _eventBus = getIt<EventBus>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? receptImage = null;

  _WidgetState(Recept recept) {
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
    if (event.recept.uuid == _recept.uuid) {
      setState(() {
        _recept = event.recept;
        receptImage = null;
      });
    }
  }

  _openRecept() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
              // ReceptDetailsPage(title: 'Recept', recept: _recept)),
    // );
  }

  @override
  Widget build(BuildContext context) {

    if (receptImage==null) {
      final Future<Image> data = _imageStorageService.get300x300(_recept.uuid);
      data.then((value) =>
          setState(() {
            receptImage = value;
          })
      ).catchError((e) =>
            print(e)
      );
    }
    var img = receptImage != null ? receptImage : Image.asset("assets/images/transparant120x120.png", height: 120, width: 120, fit: BoxFit.cover);
    return InkWell(
        onTap: () {
          _openRecept();
        }, // Handle your callback
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              _recept.name,
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
                    if (_recept.favorite)
                      new Icon(ICON_YELLOW_STAR, size: 20.0, color: Colors.yellow),
                    Text(_recept.preparingTime.toString() +
                        "/" +
                        _recept.totalCookingTime.toString() +
                        " minuten "),
                    Text(_recept.remark),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
