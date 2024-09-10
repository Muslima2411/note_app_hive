import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/note.dart';

class DBService {
  static const dbName = "dbName";

  static Box box = Hive.box(dbName);

  static Future<void> storeNote(List<Note> noteList) async {
    List<String> stringList =
        noteList.map((note) => jsonEncode(note.toJson())).toList();
    await box.put("notes", stringList);
  }

  static Future<List<Note>> loadNote() async {
    List<String> stringList = box.get("notes") ?? <String>[];
    List<Note> notesList =
        stringList.map((note) => Note.fromJson(jsonDecode(note))).toList();
    return notesList;
  }

  static Future<void> removeNote() async {
    await box.delete("notes");
  }
}
