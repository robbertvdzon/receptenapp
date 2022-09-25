import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/plannerapp/PlannerHomePage.dart';
import '../../GetItDependencies.dart';
import '../../repositories/UserRepository.dart';
import '../diaryapp/DiaryHomePage.dart';
import '../ingredientsapp/search/SearchIngredientsPage.dart';
import '../receptenapp/search/SearchRecipesPage.dart';
import '../shoppingapp/ShoppingHomePage.dart';
import '../statisticsapp/StatisticsHomePage.dart';

class AllAppHomePage extends StatefulWidget {

  AllAppHomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<AllAppHomePage> createState() => _AllAppHomePageState();
}


class _AllAppHomePageState extends State<AllAppHomePage> {
  var userRepository = getIt<UserRepository>();

  _AllAppHomePageState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Text(
            'user: ${userRepository.getUsersEmail()}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildElevatedButton(context, SearchRecipesPage(title: 'Recepten'), "assets/images/recipes.png"),
                  buildElevatedButton(context, PlannerHomePage(title: 'planner'), "assets/images/planner.png"),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildElevatedButton(context, ShoppingHomePage(title: 'Boodschappen'), "assets/images/shopping.png"),
                  buildElevatedButton(context, SearchIngredientsPage(title: 'Ingredienten'), "assets/images/ingredients.png"),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildElevatedButton(context, DiaryHomePage(title: 'Dagbook'), "assets/images/diary.png"),
                  buildElevatedButton(context, StatisticsHomePage(title: 'Statistieken'), "assets/images/statistics.png"),
                ]
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildElevatedButton(BuildContext context, StatefulWidget widget, String imageName) {
    return ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  child:
                  Container(
                    alignment: Alignment.center,// use aligment
                    child: Image.asset(imageName,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover),
                  )
                  ,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            StatefulWidget ingredientsPage = widget;
                            return ingredientsPage;
                          }),
                    );
                  },
                );
  }

}

