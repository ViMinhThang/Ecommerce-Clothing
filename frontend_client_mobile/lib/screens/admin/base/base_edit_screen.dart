import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';
import '../../../widgets/shared/form_action_buttons.dart';

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

  String getScreenTitle();

  int getSelectedIndex();

  String getEntityName();

  IconData getSectionIcon();

  void initializeForm();

  void disposeControllers();

  Widget buildFormFields();

  bool validateForm();

  Future<void> saveEntity();

  bool get isEditing => widget.entity != null;

  Widget? buildHeaderImage() => null;

  @override
  Widget build(BuildContext context) {
    final headerImage = buildHeaderImage();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: headerImage != null ? 250.0 : 0.0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppTheme.primaryBlack),
            title: headerImage == null
                ? Text(
                    getScreenTitle(),
                    style: AppTheme.h3.copyWith(color: AppTheme.primaryBlack),
                  )
                : null,
            flexibleSpace: headerImage != null
                ? FlexibleSpaceBar(background: headerImage)
                : null,
          ),
          SliverToBoxAdapter(child: buildFormBody()),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMD),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(child: buildActionButtons()),
      ),
    );
  }

  Widget buildFormBody() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (buildHeaderImage() != null) ...[
            buildSectionHeader(),
            const SizedBox(height: AppTheme.spaceMD),
          ],
          buildFormFields(),
          const SizedBox(height: 80),
        ],
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
