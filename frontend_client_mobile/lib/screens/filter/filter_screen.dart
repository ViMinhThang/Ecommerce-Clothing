import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class FiltersPage extends StatefulWidget {
  final int categoryId;
  const FiltersPage({super.key, required this.categoryId});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  // Price
  double _minPrice = 0;
  double _maxPrice = 0;

  // Toggles
  bool _onSale = false;

  // Size, Season, Material, Colors
  final _palette = const [
    Color(0xFFF3F788), // pale yellow
    Color(0xFFF2F2F2), // very light gray
    Color(0xFFE0E7FF), // soft blue
    Color(0xFFC27063), // terracotta
    Color(0xFF4D5579), // indigo
  ];

  final Set<String> _selectedSizes = {};
  final Set<String> _selectedSeasons = {};
  final Set<String> _selectedMaterials = {};
  final Set<int> _selectedColorIdx = {};

  @override
  void initState() {
    super.initState();
    // Initial Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FilterProvider>(
        context,
        listen: false,
      ).initialize(widget.categoryId);
    });
  }

  void _reset() {
    setState(() {
      _minPrice = 95;
      _maxPrice = 495;
      _onSale = false;
      _selectedSizes
        ..clear()
        ..addAll({'S', 'M'});
      _selectedSeasons.clear();
      _selectedMaterials
        ..clear()
        ..add('Cotton');
      _selectedColorIdx
        ..clear()
        ..add(0);
    });
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
          'Filters',
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
      body: Consumer<FilterProvider>(
        builder: (context, filterProvider, child) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price
                        const _SectionTitle('Price'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _PillValue(
                              label: 'from',
                              value: filterProvider.minPrice.toInt().toString(),
                            ),
                            const SizedBox(width: 8),
                            _PillValue(
                              label: 'to',
                              value: filterProvider.maxPrice.toInt().toString(),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        RangeSlider(
                          min: filterProvider.minPrice.toDouble(),
                          max: filterProvider.maxPrice.toDouble(),
                          values: RangeValues(_minPrice, _maxPrice),
                          activeColor: Colors.black,
                          inactiveColor: const Color(0xFFE0E0E0),
                          onChanged: (v) {
                            setState(() {
                              _minPrice = v.start.roundToDouble();
                              _maxPrice = v.end.roundToDouble();
                            });
                          },
                        ),
                        const SizedBox(height: 8),

                        // Items on Sale
                        _RowTile(
                          label: 'Items on Sale',
                          trailing: Switch(
                            value: _onSale,
                            activeThumbColor: Colors.white,
                            activeTrackColor: Colors.black,
                            onChanged: (v) => setState(() => _onSale = v),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Size
                        const _SectionTitle('Size'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filterProvider.sizes.map((s) {
                                  final selected = _selectedSizes.contains(s);
                                  return FilterChip(
                                    label: Text(s),
                                    selected: selected,
                                    onSelected: (_) {
                                      setState(() {
                                        selected
                                            ? _selectedSizes.remove(s)
                                            : _selectedSizes.add(s);
                                      });
                                    },
                                    showCheckmark: false,
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    selectedColor: Colors.black,
                                    backgroundColor: const Color(0xFFF2F2F2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                await Navigator.pushNamed(context, "/size");
                              },
                              child: const Text('More...'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Season
                        const _SectionTitle('Season'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filterProvider.seasons.map((s) {
                                  final selected = filterProvider.seasons.contains(s);
                                  return FilterChip(
                                    label: Text(s),
                                    selected: selected,
                                    onSelected: (_) {
                                      setState(() {
                                        selected
                                            ? _selectedSeasons.remove(s)
                                            : _selectedSeasons.add(s);
                                      });
                                    },
                                    showCheckmark: false,
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    selectedColor: Colors.black,
                                    backgroundColor: const Color(0xFFF2F2F2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Color
                        const _SectionTitle('Color'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: List.generate(_palette.length, (i) {
                                  return _ColorDot(
                                    color: _palette[i],
                                    selected: filterProvider.colors.contains(i),
                                    onTap: () {
                                      setState(() {
                                        if (_selectedColorIdx.contains(i)) {
                                          _selectedColorIdx.remove(i);
                                        } else {
                                          _selectedColorIdx.add(i);
                                        }
                                      });
                                    },
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                await Navigator.pushNamed(context, "/color");
                              },
                              child: const Text('More...'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Material
                        const _SectionTitle('Material'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: filterProvider.materials.map((m) {
                                  final selected = filterProvider.materials.contains(
                                    m,
                                  );
                                  return FilterChip(
                                    label: Text(m),
                                    selected: selected,
                                    onSelected: (_) {
                                      setState(() {
                                        selected
                                            ? _selectedMaterials.remove(m)
                                            : _selectedMaterials.add(m);
                                      });
                                    },
                                    showCheckmark: false,
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    selectedColor: Colors.black,
                                    backgroundColor: const Color(0xFFF2F2F2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () async {
                                await Navigator.pushNamed(context, "/material");
                              },
                              child: const Text('More...'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                // Bottom primary action
                SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Show ${filterProvider.count} items',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  final String label;
  final Widget trailing;
  const _RowTile({required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }
}

class _PillValue extends StatelessWidget {
  final String label;
  final String value;
  const _PillValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF9E9E9E))),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? Colors.black : const Color(0xFFE0E0E0);
    final borderWidth = selected ? 2.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
