import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import '../../../GetItDependencies.dart';
import '../../../events/ProductChangedEvent.dart';
import '../../../model/products/v1/products.dart';
import '../../../repositories/ProductsRepository.dart';
import '../../../services/ProductsService.dart';
import 'ProductEditPage.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({Key? key, required this.title, required this.product})
      : super(key: key) {}

  final Product product;
  final String title;

  @override
  State<ProductDetailsPage> createState() => _WidgetState(product);
}

class _WidgetState extends State<ProductDetailsPage> {
  late Product _product;
  var _eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  _WidgetState(Product product) {
    this._product = product;
    _eventStreamSub = _eventBus.on<ProductChangedEvent>().listen((event) => handleEvent(event));
  }

  void handleEvent(ProductChangedEvent event) {
    if (event.product.name == _product.name) {
      setState(() {
        _product = event.product;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
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
          Text("${_product.name}"),
        ]),
        TableRow(children: [
          Text("kcal"),
          Text(":"),
          Text("${_product.kcal}"),
        ]),
        TableRow(children: [
          Text("Na"),
          Text(":"),
          Text("${_product.na}"),
        ]),
        TableRow(children: [
          Text("k"),
          Text(":"),
          Text("${_product.k}"),
        ]),
        TableRow(children: [
          Text("prot"),
          Text(":"),
          Text("${_product.prot}"),
        ]),
        TableRow(children: [
          Text("fat"),
          Text(":"),
          Text("${_product.fat}"),
        ]),
        TableRow(children: [
          Text("fe"),
          Text(":"),
          Text("${_product.fe}"),
        ]),
        TableRow(children: [
          Text("mg"),
          Text(":"),
          Text("${_product.mg}"),
        ]),
        TableRow(children: [
          Text("quantity"),
          Text(":"),
          Text("${_product.quantity}"),
        ]),
        TableRow(children: [
          Text("nt"),
          Text(":"),
          Text("${_product.nt}"),
        ]),
        TableRow(children: [
          Text("Suiker"),
          Text(":"),
          Text("${_product.sugar}"),
        ]),
        TableRow(children: [
          Text("Category"),
          Text(":"),
          Text("${_product.category}"),
        ]),
        TableRow(children: [
          Text("nnevo code"),
          Text(":"),
          Text("${_product.nevoCode}"),
        ]),
        TableRow(children: [
          Text("custom field"),
          Text(":"),
          Text("${_product.customProduct}"),
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
                      builder: (context) => ProductEditPage(
                          title: 'Edit', product: _product)),
                );
              },
            ),
          ],
        ))));
  }
}
