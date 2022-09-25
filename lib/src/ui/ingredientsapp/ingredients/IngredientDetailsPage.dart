import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receptenapp/src/GlobalState.dart';
import 'package:receptenapp/src/model/ingredients/v1/ingredients.dart';
import '../../../GetItDependencies.dart';
import '../../../events/IngredientChangedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../services/Enricher.dart';
import '../../../services/ProductsService.dart';
import '../products/ProductDetailsPage.dart';
import 'IngredientEditPage.dart';

class IngredientDetailsPage extends StatefulWidget {
  IngredientDetailsPage(
      {Key? key,
      required this.title,
      required this.ingredient}
      )
      : super(key: key) {}

  final Ingredient ingredient;
  final String title;

  @override
  State<IngredientDetailsPage> createState() =>
      _WidgetState(ingredient);
}

class _WidgetState extends State<IngredientDetailsPage> {
  late EnrichedIngredient _enrichedIngredient;
  late Ingredient _ingredient;
  var _productsService = getIt<ProductsService>();
  var _enricher = getIt<Enricher>();
  var _globalState = getIt<GlobalState>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Ingredient ingredient) {
    this._enrichedIngredient = _enricher.enrichtIngredient(ingredient);
    this._ingredient = ingredient;
  }

  @override
  void initState() {
    _handleEvents();
  }

  void _handleEvents() {
    _eventStreamSub = _globalState.eventBus.on<IngredientChangedEvent>().listen((event) {
      if (event.ingredient.uuid == _enrichedIngredient.uuid) {
        setState(() {
          _enrichedIngredient = _enricher.enrichtIngredient(event.ingredient);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _openProdut(){
    if (_ingredient.productName==null) return;
    var product = _productsService.getProductByName(_ingredient.productName!);
    if (product==null) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductDetailsPage(
                  title: 'Product',
                  product: product,
                )
        )
    );
  }

  Table tableWithValues() {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(200),
        1: FixedColumnWidth(10),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          Text("Naam"),
          Text(":"),
          Text("${_enrichedIngredient.name}"),
        ]),
        TableRow(children: [
          Text("Gewicht per stuk"),
          Text(":"),
          Text("${_enrichedIngredient.gramsPerPiece}"),
        ]),
        TableRow(children: [
          Text("kcal"),
          Text(":"),
          Text("${_enrichedIngredient.nutritionalValues.kcal}"),
        ]),
        TableRow(children: [
          Text("fat"),
          Text(":"),
          Text("${_enrichedIngredient.nutritionalValues.fat}"),
        ]),
        TableRow(children: [
          Text("recepten"),
          Text(":"),
          Text("${_enrichedIngredient.recipes.map((e) => e?.name).join(",")}"),
        ]),
        TableRow(children: [
          Text("tags"),
          Text(":"),
          Text("${_enrichedIngredient.tags.map((e) => e?.tag).join(",")}"),
        ]),
        TableRow(children: [
          Text("product"),
          Text(":"),
            InkWell(
            onTap: () {_openProdut();}, // Handle your callback
            child:
            Text( "${_enrichedIngredient.productName}"),
            )
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            tableWithValues(),
            ElevatedButton(
              child: Text('Bewerk'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IngredientEditPage(
                          title: 'Edit', ingredient: _ingredient)),
                );
              },
            ),
          ],
        ))));
  }
}
