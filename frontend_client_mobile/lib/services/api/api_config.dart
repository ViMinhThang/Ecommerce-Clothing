import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String LOCAL_NETWORK_IP = "10.0.125.15";

  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8080/";
    } else if (Platform.isAndroid) {
      return "http://$LOCAL_NETWORK_IP:8080/";
    } else if (Platform.isIOS) {
      return "http://localhost:8080/";
    } else {
      return "http://localhost:8080/";
    }
  }
}
