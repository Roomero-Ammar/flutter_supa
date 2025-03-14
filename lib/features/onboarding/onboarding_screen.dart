import 'package:flutter/material.dart';
import 'package:flutter_supa/models/note.dart';
import 'package:flutter_supa/models/note_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final NoteDatabase noteDatabase = NoteDatabase(Supabase.instance.client);
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final fetchedNotes = await noteDatabase.fetchNotes();
    setState(() {
      notes = fetchedNotes;
      isLoading = false;
    });
  }

  Future<void> deleteNote(int id) async {
    await noteDatabase.deleteNote(id);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Table"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadNotes),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Title")),
                  DataColumn(label: Text("Content")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: notes.map((note) {
                  return DataRow(cells: [
                    DataCell(Text(note.id.toString())),
                    DataCell(Text(note.title)),
                    DataCell(Text(note.content)),
                    DataCell(Row(
                      children: [
                       
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteNote(note.id!),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
