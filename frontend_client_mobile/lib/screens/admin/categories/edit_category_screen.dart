import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/category_provider.dart';
import '../../../config/theme_config.dart';
import '../../../utils/form_decorations.dart';
import '../../../utils/image_helper.dart';
import '../base/base_edit_screen.dart';

class EditCategoryScreen extends BaseEditScreen<model.Category> {
  const EditCategoryScreen({super.key, model.Category? entity})
    : super(entity: entity);

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
  String getScreenTitle() => isEditing ? 'Edit Category' : 'Add Category';

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

    // Upload image if a new one is selected
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

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image Layer
        if (hasImage)
          _selectedImage != null
              ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
              : Image.network(
                  ImageHelper.getFullImageUrl(_currentImageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF5F5F5),
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                )
        else
          Container(
            color: const Color(0xFFF5F5F5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'NO IMAGE SELECTED',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Overlay Layer
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Edit Button Layer
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),

        // Label Layer
        const Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            'CATEGORY IMAGE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: FormDecorations.standard('Category Name'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        TextFormField(
          controller: _descController,
          decoration: FormDecorations.standard('Description'),
          style: AppTheme.bodyMedium,
          maxLines: 3,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: FormDecorations.standard('Status'),
          items: const [
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
          ],
          onChanged: (val) => setState(() => _status = val!),
        ),
      ],
    );
  }
}
