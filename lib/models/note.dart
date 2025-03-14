class Note {
  final int? id; // ✅ id يمكن أن يكون null عند الإنشاء
  final String title;
  final String content;

  Note({
    this.id, // ✅ جعله اختياريًا
    required this.title,
    required this.content,
  });

  // ✅ تحويل Note إلى Map لإرساله إلى Supabase
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ✅ لا نرسل id إذا كان null
      'title': title,
      'content': content,
    };
  }

  // ✅ إنشاء Note من Map عند جلب البيانات من Supabase
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'], // ✅ Supabase سيملأ هذا تلقائيًا
      title: map['title'],
      content: map['content'],
    );
  }
}
