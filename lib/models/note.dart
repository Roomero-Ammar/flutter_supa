class Note {
  final int id; // تحويل id إلى int
  final String title;
  final String content;
  final DateTime? createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.createdAt,
  });

  // Convert a Note object to a Map (for Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // id الآن من نوع int
      'title': title,
      'content': content,
      // 'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create a Note object from a Map (from Supabase)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] is String ? int.parse(map['id']) : map['id'], // تحويل id من String إلى int
      title: map['title'],
      content: map['content'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}