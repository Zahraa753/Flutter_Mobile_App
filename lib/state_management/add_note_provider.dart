import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/app_pages/Hive_files_folder/folder_model.dart';
import 'package:notes_app/app_pages/Hive_files_notes/note_model.dart';

class AddNoteProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<Color> colors = [
    Colors.blue,
    Colors.grey,
    Colors.red,
    Colors.amber,
    Colors.green,
  ];
  int? selectedColor;
  List<FolderModel> folder = [];

  void getAllFolders() async {
    var box = await Hive.openBox<FolderModel>('folderBox');
    folder = box.values.toList();
  }

  void addNote(BuildContext context) async {
    final box = await Hive.openBox<NoteModel>('notesBox');
    NoteModel noteModel = NoteModel(
      title: titleController.text,
      body: bodyController.text,
      createdAt: DateTime.now(),
      color: colors[selectedColor!].value,
    );
    print('Is Completed ${noteModel.isCompleted}');
    await box.add(noteModel);
    Fluttertoast.showToast(msg: 'The note created successfully');
    Navigator.pop(context, true);
  }

  void updateNote(NoteModel? note, int index, context) async {
    if (formKey.currentState!.validate()) {
      if (selectedColor != null) {
        final box = await Hive.openBox<NoteModel>('notesBox');
        NoteModel noteModel = NoteModel(
          title: titleController.text,
          body: bodyController.text,
          createdAt: note!.createdAt, //needs more
          color: colors[selectedColor!].value,
        );
        box.putAt(index, noteModel);
        Fluttertoast.showToast(msg: 'The note updated successfully');
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: 'Please select a color');
      }
    }
  }

  void init(NoteModel? noteModel) {
    titleController.text = noteModel?.title ?? '';
    bodyController.text = noteModel?.body ?? '';
    if (noteModel != null) {
      selectedColor = colors.indexWhere(
        (element) => element.value == noteModel.color,
      );
    }
  }

  void changeColor(int index) {
    selectedColor = index;
    notifyListeners();
  }

  FolderModel? selectedFolder;
  void changeFolder(FolderModel folder) {
    selectedFolder = folder;
    notifyListeners();
  }
}
