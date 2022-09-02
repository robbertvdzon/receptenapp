import 'package:flutter/material.dart';
import 'dart:async';
import '../global.dart';
import '../model/products/v1/products.dart';
import '../services/repositories/ProductsRepository.dart';
import 'ProductItemWidget.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Products products = Products(List.empty());
  List<Product> filteredProducts = List.empty();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _filterTextFieldController = TextEditingController();
  var productsRepository = getIt<ProductsRepository>();
  String _filter = "";
  String codeDialog ="";
  String valueText = "";

  _ProductsPageState() {
    products = productsRepository.getProducts();
    filteredProducts = products.products.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterNutrients();
    });
  }

  void addProduct(String name) {
    productsRepository.createAndAddProduct(name).then((value) => {
      setState(() {
        products = productsRepository.getProducts();
        filteredProducts = products.products.where((element) => element.name!=null && element.name!.contains(_filter)).toList();
      })
    });

  }

  void _filterNutrients() {
    filteredProducts = products.products.where((element) => element.name!=null && element.name!.toLowerCase().contains(_filter.toLowerCase())).toList();
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
                  valueText = value;
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
                  addProduct(valueText);
                  _updateFilter(valueText);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          TextFormField(key: Key(_filter.toString()),
            decoration: InputDecoration(border: InputBorder.none, labelText: 'Filter: (${filteredProducts.length} ingredienten)'),
            autofocus: true,
            controller: _filterTextFieldController..text = '$_filter',
            onChanged: (text) => {_updateFilter(text)},
          )
            ,
            SizedBox(
              height: 750,
              child: ListView(
                children: filteredProducts.map((item) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 750.0,
                          ),
                          color: Colors.white60,
                          alignment: Alignment.center,
                          child:
                        ProductItemWidget(nutrient: item),
                        ),
                      ],

                  ),

                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(15),
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
        tooltip: 'Add nutrient',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
