import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/IsarDB/notes_database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'IsarDB/notes.dart';

class NewNoteScreen extends StatefulWidget {


  final Note? note;

  NewNoteScreen({super.key, this.note});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {

  TextEditingController _noteText = TextEditingController();
  TextEditingController _titleText = TextEditingController();


  //to track whether the back button has already been handled or not
  bool _backButtonHandled = false;


  // to check if current page is home or not
  bool isHomePage(BuildContext context){
    final ModalRoute? currentRoute = ModalRoute.of(context);

    //checking if its HomePage or not by the name i.e. '/',
    // because by default initial page(mostly homePage) route's name is '/'.
    return currentRoute!.settings.name == '/';
  }

  //for PopScope's onPopInvoked().
  Future<bool> handleBackButton(BuildContext context) async{

    //the if (_backButtonHandled) statement checks
    // if the back button has already been handled.
    // If it has, then the method returns false to indicate
    // that the back button has already been handled.
    if(_backButtonHandled){
      return false;
    }

    // Mark the back button as handled
    _backButtonHandled = true;

    final noteText = _noteText.text;
    final noteTitle = _titleText.text.isNotEmpty ? _titleText.text : "Untitled";

    print('noteText: $noteText');
    print('noteTitle: $noteTitle');


    if (widget.note != null) {
      if (noteText != widget.note?.text || noteTitle != widget.note?.title) {
        if (noteText.isNotEmpty) {
          await context.read<NotesDatabase>().updateNotes(widget.note!.id, noteText, noteTitle);
        } else {
          await context.read<NotesDatabase>().deleteNote(widget.note!.id);
        }
        return true;
      }
    } else {
      if (noteText.isNotEmpty) {
        await context.read<NotesDatabase>().addNote(noteText, noteTitle);
        return true;
      }
    }
    return true;

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //prefilling/initializing the note text controller with
    // the text of the selected note
    if(widget.note != null){
      _noteText.text = widget.note!.text;
      _titleText.text = widget.note!.title ?? "";
    }

  }

  //Update the selected note when the user saves the changes
  void updateNote(){

    final noteText = _noteText.text;
    final noteTitle = _titleText.text.isNotEmpty ? _titleText.text : "Untitled"; // Default title

    //print('noteText: $noteText');
    //print('noteTitle: $noteTitle');


    if (noteText.isNotEmpty) {
      if (widget.note != null) {
        context.read<NotesDatabase>().updateNotes(widget.note!.id, noteText, noteTitle);
      } else {
        context.read<NotesDatabase>().addNote(noteText, noteTitle);
      }
    } else {
      Navigator.pop(context);
    }

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      //it will handle the back button function i.e to save the notes.
      onPopInvoked: (didPop) => handleBackButton(context),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Title ",
            ),
          ),

        //save the note and pop the page, and after poping if its HomePage
          // then no need to have leading back button
        leading: isHomePage(context) ? null : IconButton(
            onPressed: (){
              //user presses the leading button, the Navigator.pop method is called,
              // which in turn calls the onPopInvoked callback, which in turn calls
              // the handleBackButton method.
              Navigator.pop(context);
              },
            icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _noteText,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Enter your Notes Here...",
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
