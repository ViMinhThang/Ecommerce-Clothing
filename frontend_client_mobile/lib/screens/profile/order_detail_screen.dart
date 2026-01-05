import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/models/order_detail_view.dart';
import 'package:frontend_client_mobile/models/order_item_view.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/api/api_config.dart';
import 'package:frontend_client_mobile/screens/home/main_screen.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/wishlist_provider.dart';
import 'package:frontend_client_mobile/providers/review_provider.dart';
import 'package:frontend_client_mobile/screens/review/write_review_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetailView? _order;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      ApiClient.configInterceptor();
      final response = await ApiClient.dio.get('/api/orders/${widget.orderId}');
      final order = OrderDetailView.fromJson(response.data);
      setState(() {
        _order = order;
        _isLoading = false;
      });
      if (order.status.toUpperCase() == 'DELIVERED') {
        Provider.of<ReviewProvider>(context, listen: false)
            .loadReviewedOrderItemIds(widget.orderId);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load order details';
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'PROCESSING':
        return Colors.blue;
      case 'SHIPPED':
        return Colors.purple;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  String _getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return 'https://via.placeholder.com/80x80?text=No+Image';
    }
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    return '${ApiConfig.baseUrl}$imageUrl';
  }

  void _onNavItemTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(initialTab: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            }
          },
        ),
        title: Text(
          'Order #${widget.orderId}',
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Consumer2<CartProvider, WishlistProvider>(
      builder: (context, cartProvider, wishlistProvider, child) {
        final cartItemCount = cartProvider.cart?.items.length ?? 0;
        final wishlistItemCount = wishlistProvider.itemCount;

        return BottomNavigationBar(
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Catalog'),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: wishlistItemCount > 0,
                label: Text(
                  wishlistItemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.black,
                child: const Icon(Icons.favorite_border),
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartItemCount > 0,
                label: Text(
                  cartItemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.black,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
          currentIndex: 4, // Profile tab since orders are accessed from profile
          onTap: _onNavItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        );
      },
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.black));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrderDetail,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_order == null) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatusCard(),
          const SizedBox(height: 12),
          _buildShippingAddressCard(),
          const SizedBox(height: 12),
          _buildItemsCard(),
          const SizedBox(height: 12),
          _buildPriceCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildShippingAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 20, color: Colors.grey.shade700),
              const SizedBox(width: 10),
              Text(
                'Shipping Address',
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Placeholder content - replace when backend is ready
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_on_outlined, size: 24, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address not available',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Shipping address will be displayed here when available from backend.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = _getStatusColor(_order!.status);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Status',
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _order!.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today_outlined, 'Order Date', _formatDate(_order!.createdDate)),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email_outlined, 'Email', _order!.buyerEmail),
          if (_order!.voucherCode != null && _order!.voucherCode!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.local_offer_outlined, 'Voucher', _order!.voucherCode!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${_order!.items.length} item(s)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _order!.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) => _buildItemTile(_order!.items[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(OrderItemView item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _getImageUrl(item.imageUrl),
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade200,
                child: Icon(Icons.image, color: Colors.grey.shade400),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Product',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    if (item.color != null) item.color,
                    if (item.size != null) item.size,
                    if (item.material != null) item.material,
                  ].where((e) => e != null).join(' • '),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.priceAtPurchase.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_order!.status.toUpperCase() == 'DELIVERED')
                  Consumer<ReviewProvider>(
                    builder: (context, reviewProvider, _) {
                      final isReviewed = reviewProvider.isOrderItemReviewed(item.id);
                      if (isReviewed) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
                              const SizedBox(width: 6),
                              Text(
                                'Reviewed',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 32,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WriteReviewScreen(
                                    orderItemId: item.id,
                                    productName: item.productName ?? 'Product',
                                    productImageUrl: _getImageUrl(item.imageUrl),
                                  ),
                                ),
                              );
                              if (result == true) {
                                reviewProvider.loadReviewedOrderItemIds(widget.orderId);
                              }
                            },
                            icon: const Icon(Icons.rate_review, size: 16),
                            label: const Text('Review'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: const BorderSide(color: Colors.black87),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Subtotal', _order!.totalPrice),
          if (_order!.discountAmount > 0) ...[
            const SizedBox(height: 10),
            _buildPriceRow('Discount', -_order!.discountAmount, isDiscount: true),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.lora(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                '\$${(_order!.finalPrice > 0 ? _order!.finalPrice : _order!.totalPrice).toStringAsFixed(2)}',
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}\$${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDiscount ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }
}
