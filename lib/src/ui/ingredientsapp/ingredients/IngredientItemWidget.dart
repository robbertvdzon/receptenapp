import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
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
  late Ingredient _ingredient;
  var _eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Ingredient ingredient, List<String> categories) {
    this._ingredient = ingredient;
  }


  @override
  void initState() {
    _handleEvents();
  }

  void _handleEvents() {
    _eventStreamSub = _eventBus.on<IngredientChangedEvent>().listen((event) {
      if (event.ingredient.uuid == _ingredient.uuid) {
        setState(() {
          _ingredient = event.ingredient;
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
                ingredient: _ingredient
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
              new Text(_ingredient.name+" ${_ingredient.getDisplayProductName()}"),
            ])
          ],
        )
    );
  }

}
