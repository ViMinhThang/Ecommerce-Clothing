import 'package:flutter/foundation.dart'; // Để dùng kIsWeb

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8080/";
    } else {
      // Đổi IP này thành IP máy tính của bạn nếu chạy trên điện thoại thật
      // Dùng 10.0.2.2 cho Android Emulator
      return "http://10.0.132.154:8080/";
    }
  }
}
