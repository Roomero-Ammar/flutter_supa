import 'package:flutter/material.dart';
import 'package:flutter_supa/auth/auth_service.dart';
import 'package:flutter_supa/core/helpers/extentsions.dart';
import 'package:flutter_supa/core/routing/routes.dart';
import 'package:flutter_supa/models/note.dart';
import 'package:flutter_supa/models/note_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Added const constructor

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteDatabase noteDatabase = NoteDatabase(Supabase.instance.client);
  List<Note> notes = [];
  bool isLoading = true; // Added loading state
    final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // Load all notes
  Future<void> loadNotes() async {
    final fetchedNotes = await noteDatabase.fetchNotes();
     print("Fetched Notes: ${fetchedNotes.length}");
    setState(() {
      notes = fetchedNotes;
      isLoading = false;
    });
  }

  // Add a new note
  Future<void> addNewNote() async {
  print("Adding a new note..."); 

  final newNote = Note(
    id: 0,
    title: 'New Note',
    content: 'Type here...',
  //  createdAt: DateTime.now(),
  );
  
  await noteDatabase.addNote(newNote);
  print("Note added successfully!"); 
  loadNotes();
}


  // Edit a note
  Future<void> editNote(Note note) async {
    TextEditingController titleController = TextEditingController(text: note.title);
    TextEditingController contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController),
            TextField(controller: contentController, maxLines: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await noteDatabase.updateNote(
                Note(
                  id: note.id,
                  title: titleController.text,
                  content: contentController.text,
                //  createdAt: note.createdAt,
                ),
              );
              loadNotes();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete a note
  Future<void> deleteNote(int id) async {
    await noteDatabase.deleteNote(id);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
  icon: Icon(Icons.refresh),
  onPressed: loadNotes,
),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            //  Navigator.of(context).pushNamed(Routes.loginScreen);
              context.pushNamed(Routes.loginScreen);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  onTap: () => editNote(note),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteNote(note.id),
                  ),
                );
              },
            ),
            
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
