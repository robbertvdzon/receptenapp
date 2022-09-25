import 'package:flutter/material.dart';
import 'package:receptenapp/src/model/ingredients/v1/ingredients.dart';
import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../services/Enricher.dart';
import '../../../repositories/ProductsRepository.dart';
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
  late EnrichedIngredient enrichedIngredient;
  late Ingredient ingredient;
  var productsService = getIt<ProductsService>();
  var enricher = getIt<Enricher>();

  _WidgetState(Ingredient ingredient) {
    this.enrichedIngredient = enricher.enrichtIngredient(ingredient);
    this.ingredient = ingredient;
  }

  void _openProdut(){
    if (ingredient.productName==null) return;
    var product = productsService.getProductByName(ingredient.productName!);
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
          Text("${enrichedIngredient.name}"),
        ]),
        TableRow(children: [
          Text("Gewicht per stuk"),
          Text(":"),
          Text("${enrichedIngredient.gramsPerPiece}"),
        ]),
        TableRow(children: [
          Text("kcal"),
          Text(":"),
          Text("${enrichedIngredient.nutritionalValues.kcal}"),
        ]),
        TableRow(children: [
          Text("fat"),
          Text(":"),
          Text("${enrichedIngredient.nutritionalValues.fat}"),
        ]),
        TableRow(children: [
          Text("recepten"),
          Text(":"),
          Text("${enrichedIngredient.recipes.map((e) => e?.name).join(",")}"),
        ]),
        TableRow(children: [
          Text("tags"),
          Text(":"),
          Text("${enrichedIngredient.tags.map((e) => e?.tag).join(",")}"),
        ]),
        TableRow(children: [
          Text("product"),
          Text(":"),
            InkWell(
            onTap: () {_openProdut();}, // Handle your callback
            child:
            Text( "${enrichedIngredient.productName}"),
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
                          title: 'Edit', ingredient: ingredient)),
                );
              },
            ),
          ],
        ))));
  }
}
