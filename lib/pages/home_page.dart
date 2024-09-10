import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_hive_project/pages/details_page.dart';
import 'package:note_hive_project/service/hive_service.dart';

import '../models/note.dart';

class HomePage extends StatefulWidget {
  static const id = "/home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color txtColor = Color(0xFF646464);

  List<Color> colors = [
    Color(0xFFC4FFCA),
    Color(0xFFC5CBFF),
    Color(0xFFFBBECF),
    Color(0xFF96F4F4),
    Color(0xFFFDF3BF),
    Color(0xFFC4FFCA),
    Color(0xFFC5CBFF),
    Color(0xFFFBBECF),
    Color(0xFF96F4F4),
    Color(0xFFFDF3BF),
    Color(0xFFC4FFCA),
    Color(0xFFC5CBFF),
    Color(0xFFFBBECF),
    Color(0xFF96F4F4),
    Color(0xFFFDF3BF),
    Color(0xFFC4FFCA),
    Color(0xFFC5CBFF),
    Color(0xFFFBBECF),
    Color(0xFF96F4F4),
    Color(0xFFFDF3BF),
  ];

  Widget _buildKartochkas({required Color color, required Note note}) {
    return Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                note.title!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: txtColor),
              ),
            ),
            Center(
              child: Text(
                note.content!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: txtColor,
                ),
              ),
            ),
          ],
        ));
  }

  List<Note> list = [];

  void loadNotes() async {
    list = await DBService.loadNote();
    setState(() {});
  }

  void _openDetail() async {
    var result = await Navigator.pushNamed(context, DetailsPage.id);
    if (result != null && result == true) {
      loadNotes();
    }
  }

  Future<void> _openDetailWithNote(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsPage(
                  note: note,
                )));
    if (result != null && result == true) {
      loadNotes();
    }
  }

  @override
  void initState() {
    loadNotes();
    super.initState();
  }

  void _showDeleteConfirmationDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteNoteAndRefresh(note);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteNoteAndRefresh(Note note) async {
    await DBService.removeNote();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Drawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset("assets/drawer.png"),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            "Recent Notes",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/search.png"),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: MasonryGridView.builder(
            itemCount: list.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onLongPress: () {
                    _showDeleteConfirmationDialog(list[index]);
                  },
                  onTap: () {
                    _openDetailWithNote(list[index]);
                  },
                  child:
                      _buildKartochkas(color: colors[index], note: list[index]),
                ),
              );
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.red,
        onPressed: () {
          _openDetail();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
