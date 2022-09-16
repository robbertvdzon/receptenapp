import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/repositories/RecipesRepository.dart';
import '../../../global.dart';
import '../../../model/recipes/v1/recept.dart';
import 'ReceptDetailsPage.dart';

class ReceptItemWidget extends StatefulWidget {
  ReceptItemWidget({Key? key, required this.recept})
      : super(key: key) {}

  final Recept recept;

  @override
  State<ReceptItemWidget> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptItemWidget> {
  late Recept recept;
  late Recept newRecept;
  var recipesRepository = getIt<RecipesRepository>();

  _WidgetState(Recept recept) {
    this.recept = recept;
    this.newRecept = recept;
  }

  _openForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReceptDetailsPage(title: 'Recept', recept: recept)),
    );
  }

  saveRecept(Recipes recipes, Recept newRecept) {
    // receptenBoek.recepten.remove(recept);
    recipes.recipes
        .where((element) => element.uuid == recept.uuid)
        .forEach((element) {
      element.name = newRecept.name;
    });
    recipesRepository.saveRecipes(recipes);
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {_openForm();}, // Handle your callback
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
              recept.name,
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft, // use aligment
                padding: EdgeInsets.only(left:0, bottom: 0, right: 20, top:0),
                child: Image.asset('assets/images/recept1.jpeg',
                    height: 100, width: 100, fit: BoxFit.cover),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(recept.preparingTime.toString() +
                      "/" +
                      recept.totalCookingTime.toString() +
                      " minuten"),
                  Text(recept.remark),
                ],
              )
            ],
          )
        ],
      )
    );



  }

}


