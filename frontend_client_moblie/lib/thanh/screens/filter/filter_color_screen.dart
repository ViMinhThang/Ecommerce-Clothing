import 'package:flutter/material.dart';

class FilterColorLayout extends StatelessWidget {
  const FilterColorLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFilterPage();
  }
}

class ColorOption {
  final String name;
  final Color color;
  const ColorOption(this.name, this.color);
}

class ColorFilterPage extends StatefulWidget {
  const ColorFilterPage({super.key});

  @override
  State<ColorFilterPage> createState() => _ColorFilterPageState();
}

class _ColorFilterPageState extends State<ColorFilterPage> {
  final List<ColorOption> _options = const [
    ColorOption('Black', Colors.black),
    ColorOption('Blue', Color(0xFF1E88E5)),
    ColorOption('Green', Color(0xFF2E7D32)),
    ColorOption('Red', Color(0xFFD32F2F)),
    ColorOption('Pink', Color(0xFFF8BBD0)),
    ColorOption('Orange', Color(0xFFFFA000)),
    ColorOption('Beige', Color(0xFFF0E1C6)),
    ColorOption('Grey', Color(0xFFBDBDBD)),
    ColorOption('White', Colors.white),
    ColorOption('Purple', Color(0xFF673AB7)),
  ];

  final Set<int> _selected = {};

  void _toggle(int i) {
    setState(() {
      if (_selected.contains(i)) {
        _selected.remove(i);
      } else {
        _selected.add(i);
      }
    });
  }

  void _reset() {
    setState(_selected.clear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: IconButton(
          // quay về
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        centerTitle: true,
        title: const Text(
          'Color',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _reset,
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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = _options[i];
                  final checked = _selected.contains(i);
                  return _ColorRow(
                    label: item.name,
                    color: item.color,
                    checked: checked,
                    onTap: () => _toggle(i),
                  );
                },
              ),
            ),
            // Bottom actions
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
                      onPressed: () {},
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
                      onPressed: () {},
                      child: const Text(
                        'Show 248 items',
                        style: TextStyle(fontWeight: FontWeight.w700),
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
    final isWhite = color.value == Colors.white.value;

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
                  _ColorDot(
                    color: color,
                    borderColor: isWhite
                        ? const Color(0xFFE0E0E0)
                        : Colors.transparent,
                  ),
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
  final Color borderColor;

  const _ColorDot({required this.color, this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderColor == Colors.transparent ? 0 : 1,
        ),
      ),
    );
  }
}
