import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/SnackChangedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../services/Enricher.dart';
import '../../../services/ImageStorageService.dart';
import '../../Icons.dart';
import 'package:flutter/widgets.dart';

import 'SnackDetailsPage.dart';

class SnackItemWidget extends StatefulWidget {
  SnackItemWidget({Key? key, required this.snack}) : super(key: key) {}

  final EnrichedSnack snack;

  @override
  State<SnackItemWidget> createState() => _WidgetState(snack);
}

class _WidgetState extends State<SnackItemWidget> {
  late EnrichedSnack _snack;
  final _eventBus = getIt<EventBus>();
  var _enricher = getIt<Enricher>();
  var _imageStorageService = getIt<ImageStorageService>();
  StreamSubscription? _eventStreamSub;
  Image? snackImage = null;

  _WidgetState(EnrichedSnack snack) {
    this._snack = snack;
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
        _snack = _enricher.enrichSnack(event.snack);
        snackImage = null;
      });
    }
  }

  _openSnack() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SnackDetailsPage(title: 'Snack', snack: _snack)),
    );
  }

  void loadImage(Image value) {
    if (this.mounted) {
      setState(() {
        snackImage = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (snackImage == null) {
      final Future<Image> data =
          _imageStorageService.get120x120(_snack.snack.uuid);
      data.then((Image value) => loadImage(value));
      data.then((Image value) => loadImage(value));
    }
    var img = snackImage != null
        ? snackImage
        : Image.asset("assets/images/transparant120x120.png",
            height: 120, width: 120, fit: BoxFit.cover);

    return InkWell(
        onTap: () {
          _openSnack();
        }, // Handle your callback
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              _snack.snack.name,
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
                    child: img),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     if (_snack.snack.favorite)
                //       new Icon(ICON_YELLOW_STAR,
                //           size: 20.0, color: Colors.yellow),
                //     Text(_snack.snack.preparingTime.toString() +
                //         "/" +
                //         _snack.snack.totalCookingTime.toString() +
                //         " minuten "),
                //     Text(_snack.snack.remark),
                //   ],
                // )
              ],
            )
          ],
        ));
  }
}
