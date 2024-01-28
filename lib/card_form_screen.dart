import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/providers/orders_providers.dart';
import 'package:food_app/providers/product_providers.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'Widget/text_widgets.dart';
import 'consts/fire_const.dart';
import 'providers/cart_providers.dart';
import 'services/global_methods.dart';
import 'services/utils.dart';

class CardFormScreen extends StatefulWidget {
  static const routeName = '/CardFormScreen';
  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _fullNameController = TextEditingController();

  String? _cardNumberError;
  String? _expiryDateError;
  String? _cvvError;
  String? _fullNameError;

  bool _validateForm() {
    setState(() {
      _cardNumberError = null;
      _expiryDateError = null;
      _cvvError = null;
      _fullNameError = null;

      if (_fullNameController.text.isEmpty) {
        _fullNameError = 'Please enter your full Name';
      } else if (_cardNumberController.text.length != 16) {
        _cardNumberError = 'Card number should be 16 digits';
      }
      if (_cardNumberController.text.isEmpty) {
        _cardNumberError = 'Please enter card number';
      } else if (_cardNumberController.text.length != 16) {
        _cardNumberError = 'Card number should be 16 digits';
      }

      if (_expiryDateController.text.isEmpty) {
        _expiryDateError = 'Please enter expiry date';
      }

      if (_cvvController.text.isEmpty) {
        _cvvError = 'Please enter CVV';
      } else if (_cvvController.text.length != 3) {
        _cvvError = 'CVV should be 3 digits';
      }
    });

    return _cardNumberError == null &&
        _expiryDateError == null &&
        _cvvError == null;
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text('Thank you for your purchase!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/cart', // Replace '/cart' with the route name for CartPage
                (route) => false, // Pop all routes until CartPage is reached
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    Size size = Utils(ctx).getscreenSize;
    final Color color = Utils(ctx).color;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    // String? phoneNumber = user?.phoneNumber;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnsale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () =>
              Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 17,
          ),
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Checkout page',
          style: TextStyle(color: color, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.credit_card,
                  size: 40,
                  color: color,
                ),
                SizedBox(height: 10),
                Text(
                  'Payment with Credit Card',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    errorText: _fullNameError,
                  ),
                  keyboardType: TextInputType.name,
                ),
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    errorText: _cardNumberError,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                ),
                TextField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    labelText: 'Expiry date',
                    errorText: _expiryDateError,
                  ),
                ),
                TextField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    errorText: _cvvError,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  onChanged: (value) {
                    if (value.contains(RegExp(r'[^\d]'))) {
                      _cvvController.text =
                          value.replaceAll(RegExp(r'[^\d]'), '');
                    }
                  },
                ),
                SizedBox(height: 7),
                ElevatedButton(
                  onPressed: () async {
                    if (_validateForm()) {
                      User? user = authInstance.currentUser;

                      final productProvider =
                          Provider.of<ProductsProvider>(ctx, listen: false);

                      cartProvider.getCartItems.forEach((key, value) async {
                        final getCurrProduct = productProvider.findProdById(
                          value.productId,
                        );
                        try {
                          final orderId = const Uuid().v4();
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderId)
                              .set({
                            'orderId': orderId,
                            'userId': user!.uid,
                            'productId': value.productId,
                            'price': (getCurrProduct.isOnsale
                                    ? getCurrProduct.salePrice
                                    : getCurrProduct.price) *
                                value.quantity,
                            'totalPrice': total,
                            'quantity': value.quantity,
                            'imageUrl': getCurrProduct.imageUrl,
                            'userName': user.displayName,
                            'orderDate': Timestamp.now(),
                          });
                          _showPaymentSuccessDialog(context);
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearLocalCart();
                          ordersProvider.fetchOrders();
                          // await Fluttertoast.showToast(
                          //   msg: "Your order has been placed",
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.CENTER,
                          // );
                        } catch (error) {
                          GlobalMethods.errorDialog(
                              subTitle: error.toString(), context: ctx);
                        } finally {}
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text(
                    'Pay Now',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
