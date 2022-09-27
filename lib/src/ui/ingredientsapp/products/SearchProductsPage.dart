import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ProductCreatedEvent.dart';
import '../../../model/products/v1/products.dart';
import '../../../services/AppStateService.dart';
import 'ProductEditPage.dart';
import 'ProductItemWidget.dart';

class SearchProductsPage extends StatefulWidget {
  SearchProductsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  var _appStateService = getIt<AppStateService>();
  var _eventBus = getIt<EventBus>();
  List<Product> _filteredProducts = List.empty();
  String _filter = "";
  StreamSubscription? _eventStreamSub;

  @override
  void initState() {
    super.initState();
    _filterProducts();
    _eventStreamSub = _eventBus.on<ProductCreatedEvent>().listen((event) => _processEvent(event));
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _processEvent(ProductCreatedEvent event) {
    setState(() {
      _filter = event.product.name??"";
      _filterProducts();
    });
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterProducts();
    });
  }

  void _createNewProduct(){
    Product newproduct = new Product("Nieuw product");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductEditPage(
                  title: 'Nieuw product', product: newproduct)),
    );
  }

  void _filterProducts() {
    List<Product> products = _getSortedListOfProducts();
    _filteredProducts = products.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
  }

  List<Product> _getSortedListOfProducts() {
    List<Product> products = List.of(_appStateService.getProducts());
    products.sort((a, b) => (a.name??"").toLowerCase().compareTo((b.name??"").toLowerCase()));
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 50,
                width: 500,
                child:
                TextFormField(key: Key(_filter.toString()),
                  decoration: InputDecoration(border: InputBorder.none, labelText: 'Filter: (${_filteredProducts.length} ingredienten)'),
                  autofocus: true,
                  controller: TextEditingController()..text = '$_filter',
                  onChanged: (text) => {_updateFilter(text)},
                )
            ),
            SizedBox(
              height: 750,
              width: 500,
              child: ListView(
                children: _filteredProducts.map((item) {
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
                        ProductItemWidget(product: item, key: ObjectKey(item)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewProduct();
        },
        tooltip: 'Add product',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
