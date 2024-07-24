import 'package:isar/isar.dart';

//below line is used to generate the file
part 'notes.g.dart';
//after writing that line run a command: dart run build_runner build
//it will generate the notes.g.dart file which helps us to store the data into the database

@collection
class Note{

  Id id = Isar.autoIncrement;

  late String text;
  String? title;
  late String date;

}