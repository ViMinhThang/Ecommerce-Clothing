
import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/category.dart' as model;
import 'package:frontend_client_mobile/widgets/image_picker_field.dart';
import 'package:frontend_client_mobile/widgets/status_dropdown.dart';
import 'package:frontend_client_mobile/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../providers/category_provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFieldInput(label: 'Category name', controller: _nameController),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ImagePickerField(
              currentImage: _currentImageUrl,
              selectedImage: _selectedImage,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 16),
            StatusDropdown(
              value: _status,
              onChanged: (val) => setState(() => _status = val),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Save changes',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
