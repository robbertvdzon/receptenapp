import 'package:flutter/material.dart';
import '../../../global.dart';
import '../../../model/products/v1/products.dart';
import '../../../repositories/ProductsRepository.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({Key? key, required this.title, required this.nutrient})
      : super(key: key) {}

  final Product nutrient;
  final String title;

  @override
  State<ProductDetailsPage> createState() => _WidgetState(nutrient);
}

class _WidgetState extends State<ProductDetailsPage> {
  late Product product;
  late Product newProduct;
  var productsRepository = getIt<ProductsRepository>();

  _WidgetState(Product product) {
    this.product = product;
    this.newProduct = product;
  }

  _saveForm() {
    var baseIngredients = productsRepository.getProducts();

    baseIngredients.products
        .where((element) => element.name == product.name)
        .forEach((element) {
      element.name = newProduct.name;
      element.quantity = newProduct.quantity;
      element.category = newProduct.category;
      element.nevoCode = newProduct.nevoCode;
      element.kcal = newProduct.kcal;
      element.prot = newProduct.prot;
      element.nt = newProduct.nt;
      element.fat = newProduct.fat;
      element.sugar = newProduct.sugar;
      element.na = newProduct.na;
      element.k = newProduct.k;
      element.fe = newProduct.fe;
      element.mg = newProduct.mg;
      element.customNutrient = newProduct.customNutrient;
    });
    productsRepository.saveProducts(baseIngredients);
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
            TextFormField(
              decoration: InputDecoration(label: Text('Name:')),
              initialValue: "${product.name}",
              onChanged: (text) {
                newProduct.name = text;
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('kcal:')),
              initialValue: "${product.kcal}",
              onChanged: (text) {
                newProduct.kcal = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('Na:')),
              initialValue: "${product.na}",
              onChanged: (text) {
                newProduct.na = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('k:')),
              initialValue: "${product.k}",
              onChanged: (text) {
                newProduct.k = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('prot:')),
              initialValue: "${product.prot}",
              onChanged: (text) {
                newProduct.prot = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('fat:')),
              initialValue: "${product.fat}",
              onChanged: (text) {
                newProduct.fat = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('fe:')),
              initialValue: "${product.fe}",
              onChanged: (text) {
                newProduct.fe = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('mg:')),
              initialValue: "${product.mg}",
              onChanged: (text) {
                newProduct.mg = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('quantity:')),
              initialValue: "${product.quantity}",
              onChanged: (text) {
                newProduct.quantity = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('nt:')),
              initialValue: "${product.nt}",
              onChanged: (text) {
                newProduct.nt = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('Suiker:')),
              initialValue: "${product.sugar}",
              onChanged: (text) {
                newProduct.sugar = double.parse(text);
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Category:')),
              initialValue: "${product.category}",
              onChanged: (text) {
                newProduct.category = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('nevo code:')),
              initialValue: "${product.nevoCode}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('custom field:')),
              initialValue: "${product.customNutrient}",
            ),

            ElevatedButton(
              child: Text('SAVE'),
              onPressed: () {
                _saveForm();
              },
            )
          ],
        ))));
  }
}
