import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class CategoryFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final String status;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String>? onNameChanged;

  const CategoryFormSection({
    super.key,
    required this.nameController,
    required this.descController,
    required this.status,
    required this.onStatusChanged,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminSectionCard(
          title: 'Category Information',
          children: [
            AdminInputField(
              controller: nameController,
              label: 'Category Name',
              icon: Icons.title_outlined,
              hint: 'e.g. Winter Essentials',
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 24),
            AdminInputField(
              controller: descController,
              label: 'Description',
              icon: Icons.auto_awesome_outlined,
              hint: 'Enter category description...',
              maxLines: 5,
            ),
          ],
        ),
        const SizedBox(height: 24),
        AdminSectionCard(
          title: 'Visibility Settings',
          children: [
            AdminStatusToggle(
              currentStatus: status,
              onChanged: onStatusChanged,
              options: const [
                StatusOption(value: 'active', label: 'Public'),
                StatusOption(value: 'inactive', label: 'Archived'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
