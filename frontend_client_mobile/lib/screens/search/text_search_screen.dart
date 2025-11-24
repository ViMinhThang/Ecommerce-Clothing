import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme_config.dart';
import '../../providers/ml_kit_provider.dart';

class TextSearchScreen extends StatefulWidget {
  const TextSearchScreen({super.key});

  @override
  State<TextSearchScreen> createState() => _TextSearchScreenState();
}

class _TextSearchScreenState extends State<TextSearchScreen> {
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
        await provider.recognizeTextFromFile(image.path);
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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
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
          'TEXT RECOGNITION',
          style: AppTheme.h4.copyWith(letterSpacing: 1.5, fontSize: 16),
        ),
      ),
      body: Consumer<MLKitProvider>(
        builder: (context, mlKitProvider, child) {
          if (mlKitProvider.isRecognizingText) {
            return _buildLoadingView();
          }

          if (mlKitProvider.recognizedText != null) {
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
            Icon(Icons.text_fields, size: 120, color: AppTheme.lightGray),
            const SizedBox(height: 32),
            Text(
              'SCAN TEXT',
              style: AppTheme.h3.copyWith(letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Extract text from product labels, tags,\nor packaging to search items',
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
            'RECOGNIZING TEXT...',
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
    final recognizedText = provider.recognizedText!;
    final fullText = recognizedText.text;
    final textBlocks = recognizedText.blocks;

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
                  'TEXT RECOGNIZED - ${textBlocks.length} BLOCKS FOUND',
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

          // Full text section
          Text(
            'FULL TEXT',
            style: AppTheme.h4.copyWith(
              fontSize: 12,
              letterSpacing: 1.5,
              color: AppTheme.mediumGray,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              border: Border.all(color: AppTheme.lightGray),
            ),
            child: Stack(
              children: [
                SelectableText(
                  fullText.isNotEmpty ? fullText : 'No text detected',
                  style: AppTheme.bodyMedium.copyWith(height: 1.6),
                ),
                if (fullText.isNotEmpty)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () => _copyToClipboard(fullText),
                      tooltip: 'Copy all text',
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Text blocks section
          if (textBlocks.isNotEmpty) ...[
            Text(
              'TEXT BLOCKS',
              style: AppTheme.h4.copyWith(
                fontSize: 12,
                letterSpacing: 1.5,
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 12),

            ...textBlocks.asMap().entries.map((entry) {
              final index = entry.key;
              final block = entry.value;
              return _buildTextBlock(index + 1, block.text);
            }),
          ],

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
                  child: const Text('SCAN ANOTHER'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: fullText.isNotEmpty
                      ? () {
                          // Return the recognized text for search
                          Navigator.pop(context, fullText);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(),
                    disabledBackgroundColor: AppTheme.lightGray,
                  ),
                  child: const Text('SEARCH TEXT'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(int index, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: AppTheme.primaryBlack),
                child: Center(
                  child: Text(
                    '$index',
                    style: AppTheme.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    border: Border.all(color: AppTheme.lightGray),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          text,
                          style: AppTheme.bodySmall.copyWith(height: 1.5),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () => _copyToClipboard(text),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Copy',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
