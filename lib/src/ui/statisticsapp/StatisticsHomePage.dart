import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../GetItDependencies.dart';
import '../../repositories/UserRepository.dart';
import '../ingredientsapp/ingredienttags/IngredientTagsPage.dart';

class StatisticsHomePage extends StatefulWidget {

  StatisticsHomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<StatisticsHomePage> createState() => _StatisticsHomePageState();
}


class _StatisticsHomePageState extends State<StatisticsHomePage> {
  var userRepository = getIt<UserRepository>();

  _StatisticsHomePageState() {
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
            Text('Statistieken kunnen inzien'),
            Text(''),
            Text('- Hoeveel keer per veek vega, vlees, kip, vis?'),
            Text('- Hoeveel variatie in groente'),
            Text('- Hoeveel kcal per dag / gemiddeld'),
            Text('- Hoeveel eiwitten per dag / gemiddeld'),
            Text('- Hoeveel vetten per dag / gemiddeld'),
            Text('- Hoeveel Omega-3 per dag / gemiddeld'),
            Text('- Dit ook voor andere voedingsstoffen'),
          ],
        ),
      ),
    );
  }
}

