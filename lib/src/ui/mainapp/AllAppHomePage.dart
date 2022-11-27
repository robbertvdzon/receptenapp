import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/plannerapp/PlannerHomePage.dart';
import '../../GetItDependencies.dart';
import '../../repositories/UserRepository.dart';
import '../diaryapp/DiaryHomePage.dart';
import '../ingredientsapp/search/SearchIngredientsPage.dart';
import '../receptenapp/search/SearchRecipesPage.dart';
import '../receptenapp/search/SearchSnacksPage.dart';
import '../shoppingapp/ShoppingHomePage.dart';
import '../statisticsapp/StatisticsHomePage.dart';

class AllAppHomePage extends StatefulWidget {
  AllAppHomePage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<AllAppHomePage> createState() => _AllAppHomePageState();
}

class _AllAppHomePageState extends State<AllAppHomePage> {
  var userRepository = getIt<UserRepository>();

  _AllAppHomePageState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Container(
          alignment: Alignment.topLeft, // use aligment
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Image.asset("assets/images/gutz.png",
              height: 60, width: 60, fit: BoxFit.cover),
        ),
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              buildElevatedButton(context, SearchRecipesPage(title: 'Recepten'),
                  "assets/images/recepten.png"),
              buildElevatedButton(context, SearchSnacksPage(title: 'Snacks'),
                  "assets/images/planner.png"),
              // buildElevatedButton(context, PlannerHomePage(title: 'planner'),
              //     "assets/images/planner.png"),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              buildElevatedButton(
                  context,
                  ShoppingHomePage(title: 'Boodschappen'),
                  "assets/images/boodschappen.png"),
              buildElevatedButton(
                  context,
                  SearchIngredientsPage(title: 'Ingredienten'),
                  "assets/images/ingredienten.png"),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              buildElevatedButton(context, DiaryHomePage(title: 'Dagbook'),
                  "assets/images/dagboek.png"),
              buildElevatedButton(
                  context,
                  StatisticsHomePage(title: 'Statistieken'),
                  "assets/images/statistieken.png"),
            ]),
          ],
        ),
      ),
    );
  }

  GestureDetector buildElevatedButton(
      BuildContext context, StatefulWidget widget, String imageName) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              StatefulWidget ingredientsPage = widget;
              return ingredientsPage;
            }),
          );
        },
        child: Container(
          alignment: Alignment.center, // use aligment
          margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Image.asset(imageName,
              height: 150, width: 150, fit: BoxFit.cover),
        ));
  }
}
