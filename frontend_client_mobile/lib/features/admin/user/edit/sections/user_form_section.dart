import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/features/admin/shared/widgets/admin_form_components.dart';

class UserFormSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController birthDayController;
  final VoidCallback onBirthdayTap;
  final ValueChanged<String>? onNameChanged;

  const UserFormSection({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.birthDayController,
    required this.onBirthdayTap,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: 'Personal Information',
      children: [
        AdminInputField(
          controller: fullNameController,
          label: 'Full Name',
          icon: Icons.badge_outlined,
          hint: 'Enter full name',
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 24),
        AdminInputField(
          controller: emailController,
          label: 'Email Address',
          icon: Icons.alternate_email_rounded,
          hint: 'user@domain.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        AdminInputField(
          controller: birthDayController,
          label: 'Birthday',
          icon: Icons.cake_outlined,
          hint: 'YYYY-MM-DD',
          readOnly: true,
          onTap: onBirthdayTap,
        ),
      ],
    );
  }
}
