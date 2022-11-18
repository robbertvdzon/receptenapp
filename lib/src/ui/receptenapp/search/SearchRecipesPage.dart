import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/Enricher.dart';

import '../../../GetItDependencies.dart';
import '../../../events/FilterModifiedEvent.dart';
import '../../../events/ReceptCreatedEvent.dart';
import '../../../events/ReceptRemovedEvent.dart';
import '../../../events/RepositoriesLoadedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Filter.dart';
import '../recepts/edit/ReceptEditDetailsPage.dart';
import '../recepts/ReceptItemWidget.dart';
import '../recepttags/RecipesTagsPage.dart';
import 'SearchRecipesFilterPage.dart';
import 'SearchRecipesPage2.dart';

class SearchRecipesPage extends StatefulWidget {
  SearchRecipesPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchRecipesPage> createState() => _SearchRecipesPageState();
}

class _SearchRecipesPageState extends State<SearchRecipesPage> {
  var _appStateService = getIt<AppStateService>();
  var _enricher = getIt<Enricher>();
  var _eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  @override
  void initState() {
    super.initState();
    _filterRecipes();
    _eventStreamSub = _eventBus.on<FilterModifiedEvent>().listen((event) => _reloadFilter());
    _eventStreamSub = _eventBus.on<ReceptCreatedEvent>().listen((event) => _reloadFilter());
    _eventStreamSub = _eventBus.on<ReceptRemovedEvent>().listen((event) => _reloadFilter());
    _eventStreamSub = _eventBus.on<RepositoriesLoadedEvent>().listen((event) => _reloadFilter());
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _reloadFilter() {
      setState(() {
        _filterRecipes();
      });
  }

  void _createNewRecept() {
    Recept newRecept = new Recept(List.empty(), "");
    EnrichedRecept enrichedNewRecept = _enricher.enrichRecipe(newRecept);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ReceptEditDetailsPage(
                    title: 'Nieuw recept', recept: enrichedNewRecept, insertMode: true)),
      );
  }

  void _openFilter(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SearchRecipesFilterPage(
                  title: 'Filter')),
    );
  }

  void _filterRecipes() {
    Filter filter = _appStateService.filter;
    List<Recept> recipes = _getSortedListOfRecipes();
    _appStateService.setFilteredRecipes(recipes.where((element) =>element.matchFilter(filter)) .toList());
  }

  List<Recept> _getSortedListOfRecipes() {
    List<Recept> recipes = List.of(_appStateService.getRecipes());
    recipes.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Zoek"),
                  ),

                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Recept tags"),
                  ),

                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Uitloggen"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchRecipesPage2(title: 'Zoek')),
                  );
                }else if(value == 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RecipesTagsPage(title: 'Recipes tags')),
                  );
                }else if(value == 2){
                  FirebaseAuth.instance.signOut();
                }
              }
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Filter'),
              onPressed: () {
                _openFilter();
              },
            ),

            SizedBox(
              height: 650,
              width: 500,
              child: ListView(
                children: _appStateService.getEnrichedFilteredRecipes().map((item) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 170.0,
                          ),
                          alignment: Alignment.center,
                          child: ReceptItemWidget(
                              recept: item, key: ObjectKey(item)),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewRecept();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
