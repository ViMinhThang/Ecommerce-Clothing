import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Để dùng kIsWeb

class FileUtils {
  /// Hàm chuyển đổi từ XFile (ImagePicker) sang MultipartFile (Dio)
  /// Tự động xử lý logic Web (bytes) và Mobile (path)
  static Future<MultipartFile?> convertXFileToMultipart(XFile? file) async {
    // 1. Nếu file null thì trả về null luôn
    if (file == null) return null;

    // 2. Xử lý cho Web
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      return MultipartFile.fromBytes(
        bytes,
        filename: file.name, // XFile có sẵn tên file
      );
    }
    // 3. Xử lý cho Mobile (Android/iOS)
    else {
      return await MultipartFile.fromFile(file.path, filename: file.name);
    }
  }
  static String fixImgUrl(String url) {
    if (url.isEmpty) return "";
    // Nếu chạy Web và thấy IP của máy ảo -> Đổi thành localhost
    if (kIsWeb && url.contains('10.0.2.2')) {
      return url.replaceAll('10.0.2.2', 'localhost');
    }
    return url;
  }
}
