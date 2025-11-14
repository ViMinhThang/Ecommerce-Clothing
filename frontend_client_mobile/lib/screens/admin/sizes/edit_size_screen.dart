import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart' as model;
import 'package:frontend_client_mobile/widgets/status_dropdown.dart';
import 'package:frontend_client_mobile/widgets/text_field_input.dart';
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../providers/size_provider.dart';

class EditSizeScreen extends StatefulWidget {
  final model.Size? size;

  const EditSizeScreen({super.key, this.size});

  @override
  State<EditSizeScreen> createState() => _EditSizeScreenState();
}

class _EditSizeScreenState extends State<EditSizeScreen> {
  late final TextEditingController _nameController;
  String _status = 'active';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.size?.sizeName ?? '');
    _status = widget.size?.status ?? 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    // 🔒 Dùng lock thủ công để chặn double tap trong cùng frame
    if (_isSaving) return;
    _isSaving = true; // gán trực tiếp, chưa cần setState
    setState(() {}); // render lại nút disable

    try {
      final sizeProvider = Provider.of<SizeProvider>(context, listen: false);

      final newSize = model.Size(
        id: widget.size?.id,
        sizeName: _nameController.text.trim(),
        status: _status,
      );

      if (widget.size == null) {
        await sizeProvider.addSize(newSize);
      } else {
        await sizeProvider.updateSize(newSize);
      }

      if (!mounted) return;
      Navigator.pop(context, newSize);
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
    print('🟢 onSave triggered at ${DateTime.now()} _isSaving=$_isSaving');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.size != null;

    return AdminLayout(
      title: isEditing ? 'Edit Size' : 'Add Size',
      selectedIndex: 5,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFieldInput(label: 'Size name', controller: _nameController),
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
