import 'package:flutter/foundation.dart'; // Để dùng kIsWeb

class ApiConfig {
  // 1. Hàm thông minh tự chọn URL
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8080/"; // Cho Flutter Web
    } else {
      // Logic cho Mobile
      // Nếu chạy máy ảo Android thì dùng 10.0.2.2
      return "http://10.0.2.2:8080/";
    }
  }
}
