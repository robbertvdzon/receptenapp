import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ReceptChangedEvent.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../Icons.dart';
import 'ReceptDetailsPage.dart';

class ReceptItemWidget extends StatefulWidget {
  ReceptItemWidget({Key? key, required this.recept}) : super(key: key) {}

  final Recept recept;

  @override
  State<ReceptItemWidget> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptItemWidget> {
  late Recept _recept;
  final _eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Recept recept) {
    this._recept = recept;
  }

  @override
  void initState() {
    _eventStreamSub = _eventBus.on<ReceptChangedEvent>().listen((event) => _processEvent(event));
  }

  void _processEvent(ReceptChangedEvent event) {
    if (event.recept.uuid == _recept.uuid) {
      setState(() {
        _recept = event.recept;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
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
                  child: Image.asset('assets/images/recept1.jpeg',
                      height: 100, width: 100, fit: BoxFit.cover),
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
                        " minuten"),
                    Text(_recept.remark),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
