import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/config/theme_config.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool isMonospace;

  const AdminInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(), const SizedBox(height: 10), _buildTextField()],
    );
  }

  Widget _buildLabel() {
    return Row(
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
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: isMonospace
          ? GoogleFonts.jetBrainsMono(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            )
          : GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
      decoration: adminInputDecoration(hint),
    );
  }
}

InputDecoration adminInputDecoration(String? hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Colors.black26,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusXS,
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusXS,
      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppTheme.borderRadiusXS,
      borderSide: const BorderSide(color: Colors.black, width: 1),
    ),
  );
}

class AdminSectionHeader extends StatelessWidget {
  final String title;

  const AdminSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: Colors.black),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AdminSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class AdminStatusToggle extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String> onChanged;
  final List<StatusOption>? options;

  const AdminStatusToggle({
    super.key,
    required this.currentStatus,
    required this.onChanged,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    final statusOptions =
        options ??
        [
          const StatusOption(value: 'active', label: 'Active'),
          const StatusOption(value: 'inactive', label: 'Inactive'),
        ];

    return Row(
      children: statusOptions.map((option) {
        final isSelected = currentStatus == option.value;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onChanged(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: AppTheme.borderRadiusXS,
                border: Border.all(
                  color: isSelected
                      ? Colors.black
                      : Colors.black.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                option.label,
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class StatusOption {
  final String value;
  final String label;

  const StatusOption({required this.value, required this.label});
}

class AdminDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLength;
  final int maxLines;

  const AdminDescriptionField({
    super.key,
    required this.controller,
    this.label = 'Description',
    this.hint = 'Enter description...',
    this.icon = Icons.notes_outlined,
    this.maxLength = 500,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
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
              label,
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
          maxLines: maxLines,
          maxLength: maxLength,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return Text(
                  '$currentLength / $maxLength',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: currentLength > (maxLength ?? 0) * 0.9
                        ? Colors.orange[700]
                        : Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            height: 1.5,
          ),
          decoration: adminInputDecoration(hint),
        ),
      ],
    );
  }
}

class AdminPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const AdminPasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.hint = '********',
  });

  @override
  Widget build(BuildContext context) {
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
                Icons.lock_outline_rounded,
                size: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
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
          obscureText: true,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: adminInputDecoration(hint),
        ),
      ],
    );
  }
}

/// Role picker dropdown for user management
class RolePicker extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List roles;
  final ValueChanged<String?> onRoleSelected;
  final VoidCallback onRetry;

  const RolePicker({
    super.key,
    required this.isLoading,
    required this.error,
    required this.roles,
    required this.onRoleSelected,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Row(
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading roles...',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black38),
          ),
        ],
      );
    }

    if (error != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              error!,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.redAccent),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      );
    }

    if (roles.isEmpty) {
      return Text(
        'No roles available',
        style: GoogleFonts.outfit(fontSize: 12, color: Colors.black38),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: adminInputDecoration('Choose a role to add'),
      icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.black54),
      items: roles
          .map<DropdownMenuItem<String>>(
            (role) =>
                DropdownMenuItem(value: role.name, child: Text(role.name)),
          )
          .toList(),
      onChanged: onRoleSelected,
    );
  }
}

/// Selected roles list with remove functionality
class SelectedRolesList extends StatelessWidget {
  final List<String> roles;
  final ValueChanged<String> onRemove;

  const SelectedRolesList({
    super.key,
    required this.roles,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return Text(
        'No roles assigned yet',
        style: GoogleFonts.inter(
          color: Colors.black26,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles
          .map((role) => _RoleChip(role: role, onRemove: () => onRemove(role)))
          .toList(),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  final VoidCallback onRemove;

  const _RoleChip({required this.role, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: AppTheme.borderRadiusSM,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            role,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.cancel, size: 16, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
