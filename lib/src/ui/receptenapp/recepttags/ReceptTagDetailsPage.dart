import 'package:flutter/material.dart';

import '../../../model/recipes/v1/receptTags.dart';

class ReceptTagDetailsPage extends StatefulWidget {
  ReceptTagDetailsPage({Key? key, required this.title, required this.receptTag}) : super(key: key) {}

  final ReceptTag receptTag;
  final String title;

  @override
  State<ReceptTagDetailsPage> createState() => _WidgetState(receptTag);
}

class _WidgetState extends State<ReceptTagDetailsPage> {
  late ReceptTag receptTag;

  _WidgetState(ReceptTag receptTag) {
    this.receptTag = receptTag;
  }
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(

              child:Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(label: Text('tag:')),
                    initialValue: "${receptTag.tag}",
                  ),

                ],
              )

          ))
    ;
  }

}


