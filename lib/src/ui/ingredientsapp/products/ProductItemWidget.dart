import 'package:flutter/material.dart';
import '../../../model/products/v1/products.dart';
import 'ProductDetailsPage.dart';

class ProductItemWidget extends StatefulWidget {
  ProductItemWidget({Key? key, required this.product}) : super(key: key) {}

  final Product product;

  @override
  State<ProductItemWidget> createState() => _WidgetState(product);
}

class _WidgetState extends State<ProductItemWidget> {
  late Product _product;


  _WidgetState(Product product) {
    this._product = product;
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductDetailsPage(title: 'Product', product: _product)),
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
              new Text(_product.name??""),
            ])
          ],
        )
    );
  }

}
