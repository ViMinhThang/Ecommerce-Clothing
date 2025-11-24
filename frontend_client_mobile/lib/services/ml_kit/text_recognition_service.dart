import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'ml_kit_service.dart';

/// Service for text recognition (OCR) from images
/// Extracts text from product labels, SKUs, and packaging
class TextRecognitionService extends MLKitService {
  TextRecognizer? _textRecognizer;
  bool _isProcessing = false;

  @override
  Future<void> initialize() async {
    await super.initialize();

    // Initialize with default script (Latin)
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  @override
  Future<void> dispose() async {
    await _textRecognizer?.close();
    _textRecognizer = null;
    await super.dispose();
  }

  /// Recognize text from file path
  /// Returns recognized text or null if processing/error
  Future<RecognizedText?> recognizeTextFromFile(String imagePath) async {
    if (!isInitialized || _isProcessing || _textRecognizer == null) {
      return null;
    }

    _isProcessing = true;

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer!.processImage(inputImage);

      _isProcessing = false;
      return recognizedText;
    } catch (e) {
      _isProcessing = false;
      debugPrint('Text recognition error: $e');
      return null;
    }
  }

  /// Recognize text from camera image
  /// Returns recognized text or null if processing/error
  Future<RecognizedText?> recognizeTextFromCamera(CameraImage image) async {
    if (!isInitialized || _isProcessing || _textRecognizer == null) {
      return null;
    }

    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return null;
      }

      final recognizedText = await _textRecognizer!.processImage(inputImage);

      _isProcessing = false;
      return recognizedText;
    } catch (e) {
      _isProcessing = false;
      debugPrint('Text recognition error: $e');
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

  /// Extract all text as a single string
  String extractFullText(RecognizedText recognizedText) {
    return recognizedText.text;
  }

  /// Extract text blocks as separate strings
  List<String> extractTextBlocks(RecognizedText recognizedText) {
    return recognizedText.blocks.map((block) => block.text).toList();
  }

  /// Extract potential SKU/model numbers
  /// Filters for alphanumeric patterns that look like product codes
  List<String> extractProductCodes(RecognizedText recognizedText) {
    final productCodePattern = RegExp(r'[A-Z0-9]{3,}[-_]?[A-Z0-9]*');
    final codes = <String>[];

    for (final block in recognizedText.blocks) {
      final matches = productCodePattern.allMatches(block.text);
      for (final match in matches) {
        final code = match.group(0);
        if (code != null && code.length >= 4) {
          codes.add(code);
        }
      }
    }

    return codes;
  }

  /// Extract numbers (for prices, sizes, etc.)
  List<String> extractNumbers(RecognizedText recognizedText) {
    final numberPattern = RegExp(r'\d+\.?\d*');
    final numbers = <String>[];

    for (final block in recognizedText.blocks) {
      final matches = numberPattern.allMatches(block.text);
      for (final match in matches) {
        final number = match.group(0);
        if (number != null) {
          numbers.add(number);
        }
      }
    }

    return numbers;
  }

  /// Check if processing is currently active
  bool get isProcessing => _isProcessing;
}
