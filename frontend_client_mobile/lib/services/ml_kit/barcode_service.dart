import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'ml_kit_service.dart';

/// Service for barcode and QR code scanning
/// Supports multiple barcode formats: QR, UPC, EAN, Code-128, etc.
class BarcodeService extends MLKitService {
  BarcodeScanner? _barcodeScanner;
  bool _isProcessing = false;

  @override
  Future<void> initialize() async {
    await super.initialize();

    // Initialize barcode scanner with all supported formats
    _barcodeScanner = BarcodeScanner(
      formats: [
        BarcodeFormat.all, // Support all barcode formats
      ],
    );
  }

  @override
  Future<void> dispose() async {
    await _barcodeScanner?.close();
    _barcodeScanner = null;
    await super.dispose();
  }

  /// Scan barcodes from camera image
  /// Returns list of detected barcodes or null if processing
  Future<List<Barcode>?> scanBarcodes(CameraImage image) async {
    if (!isInitialized || _isProcessing || _barcodeScanner == null) {
      return null;
    }

    _isProcessing = true;

    try {
      // Convert CameraImage to InputImage
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return null;
      }

      // Process the image
      final barcodes = await _barcodeScanner!.processImage(inputImage);

      _isProcessing = false;
      return barcodes;
    } catch (e) {
      _isProcessing = false;
      debugPrint('Barcode scanning error: $e');
      return null;
    }
  }

  /// Convert CameraImage to InputImage for ML Kit
  InputImage? _convertCameraImage(CameraImage image) {
    try {
      // Get image format
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) return null;

      // Get plane data
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

  /// Get human-readable barcode format name
  String getBarcodeFormatName(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
        return 'QR Code';
      case BarcodeFormat.ean13:
        return 'EAN-13';
      case BarcodeFormat.ean8:
        return 'EAN-8';
      case BarcodeFormat.upca:
        return 'UPC-A';
      case BarcodeFormat.upce:
        return 'UPC-E';
      case BarcodeFormat.code128:
        return 'Code-128';
      case BarcodeFormat.code39:
        return 'Code-39';
      case BarcodeFormat.code93:
        return 'Code-93';
      case BarcodeFormat.codabar:
        return 'Codabar';
      case BarcodeFormat.itf:
        return 'ITF';
      case BarcodeFormat.dataMatrix:
        return 'Data Matrix';
      case BarcodeFormat.pdf417:
        return 'PDF417';
      case BarcodeFormat.aztec:
        return 'Aztec';
      default:
        return 'Unknown';
    }
  }
}
