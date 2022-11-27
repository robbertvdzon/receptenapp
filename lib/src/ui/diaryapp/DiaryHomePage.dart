import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../GetItDependencies.dart';
import '../../model/diary/v1/diary.dart';
import '../../model/recipes/v1/recept.dart';
import '../../repositories/DiaryRepository.dart';
import '../../repositories/UserRepository.dart';
import '../ingredientsapp/ingredienttags/IngredientTagsPage.dart';

class DiaryHomePage extends StatefulWidget {

  DiaryHomePage({Key? key, required this.title})
      : super(key: key) {
  }

  final String title;

  @override
  State<DiaryHomePage> createState() => _DiaryHomePageState();
}


class _DiaryHomePageState extends State<DiaryHomePage> {
  var userRepository = getIt<UserRepository>();
  var _diaryRepository = getIt<DiaryRepository>(); // TODO: via service!

  _DiaryHomePageState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Text(
            'user: ${userRepository.getUsersEmail()}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildChildren(),
        ),
      ),
    );
  }

  List<Widget> buildChildren() {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    int todayTS =  today.add(new Duration(days: 0)).millisecondsSinceEpoch;
    int todayTSMin1 =  today.add(new Duration(days: -1)).millisecondsSinceEpoch;
    int todayTSMin2 =  today.add(new Duration(days: -2)).millisecondsSinceEpoch;
    int todayTSMin3 =  today.add(new Duration(days: -3)).millisecondsSinceEpoch;
    int todayTSPlus1 =  today.add(new Duration(days: 1)).millisecondsSinceEpoch;
    int todayTSPlus2 =  today.add(new Duration(days: 2)).millisecondsSinceEpoch;
    int todayTSPlus3 =  today.add(new Duration(days: 3)).millisecondsSinceEpoch;
    int todayTSPlus4 =  today.add(new Duration(days: 4)).millisecondsSinceEpoch;

    var list = List<Widget>.empty(growable: true);
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSMin3)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSMin2)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSMin1)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTS)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSPlus1)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSPlus2)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSPlus3)));
    list.addAll(buildChildrenForDay(_diaryRepository.getDay(todayTSPlus4)));

    return list;
  }

  List<Widget> buildChildrenForDay(DiaryDay? diaryDay) {
    if (diaryDay==null) return List.empty();
    List<Widget> result = List.empty(growable: true);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(diaryDay.dateAsTimestamp);
    result.add(Text(''));
    result.add(Text('Dag: ${date.toString()}:'));
    result.add(Text('breakfast:'));
    result.addAll(buildChildrenForPartOfDay(diaryDay.breakfast));
    result.add(Text('morningSnack:'));
    result.addAll(buildChildrenForPartOfDay(diaryDay.morningSnack));
    result.add(Text('lunch:'));
    result.addAll(buildChildrenForPartOfDay(diaryDay.lunch));
    result.add(Text('afternoonSnack:'));
    result.addAll(buildChildrenForPartOfDay(diaryDay.afternoonSnack));
    result.add(Text('diner:'));
    result.addAll(buildChildrenForPartOfDay(diaryDay.diner));
    result.add(Text('eveningSnack:'));
    result.addAll(buildChildrenForPartOfDay(diaryDay.eveningSnack));
    return result;
  }

  List<Widget> buildChildrenForPartOfDay(List<FoodEaten> meals) {
    return meals.map((e) => Text("${e.portions} portions of ${e.getName()}")).toList();
  }

}

