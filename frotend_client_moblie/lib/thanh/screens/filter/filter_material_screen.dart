import 'package:flutter/material.dart';

class FilterMaterialLayout extends StatelessWidget {
  const FilterMaterialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialFilterPage();
  }
}

class MaterialFilterPage extends StatefulWidget {
  const MaterialFilterPage({super.key});

  @override
  State<MaterialFilterPage> createState() => _MaterialFilterPageState();
}

class _MaterialFilterPageState extends State<MaterialFilterPage> {
  final List<String> _materials = const [
    'Polyester / synthetic',
    'Viscose',
    'Cotton',
    'Denim',
    'Lyocell',
    'Linen',
    'Modal',
    'Organic cotton',
    'Silk',
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        centerTitle: true,
        title: const Text(
          'Material',
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
                itemCount: _materials.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final checked = _selected.contains(i);
                  return _MaterialRow(
                    label: _materials[i],
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
