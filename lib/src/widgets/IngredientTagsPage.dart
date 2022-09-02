import 'package:flutter/material.dart';
import '../global.dart';
import '../services/repositories/IngredientTagsRepository.dart';

class IngredientsTagsPage extends StatefulWidget {
  IngredientsTagsPage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<IngredientsTagsPage> createState() => _PageState();
}

class _PageState extends State<IngredientsTagsPage> {
  List<String?> categories = List.empty();
  var tagsRepository = getIt<IngredientTagsRepository>();

  _PageState() {
    categories = tagsRepository.getTags().tags.map((e)=>e.tag).toList();
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
                children: categories.map((item) {
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
