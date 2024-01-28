import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/heart_btt.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:provider/provider.dart';

import '../consts/fire_const.dart';
import '../providers/cart_providers.dart';
import '../providers/product_providers.dart';
import '../providers/viewed_provider.dart';
import '../providers/wishlist_providers.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductsDetails';
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');
  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrProduct = productProvider.findProdById(productId);

    double usedPrice = getCurrProduct.isOnsale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    bool? _isInWishList =
        wishlistProvider.getwishlistItems.containsKey(getCurrProduct.id);
    // ignore: unused_local_variable
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        //viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                Navigator.canPop(context) ? Navigator.pop(context) : null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrProduct.imageUrl,
                boxFit: BoxFit.scaleDown,
                width: size.width,
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Textwidget(
                                text: getCurrProduct.title,
                                color: color,
                                textSize: 19,
                                isTitle: true,
                              ),
                            ),
                            HeartBttm(
                              productId: getCurrProduct.id,
                              isInWishlist: _isInWishList,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Textwidget(
                              text: '\$${usedPrice.toStringAsFixed(2)}/',
                              color: Colors.green,
                              textSize: 22,
                              isTitle: true,
                            ),
                            Textwidget(
                              text: getCurrProduct.isPiece ? 'Piece' : 'Kg',
                              color: color,
                              textSize: 12,
                              isTitle: false,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: getCurrProduct.isOnsale ? true : false,
                              child: Text(
                                '\$${getCurrProduct.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: color,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(63, 200, 201, 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Textwidget(
                                text: 'Free delievery',
                                color: Colors.white,
                                textSize: 15,
                                isTitle: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quantityTextControl(
                            fct: () {
                              if (_quantityTextController.text == '1') {
                                return;
                              } else {
                                setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) -
                                              1)
                                          .toString();
                                });
                              }
                            },
                            icon: CupertinoIcons.minus,
                            color: Colors.red,
                          ),
                          // SizedBox(
                          //   width: 5,
                          // ),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _quantityTextController,
                              key: const ValueKey('quantity'),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.blue,
                              enabled: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quantityTextController.text = '1';
                                  } else {}
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          quantityTextControl(
                            fct: () {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text) +
                                            1)
                                        .toString();
                              });
                            },
                            icon: CupertinoIcons.plus,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Textwidget(
                                    text: 'TOTAL',
                                    color: Colors.orange,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        Textwidget(
                                          text:
                                              '\$${totalPrice.toStringAsFixed(2)}/',
                                          color: color,
                                          textSize: 20,
                                          isTitle: true,
                                        ),
                                        Textwidget(
                                          text:
                                              '${_quantityTextController.text}KG',
                                          color: color,
                                          textSize: 15,
                                          isTitle: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                                child: Material(
                              color: _isInCart ? Colors.red : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: _isInCart
                                    ? null
                                    : () async {
                                        final User? user =
                                            authInstance.currentUser;

                                        if (user == null) {
                                          GlobalMethods.errorDialog(
                                              subTitle:
                                                  'No user found, thanks for login first ',
                                              context: context);
                                          return;
                                        }
                                        await GlobalMethods.addTocart(
                                            productId: getCurrProduct.id,
                                            quantity: int.parse(
                                                _quantityTextController.text),
                                            context: context);
                                        await cartProvider.featchCart();
                                        // cartProvider.addProductsToCart(
                                        //     productId: getCurrProduct.id,
                                        //     quantity: int.parse(
                                        //         _quantityTextController.text));
                                      },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Textwidget(
                                    text:
                                        _isInCart ? ' In cart ' : 'Add to Cart',
                                    color: Colors.white,
                                    textSize: 15,
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantityTextControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
