import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../services/AppStateService.dart';
import '../../ingredientsapp/ingredienttags/IngredientTagItemWidget.dart';

class IngredientsTagsPage extends StatefulWidget {
  IngredientsTagsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<IngredientsTagsPage> createState() => _PageState();
}

class _PageState extends State<IngredientsTagsPage> {
  var _appStateService = getIt<AppStateService>();

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
                children: _appStateService.getIngredientTags().map((item) {
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
                          IngredientTagItemWidget(ingredientTag: item, key: ObjectKey(item)),
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
