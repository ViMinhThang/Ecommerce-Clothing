
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:frontend_client_mobile/widgets/image_picker_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../providers/category_provider.dart';
import '../../../config/theme_config.dart';

class EditCategoryScreen extends StatefulWidget {
  final model.Category? category;

  const EditCategoryScreen({super.key, this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  String _status = 'active';
  XFile? _selectedImage;
  String? _currentImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descController = TextEditingController(
      text: widget.category?.description ?? '',
    );
    _status = widget.category?.status ?? 'active';
    _currentImageUrl = widget.category?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
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

  Future<void> _onSave() async {
    if (_isSaving) return;
    _isSaving = true;
    setState(() {});

    try {
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );
      String? imageUrlToSave = _currentImageUrl;

      if (_selectedImage != null) {
        // Upload image if a new one is selected
        if (_selectedImage != null) {
          imageUrlToSave = await categoryProvider.uploadCategoryImage(
            _selectedImage!,
          );
        }
      }

      final newCategory = model.Category(
        id: widget.category?.id,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: imageUrlToSave ?? '', // Use uploaded URL or existing
        status: _status,
      );

      if (widget.category == null) {
        await categoryProvider.addCategory(newCategory);
      } else {
        await categoryProvider.updateCategory(newCategory);
      }

      if (!mounted) return;
      Navigator.pop(
        context,
      ); // Pop without returning data, provider handles state
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      } else {
        _isSaving = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;

    return AdminLayout(
      title: isEditing ? 'Edit Category' : 'Add Category',
      selectedIndex: 4,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: AppTheme.primaryWhite,
            borderRadius: AppTheme.borderRadiusMD,
            border: AppTheme.borderThin,
            boxShadow: AppTheme.shadowSM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 20,
                    color: AppTheme.primaryBlack,
                  ),
                  const SizedBox(width: AppTheme.spaceXS),
                  Text(
                    'Category Details',
                    style: AppTheme.h4.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Category Name'),
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _descController,
                decoration: _inputDecoration('Description'),
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
                decoration: _inputDecoration('Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlack,
                        foregroundColor: AppTheme.primaryWhite,
                        disabledBackgroundColor: AppTheme.mediumGray,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.borderRadiusSM,
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryWhite,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isEditing ? Icons.save_outlined : Icons.add,
                                  size: 18,
                                ),
                                const SizedBox(width: AppTheme.spaceXS),
                                Text(
                                  isEditing
                                      ? 'Save Changes'
                                      : 'Create Category',
                                  style: AppTheme.button.copyWith(
                                    color: AppTheme.primaryWhite,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceSM),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlack,
                        side: BorderSide(
                          color: _isSaving
                              ? AppTheme.lightGray
                              : AppTheme.mediumGray,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppTheme.borderRadiusSM,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTheme.button.copyWith(
                          color: _isSaving
                              ? AppTheme.lightGray
                              : AppTheme.primaryBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppTheme.spaceMD,
      vertical: 14,
    ),
    filled: true,
    fillColor: AppTheme.primaryWhite,
  );
}
