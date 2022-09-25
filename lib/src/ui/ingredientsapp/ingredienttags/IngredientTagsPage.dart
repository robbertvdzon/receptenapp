import 'package:flutter/material.dart';
import 'package:receptenapp/src/GlobalState.dart';
import '../../../GetItDependencies.dart';
import '../../../model/ingredients/v1/ingredientTags.dart';
import '../../../repositories/IngredientTagsRepository.dart';
import '../../../services/GlobalStateService.dart';
import '../../ingredientsapp/ingredienttags/IngredientTagItemWidget.dart';

class IngredientsTagsPage extends StatefulWidget {
  IngredientsTagsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<IngredientsTagsPage> createState() => _PageState();
}

class _PageState extends State<IngredientsTagsPage> {
  var _globalStateService = getIt<GlobalStateService>();

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
                children: _globalStateService.getIngredientTags().map((item) {
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
