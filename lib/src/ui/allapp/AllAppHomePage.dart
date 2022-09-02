import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:receptenapp/src/ui/plannerapp/PlannerHomePage.dart';
import 'package:receptenapp/src/ui/receptenapp/ingredients/IngredientTagsPage.dart';
import '../../global.dart';
import '../../services/repositories/UserRepository.dart';
import '../receptenapp/home/HomePage.dart';

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
              child: Text('Recepten'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(title: 'Recepten')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

