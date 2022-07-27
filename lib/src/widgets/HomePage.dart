import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../global.dart';
import '../services/UserRepository.dart';
import 'IngredientsPage.dart';

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
            'user: ${userRepository.getUser()?.email}',
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
            ElevatedButton(
              child: Text('Open ingredients'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IngredientsPage(title: 'Ingredienten')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

