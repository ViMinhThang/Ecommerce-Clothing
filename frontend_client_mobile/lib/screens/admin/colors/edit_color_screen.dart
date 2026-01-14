import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/color.dart' as model;
import 'package:provider/provider.dart';
import '../../../features/admin/color/edit/sections/color_form_section.dart';
import '../../../providers/color_provider.dart';
import '../base/base_edit_screen.dart';

class EditColorScreen extends BaseEditScreen<model.Color> {
  const EditColorScreen({super.key, super.entity});

  @override
  State<EditColorScreen> createState() => _EditColorScreenState();
}

class _EditColorScreenState
    extends BaseEditScreenState<model.Color, EditColorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
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
    _codeController = TextEditingController(
      text: widget.entity?.colorCode ?? '',
    );
    _status = widget.entity?.status ?? 'active';
  }

  @override
  void disposeControllers() {
    _nameController.dispose();
    _codeController.dispose();
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
      colorCode: _codeController.text.trim(),
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
    return ColorFormSection(
      nameController: _nameController,
      codeController: _codeController,
      status: _status,
      onStatusChanged: (val) => setState(() => _status = val),
      onCodeChanged: () => setState(() {}),
    );
  }
}
