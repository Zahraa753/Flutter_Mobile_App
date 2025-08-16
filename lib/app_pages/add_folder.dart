import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app/app_pages/Hive_files_folder/folder_model.dart';
import 'package:notes_app/state_management/add_folder_provider.dart';
import 'package:provider/provider.dart';

class AddFolder extends StatefulWidget {
  final FolderModel? folderModel;
  final int? index;
  const AddFolder({super.key, this.folderModel, this.index});

  @override
  State<AddFolder> createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFolderProvider(),

      child: Builder(
        builder: (context) {
          final prov = Provider.of<AddFolderProvider>(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Add folder'),
              backgroundColor: Colors.white,
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Column(
                  children: [
                    Form(
                      key: prov.formKey,
                      child: Column(
                        spacing: 16,
                        children: [
                          //file title
                          TextFormField(
                            controller: prov.lableController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              //focus Decoration
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.blue),
                              ),

                              labelText: 'Enter note title',

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              //focus error Decoration
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid lable';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          //color selection
                          Row(
                            children: List.generate(
                              prov.colors.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      prov.selected_color = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      //to handle the diffrence bteen color and background
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: prov.selected_color == index
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: prov.colors[index],

                                      child: prov.selected_color == index
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
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: prov.folder.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(prov.folder[index].color),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Text(
                                            prov.folder[index].createAt
                                                .toString()
                                                .split(' ')[0],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Remove the empty Row widget here
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey);
                      },
                    ),

                    Container(
                      height: 50,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.green[500],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if (prov.formKey.currentState!.validate()) {
                            if (prov.selected_color != null) {
                              AddFolder();
                              prov.getAllFolders();
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Please select a color',
                              );
                            }
                          }
                        },
                        child: Text(
                          'Add Note',
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
            ),
          );
        },
      ),
    );
  }
}
