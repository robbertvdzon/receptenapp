import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../GetItDependencies.dart';
import '../../repositories/UserRepository.dart';
import '../ingredientsapp/ingredienttags/IngredientTagsPage.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Op deze pagina recepten kunnen toevoegen aan een weekplanner'),
            Text(''),
            Text('Voorbeeld:'),
            Text(''),
            Text('Ontbijt Robbert:'),
            Text('Vandaag (Ma): Smoothie met rodebiet [open] [verwijder]'),
            Text('Morgen (Di): Smoothie met wortel [open] [verwijder]'),
            Text('Wo: [zoek]'),
            Text('Do: [zoek]'),
            Text('Vr: [zoek]'),
            Text(''),
            Text('Ontbijt Karen:'),
            Text('Vandaag (Ma): Smoothie met rodebiet [open] [verwijder]'),
            Text('Morgen (Di): Smoothie met wortel [open] [verwijder]'),
            Text('Wo: [zoek]'),
            Text('Do: [zoek]'),
            Text('Vr: [zoek]'),
            Text(''),
            Text('Lunch Robbert :'),
            Text('Vandaag (Ma): Broodje zalm [open] [verwijder]'),
            Text('Morgen (Di): Omelet [open] [verwijder]'),
            Text('Wo: [zoek]'),
            Text('Do: [zoek]'),
            Text('Vr: [zoek]'),
            Text(''),
            Text('Lunch Karen :'),
            Text('Vandaag (Ma): Broodje kaas [open] [verwijder]'),
            Text('Morgen (Di): Broodje kaas [open] [verwijder]'),
            Text('Wo: [zoek]'),
            Text('Do: [zoek]'),
            Text('Vr: [zoek]'),
            Text(''),
            Text(''),
            Text('Avondeten :'),
            Text('Vandaag (Ma): Poke bowl [open] [verwijder]'),
            Text('Morgen (Di): Bloemkool met vegaburger [open] [verwijder]'),
            Text('Wo: [zoek]'),
            Text('Do: [zoek]'),
            Text('Vr: [zoek]'),
          ],
        ),
      ),
    );
  }
}

