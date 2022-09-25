import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../global.dart';
import '../../repositories/UserRepository.dart';
import '../ingredientsapp/ingredienttags/IngredientTagsPage.dart';

class DiaryHomePage extends StatefulWidget {

  DiaryHomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}


class _DiaryHomePageState extends State<DiaryHomePage> {
  var userRepository = getIt<UserRepository>();

  _DiaryHomePageState() {
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Op deze pagina aan kunnen geven hoeveel gegeten'),
            Text(''),
            Text('- Op basis van de planner (bv 60% van pokebowl recept)'),
            Text('- Losse dingen kunnen toevoegen (chips, nootjes etc)'),
            Text('- De veelgebruikte tussendoortjes makkelijk kunnen zien (en toevoegen)'),
          ],
        ),
      ),
    );
  }
}

