import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class UploadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 🔹 اختيار أي ملف (بما في ذلك الفيديوهات والصوتيات)
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  /// 🔹 رفع الملف إلى Supabase
  Future<String?> uploadFile(File file, String title) async {
    try {
      final String fileExtension = file.path.split('.').last;
      final String fileName = "$title.$fileExtension"; // استخدام الاسم المخصص
      final String path = "uploads/$fileName";

      await _supabase.storage.from('upload-file').upload(path, file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false));

      final String publicUrl = _supabase.storage.from('upload-file').getPublicUrl(path);
      return publicUrl;
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
        'file_type': fileType, // (image, pdf, video, audio)
      });
    } catch (e) {
      print("Database Error: $e");
    }
  }

  /// 🔹 استرجاع الصور فقط من Supabase
  Future<List<String>?> getImages() async {
    try {
      final List<dynamic> response = await _supabase
          .from('upload-file')
          .select('file_url')
          .eq('file_type', 'image');

      if (response.isEmpty) return [];

      List<String> imageUrls = response.map((row) => row['file_url'].toString()).toList();
      return imageUrls;
    } catch (e) {
      print("Fetch Images Error: $e");
      return null;
    }
  }
}
