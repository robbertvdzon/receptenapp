import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '../GetItDependencies.dart';
import '../model/diary/v1/diary.dart';

class DiaryRepository {
  String? usersCollection = null;
  Diary? cachedDiary = null;

  final _DOCNAME = "diary";
  final _KEY = "v1";
  var _db = getIt<FirebaseFirestore>();

  Future<Diary> init(String email) {
    usersCollection = email;
    return _loadDiary();
  }

  Diary getDiary() {
    if (cachedDiary == null) throw Exception("Repository not initialized");
    return cachedDiary!;
  }

  DiaryDay? getDay (int dateAsTimestamp) {
    return getDiary().diaryDays.firstWhereOrNull((element) => element.dateAsTimestamp==dateAsTimestamp);
  }

  Future<void> saveDiaryDay(DiaryDay day) async {
    var diary = getDiary();
    var oldDay = diary.diaryDays.firstWhereOrNull((element) => element.dateAsTimestamp==day.dateAsTimestamp);
    if (oldDay!=null){
      diary.diaryDays.remove(oldDay);
    }
    diary.diaryDays.add(day);
    return _saveDiary(diary);
  }

  Future<void> _saveDiary(Diary diary) async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final Map<String, dynamic> jsonMap = diary.toJson();
    final jsonKeyValue = <String, String>{_KEY: jsonEncode(jsonMap)};
    return _db
        .collection(usersCollection!)
        .doc(_DOCNAME)
        .set(jsonKeyValue)
        .onError((e, _) => print("Error writing document: $e"))
        .then((data) => cachedDiary = diary);
  }

  Future<Diary> _loadDiary() async {
    if (usersCollection == null) throw Exception("Repository not initialized");
    final event = await _db.collection(usersCollection!).doc(_DOCNAME).get();
    Map<String, dynamic>? data = event.data();
    if (data != null) {
      var jsonData = data[_KEY];
      var json = jsonData as String;
      var jsonObj = jsonDecode(json);
      final diary = Diary.fromJson(jsonObj);
      cachedDiary = diary;
      return diary;
    }
    else{
      cachedDiary = Diary();
    }
    return cachedDiary!;
  }



}
