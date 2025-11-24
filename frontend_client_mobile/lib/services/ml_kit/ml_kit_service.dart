import 'package:flutter/foundation.dart';

/// Base service class for all ML Kit features
/// Provides common error handling and lifecycle management
abstract class MLKitService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize the ML Kit service
  /// Override this method to perform any setup required
  @mustCallSuper
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('${runtimeType.toString()} already initialized');
      return;
    }
    _isInitialized = true;
    debugPrint('${runtimeType.toString()} initialized successfully');
  }

  /// Dispose and clean up resources
  /// Override this method to perform cleanup
  @mustCallSuper
  Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }
    _isInitialized = false;
    debugPrint('${runtimeType.toString()} disposed');
  }

  /// Handle common ML Kit errors
  String handleError(dynamic error) {
    debugPrint('ML Kit Error in ${runtimeType.toString()}: $error');

    if (error.toString().contains('permission')) {
      return 'Camera permission is required. Please enable it in settings.';
    } else if (error.toString().contains('not available')) {
      return 'This feature is not available on your device.';
    } else if (error.toString().contains('model')) {
      return 'ML model loading failed. Please check your internet connection.';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
