import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/models/size.dart' as model;
import 'package:provider/provider.dart';
import '../../../features/admin/size/edit/sections/size_form_section.dart';
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
    return SizeFormSection(
      nameController: _nameController,
      status: _status,
      onStatusChanged: (val) => setState(() => _status = val),
    );
  }
}
