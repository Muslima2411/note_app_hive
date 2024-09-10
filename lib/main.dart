import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_hive_project/pages/details_page.dart';
import 'package:note_hive_project/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_hive_project/service/hive_service.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(DBService.dbName);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        DetailsPage.id: (context) => const DetailsPage(),
      },
    );
  }
}
