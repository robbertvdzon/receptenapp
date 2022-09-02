import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/ingredients/IngredientTagsPage.dart';
import 'package:receptenapp/src/ui/recepts/RecipesPage.dart';
import 'package:receptenapp/src/ui/recepts/RecipesTagsPage.dart';
import '../../global.dart';
import '../../services/repositories/UserRepository.dart';
import '../products/ProductsPage.dart';
import '../ingredients/IngredientsPage.dart';

class PlannerHomePage extends StatefulWidget {

  PlannerHomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<PlannerHomePage> createState() => _PlannerHomePageState();
}


class _PlannerHomePageState extends State<PlannerHomePage> {
  var userRepository = getIt<UserRepository>();

  _PlannerHomePageState() {
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
            Spacer(),
            ElevatedButton(
              child: Text('Planner'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IngredientsTagsPage(title: 'Ingredient tags')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

