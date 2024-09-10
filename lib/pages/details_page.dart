import 'package:flutter/material.dart';
import 'package:note_hive_project/models/note.dart';
import 'package:note_hive_project/service/hive_service.dart';

import 'home_page.dart';

class DetailsPage extends StatefulWidget {
  static const id = "/detail_page";
  final Note? note;
  const DetailsPage({super.key, this.note});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> store() async {
    if (widget.note == null) {
      Note note = Note(
        title: titleController.text,
        content: contentController.text,
      );
      List<Note> list = await DBService.loadNote();
      list.add(note);
      await DBService.storeNote(list);
      Navigator.pop(context, true);
      print("1 saved");
    } else {
      Note updatedNote = Note(
        title: titleController.text,
        content: contentController.text,
      );
      List<Note> list = await DBService.loadNote();
      list.removeWhere((element) => element.title == widget.note!.title);
      list.add(updatedNote);
      await DBService.storeNote(list);
      Navigator.pop(context, true);
      print("2 saved");
    }
  }

  void loadNotes(Note? note) {
    if (note != null) {
      setState(() {
        if (note.title != null && note.content != null) {
          titleController.text = note.title!;
          contentController.text = note.content!;
        } else {
          titleController.text = "";
          contentController.text = "";
        }
      });
    }
  }

  @override
  void initState() {
    loadNotes(widget.note);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3BF),
      appBar: AppBar(
          backgroundColor: const Color(0xFFFDF3BF),
          title: const Center(
            child: Text("Edit Note"),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.done_rounded,
                size: 27,
              ),
              onPressed: () {
                store();
                print("saved");
              },
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.more_vert,
              size: 27,
            ),
            const SizedBox(
              width: 10,
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ListView(
          children: [
            Expanded(
              flex: 1,
              child: TextField(
                style: const TextStyle(
                  fontSize: 24, // Set the font size
                  fontWeight: FontWeight.bold, // Set the font weight
                ),
                controller: titleController,
                maxLength: 15,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent), // No border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.transparent), // No border when not focused
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: TextField(
                controller: contentController,
                maxLength: 500,
                maxLines: 25,
                decoration: const InputDecoration(
                  hintText: "Content",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent), // No border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            Colors.transparent), // No border when not focused
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
