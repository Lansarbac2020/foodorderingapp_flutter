import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/Widget/heart_btt.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/inner_screen/product_details.dart';
import 'package:food_app/models/cat-model.dart';
import 'package:food_app/providers/product_providers.dart';
// import 'package:food_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_providers.dart';
import '../../providers/wishlist_providers.dart';
import '../../services/utils.dart';

class Cartwidget extends StatefulWidget {
  const Cartwidget({super.key, required this.q});
  final int q;

  @override
  State<Cartwidget> createState() => _CartwidgetState();
}

class _CartwidgetState extends State<Cartwidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getscreenSize;
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final getCurrProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrProduct.isOnsale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishList =
        wishlistProvider.getwishlistItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.28,
                      width: size.width * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FancyShimmerImage(
                        imageUrl: getCurrProduct.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Textwidget(
                          text: getCurrProduct.title,
                          color: color,
                          textSize: 21,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                          child: Row(
                            children: [
                              _quantityController(
                                  fct: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      cartProvider.reduceQuatityByOne(
                                          cartModel.productId);
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      });
                                    }
                                  },
                                  color: Colors.red,
                                  icon: CupertinoIcons.minus),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide())),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      if (v.isEmpty) {
                                        _quantityTextController.text = '1';
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                              ),
                              _quantityController(
                                  fct: () {
                                    cartProvider.IncreaseQuatityByOne(
                                        cartModel.productId);
                                    setState(() {
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  color: Colors.blue,
                                  icon: CupertinoIcons.plus),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await cartProvider.removeOneItem(
                                cartId: cartModel.id,
                                productId: cartModel.productId,
                                quantity: cartModel.quantity,
                              );
                              Fluttertoast.showToast(
                                msg:
                                    "The item has been remove successfully from your cart ",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    const Color.fromARGB(255, 88, 90, 92),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                            child: const Icon(CupertinoIcons.cart_badge_minus,
                                color: Colors.red, size: 20),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          HeartBttm(
                            productId: getCurrProduct.id,
                            isInWishlist: _isInWishList,
                          ),
                          Textwidget(
                            text:
                                '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: Colors.orange,
                            textSize: 17,
                            maxLines: 1,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
