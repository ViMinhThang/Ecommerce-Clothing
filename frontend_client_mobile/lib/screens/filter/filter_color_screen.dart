import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart'
    as catalog;
import 'package:frontend_client_mobile/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class FilterColorLayout extends StatelessWidget {
  const FilterColorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColorFilterPage();
  }
}

class ColorFilterPage extends StatelessWidget {
  const ColorFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FilterProvider, catalog.ColorProvider>(
      builder: (context, filterProvider, colorProvider, _) {
        final colors = filterProvider.colors;
        final lookup = {
          for (final color in colorProvider.colors)
            color.colorName.toLowerCase(): color.colorCode,
        };

        return Scaffold(
          appBar: AppBar(
            leadingWidth: 56,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            centerTitle: true,
            title: const Text(
              'Color',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: filterProvider.resetColorsSelection,
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
                  child: colors.isEmpty
                      ? const _EmptyPlaceholder(message: 'Chưa có màu nào')
                      : colorProvider.colors.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: colors.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final label = colors[index];
                            final colorKey = label.toLowerCase();
                            final swatch = _colorFromHex(lookup[colorKey]);
                            final checked = filterProvider.selectedColorIdx
                                .contains(index);
                            return _ColorRow(
                              label: label,
                              color: swatch,
                              checked: checked,
                              onTap: () =>
                                  filterProvider.toggleColorIndex(index),
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
                            filterProvider.isCounting
                                ? 'Loading...'
                                : 'Show ${filterProvider.matchedCount} items',
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

class _ColorRow extends StatelessWidget {
  final String label;
  final Color color;
  final bool checked;
  final VoidCallback onTap;

  const _ColorRow({
    required this.label,
    required this.color,
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
              // Color dot + name
              Row(
                children: [
                  _ColorDot(color: color),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    final isWhite = color.value == Colors.white.value;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isWhite ? const Color(0xFFE0E0E0) : Colors.transparent,
          width: isWhite ? 1 : 0,
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

Color _colorFromHex(String? value) {
  if (value == null || value.isEmpty) {
    return Colors.grey.shade400;
  }

  var hex = value.trim();
  if (hex.startsWith('#')) {
    hex = hex.substring(1);
  }

  if (hex.length == 6) {
    hex = 'FF$hex';
  }

  if (hex.length != 8) {
    return Colors.grey.shade400;
  }

  try {
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return Colors.grey.shade400;
  }
}
