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
  late ReceptTag receptTag;

  _WidgetState(ReceptTag receptTag) {
    this.receptTag = receptTag;
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReceptTagDetailsPage(title: 'Recept Tag', receptTag: receptTag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new TextButton(
          onPressed: () {
            _openForm();
          },
          child: new Text(receptTag.tag??""),
        )
      ],
    );
  }

}


