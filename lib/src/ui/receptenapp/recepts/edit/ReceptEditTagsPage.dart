import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:receptenapp/src/ui/receptenapp/recepts/edit/ReceptEditInstructionsPage.dart';

import '../../../../GetItDependencies.dart';
import '../../../../model/enriched/enrichedmodels.dart';
import '../../../../model/recipes/v1/recept.dart';
import '../../../../repositories/RecipesTagsRepository.dart';
import '../../../../services/RecipesService.dart';
import '../ReceptDetailsPage.dart';

class ReceptEditTagsPage extends StatefulWidget {
  ReceptEditTagsPage({Key? key, required this.title, required this.recept, required this.insertMode})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;
  final bool insertMode;

  @override
  State<ReceptEditTagsPage> createState() => _WidgetState(recept, insertMode);
}

class _WidgetState extends State<ReceptEditTagsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  late bool _insertMode;
  var _recipesService = getIt<RecipesService>();
  var _recipesTagsRepository = getIt<RecipesTagsRepository>();
  var _tagsSet = Set<String>();
  var _additionalTags= "";

  _WidgetState(EnrichedRecept recept, bool insertMode) {
    this._recept = recept;
    this._newRecept = recept.recept;
    this._insertMode = insertMode;
    _recept.tags.forEach((element) {
      _tagsSet.add(element?.tag??"");
    });
  }

  _saveRecept() {
    _newRecept.tags = _tagsSet.toList();
    _additionalTags.split(",").forEach((element) {
      var tag =element.trim();
      if (tag.isNotEmpty) {
        _newRecept.tags.add(tag);
      }
    });
    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context))
    ;
  }

  _newReceptNextStep() {
    _saveRecept();
    // pop 3 extra times (all other edit fields!)
    Navigator.pop(context);
    Navigator.pop(context);
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
                    TextFormField(
                      decoration: InputDecoration(label: Text('Additional new tags (comma separated):')),
                      initialValue: _additionalTags,
                      onChanged: (text) {
                        _additionalTags = text;
                      },
                    ),

                    ElevatedButton(
                      child: _insertMode?Text('Add recept'):Text('Save'),
                      onPressed: () {
                        if (_insertMode){
                          _newReceptNextStep();
                        }
                        else{
                          _saveRecept();
                        }
                      },
                    ),
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
                        var res = _tagsSet.remove(tag);
                      }
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
