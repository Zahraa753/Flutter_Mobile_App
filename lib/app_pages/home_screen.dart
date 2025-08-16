import 'package:flutter/material.dart';
import 'package:notes_app/app_pages/add_folder.dart';
import 'package:notes_app/app_pages/add_update_note_screen.dart';
import 'package:notes_app/state_management/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, child) {
        final prov = Provider.of<HomeProvider>(context);
        prov.getAllNotes();
        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),

            actions: [
              IconButton(
                icon: Icon(Icons.folder),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFolder()),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: Consumer<HomeProvider>(
            builder: (context, _, _) {
              return FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNoteScreen()),
                  );
                  if (result != null && result) {
                    prov.getAllNotes();
                  }
                },
                backgroundColor: Colors.blue,
                child: Icon(Icons.add, color: Colors.white),
              );
            },
          ),
          body: Consumer(
            builder: (context, _, _) {
              return ListView.separated(
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNoteScreen(
                          noteModel: prov.notes[index],
                          index: index,
                        ),
                      ),
                    );
                    if (result != null && result) {
                      prov.getAllNotes();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(prov.notes[index].color),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: prov.notes[index].isCompleted,
                          onChanged: (value) {
                            prov.toggleNoteCompletion(index);
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      prov.notes[index].title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    prov.notes[index].createdAt
                                        .toString()
                                        .split(' ')[0],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      prov.notes[index].body,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      prov.deleteNote(index);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              if (prov.notes[index].folder != null)
                                Row(
                                  spacing: 5,
                                  children: [
                                    Icon(
                                      Icons.folder,
                                      color: Color(
                                        prov.notes[index].folder!.color,
                                      ),
                                    ),
                                    Text(
                                      prov.notes[index].folder!.label,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: prov.notes.length,
              );
            },
          ),
        );
      },
    );
  }
}
