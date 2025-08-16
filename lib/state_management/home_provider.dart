import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/app_pages/Hive_files_notes/note_model.dart';

class HomeProvider extends ChangeNotifier {
  // Add any state management logic here for the home page
  // For example, you can manage a list of folders or notes
  // and notify listeners when changes occur.
  List<NoteModel> notes = [];
  void getAllNotes() async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    notes = box.values.toList();
    notifyListeners();
  }

  void deleteNote(int index) async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    box.deleteAt(index);
    getAllNotes();
  }

  void toggleNoteCompletion(int index) async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    var noteModel = notes[index];
    noteModel.isCompleted = !noteModel.isCompleted;
    await box.putAt(index, noteModel);
    getAllNotes();
  }

  List<String> folders = [];

  // Example method to add a folder
  void addFolder(String folderName) {
    folders.add(folderName);
    notifyListeners();
  }

  // Example method to remove a folder
  void removeFolder(String folderName) {
    folders.remove(folderName);
    notifyListeners();
  }
}
