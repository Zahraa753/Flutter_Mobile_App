import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/app_pages/Hive_files_folder/folder_model.dart';

class AddFolderProvider extends ChangeNotifier {
  final lableController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<Color> colors = [
    Colors.blue,
    Colors.grey,
    Colors.red,
    Colors.amber,
    Colors.green,
  ];

  int? selected_color;
  List<FolderModel> folder = [];

  // Function to add a new folder
  void AddFolder() async {
    final box = await Hive.openBox<FolderModel>('folderBox');
    FolderModel folderModel = FolderModel(
      label: lableController.text,
      createAt: DateTime.now().toString(),
      color: colors[selected_color!].value,
    );
    await box.add(folderModel);
    Fluttertoast.showToast(msg: 'The folder created successfully');
  }

  void getAllFolders() async {
    var box = await Hive.openBox<FolderModel>('folderBox');
    folder = box.values.toList();
    notifyListeners();
  }
}
