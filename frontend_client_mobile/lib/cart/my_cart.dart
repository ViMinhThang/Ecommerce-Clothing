import 'package:flutter/material.dart';
class MyCart extends StatefulWidget {
	const MyCart({super.key});
	@override
		MyCartState createState() => MyCartState();
	}
class MyCartState extends State<MyCart> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										color: Color(0xFFFFFFFF),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 10),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFFFFFFFF),
																			padding: const EdgeInsets.symmetric(vertical: 14),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 33),
																						child: Text(
																							"9:41",
																							style: TextStyle(
																								color: Color(0xFF000000),
																								fontSize: 15,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					Expanded(
																						child: Container(
																							width: double.infinity,
																							child: SizedBox(),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( right: 5),
																						width: 17,
																						height: 10,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/em8s8u3v_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Container(
																						margin: const EdgeInsets.only( right: 5),
																						width: 15,
																						height: 11,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/qquomupk_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Container(
																						margin: const EdgeInsets.only( right: 14),
																						width: 24,
																						height: 11,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/g21qg8o8_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFFFFFFFF),
																			padding: const EdgeInsets.only( bottom: 4, left: 12, right: 12),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 8),
																						width: 48,
																						height: 48,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/zly48hkx_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.symmetric(vertical: 10),
																								margin: const EdgeInsets.only( right: 8),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Cart",
																											style: TextStyle(
																												color: Color(0xFF272728),
																												fontSize: 18,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Container(
																						width: 48,
																						height: 48,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/s5a4j7x7_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													Container(
														margin: const EdgeInsets.only( bottom: 32),
														child: Text(
															"You have 3 products in your Cart",
															style: TextStyle(
																color: Color(0xFF000000),
																fontSize: 16,
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFF6F8F9),
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 24, right: 24),
															margin: const EdgeInsets.only( bottom: 8),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 14),
																		width: 98,
																		height: 127,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/v87x8o0s_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				padding: const EdgeInsets.only( right: 3),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.symmetric(vertical: 8),
																								margin: const EdgeInsets.only( bottom: 8, left: 3),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											width: 141,
																											child: Text(
																												"CLAUDETTE CORSET SHIRT DRESS IN WHITE",
																												style: TextStyle(
																													color: Color(0xFF202325),
																													fontSize: 14,
																												),
																											),
																										),
																										Container(
																											width: 20,
																											height: 20,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/kajxbos0_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																									]
																								),
																							),
																						),
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 6, left: 2),
																									child: Row(
																										children: [
																											Container(
																												margin: const EdgeInsets.only( right: 16),
																												child: Text(
																													"Color:",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 14,
																													),
																												),
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 25),
																												width: 20,
																												height: 20,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/j0bgcd9f_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 21),
																												child: Text(
																													"Size:",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 14,
																													),
																												),
																											),
																											Text(
																												"XS",
																												style: TextStyle(
																													color: Color(0xFF000000),
																													fontSize: 14,
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																						IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( right: 46),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"79.95\$",
																																style: TextStyle(
																																	color: Color(0xFF979C9E),
																																	fontSize: 14,
																																),
																															),
																															Text(
																																"65.00\$",
																																style: TextStyle(
																																	color: Color(0xFFD3180C),
																																	fontSize: 16,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																										Expanded(
																											child: InkWell(
																												onTap: () { print('Pressed'); },
																												child: IntrinsicHeight(
																													child: Container(
																														decoration: BoxDecoration(
																															border: Border.all(
																																color: Color(0xFFE3E4E5),
																																width: 1,
																															),
																															borderRadius: BorderRadius.circular(8),
																														),
																														padding: const EdgeInsets.symmetric(vertical: 6),
																														margin: const EdgeInsets.only( top: 13),
																														width: double.infinity,
																														child: Row(
																															mainAxisAlignment: MainAxisAlignment.center,
																															children: [
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(8),
																																	),
																																	margin: const EdgeInsets.only( right: 21),
																																	width: 20,
																																	height: 20,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(8),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/2ltxyuda_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																																Container(
																																	margin: const EdgeInsets.only( right: 18),
																																	child: Text(
																																		"1",
																																		style: TextStyle(
																																			color: Color(0xFF090A0A),
																																			fontSize: 14,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																),
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(8),
																																	),
																																	width: 20,
																																	height: 20,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(8),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/k7z2lf6l_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																															]
																														),
																													),
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(8),
																color: Color(0xFFF6F8F9),
															),
															padding: const EdgeInsets.only( top: 16, bottom: 16, left: 24, right: 24),
															margin: const EdgeInsets.only( bottom: 8),
															width: double.infinity,
															child: Row(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 16),
																		width: 98,
																		height: 127,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/rhe6la2w_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 8, left: 1, right: 1),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											width: 140,
																											child: Text(
																												"Other Stories tailored mini skirt with asymmetric detail in rust",
																												style: TextStyle(
																													color: Color(0xFF202325),
																													fontSize: 14,
																												),
																											),
																										),
																										Container(
																											width: 20,
																											height: 20,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/mdjjddmo_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																									]
																								),
																							),
																						),
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 19),
																									child: Row(
																										children: [
																											Container(
																												margin: const EdgeInsets.only( right: 16),
																												child: Text(
																													"Color:",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 14,
																													),
																												),
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 25),
																												width: 20,
																												height: 20,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/xfmsfvbq_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 21),
																												child: Text(
																													"Size:",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 14,
																													),
																												),
																											),
																											Text(
																												"S",
																												style: TextStyle(
																													color: Color(0xFF000000),
																													fontSize: 14,
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																						IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.end,
																									children: [
																										InkWell(
																											onTap: () { print('Pressed'); },
																											child: IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														decoration: BoxDecoration(
																															border: Border.all(
																																color: Color(0xFFE3E4E5),
																																width: 1,
																															),
																															borderRadius: BorderRadius.circular(8),
																														),
																														padding: const EdgeInsets.only( top: 6, bottom: 6, left: 16, right: 16),
																														child: Row(
																															children: [
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(8),
																																	),
																																	margin: const EdgeInsets.only( right: 21),
																																	width: 20,
																																	height: 20,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(8),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/i80cg1nw_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																																Container(
																																	margin: const EdgeInsets.only( right: 18),
																																	child: Text(
																																		"1",
																																		style: TextStyle(
																																			color: Color(0xFF090A0A),
																																			fontSize: 14,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																),
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(8),
																																	),
																																	width: 20,
																																	height: 20,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(8),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/5et9lrzo_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																															]
																														),
																													),
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(8),
																color: Color(0xFFF6F8F9),
															),
															padding: const EdgeInsets.only( top: 16, bottom: 16, left: 24, right: 24),
															margin: const EdgeInsets.only( bottom: 32),
															width: double.infinity,
															child: Row(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 16),
																		width: 98,
																		height: 127,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/nnnn35qk_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 8),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.spaceBetween,
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											width: 156,
																											child: Text(
																												"HIGH WAISTED TAILORED SUITING SHORTS IN OXY FIRE",
																												style: TextStyle(
																													color: Color(0xFF202325),
																													fontSize: 14,
																												),
																											),
																										),
																										Container(
																											width: 20,
																											height: 20,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/n9o1x9yo_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										),
																									]
																								),
																							),
																						),
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 19),
																									child: Row(
																										children: [
																											Container(
																												margin: const EdgeInsets.only( right: 16),
																												child: Text(
																													"Color:",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 14,
																													),
																												),
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 22),
																												width: 20,
																												height: 20,
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/41u6lb11_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											),
																											Container(
																												margin: const EdgeInsets.only( right: 21),
																												child: Text(
																													"Size:",
																													style: TextStyle(
																														color: Color(0xFF000000),
																														fontSize: 14,
																													),
																												),
																											),
																											Text(
																												"M",
																												style: TextStyle(
																													color: Color(0xFF000000),
																													fontSize: 14,
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																						IntrinsicHeight(
																							child: Container(
																								width: double.infinity,
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.end,
																									children: [
																										InkWell(
																											onTap: () { print('Pressed'); },
																											child: IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														decoration: BoxDecoration(
																															border: Border.all(
																																color: Color(0xFFE3E4E5),
																																width: 1,
																															),
																															borderRadius: BorderRadius.circular(8),
																														),
																														padding: const EdgeInsets.only( top: 6, bottom: 6, left: 16, right: 16),
																														child: Row(
																															children: [
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(8),
																																	),
																																	margin: const EdgeInsets.only( right: 21),
																																	width: 20,
																																	height: 20,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(8),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/otlp9zm7_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																																Container(
																																	margin: const EdgeInsets.only( right: 18),
																																	child: Text(
																																		"1",
																																		style: TextStyle(
																																			color: Color(0xFF090A0A),
																																			fontSize: 14,
																																			fontWeight: FontWeight.bold,
																																		),
																																	),
																																),
																																Container(
																																	decoration: BoxDecoration(
																																		borderRadius: BorderRadius.circular(8),
																																	),
																																	width: 20,
																																	height: 20,
																																	child: ClipRRect(
																																		borderRadius: BorderRadius.circular(8),
																																		child: Image.network(
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/t3hgwiec_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																															]
																														),
																													),
																												),
																											),
																										),
																									]
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													Container(
														color: Color(0xFFF2F3F4),
														margin: const EdgeInsets.only( bottom: 32),
														height: 2,
														width: double.infinity,
														child: SizedBox(),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 4, left: 24, right: 24),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		"Total Price",
																		style: TextStyle(
																			color: Color(0xFF979C9E),
																			fontSize: 16,
																		),
																	),
																	Text(
																		"133.95\$",
																		style: TextStyle(
																			color: Color(0xFF979C9E),
																			fontSize: 16,
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 4, left: 24, right: 24),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		"Discount",
																		style: TextStyle(
																			color: Color(0xFF979C9E),
																			fontSize: 16,
																		),
																	),
																	Text(
																		"14.95\$",
																		style: TextStyle(
																			color: Color(0xFF979C9E),
																			fontSize: 16,
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 61, left: 24, right: 24),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		"Estimated delivery fees",
																		style: TextStyle(
																			color: Color(0xFF979C9E),
																			fontSize: 16,
																		),
																	),
																	Text(
																		"Free",
																		style: TextStyle(
																			color: Color(0xFF979C9E),
																			fontSize: 16,
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFF2F3F4),
															padding: const EdgeInsets.symmetric(vertical: 12),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 16, left: 24, right: 24),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 4),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Total:",
																										style: TextStyle(
																											color: Color(0xFF090A0A),
																											fontSize: 20,
																										),
																									),
																									Text(
																										"119.00\$",
																										style: TextStyle(
																											color: Color(0xFF090A0A),
																											fontSize: 20,
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Saving Applied",
																										style: TextStyle(
																											color: Color(0xFF979C9E),
																											fontSize: 14,
																										),
																									),
																									Text(
																										"14.95\$",
																										style: TextStyle(
																											color: Color(0xFF979C9E),
																											fontSize: 14,
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	InkWell(
																		onTap: () { print('Pressed'); },
																		child: IntrinsicHeight(
																			child: Container(
																				decoration: BoxDecoration(
																					borderRadius: BorderRadius.circular(8),
																					color: Color(0xFF090A0A),
																				),
																				padding: const EdgeInsets.symmetric(vertical: 14),
																				margin: const EdgeInsets.symmetric(horizontal: 25),
																				width: double.infinity,
																				child: Row(
																					mainAxisAlignment: MainAxisAlignment.center,
																					children: [
																						Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(8),
																							),
																							margin: const EdgeInsets.only( right: 8),
																							width: 20,
																							height: 20,
																							child: ClipRRect(
																								borderRadius: BorderRadius.circular(8),
																								child: Image.network(
																									"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/6xxl44y6_expires_30_days.png",
																									fit: BoxFit.fill,
																								)
																							)
																						),
																						Text(
																							"Checkout",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
																								fontSize: 16,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( bottom: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		margin: const EdgeInsets.only( bottom: 29),
																		height: 56,
																		width: double.infinity,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/Qcx8f6kgIF/31ee4cg0_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(100),
																			color: Color(0xFF000000),
																		),
																		width: 134,
																		height: 5,
																		child: SizedBox(),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}