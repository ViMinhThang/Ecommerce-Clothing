import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/widgets/shared/bottom_nav_bar.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPayment = 'credit_card';
  bool showCardNumber = false;
  int _selectedNavIndex = 3; // Cart is selected by default

  @override
  void dispose() {
    super.dispose();
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
                  const Text(
                    'Payment',
                    style: TextStyle(
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

                  // COD Option
                  _buildPaymentOption(
                    icon: _buildCODIcon(),
                    title: 'Cash on Delivery',
                    value: 'cod',
                  ),

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
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dmitriy Divnov',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Brest, Belarus',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+375 (29) 749-19-24',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Total
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '119.00\$',
                        style: TextStyle(
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

          // Pay Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          CustomBottomNavBar(
            selectedIndex: _selectedNavIndex,
            onItemTapped: _onNavItemTapped,
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
                  ? const Icon(
                Icons.circle,
                size: 12,
                color: Colors.white,
              )
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
          // Fallback to text logo if image fails to load
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