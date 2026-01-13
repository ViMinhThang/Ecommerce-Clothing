import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/screens/profile/order_detail_screen.dart';

class StatusCheckoutScreen extends StatelessWidget {
  final String orderNumber;
  final int? orderId;

  const StatusCheckoutScreen({
    super.key,
    this.orderNumber = '245877456333248',
    this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 4,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 70,
                  color: Color(0xFF4CAF50),
                ),
              ),

              const SizedBox(height: 40),

              // Payment successful text
              const Text(
                'Order successful!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Order number
              Text(
                'Order number: $orderNumber',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // Thank you message
              Text(
                'Thank you for shopping!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (orderId != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailScreen(orderId: orderId!),
                        ),
                        (route) => false,
                      );
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/home', 
                        (route) => false,
                      );
                    }
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
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

