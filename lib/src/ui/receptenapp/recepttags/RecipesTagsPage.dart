import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../model/recipes/v1/receptTags.dart';
import '../../../services/AppStateService.dart';
import 'ReceptTagItemWidget.dart';

class RecipesTagsPage extends StatefulWidget {
  RecipesTagsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<RecipesTagsPage> createState() => _PageState();
}

class _PageState extends State<RecipesTagsPage> {
  List<ReceptTag> _tags = List.empty(growable: true);
  var _appStateService = getIt<AppStateService>();

  _PageState() {
    _tags = _appStateService.getReceptTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 750,
              child: ListView(
                children: _tags.map((item) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 30.0,
                          ),
                          alignment: Alignment.center,
                          child:
                          ReceptTagItemWidget(receptTag: item, key: ObjectKey(item)),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    // color: Colors.green[100],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
