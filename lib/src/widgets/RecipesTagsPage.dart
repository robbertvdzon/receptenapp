import 'package:flutter/material.dart';
import 'package:receptenapp/src/services/RecipesTagsRepository.dart';
import '../global.dart';

class RecipesTagsPage extends StatefulWidget {
  RecipesTagsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<RecipesTagsPage> createState() => _PageState();
}

class _PageState extends State<RecipesTagsPage> {
  List<String?> tags = List.empty();
  var tagsRepository = getIt<RecipesTagsRepository>();

  _PageState() {
    tags = tagsRepository.getTags().tags.map((e)=>e.tag).toList();
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
              height: 400,
              child: ListView(
                children: tags.map((item) {
                  return Container(
                    child: Text(item??""),
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
