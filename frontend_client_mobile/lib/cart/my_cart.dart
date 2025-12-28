import 'package:flutter/material.dart';
import 'package:frontend_client_mobile/widgets/common/app_bar_widget.dart';

class MyCart extends StatefulWidget {
	const MyCart({super.key});

	@override
	State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
	final List<Map<String, dynamic>> products = [
		{
			"name": "Black Jacket",
			"price": 59.99,
			"oldPrice": 79.99,
			"color": Colors.black,
			"size": "M",
			"quantity": 1,
			"image": "https://m.media-amazon.com/images/I/51wbSZDIWlL.jpg"
		},
		{
			"name": "White T-Shirt",
			"price": 29.99,
			"oldPrice": 39.99,
			"color": Colors.grey,
			"size": "L",
			"quantity": 1,
			"image":
			"https://www.gundam.co.nz/wp-content/uploads/2025/04/Gundam-Universe-RX-78-2-Gundam-Renewal_0.jpg"
		},
	];

	// Calculate totals
	double get totalPrice {
		return products.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
	}

	double get discount {
		return products.fold(0, (sum, item) {
			if (item['oldPrice'] != null) {
				return sum + ((item['oldPrice'] - item['price']) * item['quantity']);
			}
			return sum;
		});
	}

	double get finalTotal {
		return totalPrice;
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			appBar: const CustomAppBar(
				title: "Cart",
				icons: Icons.search,
			),
			body: Column(
				children: [
					Padding(
						padding: const EdgeInsets.all(16.0),
						child: Center(
							child: Text(
								"You have ${products.length} products in your Cart",
								style: const TextStyle(
									fontSize: 16,
									fontWeight: FontWeight.w400,
									color: Colors.black54,
								),
							),
						),
					),

					// PRODUCT LIST
					Expanded(
						child: ListView.builder(
							padding: const EdgeInsets.symmetric(horizontal: 16),
							itemCount: products.length,
							itemBuilder: (context, index) {
								final item = products[index];

								return Container(
									margin: const EdgeInsets.only(bottom: 16),
									padding: const EdgeInsets.all(12),
									decoration: BoxDecoration(
										color: Colors.white60,
										borderRadius: BorderRadius.circular(12),
										boxShadow: [
											BoxShadow(
												color: Colors.grey.shade300,
												blurRadius: 6,
												offset: const Offset(0, 3),
											)
										],
									),
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											// IMAGE
											ClipRRect(
												borderRadius: BorderRadius.circular(8),
												child: Image.network(
													item["image"],
													width: 100,
													height: 120,
													fit: BoxFit.cover,
												),
											),

											const SizedBox(width: 12),

											// PRODUCT INFO
											Expanded(
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														// Product Name
														Text(
															item["name"],
															style: const TextStyle(
																fontSize: 16,
																fontWeight: FontWeight.w600,
															),
															maxLines: 2,
															overflow: TextOverflow.ellipsis,
														),
														const SizedBox(height: 8),

														// Color & Size
														Row(
															children: [
																const Text(
																	"Color: ",
																	style: TextStyle(
																			fontSize: 12, color: Colors.black54),
																),
																Container(
																	width: 20,
																	height: 20,
																	decoration: BoxDecoration(
																		color: item["color"],
																		shape: BoxShape.circle,
																		border: Border.all(
																				color: Colors.grey.shade300,
																				width: 1),
																	),
																),
																const SizedBox(width: 16),
																Text(
																	"Size: ${item["size"]}",
																	style: const TextStyle(
																			fontSize: 12, color: Colors.black54),
																),
															],
														),
														const SizedBox(height: 8),

														// Price
														Row(
															children: [
																if (item["oldPrice"] != null)
																	Text(
																		"\$${item["oldPrice"]}",
																		style: const TextStyle(
																			fontSize: 14,
																			color: Colors.grey,
																			decoration: TextDecoration.lineThrough,
																		),
																	),
																const SizedBox(width: 8),
																Text(
																	"\$${item["price"]}",
																	style: const TextStyle(
																		fontSize: 18,
																		fontWeight: FontWeight.bold,
																		color: Colors.redAccent,
																	),
																),
															],
														),
														const SizedBox(height: 8),

														// Quantity Controller
														Container(
															decoration: BoxDecoration(
																border:
																Border.all(color: Colors.grey.shade300),
																borderRadius: BorderRadius.circular(8),
															),
															child: Row(
																mainAxisSize: MainAxisSize.min,
																children: [
																	IconButton(
																		onPressed: () {
																			setState(() {
																				if (item["quantity"] > 1) {
																					item["quantity"]--;
																				}
																			});
																		},
																		icon: const Icon(Icons.remove, size: 18),
																		padding: const EdgeInsets.all(4),
																		constraints: const BoxConstraints(),
																	),
																	Padding(
																		padding: const EdgeInsets.symmetric(
																				horizontal: 12),
																		child: Text(
																			"${item["quantity"]}",
																			style: const TextStyle(
																				fontSize: 16,
																				fontWeight: FontWeight.w600,
																			),
																		),
																	),
																	IconButton(
																		onPressed: () {
																			setState(() {
																				item["quantity"]++;
																			});
																		},
																		icon: const Icon(Icons.add, size: 18),
																		padding: const EdgeInsets.all(4),
																		constraints: const BoxConstraints(),
																	),
																],
															),
														),
													],
												),
											),

											// DELETE BUTTON
											IconButton(
												onPressed: () {
													setState(() {
														products.removeAt(index);
													});
												},
												icon: const Icon(Icons.close),
												color: Colors.black54,
												padding: EdgeInsets.zero,
												constraints: const BoxConstraints(),
											),
										],
									),
								);
							},
						),
					),

					// PRICE SUMMARY SECTION
					Container(
						padding: const EdgeInsets.all(16),
						decoration: BoxDecoration(
							color: Colors.grey.shade50,
							border: Border(
								top: BorderSide(color: Colors.grey.shade200, width: 1),
							),
						),
						child: Column(
							children: [
								// Total Price
								_buildPriceRow(
									"Total Price",
									"\$${totalPrice.toStringAsFixed(2)}",
									isGrey: true,
								),
								const SizedBox(height: 8),

								// Discount
								_buildPriceRow(
									"Discount",
									"\$${discount.toStringAsFixed(2)}",
									isGrey: true,
								),
								const SizedBox(height: 8),

								// Delivery Fees
								_buildPriceRow(
									"Estimated delivery fees",
									"Free",
									isGrey: true,
								),

								const SizedBox(height: 16),
								Divider(color: Colors.grey.shade300, thickness: 1),
								const SizedBox(height: 16),

								// TOTAL
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										const Text(
											"Total:",
											style: TextStyle(
												fontSize: 20,
												fontWeight: FontWeight.bold,
												color: Colors.black,
											),
										),
										Text(
											"\$${finalTotal.toStringAsFixed(2)}",
											style: const TextStyle(
												fontSize: 22,
												fontWeight: FontWeight.bold,
												color: Colors.black,
											),
										),
									],
								),
								const SizedBox(height: 8),

								// Saving Applied
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										Text(
											"Saving Applied",
											style: TextStyle(
												fontSize: 14,
												color: Colors.grey.shade600,
											),
										),
										Text(
											"\$${discount.toStringAsFixed(2)}",
											style: TextStyle(
												fontSize: 14,
												color: Colors.grey.shade600,
											),
										),
									],
								),
								const SizedBox(height: 20),

								// CHECKOUT BUTTON
								SizedBox(
									width: double.infinity,
									height: 56,
									child: ElevatedButton(
										onPressed: () {
											// Handle checkout
											ScaffoldMessenger.of(context).showSnackBar(
												const SnackBar(
													content: Text("Proceeding to checkout..."),
												),
											);
										},
										style: ElevatedButton.styleFrom(
											backgroundColor: Colors.black,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
											),
										),
										child: const Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Icon(Icons.shopping_cart, color: Colors.white),
												SizedBox(width: 8),
												Text(
													"Checkout",
													style: TextStyle(
														fontSize: 18,
														fontWeight: FontWeight.w600,
														color: Colors.white,
													),
												),
											],
										),
									),
								),
							],
						),
					),
				],
			),
		);
	}

	// Helper widget for price rows
	Widget _buildPriceRow(String label, String value, {bool isGrey = false}) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Text(
					label,
					style: TextStyle(
						fontSize: 15,
						color: isGrey ? Colors.grey.shade600 : Colors.black,
					),
				),
				Text(
					value,
					style: TextStyle(
						fontSize: 15,
						color: isGrey ? Colors.grey.shade600 : Colors.black,
						fontWeight: isGrey ? FontWeight.normal : FontWeight.w600,
					),
				),
			],
		);
	}
}