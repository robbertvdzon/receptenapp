import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../GetItDependencies.dart';
import '../../repositories/UserRepository.dart';

class ShoppingHomePage extends StatefulWidget {

  ShoppingHomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<ShoppingHomePage> createState() => _ShoppingHomePageState();
}


class _ShoppingHomePageState extends State<ShoppingHomePage> {
  var userRepository = getIt<UserRepository>();

  _ShoppingHomePageState() {
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
            Text('Op deze pagina de boodschappen kunnen beheren'),
            Text(''),
            Text('- De boodschappen kunnen toevoegen vanuit de planner'),
            Text('- Losse producten kunnen toevoegen aan de lijst'),
            Text('- Sorteer boodschappen lijst op categorie'),
            Text('- markeer een product als gereed'),
          ],
        ),
      ),
    );
  }
}

