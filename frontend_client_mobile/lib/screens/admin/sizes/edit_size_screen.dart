import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart' as model;
import 'package:provider/provider.dart';
import '../../../layouts/admin_layout.dart';
import '../../../providers/size_provider.dart';
import '../../../config/theme_config.dart';

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
    if (_isSaving) return;
    _isSaving = true;
    setState(() {});

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
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.size != null;

    return AdminLayout(
      title: isEditing ? 'Edit Size' : 'Add Size',
      selectedIndex: 5,
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
                    Icons.straighten_outlined,
                    size: 20,
                    color: AppTheme.primaryBlack,
                  ),
                  const SizedBox(width: AppTheme.spaceXS),
                  Text(
                    'Size Details',
                    style: AppTheme.h4.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMD),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Size Name'),
                style: AppTheme.bodyMedium,
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
                                  isEditing ? 'Save Changes' : 'Create Size',
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
