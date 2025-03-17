import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 🔹 اختيار ملفات متعددة
  Future<List<File>?> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'png', 'pdf', 'mp4', 'mp3', 'wav'],
      type: FileType.custom,
      allowMultiple: true, // ✅ دعم الاختيار المتعدد
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files
          .where((file) => file.path != null)
          .map((file) => File(file.path!))
          .toList();
    }
    return null;
  }

  /// 🔹 رفع ملف إلى Supabase
  Future<String?> uploadFile(File file, String title) async {
    try {
      final String fileExtension = file.path.split('.').last;
      final String fileName = "$title-${DateTime.now().millisecondsSinceEpoch}.$fileExtension";
      final String path = "uploads/$fileName";

      await _supabase.storage.from('upload-file').upload(path, file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      return _supabase.storage.from('upload-file').getPublicUrl(path);
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  /// 🔹 حفظ بيانات الملف في قاعدة البيانات
  Future<void> saveFileData(String title, String fileUrl, String fileType) async {
    try {
      await _supabase.from('upload-file').insert({
        'title': title,
        'file_url': fileUrl,
        'file_type': fileType,
      });
    } catch (e) {
      print("Database Error: $e");
    }
  }

  /// 🔹 جلب جميع الملفات من Supabase
/// 🔹 تحديد نوع الملف بناءً على الامتداد
String getFileType(String fileName) {
  if (fileName.endsWith(".jpg") || fileName.endsWith(".png")) {
    return "image";
  } else if (fileName.endsWith(".pdf")) {
    return "pdf";
  } else if (fileName.endsWith(".mp4") || fileName.endsWith(".mov")) {
    return "video";
  } else if (fileName.endsWith(".mp3") || fileName.endsWith(".wav")) {
    return "audio";
  } else {
    return "other";
  }
}

Future<List<Map<String, String>>?> getFiles() async {
  try {
    final List<FileObject> files = await _supabase.storage.from('upload-file').list(path: "uploads/");
    
    if (files.isEmpty) return [];

    return files.map((file) {
      final String fileUrl = _supabase.storage.from('upload-file').getPublicUrl("uploads/${file.name}");
      return {
        'name': file.name,
        'url': fileUrl,
        'type': getFileType(file.name), // استخدم دالة لتحديد النوع
      };
    }).toList();
  } catch (e) {
    print("❌ خطأ أثناء جلب الملفات: $e");
    return null;
  }
}



}
