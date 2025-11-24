import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/ml_kit/barcode_service.dart';
import '../services/ml_kit/image_labeling_service.dart';
import '../services/ml_kit/text_recognition_service.dart';

/// Provider for managing ML Kit processing states and results
class MLKitProvider with ChangeNotifier {
  // Services
  final BarcodeService _barcodeService = BarcodeService();
  final ImageLabelingService _imageLabelingService = ImageLabelingService();
  final TextRecognitionService _textRecognitionService =
      TextRecognitionService();

  // Camera
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _cameraError;

  // Barcode scanning state
  List<Barcode> _detectedBarcodes = [];
  bool _isScanningBarcode = false;

  // Image labeling state
  List<ImageLabel> _detectedLabels = [];
  bool _isLabelingImage = false;

  // Text recognition state
  RecognizedText? _recognizedText;
  bool _isRecognizingText = false;

  // Processing state
  bool _isProcessing = false;
  String? _errorMessage;

  // Getters
  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  String? get cameraError => _cameraError;
  List<Barcode> get detectedBarcodes => _detectedBarcodes;
  bool get isScanningBarcode => _isScanningBarcode;
  List<ImageLabel> get detectedLabels => _detectedLabels;
  bool get isLabelingImage => _isLabelingImage;
  RecognizedText? get recognizedText => _recognizedText;
  bool get isRecognizingText => _isRecognizingText;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  /// Initialize ML Kit services
  Future<void> initializeServices() async {
    try {
      await _barcodeService.initialize();
      await _imageLabelingService.initialize();
      await _textRecognitionService.initialize();
      debugPrint('All ML Kit services initialized successfully');
    } catch (e) {
      _errorMessage = 'Failed to initialize ML Kit services: $e';
      notifyListeners();
    }
  }

  /// Initialize camera
  Future<void> initializeCamera({int cameraIndex = 0}) async {
    try {
      _isCameraInitialized = false;
      _cameraError = null;
      notifyListeners();

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        _cameraError = 'No cameras available';
        notifyListeners();
        return;
      }

      // Initialize camera controller
      _cameraController = CameraController(
        _cameras![cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup:
            ImageFormatGroup.nv21, // Required for ML Kit on Android
      );

      await _cameraController!.initialize();
      _isCameraInitialized = true;
      notifyListeners();
    } catch (e) {
      _cameraError = 'Camera initialization failed: $e';
      _isCameraInitialized = false;
      notifyListeners();
    }
  }

  /// Start barcode scanning from camera stream
  Future<void> startBarcodeScanning() async {
    if (_cameraController == null || !_isCameraInitialized) {
      _errorMessage = 'Camera not initialized';
      notifyListeners();
      return;
    }

    _isScanningBarcode = true;
    _detectedBarcodes = [];
    notifyListeners();

    try {
      await _cameraController!.startImageStream((CameraImage image) async {
        if (_isProcessing || !_isScanningBarcode) return;

        _isProcessing = true;
        final barcodes = await _barcodeService.scanBarcodes(image);
        _isProcessing = false;

        if (barcodes != null && barcodes.isNotEmpty) {
          _detectedBarcodes = barcodes;
          notifyListeners();
        }
      });
    } catch (e) {
      _errorMessage = 'Barcode scanning failed: $e';
      _isScanningBarcode = false;
      notifyListeners();
    }
  }

  /// Stop barcode scanning
  Future<void> stopBarcodeScanning() async {
    _isScanningBarcode = false;
    _isProcessing = false;

    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
    }

    notifyListeners();
  }

  /// Label image from file
  Future<void> labelImageFromFile(String imagePath) async {
    _isLabelingImage = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final labels = await _imageLabelingService.labelImageFromFile(imagePath);

      if (labels != null) {
        _detectedLabels = labels;
      } else {
        _errorMessage = 'Failed to label image';
      }
    } catch (e) {
      _errorMessage = 'Image labeling failed: $e';
    } finally {
      _isLabelingImage = false;
      notifyListeners();
    }
  }

  /// Start image labeling from camera stream
  Future<void> startImageLabeling() async {
    if (_cameraController == null || !_isCameraInitialized) {
      _errorMessage = 'Camera not initialized';
      notifyListeners();
      return;
    }

    _isLabelingImage = true;
    _detectedLabels = [];
    notifyListeners();

    try {
      await _cameraController!.startImageStream((CameraImage image) async {
        if (_isProcessing || !_isLabelingImage) return;

        _isProcessing = true;
        final labels = await _imageLabelingService.labelImageFromCamera(image);
        _isProcessing = false;

        if (labels != null && labels.isNotEmpty) {
          _detectedLabels = labels;
          notifyListeners();
        }
      });
    } catch (e) {
      _errorMessage = 'Image labeling failed: $e';
      _isLabelingImage = false;
      notifyListeners();
    }
  }

  /// Stop image labeling
  Future<void> stopImageLabeling() async {
    _isLabelingImage = false;
    _isProcessing = false;

    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
    }

    notifyListeners();
  }

  /// Recognize text from file
  Future<void> recognizeTextFromFile(String imagePath) async {
    _isRecognizingText = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final text = await _textRecognitionService.recognizeTextFromFile(
        imagePath,
      );

      if (text != null) {
        _recognizedText = text;
      } else {
        _errorMessage = 'Failed to recognize text';
      }
    } catch (e) {
      _errorMessage = 'Text recognition failed: $e';
    } finally {
      _isRecognizingText = false;
      notifyListeners();
    }
  }

  /// Start text recognition from camera stream
  Future<void> startTextRecognition() async {
    if (_cameraController == null || !_isCameraInitialized) {
      _errorMessage = 'Camera not initialized';
      notifyListeners();
      return;
    }

    _isRecognizingText = true;
    _recognizedText = null;
    notifyListeners();

    try {
      await _cameraController!.startImageStream((CameraImage image) async {
        if (_isProcessing || !_isRecognizingText) return;

        _isProcessing = true;
        final text = await _textRecognitionService.recognizeTextFromCamera(
          image,
        );
        _isProcessing = false;

        if (text != null && text.text.isNotEmpty) {
          _recognizedText = text;
          notifyListeners();
        }
      });
    } catch (e) {
      _errorMessage = 'Text recognition failed: $e';
      _isRecognizingText = false;
      notifyListeners();
    }
  }

  /// Stop text recognition
  Future<void> stopTextRecognition() async {
    _isRecognizingText = false;
    _isProcessing = false;

    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      await _cameraController!.stopImageStream();
    }

    notifyListeners();
  }

  /// Get fashion-related labels only
  List<ImageLabel> getFashionLabels() {
    return _imageLabelingService.filterFashionLabels(_detectedLabels);
  }

  /// Clear all results
  void clearResults() {
    _detectedBarcodes = [];
    _detectedLabels = [];
    _recognizedText = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeService.dispose();
    _imageLabelingService.dispose();
    _textRecognitionService.dispose();
    super.dispose();
  }
}
