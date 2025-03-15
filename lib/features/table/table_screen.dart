import 'package:flutter/material.dart';
import 'package:flutter_supa/models/note.dart';
import 'package:flutter_supa/models/note_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
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
                  DataColumn(label: Text("ID", style:  TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("Title", style:  TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("Content", style:  TextStyle(fontWeight: FontWeight.bold),)),
                  DataColumn(label: Text("Delete", style:  TextStyle(fontWeight: FontWeight.bold),)),
                ],
                rows: notes.map((note) {
                  return DataRow(cells: [
                    DataCell(Text(note.id.toString(),style: const TextStyle(fontWeight: FontWeight.bold),)),
                    DataCell(Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold),)),
                    DataCell(Text(note.content, style: const TextStyle(fontWeight: FontWeight.bold),)),
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
