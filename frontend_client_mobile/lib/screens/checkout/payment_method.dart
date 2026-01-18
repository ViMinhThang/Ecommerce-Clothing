import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/checkout/status_checkout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_client_mobile/models/voucher.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';
import 'package:frontend_client_mobile/providers/voucher_provider.dart';
import 'package:frontend_client_mobile/services/api/api_client.dart';
import 'package:frontend_client_mobile/services/token_storage.dart';
import 'package:provider/provider.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<int> selectedItemIds;
  final double selectedTotal;

  const PaymentMethodScreen({
    super.key,
    required this.selectedItemIds,
    required this.selectedTotal,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPayment = 'cod';
  bool showCardNumber = false;
  bool _isLoading = false;
  final int _selectedNavIndex = 3;

  final _voucherController = TextEditingController();
  bool _isValidatingVoucher = false;
  ValidateVoucherResponse? _voucherResponse;
  String? _voucherError;
  String? _appliedVoucherCode;

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  double get _discountAmount => _voucherResponse?.discountAmount ?? 0;
  double get _finalPrice => widget.selectedTotal - _discountAmount;

  Future<void> _validateVoucher() async {
    final code = _voucherController.text.trim();
    if (code.isEmpty) {
      setState(() => _voucherError = 'Please enter a voucher code');
      return;
    }

    setState(() {
      _isValidatingVoucher = true;
      _voucherError = null;
    });

    try {
      final response = await context.read<VoucherProvider>().validateVoucher(
        code,
        widget.selectedTotal,
      );

      setState(() {
        _isValidatingVoucher = false;
        if (response != null && response.valid) {
          _voucherResponse = response;
          _appliedVoucherCode = code;
          _voucherError = null;
        } else {
          _voucherResponse = null;
          _appliedVoucherCode = null;
          _voucherError = response?.message ?? 'Invalid voucher';
        }
      });
    } catch (e) {
      setState(() {
        _isValidatingVoucher = false;
        _voucherError = 'Failed to validate voucher';
      });
    }
  }

  void _removeVoucher() {
    setState(() {
      _voucherResponse = null;
      _appliedVoucherCode = null;
      _voucherError = null;
      _voucherController.clear();
    });
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedNavIndex) return;

    switch (index) {
      case 0: // Home
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1: // Catalog
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: 1,
        );
        break;
      case 2: // Wishlist
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: 2,
        );
        break;
      case 3: // Cart
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: 3,
        );
        break;
      case 4: // Profile
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: 4,
        );
        break;
    }
  }

  Future<void> _handleOrder() async {
    // Check if user is authenticated
    final tokenStorage = TokenStorage();
    final token = await tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to place an order'),
          backgroundColor: Colors.orange,
        ),
      );
      Navigator.pushNamed(context, '/login');
      return;
    }

    // Only process COD for now
    if (selectedPayment != 'cod') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only Cash on Delivery is supported at this time'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (!mounted) return;
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      if (widget.selectedItemIds.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No items selected for checkout'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Use selected item IDs passed from cart screen
      final cartItemIds = widget.selectedItemIds;

      final orderApiService = ApiClient.getOrderApiService();
      final response = await orderApiService.createOrderFromCart({
        'cartItemIds': cartItemIds,
        'voucherCode': _appliedVoucherCode,
      });

      // Remove only checked out items from cart
      await cartProvider.removeSelectedItems(cartItemIds, 1);

      if (!mounted) return;

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatusCheckoutScreen(
            orderNumber: response.id.toString(),
            orderId: response.id,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Section
                  Text(
                    'Payment',
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Credit Card Option
                  _buildPaymentOption(
                    icon: _buildMastercardIcon(),
                    title: 'Credit card',
                    value: 'credit_card',
                  ),

                  const SizedBox(height: 12),

                  // VNPay Option
                  _buildPaymentOption(
                    icon: _buildVNPayIcon(),
                    title: 'VNPay',
                    value: 'vnpay',
                  ),

                  const SizedBox(height: 12),

                  _buildPaymentOption(
                    icon: _buildCODIcon(),
                    title: 'Cash on Delivery',
                    value: 'cod',
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Voucher',
                    style: GoogleFonts.lora(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_appliedVoucherCode != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _appliedVoucherCode!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '-\$${_discountAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.green[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _removeVoucher,
                            icon: Icon(Icons.close, color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'Enter voucher code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              errorText: _voucherError,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isValidatingVoucher
                                ? null
                                : _validateVoucher,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isValidatingVoucher
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Apply',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Credit Card Details (only show when credit card is selected)
                  if (selectedPayment == 'credit_card') ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                showCardNumber
                                    ? '**** **** **** 8207'
                                    : '**** **** **** 8207',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showCardNumber = !showCardNumber;
                                  });
                                },
                                child: const Icon(
                                  Icons.visibility_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'Name on card',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dmitriy Divnov',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              _buildMastercardIcon(size: 40),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Shipping Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dmitriy Divnov',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Brest, Belarus',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+375 (29) 749-19-24',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        '\$${widget.selectedTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  if (_discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount ($_appliedVoucherCode)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          '-\$${_discountAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '\$${_finalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Order Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final cartItemCount = cartProvider.cart?.items.length ?? 0;

              return BottomNavigationBar(
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Catalog',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    label: 'Wishlist',
                  ),
                  BottomNavigationBarItem(
                    icon: Badge(
                      isLabelVisible: cartItemCount > 0,
                      label: Text(
                        cartItemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                    label: 'Cart',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedNavIndex,
                onTap: _onNavItemTapped,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required Widget icon,
    required String title,
    required String value,
  }) {
    final isSelected = selectedPayment == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey,
                  width: 2,
                ),
                color: isSelected ? Colors.black : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMastercardIcon({double size = 30}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB001B),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF79E1B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVNPayIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Image.network(
        'https://cdn-new.topcv.vn/unsafe/https://static.topcv.vn/company_logos/cong-ty-cp-giai-phap-thanh-toan-viet-nam-vnpay-6194ba1fa3d66.jpg',
        fit: BoxFit.contain,
        width: 40,
        height: 40,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0066B3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'VNPAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCODIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: const Icon(
        Icons.local_shipping_outlined,
        size: 32,
        color: Color(0xFF4CAF50),
      ),
    );
  }
}
