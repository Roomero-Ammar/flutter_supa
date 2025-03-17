import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supa/service_locator/upload_service.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  final UploadService _uploadService = UploadService();
  final TextEditingController _titleController = TextEditingController();

  File? _selectedFile;
  String? _fileType;
  bool _isUploading = false;
  String? _uploadedFileUrl;

  List<String> _imageUrls = []; // 🔹 قائمة لعرض الصور من Supabase

  @override
  void initState() {
    super.initState();
    _fetchImages(); // 🔹 تحميل الصور عند فتح الشاشة
  }

  /// 🔹 تحميل الصور من Supabase
  Future<void> _fetchImages() async {
    final List<String>? images = await _uploadService.getImages();
    if (images != null) {
      setState(() {
        _imageUrls = images;
      });
    }
  }

  /// 🔹 اختيار ملف
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'png', 'pdf', 'mp4', 'mp3', 'wav'],
      type: FileType.custom,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
        _fileType = _getFileType(file.path);
      });
    }
  }

  /// 🔹 رفع الملف
  Future<void> _uploadFile() async {
    if (_selectedFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار ملف وكتابة عنوان")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // ✅ استدعاء دالة `uploadFile` من `UploadService`
    String? fileUrl = await _uploadService.uploadFile(_selectedFile!, _titleController.text);

    if (fileUrl != null) {
      await _uploadService.saveFileData(_titleController.text, fileUrl, _fileType ?? "unknown");

      setState(() {
        _uploadedFileUrl = fileUrl;
        _isUploading = false;
        _selectedFile = null;
        _titleController.clear();
      });

      // 🔹 تحديث قائمة الصور بعد الرفع مباشرةً
      _fetchImages();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم الرفع بنجاح!")),
      );
    } else {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل في الرفع")),
      );
    }
  }

  /// 🔹 تحديد نوع الملف
  String _getFileType(String filePath) {
    if (filePath.endsWith(".jpg") || filePath.endsWith(".png")) {
      return "image";
    } else if (filePath.endsWith(".pdf")) {
      return "pdf";
    } else if (filePath.endsWith(".mp4") || filePath.endsWith(".mov")) {
      return "video";
    } else if (filePath.endsWith(".mp3") || filePath.endsWith(".wav")) {
      return "audio";
    } else {
      return "other";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رفع الملفات")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "أدخل عنوان الملف"),
            ),
            const SizedBox(height: 20),
            _selectedFile != null
                ? Text("ملف مختار: ${_selectedFile!.path.split('/').last}")
                : const Text("لم يتم اختيار أي ملف"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  child: const Text("اختيار ملف"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadFile,
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("رفع الملف"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "📸 الصور المرفوعة:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _imageUrls.isEmpty
                  ? const Text("لا توجد صور مرفوعة")
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          _imageUrls[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
