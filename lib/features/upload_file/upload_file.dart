import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_supa/service_locator/upload_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  final UploadService _uploadService = UploadService();
  final TextEditingController _titleController = TextEditingController();

  List<File> _selectedFiles = [];
  bool _isUploading = false;
  List<Map<String, String>> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  /// 🔹 تحميل جميع الملفات من Supabase
Future<void> _fetchFiles() async {
  final List<Map<String, String>>? files = await _uploadService.getFiles();
  if (files != null) {
    setState(() {
      _uploadedFiles = files;
    });

    // 📌 عرض الملفات في BottomSheet عند جلبها
    _showFilesBottomSheet();
  }
}
void _showFilesBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const Text(
              "📂 الملفات المرفوعة",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Expanded(
              child: _uploadedFiles.isEmpty
                  ? const Center(child: Text("لا توجد ملفات مرفوعة"))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _uploadedFiles.length,
                      itemBuilder: (context, index) {
                        final file = _uploadedFiles[index];
                        final fileType = file['type'] ?? "unknown";

                        return GestureDetector(
                          onTap: () => _openFile(file['url'] ?? ""),
                          child: Column(
                            children: [
                              if (fileType == "image")
                                Expanded(
                                  child: Image.network(
                                    file['url'] ?? "",
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, color: Colors.red);
                                    },
                                  ),
                                )
                              else
                                Icon(Icons.file_present, size: 50, color: Colors.blue),
                              const SizedBox(height: 5),
                              Text(
                                file['name'] ?? "غير معروف",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
        
          ],
        ),
      );
    },
  );
}



  /// 🔹 اختيار ملفات متعددة
  Future<void> _pickFiles() async {
    final files = await _uploadService.pickFiles();
    if (files != null) {
      setState(() {
        _selectedFiles = files;
      });
    }
  }

  /// 🔹 رفع الملفات المختارة
  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار ملفات وكتابة عنوان")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    for (File file in _selectedFiles) {
      String? fileUrl = await _uploadService.uploadFile(file, _titleController.text);
      if (fileUrl != null) {
        await _uploadService.saveFileData(_titleController.text, fileUrl, _getFileType(file.path));
      }
    }

    setState(() {
      _isUploading = false;
      _selectedFiles.clear();
      _titleController.clear();
    });

    _fetchFiles();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم رفع الملفات بنجاح!")),
    );
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

  /// 🔹 فتح الملف عند الضغط عليه
  Future<void> _openFile(String url) async {
    final Uri fileUri = Uri.parse(url);
    if (await canLaunchUrl(fileUri)) {
      await launchUrl(fileUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تعذر فتح الملف")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رفع وتصفح الملفات")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "أدخل عنوان الملفات"),
            ),
            const SizedBox(height: 20),
            _selectedFiles.isNotEmpty
                ? Column(
                    children: _selectedFiles
                        .map((file) => Text("📄 ${file.path.split('/').last}"))
                        .toList(),
                  )
                : const Text("لم يتم اختيار أي ملف"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickFiles,
                  child: const Text("اختيار ملفات"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadFiles,
                  child: _isUploading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Text("رفع الملفات"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchFiles,
              icon: const Icon(Icons.folder),
              label: const Text("تصفح الملفات"),
            ),
            const Divider(),
            const Text("📂 الملفات المرفوعة:", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
          child: _uploadedFiles.isEmpty
              ? const Text("لا توجد ملفات مرفوعة")
              : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _uploadedFiles.length,
          itemBuilder: (context, index) {
            final file = _uploadedFiles[index];
            final fileType = file['type'] ?? "unknown";
        
         if (fileType == "image") {
  return GestureDetector(
    onTap: () => _openFile(file['url'] ?? ""),
    child: Image.network(
      file['url'] ?? "",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, color: Colors.red);
      },
    ),
  );
}
else {
              return ListTile(
                leading: _getFileIcon(fileType),
                title: Text(file['name'] ?? "غير معروف"),
                onTap: () => _openFile(file['url'] ?? ""),
              );
            }
          },
        ),
        ),
        
        
          ],
        ),
      ),
    );
  }

  Widget _getFileIcon(String fileType) {
    return Icon(Icons.insert_drive_file, color: Colors.blue);
  }
}
