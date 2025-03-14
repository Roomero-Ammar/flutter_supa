import 'package:flutter/material.dart';
import 'package:flutter_supa/auth/auth_service.dart';
import 'package:flutter_supa/core/helpers/extentsions.dart';
import 'package:flutter_supa/core/routing/routes.dart';
import 'package:flutter_supa/core/theming/theme_provider.dart';
import 'package:flutter_supa/models/note.dart';
import 'package:flutter_supa/models/note_database.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteDatabase noteDatabase = NoteDatabase(Supabase.instance.client);
  List<Note> notes = [];
  bool isLoading = true;
  final AuthService _authService = AuthService();

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

  Future<void> showNoteDialog({Note? note}) async {
    TextEditingController titleController = TextEditingController(text: note?.title ?? '');
    TextEditingController contentController = TextEditingController(text: note?.content ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 5),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                if (note == null) {
                  final newNote = Note(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: titleController.text,
                    content: contentController.text,
                  );
                  await noteDatabase.addNote(newNote);
                } else {
                  final updatedNote = Note(
                    id: note.id,
                    title: titleController.text,
                    content: contentController.text,
                  );
                  await noteDatabase.updateNote(updatedNote);
                }
                loadNotes();
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteNote(int id) async {
    await noteDatabase.deleteNote(id);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // ✅ جلب المزود داخل build

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme(themeProvider.themeMode == ThemeMode.light);
            },
          ),
          IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadNotes),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              context.pushNamed(Routes.loginScreen);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  onTap: () => showNoteDialog(note: note),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showNoteDialog(note: note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (note.id != null) {
                            deleteNote(note.id!);
                          } else {
                            print("Error: Cannot delete a note without an ID.");
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
