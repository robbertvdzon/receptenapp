import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../GetItDependencies.dart';
import '../../../events/FilterModifiedEvent.dart';
import '../../../services/AppStateService.dart';

class SearchRecipesFilterPage extends StatefulWidget {
  SearchRecipesFilterPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<SearchRecipesFilterPage> createState() => _WidgetState();
}

class _WidgetState extends State<SearchRecipesFilterPage> {
  var _appStateService = getIt<AppStateService>();
  var _eventBus = getIt<EventBus>();

  String _nameFilter = "";
  String _ingredientsFilter = "";
  String _tagFilter = "";
  String _maxCoockTime = "";
  bool? _favorite = false;

  _WidgetState() {
    _nameFilter = _appStateService.filter.nameFilter;
    _ingredientsFilter = _appStateService.filter.ingredientsFilter;
    _tagFilter = _appStateService.filter.tagFilter;
    _maxCoockTime = _appStateService.filter.maxCoockTime;
    _favorite = _appStateService.filter.favorite;
  }

  _apply() {
    _appStateService.filter.nameFilter = _nameFilter;
    _appStateService.filter.ingredientsFilter = _ingredientsFilter;
    _appStateService.filter.tagFilter = _tagFilter;
    _appStateService.filter.maxCoockTime = _maxCoockTime;
    _appStateService.filter.favorite = _favorite ?? false;
    _eventBus.fire(FilterModifiedEvent());
    Navigator.pop(context);
  }

  _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(label: Text('Name:')),
              initialValue: "${_nameFilter}",
              onChanged: (text) {
                _nameFilter = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('ingredientsFilter:')),
              initialValue: "${_ingredientsFilter}",
              onChanged: (text) {
                _ingredientsFilter = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('tagFilter:')),
              initialValue: "${_tagFilter}",
              onChanged: (text) {
                _tagFilter = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(label: Text('maxCoockTime:')),
              initialValue: "${_maxCoockTime}",
              onChanged: (text) {
                _maxCoockTime = text;
              },
            ),
            SizedBox(
                height: 50,
                width: 500,
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  title: Text("Filter op favoriet"),
                  value: _favorite,
                  onChanged: (bool? value) {
                    setState(() {
                      _favorite = value;
                    });
                  },
                )),
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                _cancel();
              },
            ),
            ElevatedButton(
              child: Text('Apply'),
              onPressed: () {
                _apply();
              },
            ),
          ],
        ))));
  }
}
