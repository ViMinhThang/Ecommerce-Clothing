import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as model;
import 'package:provider/provider.dart';
import '../../../providers/color_provider.dart';
import '../../../config/theme_config.dart';
import '../../../utils/form_decorations.dart';
import '../base/base_edit_screen.dart';

class EditColorScreen extends BaseEditScreen<model.Color> {
  const EditColorScreen({super.key, super.entity});

  @override
  State<EditColorScreen> createState() => _EditColorScreenState();
}

class _EditColorScreenState
    extends BaseEditScreenState<model.Color, EditColorScreen> {
  late final TextEditingController _nameController;
  String _status = 'active';

  @override
  String getScreenTitle() => isEditing ? 'Edit Color' : 'Add Color';

  @override
  int getSelectedIndex() => 6;

  @override
  String getEntityName() => 'Color';

  @override
  IconData getSectionIcon() => Icons.palette_outlined;

  @override
  void initializeForm() {
    _nameController = TextEditingController(
      text: widget.entity?.colorName ?? '',
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
    final colorProvider = Provider.of<ColorProvider>(context, listen: false);

    final color = model.Color(
      id: widget.entity?.id,
      colorName: _nameController.text.trim(),
      status: _status,
    );

    if (isEditing) {
      await colorProvider.updateColor(color);
    } else {
      await colorProvider.addColor(color);
    }
  }

  @override
  Widget buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: FormDecorations.standard('Color Name'),
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: AppTheme.spaceMD),
        DropdownButtonFormField<String>(
          initialValue: _status,
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
