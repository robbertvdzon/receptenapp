import 'package:flutter/material.dart';
import '../../../GetItDependencies.dart';
import '../../../model/products/v1/products.dart';
import '../../../repositories/ProductsRepository.dart';
import '../../../services/ProductsService.dart';

class ProductEditPage extends StatefulWidget {
  ProductEditPage({Key? key, required this.title, required this.product})
      : super(key: key) {}

  final Product product;
  final String title;

  @override
  State<ProductEditPage> createState() => _WidgetState(product);
}

class _WidgetState extends State<ProductEditPage> {
  late Product _product;
  late Product _newProduct;
  var productsService = getIt<ProductsService>();

  _WidgetState(Product product) {
    this._product = product;
    this._newProduct = product;
  }

  _saveProduct() {
    productsService.saveProduct(_newProduct).whenComplete(() => Navigator.pop(context));
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
              initialValue: "${_product.name}",
              onChanged: (text) {
                _newProduct.name = text;
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('kcal:')),
              initialValue: "${_product.kcal}",
              onChanged: (text) {
                _newProduct.kcal = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('Na:')),
              initialValue: "${_product.na}",
              onChanged: (text) {
                _newProduct.na = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('k:')),
              initialValue: "${_product.k}",
              onChanged: (text) {
                _newProduct.k = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('prot:')),
              initialValue: "${_product.prot}",
              onChanged: (text) {
                _newProduct.prot = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('fat:')),
              initialValue: "${_product.fat}",
              onChanged: (text) {
                _newProduct.fat = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('fe:')),
              initialValue: "${_product.fe}",
              onChanged: (text) {
                _newProduct.fe = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('mg:')),
              initialValue: "${_product.mg}",
              onChanged: (text) {
                _newProduct.mg = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('quantity:')),
              initialValue: "${_product.quantity}",
              onChanged: (text) {
                _newProduct.quantity = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('nt:')),
              initialValue: "${_product.nt}",
              onChanged: (text) {
                _newProduct.nt = double.parse(text);
              },
            ),

            TextFormField(
              decoration: InputDecoration(label: Text('Suiker:')),
              initialValue: "${_product.sugar}",
              onChanged: (text) {
                _newProduct.sugar = double.parse(text);
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('Category:')),
              initialValue: "${_product.category}",
              onChanged: (text) {
                _newProduct.category = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('nevo code:')),
              initialValue: "${_product.nevoCode}",
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('custom field:')),
              initialValue: "${_product.customProduct}",
            ),

            ElevatedButton(
              child: Text('SAVE'),
              onPressed: () {
                _saveProduct();
              },
            )
          ],
        ))));
  }
}
