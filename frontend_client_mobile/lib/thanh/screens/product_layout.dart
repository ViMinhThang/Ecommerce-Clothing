import 'package:flutter/material.dart';

class ProductLayout extends StatelessWidget {
  const ProductLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 13, color: Color(0xFF4A4A4A)),
        ),
      ),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _images = const [
    'https://images.unsplash.com/photo-1516826957135-700dedea698c?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc?q=80&w=1080&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=1080&auto=format&fit=crop',
  ];

  final _colors = const [
    Color(0xFF4A403A), // nâu
    Color(0xFFDDDDDD), // xám nhạt
    Color(0xFFD4B21D), // vàng
  ];

  final _sizes = const ['XS', 'S', 'M', 'L', 'XL'];

  int _pageIndex = 0;
  int _qty = 1;
  int _selectedColor = 0;
  int _selectedSize = 2; // M

  bool _fav = false;

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        centerTitle: true,
        title: const Text(
          'Product',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _fav = !_fav),
            icon: Icon(
              _fav ? Icons.favorite : Icons.favorite_border,
              color: _fav ? Colors.red : null,
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      // Chỉ làm phần layout chính, không hiện thực bottom navigation bar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh sản phẩm (carousel)
              _ImageCarousel(
                images: _images,
                index: _pageIndex,
                onChanged: (i) => setState(() => _pageIndex = i),
              ),
              const SizedBox(height: 12),

              // Tiêu đề + Giá + Rating
              Text(
                'Claudette corset shirt dress in white',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _Stars(rating: 4.8),
                  const SizedBox(width: 8),
                  Text(
                    '5.0',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '1.299.000đ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '1.059.000đ',
                    style: const TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Màu sắc
              Text('Màu', style: _sectionLabelStyle),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_colors.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i == _colors.length - 1 ? 0 : 12,
                    ),
                    child: _ColorDot(
                      color: _colors[i],
                      selected: _selectedColor == i,
                      onTap: () => setState(() => _selectedColor = i),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Size
              Text('Size', style: _sectionLabelStyle),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(_sizes.length, (i) {
                  final selected = _selectedSize == i;
                  return ChoiceChip(
                    label: Text(_sizes[i]),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedSize = i),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: Colors.black,
                    backgroundColor: const Color(0xFFF2F2F2),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Gợi ý size
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.straighten_rounded, size: 18),
                label: const Text('Gợi ý size'),
              ),
              const SizedBox(height: 4),

              // Số lượng + Thêm vào giỏ
              Row(
                children: [
                  _QtyStepper(
                    value: _qty,
                    onChanged: (v) => setState(() => _qty = v),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: const Text('Thêm vào giỏ'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),

              // Mô tả
              _SectionTile(
                title: 'Description',
                child: Text(
                  'A shirtdress, a perennial investment that reinvents itself every season.\n'
                  '- Shirtdress crafted with a soft cotton poplin.\n'
                  '- Corset-like waist darts flatter any silhouette.\n'
                  '- Slightly curved mid-length hem ideal to wear with boots or heels.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(height: 1),

              // Đánh giá
              _SectionTile(
                title: 'Customer reviews',
                trailing: const Icon(Icons.expand_more),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        _Avatar(),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Sản phẩm đẹp, chất vải mát. Form ôm vừa phải, sẽ mua thêm màu khác!',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _Stars(rating: 5),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Sản phẩm tương tự
              _ListHeader(title: 'Similar products'),
              const SizedBox(height: 8),
              _ProductScroller(products: _mockProductsA),
              const SizedBox(height: 16),

              // Gợi ý thêm
              _ListHeader(title: "We think you'll love"),
              const SizedBox(height: 8),
              _ProductScroller(products: _mockProductsB),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

final TextStyle _sectionLabelStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

class _ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int index;
  final ValueChanged<int> onChanged;

  const _ImageCarousel({
    required this.images,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: onChanged,
              itemBuilder: (_, i) => Ink.image(
                image: NetworkImage(images[i]),
                fit: BoxFit.cover,
                child: InkWell(onTap: () {}),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) {
            final active = i == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? Colors.black : const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating; // 0..5
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = rating >= i + 1;
        final half = rating > i && rating < i + 1;
        return Icon(
          half ? Icons.star_half_rounded : Icons.star_rounded,
          size: 18,
          color: const Color(0xFFFFB300),
          grade: filled || half ? 1 : 0,
        );
      }),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _QtyStepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    void inc() => onChanged(value + 1);
    void dec() => onChanged(value > 1 ? value - 1 : 1);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(icon: Icons.remove, onTap: dec),
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          _QtyBtn(icon: Icons.add, onTap: inc),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: SizedBox(width: 36, height: 40, child: Icon(icon, size: 18)),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionTile({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        initiallyExpanded: title == 'Description',
        title: Text(title, style: textStyle),
        trailing: trailing,
        children: [child],
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  final String title;
  const _ListHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }
}

class Product {
  final String title;
  final String image;
  final String price;
  final String? oldPrice;

  Product({
    required this.title,
    required this.image,
    required this.price,
    this.oldPrice,
  });
}

class _ProductScroller extends StatelessWidget {
  final List<Product> products;
  const _ProductScroller({required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _ProductCard(item: products[i]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product item;
  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 0.8,
                  child: Ink.image(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                    child: InkWell(onTap: () {}),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (item.oldPrice != null) ...[
                Text(
                  item.oldPrice!,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                item.price,
                style: const TextStyle(
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(
        'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?q=80&w=256&auto=format&fit=crop',
      ),
    );
  }
}

// Mock data
final _mockProductsA = [
  Product(
    title: 'Balloon sleeve shirt dress',
    image:
        'https://images.unsplash.com/photo-1520975922138-8bdf0ee0b6df?q=80&w=1080&auto=format&fit=crop',
    price: '799.000đ',
    oldPrice: '999.000đ',
  ),
  Product(
    title: 'Marine blazer dress in white',
    image:
        'https://images.unsplash.com/photo-1540574163026-643ea20ade25?q=80&w=1080&auto=format&fit=crop',
    price: '1.259.000đ',
  ),
  Product(
    title: 'Minimal wrap dress',
    image:
        'https://images.unsplash.com/photo-1520975867597-0f2f0f2f0f2f?q=80&w=1080&auto=format&fit=crop',
    price: '959.000đ',
  ),
];

final _mockProductsB = [
  Product(
    title: 'One shoulder pencil dress',
    image:
        'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?q=80&w=1080&auto=format&fit=crop',
    price: '899.000đ',
  ),
  Product(
    title: 'Ribbed pants in bright orange',
    image:
        'https://images.unsplash.com/photo-1603252109303-2751441dd157?q=80&w=1080&auto=format&fit=crop',
    price: '699.000đ',
  ),
  Product(
    title: 'Pleated midi skirt',
    image:
        'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=1080&auto=format&fit=crop',
    price: '629.000đ',
  ),
];
