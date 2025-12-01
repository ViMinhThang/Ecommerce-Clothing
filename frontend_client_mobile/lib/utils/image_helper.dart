import 'package:flutter/foundation.dart';
import '../services/api/api_config.dart';

class ImageHelper {
  static String getFullImageUrl(String? url) {
    print('[ImageHelper] Input URL: $url');

    if (url == null || url.isEmpty) {
      print('[ImageHelper] URL is null or empty, returning empty string');
      return '';
    }

    // If it's already a full URL
    if (url.startsWith('http://') || url.startsWith('https://')) {
      print('[ImageHelper] URL is already full: $url');
      // Special handling for Android Emulator:
      // If we are NOT on web, and the URL points to localhost, replace it with 10.0.2.2
      if (!kIsWeb && url.contains('localhost')) {
        final fixedUrl = url.replaceAll('localhost', '10.0.2.2');
        print('[ImageHelper] Fixed localhost to 10.0.2.2: $fixedUrl');
        return fixedUrl;
      }
      return url;
    }

    // It's a relative path, prepend base URL
    final baseUrl = ApiConfig.baseUrl;
    print('[ImageHelper] Base URL: $baseUrl');

    // Clean up slashes
    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final cleanUrl = url.startsWith('/') ? url.substring(1) : url;
    final finalUrl = '$cleanBaseUrl$cleanUrl';

    print('[ImageHelper] Final URL: $finalUrl');
    return finalUrl;
  }
}
