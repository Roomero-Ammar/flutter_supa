import 'package:flutter_supa/models/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  final SupabaseClient client;

  NoteDatabase(this.client);

  // Fetch all notes
Future<List<Note>> fetchNotes() async {
final response = await client.from('notes').select();
return response.map((note) => Note.fromMap(note)).toList();
}

  // Add a new note
  Future<void> addNote(Note note) async {
    await client.from('notes').insert(note.toMap());
  }

  // Edit an existing note
 Future<void> updateNote(Note note) async {
  if (note.id == null) {
    print("Error: Cannot update a note without an ID.");
    return;
  }

  await client.from('notes').update(note.toMap()).eq('id', note.id!);
}


  // Delete a note
  Future<void> deleteNote(int id) async { // تغيير id إلى int
    await client.from('notes').delete().eq('id', id);
  }
}