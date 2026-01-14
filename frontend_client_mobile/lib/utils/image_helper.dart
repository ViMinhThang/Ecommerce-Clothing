import 'package:flutter/foundation.dart';
import '../services/api/api_config.dart';

class ImageHelper {
  static String getFullImageUrl(String? url) {
    debugPrint('[ImageHelper] Input URL: $url');

    if (url == null || url.isEmpty) {
      debugPrint('[ImageHelper] URL is null or empty, returning empty string');
      return '';
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      debugPrint('[ImageHelper] URL is already full: $url');
      if (!kIsWeb && url.contains('localhost')) {
        final fixedUrl = url.replaceAll('localhost', '10.0.2.2');
        debugPrint('[ImageHelper] Fixed localhost to 10.0.2.2: $fixedUrl');
        return fixedUrl;
      }
      return url;
    }

    final baseUrl = ApiConfig.baseUrl;
    debugPrint('[ImageHelper] Base URL: $baseUrl');

    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final cleanUrl = url.startsWith('/') ? url.substring(1) : url;
    final finalUrl = '$cleanBaseUrl$cleanUrl';

    debugPrint('[ImageHelper] Final URL: $finalUrl');
    return finalUrl;
  }
}
