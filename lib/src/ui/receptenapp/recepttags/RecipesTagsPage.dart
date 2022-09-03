import 'package:flutter/material.dart';
import '../../../global.dart';
import '../../../model/recipes/v1/receptTags.dart';
import '../../../services/repositories/RecipesTagsRepository.dart';
import 'ReceptTagItemWidget.dart';

class RecipesTagsPage extends StatefulWidget {
  RecipesTagsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<RecipesTagsPage> createState() => _PageState();
}

class _PageState extends State<RecipesTagsPage> {
  List<ReceptTag> tags = List.empty();
  var tagsRepository = getIt<RecipesTagsRepository>();

  _PageState() {
    tags = tagsRepository.getTags().tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 750,
              child: ListView(
                children: tags.map((item) {
                  return Container(
                    child:
                    Column(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            height: 30.0,
                          ),
                          alignment: Alignment.center,
                          child:
                          ReceptTagItemWidget(receptTag: item),
                        ),
                      ],

                    ),

                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    // color: Colors.green[100],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
