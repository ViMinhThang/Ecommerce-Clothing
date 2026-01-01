import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/providers/color_provider.dart';
import 'package:frontend_client_mobile/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class FiltersPage extends StatefulWidget {
  final Map<String, dynamic> filterParams;
  const FiltersPage({super.key, required this.filterParams});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  bool _initialized = false;
  late final int _categoryId;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.filterParams['categoryId'] as int;

    // Chỉ init meta filter nếu khác category hiện tại
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final fp = context.read<FilterProvider>();
      final colorProvider = context.read<ColorProvider>();

      if (fp.categoryId != _categoryId) {
        await fp.initialize(_categoryId);
      }
      if (colorProvider.colors.isEmpty && !colorProvider.isLoading) {
        await colorProvider.fetchColors();
      }
      if (mounted) {
        setState(() {
          _initialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left_rounded, color: Colors.black,),
        ),
        centerTitle: true,
        title: const Text(
          'Filters',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          Consumer<FilterProvider>(
            builder: (context, p, _) {
              return TextButton(
                onPressed: p.resetFilters,
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<FilterProvider>(
        builder: (context, filterProvider, child) {
          // Nếu chưa init xong meta filter lần đầu thì show loading
          if ((_initialized == false && filterProvider.isLoading) ||
              filterProvider.categoryId == 0) {
            return const Center(child: CircularProgressIndicator());
          }

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
                              value: filterProvider.selectedMinPrice
                                  .toInt()
                                  .toString(),
                            ),
                            const SizedBox(width: 8),
                            _PillValue(
                              label: 'to',
                              value: filterProvider.selectedMaxPrice
                                  .toInt()
                                  .toString(),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 6),
                        RangeSlider(
                          min: filterProvider.minPrice.toDouble(),
                          max: filterProvider.maxPrice.toDouble(),
                          values: RangeValues(
                            filterProvider.selectedMinPrice.clamp(
                              filterProvider.minPrice.toDouble(),
                              filterProvider.maxPrice.toDouble(),
                            ),
                            filterProvider.selectedMaxPrice.clamp(
                              filterProvider.minPrice.toDouble(),
                              filterProvider.maxPrice.toDouble(),
                            ),
                          ),
                          activeColor: Colors.black,
                          inactiveColor: const Color(0xFFE0E0E0),
                          onChanged: (v) {
                            filterProvider.setSelectedPriceRange(
                              v.start.roundToDouble(),
                              v.end.roundToDouble(),
                            );
                          },
                          onChangeEnd: (value) =>
                              filterProvider.callUpdateMatchedCount(),
                        ),
                        const SizedBox(height: 8),

                        // Items on Sale
                        _RowTile(
                          label: 'Items on Sale',
                          trailing: Switch(
                            value: filterProvider.selectedOnSale,
                            activeThumbColor: Colors.white,
                            activeTrackColor: Colors.black,
                            onChanged: filterProvider.toggleOnSale,
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
                                  final selected = filterProvider.selectedSizes
                                      .contains(s);
                                  return FilterChip(
                                    label: Text(s),
                                    selected: selected,
                                    onSelected: (_) =>
                                        filterProvider.toggleSize(s),
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: filterProvider.seasons.map((season) {
                            final selected = filterProvider.selectedSeasons
                                .contains(season);
                            return FilterChip(
                              label: Text(season),
                              selected: selected,
                              onSelected: (_) =>
                                  filterProvider.toggleSeason(season),
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : Colors.black,
                              ),
                              selectedColor: Colors.black,
                              backgroundColor: const Color(0xFFF2F2F2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Color
                        const _SectionTitle('Color'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _ColorOptions(
                                filterProvider: filterProvider,
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
                                children: filterProvider.materials.map((
                                  material,
                                ) {
                                  final selected = filterProvider
                                      .selectedMaterials
                                      .contains(material);
                                  return FilterChip(
                                    label: Text(material),
                                    selected: selected,
                                    onSelected: (_) =>
                                        filterProvider.toggleMaterial(material),
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
                      onPressed: () {
                        // Không gọi initialize/refresh ở đây.
                        // Chỉ pop về Category Detail.
                        Navigator.pop(context);
                      },
                      child: Text(
                        filterProvider.isCounting
                            ? 'Loading...'
                            : 'Show ${filterProvider.matchedCount} items',
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

class _ColorOptions extends StatelessWidget {
  const _ColorOptions({required this.filterProvider});

  final FilterProvider filterProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        final availableColors = filterProvider.colors;
        if (availableColors.isEmpty) {
          return const Text(
            'No colors available',
            style: TextStyle(color: Color(0xFF9E9E9E)),
          );
        }

        if (colorProvider.colors.isEmpty) {
          return const SizedBox(
            height: 32,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final lookup = {
          for (final color in colorProvider.colors)
            color.colorName.toLowerCase(): color.colorCode,
        };

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(availableColors.length, (index) {
            final colorName = availableColors[index];
            final colorKey = colorName.toLowerCase();
            final hexCode = lookup[colorKey];
            final swatch = _colorFromHex(hexCode);
            final selected = filterProvider.selectedColorIdx.contains(index);

            return Tooltip(
              message: colorName,
              child: _ColorDot(
                color: swatch,
                selected: selected,
                onTap: () => filterProvider.toggleColorIndex(index),
              ),
            );
          }),
        );
      },
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
