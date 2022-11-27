import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../events/FilterModifiedEvent.dart';
import '../../../events/SnackCreatedEvent.dart';
import '../../../events/SnackRemovedEvent.dart';
import '../../../events/RepositoriesLoadedEvent.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/snacks/v1/snack.dart';
import '../../../services/AppStateService.dart';
import '../../../services/Enricher.dart';
import '../../../services/Filter.dart';
import '../snacks/SnackItemWidget.dart';
import '../snacks/edit/SnackEditDetailsPage.dart';

class SearchSnacksPage extends StatefulWidget {
  SearchSnacksPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchSnacksPage> createState() => _SearchSnacksPageState();
}

class _SearchSnacksPageState extends State<SearchSnacksPage> {
  var _appStateService = getIt<AppStateService>();
  var _enricher = getIt<Enricher>();
  var _eventBus = getIt<EventBus>();
  StreamSubscription? _eventStreamSub;

  @override
  void initState() {
    super.initState();
    _filterSnacks();
    _eventStreamSub = _eventBus.on<SnackCreatedEvent>().listen((event) => _reloadFilter());
    _eventStreamSub = _eventBus.on<SnackRemovedEvent>().listen((event) => _reloadFilter());
    _eventStreamSub = _eventBus.on<RepositoriesLoadedEvent>().listen((event) => _reloadFilter());
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSub?.cancel();
  }

  void _reloadFilter() {
      setState(() {
        _filterSnacks();
      });
  }

  void _createNewSnack() {
    Snack newSnack = new Snack(List.empty(growable: true), "");
    EnrichedSnack enrichedNewSnack = _enricher.enrichSnack(newSnack);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SnackEditDetailsPage(
                    title: 'Nieuw snack', snack: enrichedNewSnack, insertMode: true)),
      );
  }

  // void _openFilter(){
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             SearchSnacksFilterPage(
  //                 title: 'Filter')),
  //   );
  // }
  //
  // void _clearFilter(){
  //   _appStateService.clearFilter();
  //
  // }
  //
  //
  void _filterSnacks() {
    Filter filter = _appStateService.filter;
    List<Snack> snacks = _getSortedListOfSnacks();
    _appStateService.setFilteredSnacks(snacks.where((element) =>element.matchFilter(filter)) .toList());
  }

  List<Snack> _getSortedListOfSnacks() {
    List<Snack> snacks = List.of(_appStateService.getSnacks());
    snacks.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return snacks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 650,
              width: 500,
              child: ListView(
                children: _appStateService.getEnrichedFilteredSnacks().map((item) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 170.0,
                          ),
                          alignment: Alignment.center,
                          child: SnackItemWidget(
                              snack: item, key: ObjectKey(item)),
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
          _createNewSnack();
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
