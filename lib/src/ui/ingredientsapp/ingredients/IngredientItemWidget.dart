import 'dart:async';

import 'package:flutter/material.dart';
import '../../../GetItDependencies.dart';
import '../../../GlobalState.dart';
import '../../../events/IngredientChangedEvent.dart';
import '../../../model/ingredients/v1/ingredients.dart';
import 'IngredientDetailsPage.dart';

class IngredientItemWidget extends StatefulWidget {
  IngredientItemWidget(
      {Key? key, required this.ingredient, required this.categories})
      : super(key: key) {}

  final Ingredient ingredient;
  final List<String> categories; 

  @override
  State<IngredientItemWidget> createState() =>
      _WidgetState(ingredient, categories);
}

class _WidgetState extends State<IngredientItemWidget> {
  late Ingredient ingredient;
  var _globalState = getIt<GlobalState>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Ingredient ingredient, List<String> categories) {
    this.ingredient = ingredient;
  }


  @override
  void initState() {
    _handleEvents();
  }

  void _handleEvents() {
    _eventStreamSub = _globalState.eventBus.on<IngredientChangedEvent>().listen((event) {
      if (event.ingredient.uuid == ingredient.uuid) {
        setState(() {
          ingredient = event.ingredient;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => IngredientDetailsPage(
                title: 'Ingredient',
                ingredient: ingredient
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _openForm();
        }, // Handle your callback
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              new Text(ingredient.name+" ${ingredient.getDisplayProductName()}"),
            ])
          ],
        )
    );
  }

}
