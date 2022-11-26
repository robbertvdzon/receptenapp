import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/Enricher.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import '../../../GetItDependencies.dart';
import '../../../events/ReceptCreatedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/AppStateService.dart';
import '../recepts/edit/ReceptEditDetailsPage.dart';
import '../recepts/ReceptItemWidget.dart';
import '../recepts/ReceptItemWidgetCard.dart';
import '../recepttags/RecipesTagsPage.dart';

class SearchRecipesPage2 extends StatefulWidget {
  SearchRecipesPage2({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchRecipesPage2> createState() => _SearchRecipesPage2State();
}

class _SearchRecipesPage2State extends State<SearchRecipesPage2> {
  var _appStateService = getIt<AppStateService>();
  var _enricher = getIt<Enricher>();
  var _eventBus = getIt<EventBus>();
  String _filter = "";
  bool? _filterOnFavorite = false;
  StreamSubscription? _eventStreamSub;

  @override
  void initState() {
    super.initState();
    _filterRecipes();
    _eventStreamSub = _eventBus.on<ReceptCreatedEvent>().listen((event) => _processEvent(event));
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _processEvent(ReceptCreatedEvent event) {
      setState(() {
        _filter = event.recept.name;
        _filterRecipes();
      });
  }

  void _updateFilter(String filter) {
    setState(() {
      _filter = filter;
      _filterRecipes();
    });
  }

  void _updateFilterOnFavorite(bool? filterOnFavorite) {
    setState(() {
      _filterOnFavorite = filterOnFavorite;
      _filterRecipes();
    });
  }

  void _createNewRecept() {
    Recept newRecept = new Recept(List.empty(growable: true), "Nieuw recept");
    EnrichedRecept enrichedNewRecept = _enricher.enrichRecipe(newRecept);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ReceptEditDetailsPage(
                    title: 'Nieuw recept', recept: enrichedNewRecept, insertMode: true,)),
      );
  }

  void _filterRecipes() {
    bool filterOnFavorite = _filterOnFavorite == true;

    // TODO: dit kan vast in 1 query!
    List<Recept> recipes = _getSortedListOfRecipes();
    if (filterOnFavorite) {
      _appStateService.setFilteredRecipes(recipes
          .where((element) =>
      element.favorite &&
          element.name != null &&
          element.name.toLowerCase().contains(_filter.toLowerCase()))
          .toList());
    } else {
      _appStateService.setFilteredRecipes(recipes
          .where((element) =>
      element.name != null &&
          element.name.toLowerCase().contains(_filter.toLowerCase()))
          .toList());
    }
  }

  List<Recept> _getSortedListOfRecipes() {
    List<Recept> recipes = List.of(_appStateService.getRecipes());
    recipes.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    SwipeableCardSectionController _cardController = SwipeableCardSectionController();
    var filteredRecipes = _appStateService.getFilteredRecipes();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        SwipeableCardsSection(
        cardController: _cardController,
        context: context,
        //add the first 3 cards (widgets)
        items: [
          ReceptItemWidgetCard(
              recept: filteredRecipes[0], key: ObjectKey(filteredRecipes[0])),
          ReceptItemWidgetCard(
              recept: filteredRecipes[1], key: ObjectKey(filteredRecipes[1])),
          ReceptItemWidgetCard(
              recept: filteredRecipes[2], key: ObjectKey(filteredRecipes[2])),
        ],
        //Get card swipe event callbacks
        onCardSwiped: (dir, index, widget) {
          //Add the next card using _cardController
          if (index<filteredRecipes.length) {
            _cardController.addItem(ReceptItemWidgetCard(recept: filteredRecipes[index], key: ObjectKey(filteredRecipes[index])));
          }
          //Take action on the swiped widget based on the direction of swipe
          //Return false to not animate cards
        },
        //
        enableSwipeUp: true,
        enableSwipeDown: false,
      ),
      //other children
     ])
    );
  }
}
