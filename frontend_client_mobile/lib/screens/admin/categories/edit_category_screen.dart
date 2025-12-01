import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:frontend_client_mobile/widgets/image_picker_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/category_provider.dart';
import '../../../config/theme_config.dart';
import '../../../utils/form_decorations.dart';
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
        ImagePickerField(
          currentImage: _currentImageUrl,
          selectedImage: _selectedImage,
          onPickImage: _pickImage,
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
