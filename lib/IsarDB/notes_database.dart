import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:notes/IsarDB/notes.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier{

  //Object of Isar
  static late Isar isar;

  //initialize Db
  static Future<void> initialize() async{

    final dir = await getApplicationDocumentsDirectory();

     isar = await Isar.open(
        [NoteSchema],
        directory: dir.path,
    );
  }

  //List of Notes
  final List<Note> currentNotes = [];

  //create a note and save to Db
  Future<void> addNote(String text, String title) async{

    //creating a object of our Note class (from notes.dart)
    final newNote = Note();
    newNote.text = text;
    newNote.title = title.isNotEmpty ? title : "Untitled";
    newNote.date =  DateFormat('d MMM').format(DateTime.now());

    if (kDebugMode) {
      print("Title in add note ${newNote.title}");
    }
    //saving the note in the Db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //re-read from Db to get the instant reflection of new note
    fetchNotes();
}

  //read notes from Db
  Future<void> fetchNotes([String query = '']) async{

    List<Note> fetchedNotes;

    if(query.isNotEmpty){
      //It's querying the Db to fetch notes as per the user searches.
      fetchedNotes = await isar.notes.filter()
          .textContains(query, caseSensitive: false)
          .or()
          .titleContains(query, caseSensitive: false)
          .findAll();
    }else{
      // It's querying the database (isar) to fetch all notes.
      fetchedNotes = await isar.notes.where().findAll();
    }

    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  //Update notes in Db
  Future<void> updateNotes(int id, String newText, String newTitle) async{

    //getting the current node(existing) to make change on it.
    final existingNote = await isar.notes.get(id);

    if(existingNote != null){
      existingNote.text = newText;
      existingNote.title = newTitle.isNotEmpty ? newTitle : "Untitled";
      existingNote.date = DateFormat('d MMM').format(DateTime.now());
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }

  }

  //delete notes from the Db
  Future<void> deleteNote(int id) async{
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }

}