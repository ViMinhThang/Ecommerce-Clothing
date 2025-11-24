import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import '../../config/theme_config.dart';
import '../../providers/ml_kit_provider.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    final provider = context.read<MLKitProvider>();
    await provider.initializeServices();
    await provider.initializeCamera();
    if (mounted) {
      await provider.startBarcodeScanning();
    }
  }

  @override
  void dispose() {
    final provider = context.read<MLKitProvider>();
    provider.stopBarcodeScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<MLKitProvider>(
        builder: (context, mlKitProvider, child) {
          if (mlKitProvider.cameraError != null) {
            return _buildErrorView(mlKitProvider.cameraError!);
          }

          if (!mlKitProvider.isCameraInitialized ||
              mlKitProvider.cameraController == null) {
            return _buildLoadingView();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview
              CameraPreview(mlKitProvider.cameraController!),

              // Scanning overlay
              _buildScanningOverlay(),

              // Top app bar
              _buildTopBar(),

              // Bottom result panel
              if (mlKitProvider.detectedBarcodes.isNotEmpty)
                _buildResultPanel(mlKitProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            'INITIALIZING CAMERA...',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'CAMERA ERROR',
              style: AppTheme.h3.copyWith(
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('GO BACK'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'SCAN BARCODE',
                style: AppTheme.h4.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return CustomPaint(
      painter: _ScanningOverlayPainter(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 250, height: 250),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Point camera at barcode or QR code',
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPanel(MLKitProvider provider) {
    final barcode = provider.detectedBarcodes.first;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0), // Sharp corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(width: 4, height: 20, color: AppTheme.primaryBlack),
                  const SizedBox(width: 12),
                  Text(
                    'BARCODE DETECTED',
                    style: AppTheme.h4.copyWith(
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barcode type
              Text(
                'Type: ${_getBarcodeTypeName(barcode.format)}',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Barcode value
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  border: Border.all(color: AppTheme.lightGray),
                ),
                child: SelectableText(
                  barcode.displayValue ?? barcode.rawValue ?? 'No data',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Search product by barcode
                    Navigator.pop(
                      context,
                      barcode.displayValue ?? barcode.rawValue,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(
                    'SEARCH PRODUCT',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getBarcodeTypeName(BarcodeFormat format) {
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
      default:
        return 'Barcode';
    }
  }
}

/// Custom painter for scanning overlay with corner brackets
class _ScanningOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanAreaSize = 250.0;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2;
    final right = left + scanAreaSize;
    final bottom = top + scanAreaSize;

    // Draw semi-transparent overlay except scan area
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTRB(left, top, right, bottom))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw corner brackets
    final bracketPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final bracketLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top),
      Offset(left + bracketLength, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + bracketLength),
      bracketPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(right, top),
      Offset(right - bracketLength, top),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + bracketLength),
      bracketPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + bracketLength, bottom),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, bottom - bracketLength),
      bracketPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right - bracketLength, bottom),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - bracketLength),
      bracketPaint,
    );

    // Animated scanning line (simplified - in production use AnimationController)
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(left, top + scanAreaSize / 2),
      Offset(right, top + scanAreaSize / 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
