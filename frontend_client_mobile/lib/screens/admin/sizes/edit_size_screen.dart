import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart' as model;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../config/theme_config.dart';
import '../../../providers/size_provider.dart';
import '../base/base_edit_screen.dart';

class EditSizeScreen extends BaseEditScreen<model.Size> {
  const EditSizeScreen({super.key, super.entity});

  @override
  State<EditSizeScreen> createState() => _EditSizeScreenState();
}

class _EditSizeScreenState
    extends BaseEditScreenState<model.Size, EditSizeScreen> {
  late final TextEditingController _nameController;
  String _status = 'active';

  @override
  String getScreenTitle() => isEditing ? 'Edit Size' : 'Add Size';

  @override
  int getSelectedIndex() => 5;

  @override
  String getEntityName() => 'Size';

  @override
  IconData getSectionIcon() => Icons.straighten_outlined;

  @override
  void initializeForm() {
    _nameController = TextEditingController(
      text: widget.entity?.sizeName ?? '',
    );
    _status = widget.entity?.status ?? 'active';
  }

  @override
  void disposeControllers() {
    _nameController.dispose();
  }

  @override
  bool validateForm() {
    return _nameController.text.trim().isNotEmpty;
  }

  @override
  Future<void> saveEntity() async {
    final sizeProvider = Provider.of<SizeProvider>(context, listen: false);

    final size = model.Size(
      id: widget.entity?.id,
      sizeName: _nameController.text.trim(),
      status: _status,
    );

    if (isEditing) {
      await sizeProvider.updateSize(size);
    } else {
      await sizeProvider.addSize(size);
    }
  }

  @override
  Widget buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusSM,
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            controller: _nameController,
            label: 'Size Name',
            hint: 'e.g. XL, 42, Large',
            icon: Icons.straighten,
          ),
          const SizedBox(height: 24),
          _buildStatusDropdown(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: AppTheme.borderRadiusXS,
              ),
              child: Icon(icon, size: 14, color: Colors.black54),
            ),
            const SizedBox(width: 10),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: AppTheme.borderRadiusXS,
              ),
              child: const Icon(
                Icons.info_outline,
                size: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'OPERATIONAL_STATUS',
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _status,
          items: const [
            DropdownMenuItem(value: 'active', child: Text('ACTIVE')),
            DropdownMenuItem(value: 'inactive', child: Text('INACTIVE')),
          ],
          onChanged: (val) => setState(() => _status = val!),
          icon: const Icon(Icons.unfold_more, color: Colors.black54, size: 20),
          borderRadius: AppTheme.borderRadiusXS,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: _inputDecoration('Select Status'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black26,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.borderRadiusXS,
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
