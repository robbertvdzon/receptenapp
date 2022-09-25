import 'package:flutter/material.dart';
import 'dart:async';
import '../../../GetItDependencies.dart';
import '../../../model/products/v1/products.dart';
import '../../../repositories/ProductsRepository.dart';
import '../../../services/ProductsService.dart';
import 'ProductItemWidget.dart';

class SearchProductsPage extends StatefulWidget {
  SearchProductsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  Products _products = Products(List.empty());
  List<Product> _filteredProducts = List.empty();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var _productsService = getIt<ProductsService>();
  String _filter = "";
  String _codeDialog ="";
  String _valueText = "";

  @override
  void initState() {
    _products = _productsService.getProducts();
    _filteredProducts = _products.products.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterProducts();
    });
  }

  void addProduct(String name) {
    _productsService.createAndAddProduct(name).then((value) => {
      setState(() {
        _products = _productsService.getProducts();
        _filteredProducts = _products.products.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
      })
    });

  }

  void _filterProducts() {
    _filteredProducts = _products.products.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  addProduct(_valueText);
                  _updateFilter(_valueText);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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
                  controller: _filterTextFieldController..text = '$_filter',
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
          // _filterTextFieldController.text ="bla";
          // _incrementCounter(_filterTextFieldController);
          _displayTextInputDialog(context);
        },
        tooltip: 'Add product',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
