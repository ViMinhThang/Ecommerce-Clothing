import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/category_provider.dart';
import '../../../config/theme_config.dart';
import '../../../utils/image_helper.dart';
import '../../../features/admin/category/edit/sections/category_form_section.dart';
import '../base/base_edit_screen.dart';

class EditCategoryScreen extends BaseEditScreen<model.Category> {
  const EditCategoryScreen({super.key, super.entity});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState
    extends BaseEditScreenState<model.Category, EditCategoryScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  String _status = 'active';
  XFile? _selectedImage;
  String? _currentImageUrl;

  @override
  String getScreenTitle() => isEditing ? 'Edit Category' : 'New Category';

  @override
  int getSelectedIndex() => 4;

  @override
  String getEntityName() => 'Category';

  @override
  IconData getSectionIcon() => Icons.category_outlined;

  @override
  void initializeForm() {
    _nameController = TextEditingController(text: widget.entity?.name ?? '');
    _descController = TextEditingController(
      text: widget.entity?.description ?? '',
    );
    _status = widget.entity?.status ?? 'active';
    _currentImageUrl = widget.entity?.imageUrl;
  }

  @override
  void disposeControllers() {
    _nameController.dispose();
    _descController.dispose();
  }

  @override
  bool validateForm() {
    return _nameController.text.trim().isNotEmpty &&
        _descController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    String? imageUrlToSave = _currentImageUrl;

    if (_selectedImage != null) {
      imageUrlToSave = await categoryProvider.uploadCategoryImage(
        _selectedImage!,
      );
    }

    final category = model.Category(
      id: widget.entity?.id,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      imageUrl: imageUrlToSave ?? '',
      status: _status,
    );

    if (isEditing) {
      await categoryProvider.updateCategory(category);
    } else {
      await categoryProvider.addCategory(category);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  @override
  Widget? buildHeaderImage() {
    final hasImage =
        _selectedImage != null ||
        (_currentImageUrl != null && _currentImageUrl!.isNotEmpty);

    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (hasImage)
            Opacity(
              opacity: 0.4,
              child: _selectedImage != null
                  ? Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.network(
                      ImageHelper.getFullImageUrl(_currentImageUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const _ErrorPlaceholder(),
                    ),
            ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: _TechnicalPatternPainter()),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Editor',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing ? 'Edit Details' : 'Create New',
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -20,
            right: 24,
            child: _CollectionPreview(
              name: _nameController.text,
              imagePath: _selectedImage?.path,
              imageUrl: _currentImageUrl,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: AppTheme.borderRadiusXS,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.camera_enhance_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        const SizedBox(height: 48),
        CategoryFormSection(
          nameController: _nameController,
          descController: _descController,
          status: _status,
          onStatusChanged: (val) => setState(() => _status = val),
          onNameChanged: (v) => setState(() {}),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _TechnicalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    paint.color = Colors.white.withOpacity(0.1);
    for (var i = -size.height; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      40,
      paint..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CollectionPreview extends StatelessWidget {
  final String name;
  final String? imagePath;
  final String? imageUrl;

  const _CollectionPreview({required this.name, this.imagePath, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusMD),
          topRight: Radius.circular(AppTheme.radiusMD),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: AppTheme.borderRadiusSM,
              child: _buildImage(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name.isEmpty ? 'Untitled' : name.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              height: 1.2,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Preview',
            style: GoogleFonts.outfit(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: Colors.black26,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath != null) {
      return Image.file(File(imagePath!), fit: BoxFit.cover);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        ImageHelper.getFullImageUrl(imageUrl),
        fit: BoxFit.cover,
      );
    }
    return Container(color: Colors.grey[100]);
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }
}
