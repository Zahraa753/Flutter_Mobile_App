import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/app_pages/Hive_files_notes/note_model.dart';
import 'package:notes_app/state_management/add_folder_provider.dart';
import 'package:notes_app/state_management/add_note_provider.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final NoteModel? noteModel;
  final int? index;
  const AddNoteScreen({super.key, this.noteModel, this.index});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNoteProvider(),

      child: Builder(
        builder: (context) {
          final prov = Provider.of<AddNoteProvider>(context);

          return Scaffold(
            backgroundColor: prov.selectedColor != null
                ? lighten(prov.colors[prov.selectedColor!], 0.2)
                : Colors.white,
            appBar: AppBar(
              title: Text('Add Note'),
              backgroundColor: prov.selectedColor != null
                  ? lighten(prov.colors[prov.selectedColor!], 0.2)
                  : Colors.white,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: prov.formKey,
                        child: Column(
                          spacing: 16,
                          children: [
                            TextFormField(
                              controller: prov.titleController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                labelText: 'Enter note title',
                                labelStyle: TextStyle(color: Colors.black),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid title';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            TextFormField(
                              controller: prov.bodyController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                labelText: 'Enter note description',
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid title';
                                }
                                return null;
                              },
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                            ),
                            //*****************cosumer for color selection***************************
                            Consumer<AddNoteProvider>(
                              builder: (context, _, _) {
                                return Row(
                                  children: List.generate(
                                    prov.colors.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            prov.selectedColor = index;
                                            prov.getAllFolders();
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: prov.selectedColor == index
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: prov.colors[index],

                                            child: prov.selectedColor == index
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<AddNoteProvider>(
                    builder: (context, _, _) {
                      return ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () async {
                            prov.changeFolder(prov.folder[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(prov.folder[index].color),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    prov.folder[index].label,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                if (prov.selectedFolder == prov.folder[index])
                                  Icon(Icons.check, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemCount: prov.folder.length,
                      );
                    },
                  ),

                  Container(
                    height: 50,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (prov.formKey.currentState!.validate()) {
                          if (prov.selectedColor != null) {
                            if (widget.noteModel != null) {
                              prov.updateNote(
                                widget.noteModel,
                                widget.index!,
                                context,
                              );
                            } else {
                              prov.addNote(context);
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please select a color',
                            );
                          }
                        }
                      },
                      child: Text(
                        widget.noteModel != null ? 'Update Note' : 'Add Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
