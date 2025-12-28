import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_client_mobile/providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _email = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Giỏ hàng trống')));
      return;
    }
    if (_email.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nhập email')));
      return;
    }

    setState(() => _loading = true);
    try {
      final order = await cart.checkout(buyerEmail: _email.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tạo đơn #${order.id} thành công')),
      );
      Navigator.pushReplacementNamed(context, '/orders');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi tạo đơn: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Tổng: ₫${cart.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email người nhận'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Xác nhận và tạo đơn'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
