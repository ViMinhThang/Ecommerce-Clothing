import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../layouts/admin_layout.dart';
import '../../../widgets/text_field_input.dart';
import '../../../widgets/status_dropdown.dart';
import '../../../widgets/image_picker_field.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const EditProductScreen({super.key, this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  String _status = 'Active';
  File? _selectedImage;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.product?['name'] ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?['price']?.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?['stock']?.toString() ?? '',
    );
    _status = widget.product?['status'] ?? 'Active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;
      if (picked != null) {
        setState(() => _selectedImage = File(picked.path));
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi chọn ảnh: $e')));
    }
  }

  void _onSave() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên sản phẩm')),
      );
      return;
    }

    final productData = {
      'id': widget.product?['id'] ?? DateTime.now().millisecondsSinceEpoch,
      'name': _nameController.text.trim(),
      'price': int.tryParse(_priceController.text.trim()) ?? 0,
      'stock': int.tryParse(_stockController.text.trim()) ?? 0,
      'status': _status,
      'image':
          _selectedImage?.path ??
          widget.product?['image'] ??
          'https://via.placeholder.com/100x100.png?text=New+Product',
    };

    Navigator.pop(context, productData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing ? 'Đã lưu thay đổi sản phẩm' : 'Đã tạo sản phẩm mới',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: isEditing ? 'Edit Product' : 'Create Product',
      selectedIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFieldInput(label: 'Product Name', controller: _nameController),
            const SizedBox(height: 16),
            TextFieldInput(
              label: 'Price',
              controller: _priceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFieldInput(
              label: 'Inventory',
              controller: _stockController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            StatusDropdown(
              value: _status,
              onChanged: (val) => setState(() => _status = val),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'Disable', child: Text('Disable')),
              ],
            ),
            const SizedBox(height: 16),
            ImagePickerField(
              currentImage: widget.product?['image'],
              selectedImage: _selectedImage,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Create Product',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black),
                    ),
                    child: const Text(
                      'Cancel',
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
