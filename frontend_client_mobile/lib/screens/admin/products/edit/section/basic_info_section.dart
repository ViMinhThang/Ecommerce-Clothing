import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/edit_product_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../../config/theme_config.dart';
import '../../../../../services/ml_kit/text_recognition_service.dart';

class BasicInfoSection extends StatefulWidget {
  const BasicInfoSection({super.key});

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  final TextRecognitionService _textRecognitionService =
      TextRecognitionService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _textRecognitionService.initialize();
  }

  @override
  void dispose() {
    _textRecognitionService.dispose();
    super.dispose();
  }

  Future<void> _scanProductLabel() async {
    setState(() => _isScanning = true);

    try {
      // Pick image from camera or gallery
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image == null) {
        setState(() => _isScanning = false);
        return;
      }

      // Recognize text from image
      final recognizedText = await _textRecognitionService
          .recognizeTextFromFile(image.path);

      if (recognizedText != null && mounted) {
        final viewModel = context.read<EditProductViewModel>();

        // Extract text blocks
        final textBlocks = _textRecognitionService.extractTextBlocks(
          recognizedText,
        );

        // Auto-fill fields based on extracted text
        if (textBlocks.isNotEmpty) {
          // Use first block as product name if name field is empty
          if (viewModel.nameController.text.isEmpty && textBlocks.isNotEmpty) {
            viewModel.nameController.text = textBlocks.first;
          }

          // Use remaining blocks as description
          if (textBlocks.length > 1) {
            final description = textBlocks.skip(1).join('\n');
            if (viewModel.descriptionController.text.isEmpty) {
              viewModel.descriptionController.text = description;
            }
          }

          // Show success message with preview
          if (mounted) {
            _showScanResultDialog(textBlocks);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No text detected. Please try again with a clearer image.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning label: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isScanning = false);
    }
  }

  void _showScanResultDialog(List<String> textBlocks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              'Text Scanned Successfully',
              style: AppTheme.h4.copyWith(fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detected ${textBlocks.length} text block(s):',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.mediumGray),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                border: Border.all(color: AppTheme.lightGray),
              ),
              child: Text(
                textBlocks.take(3).join('\n'),
                style: AppTheme.bodySmall,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditProductViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        border: AppTheme.borderThin,
        borderRadius: AppTheme.borderRadiusMD,
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: AppTheme.primaryBlack),
              const SizedBox(width: AppTheme.spaceXS),
              Text(
                'Basic Information',
                style: AppTheme.h4.copyWith(fontSize: 16),
              ),
              const Spacer(),
              // ML Kit OCR Button
              OutlinedButton.icon(
                onPressed: _isScanning ? null : _scanProductLabel,
                icon: _isScanning
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.document_scanner, size: 16),
                label: Text(
                  _isScanning ? 'SCANNING...' : 'SCAN LABEL',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlack,
                  side: BorderSide(
                    color: _isScanning
                        ? AppTheme.lightGray
                        : AppTheme.primaryBlack,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          // Info text about OCR feature
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 14,
                  color: Colors.blue.shade900,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Tip: Use "Scan Label" to auto-fill fields from product packaging',
                    style: AppTheme.caption.copyWith(
                      color: Colors.blue.shade900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          TextFormField(
            controller: viewModel.nameController,
            decoration: _inputDecoration('Product Name'),
            style: AppTheme.bodyMedium,
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Please enter a name' : null,
          ),
          const SizedBox(height: AppTheme.spaceMD),
          TextFormField(
            controller: viewModel.descriptionController,
            decoration: _inputDecoration('Description'),
            style: AppTheme.bodyMedium,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: AppTheme.bodyMedium.copyWith(
      color: AppTheme.mediumGray,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(
        color: Color(0xFFB0B0B0), // Visible mid-gray
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: AppTheme.mediumGray, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusSM,
      borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spaceMD,
      vertical: 14,
    ),
    filled: true,
    fillColor: AppTheme.primaryWhite,
  );
}
