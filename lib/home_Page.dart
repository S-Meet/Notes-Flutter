import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/IsarDB/notes.dart';
import 'package:notes/IsarDB/notes_database.dart';
import 'package:notes/newnote_page.dart';
import 'package:provider/provider.dart';

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // manage the visibility of the search bar
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //For searching a note
    _searchController.addListener(_onSearchChanged);

    //it will show notes on app startup.
    readNotes();
  }

  @override
  void dispose(){
    super.dispose();

    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();

  }

  void _onSearchChanged(){
    setState(() {
      _searchQuery = _searchController.text;
    });
    readNotes();
  }
  void _toggleSearch() {

    //toggles the search bar visibility.
    // When the search bar is closed,
    // it clears the search query and fetches all notes.

    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        readNotes();
      }
    });
  }

  //read notes
  void readNotes() {
    context.read<NotesDatabase>().fetchNotes(_searchQuery);
  }

  void deleteNote(int id){
    context.read<NotesDatabase>().deleteNote(id);

    //for poping the BottomSheet after button is pressed
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    //note Db
    final noteDatabase = context.watch<NotesDatabase>();

    //List of notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title:
        //Shows either the title or the search bar based on _isSearching.
        _isSearching ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        )
            : Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewNoteScreen(),
              ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        foregroundColor: Colors.deepOrange,
        child: ImageIcon(
          AssetImage('Assets/icons/edit.png'),
          size: 25,
        ),
      ),
      body: GridView.builder(
        itemCount: currentNotes.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1/1.5,),
        itemBuilder: (context, index) {
          //getting the individual Note
          final note = currentNotes[index];

          return GestureDetector(

            //When tap on Note user can edit it.
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewNoteScreen(note: note),));
            },
            onLongPress: (){
              showBottomSheet(context: context, builder: (context) {
                   return Container(
                     height: 60,
                     color: Theme.of(context).colorScheme.background,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         InkWell(

                           //delete the specific note
                           onTap: (){

                              deleteNote(note.id);
                           },
                           child: Padding(
                             padding: const EdgeInsets.only(top: 10.0),
                             child: const Column(
                               children: [
                                 Icon(Icons.delete_outline),
                                 Text("Delete",)
                               ],
                             ),
                           ),
                         )
                       ],
                     ),
                   );
              },);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        //color: Theme.of(context).colorScheme.secondary,
                        color: Theme.of(context).colorScheme.secondary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: GridTile(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${note.text}"),
                      )),
                    ),
                  ),
                   const SizedBox(height: 10,),
                  Text(note.title ?? "Untitled", style: TextStyle(fontWeight: FontWeight.bold),),
                  //SizedBox(height: 8,),
                  Text(note.date.toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
                  const SizedBox(height: 20,),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
