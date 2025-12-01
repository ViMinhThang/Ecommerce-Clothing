import 'package:flutter/material.dart';
import '../../../layouts/admin_layout.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/form_action_buttons.dart';

/// Abstract base class for all edit/create screens
///
/// This class provides common structure for form-based screens that handle
/// creating and editing entities (Color, Size, Category, etc.).
///
/// Subclasses must implement abstract methods to provide entity-specific behavior.
abstract class BaseEditScreen<T> extends StatefulWidget {
  final T? entity;

  const BaseEditScreen({super.key, this.entity});
}

abstract class BaseEditScreenState<T, S extends BaseEditScreen<T>>
    extends State<S> {
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    initializeForm();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  // Abstract methods to be implemented by subclasses

  /// Return the screen title (e.g., "Edit Color", "Add Color")
  String getScreenTitle();

  /// Return the selected index for navigation drawer
  int getSelectedIndex();

  /// Return the entity name (e.g., "Color", "Size")
  String getEntityName();

  /// Return the icon for the section header
  IconData getSectionIcon();

  /// Initialize form controllers and state
  void initializeForm();

  /// Dispose form controllers
  void disposeControllers();

  /// Build the form fields
  Widget buildFormFields();

  /// Validate the form
  bool validateForm();

  /// Save the entity (create or update)
  Future<void> saveEntity();

  /// Check if currently in editing mode
  bool get isEditing => widget.entity != null;

  // Template method - defines the structure
  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: getScreenTitle(),
      selectedIndex: getSelectedIndex(),
      body: buildFormBody(),
    );
  }

  Widget buildFormBody() {
    return SingleChildScrollView(
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
            buildSectionHeader(),
            const SizedBox(height: AppTheme.spaceMD),
            buildFormFields(),
            const SizedBox(height: 32),
            buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader() {
    return Row(
      children: [
        Icon(getSectionIcon(), size: 20, color: AppTheme.primaryBlack),
        const SizedBox(width: AppTheme.spaceXS),
        Text(
          '${getEntityName()} Details',
          style: AppTheme.h4.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return FormActionButtons(
      onSave: handleSave,
      onCancel: () => Navigator.pop(context),
      isSaving: isSaving,
      isEditing: isEditing,
      saveLabel: isEditing ? 'Save Changes' : 'Create ${getEntityName()}',
    );
  }

  Future<void> handleSave() async {
    if (isSaving) return;

    if (!validateForm()) {
      showErrorMessage('Please fill in all required fields');
      return;
    }

    setState(() => isSaving = true);

    try {
      await saveEntity();

      if (!mounted) return;

      Navigator.pop(context);
      showSuccessMessage();
    } catch (e) {
      if (mounted) {
        showErrorMessage(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void showSuccessMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved successfully')));
  }

  void showErrorMessage(String error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $error')));
  }
}
