import 'package:flutter/material.dart';

import '../../../GetItDependencies.dart';
import '../../../model/enriched/enrichedmodels.dart';
import '../../../model/recipes/v1/receptTags.dart';
import '../../../services/Enricher.dart';

class ReceptTagDetailsPage extends StatefulWidget {
  ReceptTagDetailsPage({Key? key, required this.title, required this.receptTag}) : super(key: key) {}

  final ReceptTag receptTag;
  final String title;

  @override
  State<ReceptTagDetailsPage> createState() => _WidgetState(receptTag);
}

class _WidgetState extends State<ReceptTagDetailsPage> {
  late EnrichedRecipeTag receptTag;
  var enricher = getIt<Enricher>();

  _WidgetState(ReceptTag receptTag) {
    this.receptTag = enricher.enrichtRecipeTag(receptTag);
  }
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(

              child:Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(label: Text('tag:')),
                    initialValue: "${receptTag.tag}",
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text('recipes:')),
                    initialValue: "${receptTag.recipes.map((e) => e?.name).join(",")}",
                  ),

                ],
              )

          ))
    ;
  }

}


