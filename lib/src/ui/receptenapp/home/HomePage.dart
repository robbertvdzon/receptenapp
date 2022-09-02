import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/receptenapp/ingredienttags/IngredientTagsPage.dart';
import 'package:receptenapp/src/ui/receptenapp/recepts/RecipesPage.dart';
import 'package:receptenapp/src/ui/receptenapp/recepttags/RecipesTagsPage.dart';
import '../../../global.dart';
import '../../../services/repositories/UserRepository.dart';
import '../products/ProductsPage.dart';
import '../ingredients/IngredientsPage.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  var userRepository = getIt<UserRepository>();

  _HomePageState() {
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
              child: Text('Ingredient tags'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IngredientsTagsPage(title: 'Ingredient tags')),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Recipes tags'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RecipesTagsPage(title: 'Recipes tags')),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Producten'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductsPage(title: 'Producten')),
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
                          IngredientsPage(title: 'Ingredienten')),
                );
              },
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Recepten'),
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
          ],
        ),
      ),
    );
  }
}

