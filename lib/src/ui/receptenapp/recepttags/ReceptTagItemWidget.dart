import 'package:flutter/material.dart';
import '../../../model/recipes/v1/receptTags.dart';
import 'ReceptTagDetailsPage.dart';

class ReceptTagItemWidget extends StatefulWidget {
  ReceptTagItemWidget({Key? key, required this.receptTag})
      : super(key: key) {}

  final ReceptTag receptTag;

  @override
  State<ReceptTagItemWidget> createState() => _WidgetState(receptTag);
}

class _WidgetState extends State<ReceptTagItemWidget> {
  late ReceptTag _receptTag;

  _WidgetState(ReceptTag receptTag) {
    this._receptTag = receptTag;
  }

  _openReceptTag() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReceptTagDetailsPage(title: 'Recept Tag', receptTag: _receptTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextButton(
          onPressed: () {
            _openReceptTag();
          },
          child: new Text(_receptTag.tag??""),
        )
      ],
    );
  }

}


