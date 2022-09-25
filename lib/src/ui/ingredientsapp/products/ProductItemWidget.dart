import 'package:flutter/material.dart';
import '../../../global.dart';
import '../../../model/products/v1/products.dart';
import '../../../repositories/ProductsRepository.dart';
import 'ProductDetailsPage.dart';

class ProductItemWidget extends StatefulWidget {
  ProductItemWidget({Key? key, required this.nutrient}) : super(key: key) {}

  final Product nutrient;

  @override
  State<ProductItemWidget> createState() => _WidgetState(nutrient);
}

class _WidgetState extends State<ProductItemWidget> {
  late Product product;
  late Product newProduct;
  var productsRepository = getIt<ProductsRepository>();


  _WidgetState(Product product) {
    this.product = product;
    this.newProduct = product;
  }

  _saveForm(){
    var baseIngredients = productsRepository.getProducts();

    baseIngredients.products.where((element) => element.name==product.name).forEach((element) {
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

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProductDetailsPage(title: 'Product', nutrient: product)),
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
              new Text(product.name??""),
            ])
          ],
        )
    );
  }



}
