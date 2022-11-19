import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../GetItDependencies.dart';
import '../../../events/FilterModifiedEvent.dart';
import '../../../repositories/RecipesTagsRepository.dart';
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
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();

  String _nameFilter = "";
  String _ingredientsFilter = "";
  String _tagFilter = "";
  String _maxCoockTime = "";
  bool? _favorite = false;
  var _tagsSet = Set<String>();

  _WidgetState() {
    _nameFilter = _appStateService.filter.nameFilter;
    _ingredientsFilter = _appStateService.filter.ingredientsFilter;
    _tagFilter = _appStateService.filter.tagFilter;
    _maxCoockTime = _appStateService.filter.maxCoockTime;
    _favorite = _appStateService.filter.favorite;

    _tagFilter.split(",").forEach((element) {
      _tagsSet.add(element);
    });
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

            SizedBox(
              height: 400,
              width: 500,
              child: ListView(
                children: _recipesTagsRepository.getTags().tags.map((item) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 40.0,
                          ),
                          alignment: Alignment.center,
                          child: buildTag(item.tag??"unknown"),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                  );
                }).toList(),
              ),
            ),




            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
                )
              ],
            )


          ],
        ))));
  }

  Widget buildTag(String tag) {
    return InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  value: _tagsSet.contains(tag),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value==true){
                        _tagsSet.add(tag);
                      }
                      else{
                        _tagsSet.remove(tag);
                      }
                      _tagFilter = _tagsSet.join(",");
                    });
                  },
                ),
                Text(tag),
              ],
            )
          ],
        ));
  }
}
