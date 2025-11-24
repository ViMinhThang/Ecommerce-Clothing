import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme_config.dart';
import '../../providers/ml_kit_provider.dart';

class VisualSearchScreen extends StatefulWidget {
  const VisualSearchScreen({super.key});

  @override
  State<VisualSearchScreen> createState() => _VisualSearchScreenState();
}

class _VisualSearchScreenState extends State<VisualSearchScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final provider = context.read<MLKitProvider>();
    await provider.initializeServices();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        final provider = context.read<MLKitProvider>();
        await provider.labelImageFromFile(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlack),
        ),
        title: Text(
          'VISUAL SEARCH',
          style: AppTheme.h4.copyWith(letterSpacing: 1.5, fontSize: 16),
        ),
      ),
      body: Consumer<MLKitProvider>(
        builder: (context, mlKitProvider, child) {
          if (mlKitProvider.isLabelingImage) {
            return _buildLoadingView();
          }

          if (mlKitProvider.detectedLabels.isNotEmpty) {
            return _buildResultsView(mlKitProvider);
          }

          return _buildEmptyView();
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search, size: 120, color: AppTheme.lightGray),
            const SizedBox(height: 32),
            Text(
              'FIND SIMILAR PRODUCTS',
              style: AppTheme.h3.copyWith(letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Upload a photo to discover clothing items\nthat match your style',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.mediumGray),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Camera button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('TAKE PHOTO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlack,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gallery button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('CHOOSE FROM GALLERY'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlack,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(
                    color: AppTheme.primaryBlack,
                    width: 2,
                  ),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlack),
          ),
          const SizedBox(height: 24),
          Text(
            'ANALYZING IMAGE...',
            style: AppTheme.bodyMedium.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(MLKitProvider provider) {
    final fashionLabels = provider.getFashionLabels();
    final allLabels = provider.detectedLabels;

    // Get top labels for display
    final topLabels = allLabels.take(8).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success message
          Row(
            children: [
              Container(width: 4, height: 20, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'IMAGE ANALYZED - ${allLabels.length} LABELS DETECTED',
                  style: AppTheme.h4.copyWith(
                    fontSize: 14,
                    letterSpacing: 1.2,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Fashion labels section
          if (fashionLabels.isNotEmpty) ...[
            Text(
              'FASHION ITEMS DETECTED',
              style: AppTheme.h4.copyWith(
                fontSize: 12,
                letterSpacing: 1.5,
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: fashionLabels.map((label) {
                return _buildLabelChip(label, isPrimary: true);
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],

          // All detected labels
          Text(
            'ALL DETECTED LABELS',
            style: AppTheme.h4.copyWith(
              fontSize: 12,
              letterSpacing: 1.5,
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 12),

          // Labels list
          ...topLabels.map((label) => _buildLabelListItem(label)),

          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    provider.clearResults();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppTheme.primaryBlack),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text('TRY ANOTHER'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to search results with detected labels
                    final keywords = topLabels.map((l) => l.label).toList();
                    Navigator.pop(context, keywords);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: const Text('SEARCH PRODUCTS'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabelChip(label, {bool isPrimary = false}) {
    final confidence = (label.confidence * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isPrimary ? AppTheme.primaryBlack : const Color(0xFFF5F5F5),
        border: Border.all(
          color: isPrimary ? AppTheme.primaryBlack : AppTheme.lightGray,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.label.toUpperCase(),
            style: AppTheme.bodySmall.copyWith(
              color: isPrimary ? Colors.white : AppTheme.primaryBlack,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$confidence%',
            style: AppTheme.caption.copyWith(
              color: isPrimary ? Colors.white70 : AppTheme.mediumGray,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelListItem(label) {
    final confidence = (label.confidence * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border.all(color: AppTheme.lightGray),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.label,
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: _getConfidenceColor(confidence)),
            child: Text(
              '$confidence%',
              style: AppTheme.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return Colors.green.shade700;
    if (confidence >= 60) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
