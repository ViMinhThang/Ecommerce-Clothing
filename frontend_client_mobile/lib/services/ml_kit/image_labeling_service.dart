import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'ml_kit_service.dart';

/// Service for image labeling and visual product search
/// Detects objects, clothing items, colors, and patterns in images
class ImageLabelingService extends MLKitService {
  ImageLabeler? _imageLabeler;
  bool _isProcessing = false;

  @override
  Future<void> initialize() async {
    await super.initialize();

    // Initialize with default options (on-device model)
    final options = ImageLabelerOptions(
      confidenceThreshold: 0.5, // Only return labels with >50% confidence
    );

    _imageLabeler = ImageLabeler(options: options);
  }

  @override
  Future<void> dispose() async {
    await _imageLabeler?.close();
    _imageLabeler = null;
    await super.dispose();
  }

  /// Label image from file path
  /// Returns list of detected labels or null if processing
  Future<List<ImageLabel>?> labelImageFromFile(String imagePath) async {
    if (!isInitialized || _isProcessing || _imageLabeler == null) {
      return null;
    }

    _isProcessing = true;

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final labels = await _imageLabeler!.processImage(inputImage);

      _isProcessing = false;
      return labels;
    } catch (e) {
      _isProcessing = false;
      debugPrint('Image labeling error: $e');
      return null;
    }
  }

  /// Label image from camera
  /// Returns list of detected labels or null if processing
  Future<List<ImageLabel>?> labelImageFromCamera(CameraImage image) async {
    if (!isInitialized || _isProcessing || _imageLabeler == null) {
      return null;
    }

    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return null;
      }

      final labels = await _imageLabeler!.processImage(inputImage);

      _isProcessing = false;
      return labels;
    } catch (e) {
      _isProcessing = false;
      debugPrint('Image labeling error: $e');
      return null;
    }
  }

  /// Convert CameraImage to InputImage for ML Kit
  InputImage? _convertCameraImage(CameraImage image) {
    try {
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      final plane = image.planes.first;

      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      debugPrint('Error converting camera image: $e');
      return null;
    }
  }

  /// Filter labels relevant to clothing/fashion
  List<ImageLabel> filterFashionLabels(List<ImageLabel> labels) {
    final fashionKeywords = [
      'clothing',
      'shirt',
      'pants',
      'dress',
      'shoe',
      'jacket',
      'coat',
      'sweater',
      'skirt',
      'jeans',
      'shorts',
      'boots',
      'sneakers',
      'fashion',
      'apparel',
      'footwear',
      'accessories',
      'hat',
      'cap',
      'bag',
      'belt',
      'watch',
      'jewelry',
      'sunglasses',
      'scarf',
      'tie',
      'socks',
      'gloves',
      'sleeve',
      'collar',
      'button',
      'zipper',
      'pocket',
      'hood',
      'denim',
      'leather',
      'cotton',
      'pattern',
      'stripe',
      'plaid',
      'floral',
      'print',
    ];

    return labels.where((label) {
      final text = label.label.toLowerCase();
      return fashionKeywords.any((keyword) => text.contains(keyword));
    }).toList();
  }

  /// Get color-related labels
  List<ImageLabel> getColorLabels(List<ImageLabel> labels) {
    final colors = [
      'red',
      'blue',
      'green',
      'yellow',
      'black',
      'white',
      'gray',
      'purple',
      'pink',
      'orange',
      'brown',
      'beige',
      'navy',
      'maroon',
      'teal',
      'olive',
      'cyan',
      'magenta',
      'silver',
      'gold',
    ];

    return labels.where((label) {
      final text = label.label.toLowerCase();
      return colors.any((color) => text.contains(color));
    }).toList();
  }

  /// Convert labels to search keywords for product matching
  List<String> labelsToSearchKeywords(List<ImageLabel> labels) {
    return labels
        .where(
          (label) => label.confidence > 0.6,
        ) // Higher confidence for search
        .map((label) => label.label.toLowerCase())
        .toList();
  }
}
