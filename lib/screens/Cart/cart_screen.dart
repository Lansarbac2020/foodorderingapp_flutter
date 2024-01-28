import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/Widget/ContactFormPage.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/card_form_screen.dart';
import 'package:food_app/consts/fire_const.dart';
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/providers/orders_providers.dart';
import 'package:food_app/providers/product_providers.dart';
import 'package:food_app/screens/Cart/cartwidget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../Widget/empty_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _phoneNumber = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = Utils(context).getscreenSize;
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty ',
            subtitle: 'Add something and make an orders',
            buttonText: 'Shop now',
            imagePath:
                'https://img.freepik.com/vecteurs-libre/panier_1284-672.jpg?size=626&ext=jpg&ga=GA1.2.1278914853.1685783879&semt=ais',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Textwidget(
                text: 'Cart(${cartItemsList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.WarningDialog(
                        title: 'Empty your cart ? ',
                        subTitle: "Are you sure ? ",
                        fct: () async {
                          await cartProvider.clearOnlineCart();
                          cartProvider.clearLocalCart();
                        },
                        context: context);
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _chekout(ctx: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: Cartwidget(
                              q: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ),
          );
  }

  Widget _chekout({required BuildContext ctx}) {
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
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: CardFormScreen.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Textwidget(
                    text: 'Chekout',
                    textSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: Textwidget(
                text: 'Total: \$${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
