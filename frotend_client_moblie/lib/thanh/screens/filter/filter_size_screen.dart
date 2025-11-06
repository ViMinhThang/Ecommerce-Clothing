import 'package:flutter/material.dart';

class FilterSizeLayout extends StatelessWidget {
  const FilterSizeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizeFilterPage();
  }
}

class SizeFilterPage extends StatefulWidget {
  const SizeFilterPage({super.key});

  @override
  State<SizeFilterPage> createState() => _SizeFilterPageState();
}

class _SizeFilterPageState extends State<SizeFilterPage> {
  final List<String> _sizes = const [
    '2XL',
    '2XS',
    '3XL',
    '3XL / 4 XL',
    '4XL',
    '5XL',
    'XS',
    'XS / S',
    'S',
    'M',
    'L',
    'XL',
    'XL / 2XL',
  ];

  final Set<int> _selected = {8, 9}; // S, M

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  void _reset() {
    setState(
      () => _selected
        ..clear()
        ..addAll({8, 9}),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        centerTitle: true,
        title: const Text(
          'Size',
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
                itemCount: _sizes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final checked = _selected.contains(i);
                  return _SizeRow(
                    label: _sizes[i],
                    checked: checked,
                    onTap: () => _toggle(i),
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

class _SizeRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _SizeRow({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).dividerColor;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent),
          ),
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
                side: BorderSide(color: borderColor),
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
