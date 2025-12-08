import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class FilterMaterialLayout extends StatelessWidget {
  const FilterMaterialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialFilterPage();
  }
}

class MaterialFilterPage extends StatelessWidget {
  const MaterialFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, provider, _) {
        final materials = provider.materials;
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 56,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left_rounded, color: Colors.black),
            ),
            centerTitle: true,
            title: const Text(
              'Material',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: provider.resetMaterialsSelection,
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: materials.isEmpty
                      ? const _EmptyPlaceholder(
                          message: 'Chưa có chất liệu nào',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: materials.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final label = materials[i];
                            final checked = provider.selectedMaterials.contains(
                              label,
                            );
                            return _MaterialRow(
                              label: label,
                              checked: checked,
                              onTap: () => provider.toggleMaterial(label),
                            );
                          },
                        ),
                ),
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4A4A4A),
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            backgroundColor: const Color(0xFFF2F2F2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('More filters'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            provider.isCounting
                                ? 'Loading...'
                                : 'Show ${provider.matchedCount} items',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MaterialRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _MaterialRow({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Checkbox(
                value: checked,
                onChanged: (_) => onTap(),
                side: BorderSide(color: Theme.of(context).dividerColor),
                activeColor: Colors.black,
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  final String message;
  const _EmptyPlaceholder({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }
}
