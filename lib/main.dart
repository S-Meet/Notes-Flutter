import 'package:flutter/material.dart';
import 'package:notes/IsarDB/notes_database.dart';
import 'package:notes/Themes/theme.dart';
import 'package:notes/home_Page.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialize the isar Db
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.initialize();

  runApp(
      ChangeNotifierProvider(create: (context) => NotesDatabase(),
      child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      home: const NotesHomePage(),
    );
  }
}
