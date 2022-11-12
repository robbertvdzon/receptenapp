import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/recept.dart';
import '../../../services/RecipesService.dart';

class ReceptEditTagsPage extends StatefulWidget {
  ReceptEditTagsPage({Key? key, required this.title, required this.recept})
      : super(key: key) {}

  final EnrichedRecept recept;
  final String title;

  @override
  State<ReceptEditTagsPage> createState() => _WidgetState(recept);
}

class _WidgetState extends State<ReceptEditTagsPage> {
  late EnrichedRecept _recept;
  late Recept _newRecept;
  var _recipesService = getIt<RecipesService>();

  _WidgetState(EnrichedRecept recept) {
    this._recept = recept;
    this._newRecept = recept.recept;
  }

  _saveRecept() {
    _recipesService
        .saveRecept(_newRecept)
        .whenComplete(() => Navigator.pop(context));
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
                      decoration: InputDecoration(label: Text('Tags:')),
                      initialValue: "${_recept.tags.map((e) => e?.tag).join(",")}",
                    ),
                    ElevatedButton(
                      child: Text('SAVE'),
                      onPressed: () {
                        _saveRecept();
                      },
                    ),
                  ],
                ))));
  }
}
