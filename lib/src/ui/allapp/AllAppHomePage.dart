import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/plannerapp/PlannerHomePage.dart';
import '../../global.dart';
import '../../services/repositories/UserRepository.dart';
import '../ingredientsapp/search/IngredientsPage.dart';
import '../receptenapp/search/RecipesPage.dart';

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
                  buildElevatedButton(context, RecipesPage(title: 'Recepten'), "assets/images/recipes.png"),
                  buildElevatedButton(context, IngredientsPage(title: 'Ingredienten'), "assets/images/ingredients.png"),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildElevatedButton(context, RecipesPage(title: 'planner'), "assets/images/planner.png"),
                  buildElevatedButton(context, IngredientsPage(title: 'Boodschappen'), "assets/images/shopping.png"),
                ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildElevatedButton(context, IngredientsPage(title: 'Dagbook'), "assets/images/diary.png"),
                  buildElevatedButton(context, RecipesPage(title: 'Statistieken'), "assets/images/statistics.png"),
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

  // @override
  Widget build2(BuildContext context) {
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
            Spacer(),
            ElevatedButton(
              child: Text('Planner'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PlannerHomePage(title: 'Planner')),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Ingredienten'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RecipesPage(title: 'Recepten')),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              child:
              Container(
                alignment: Alignment.center,// use aligment
                child: Image.asset('recipes.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover),
              )
              ,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RecipesPage(title: 'Recepten')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

