import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/Widget/price_widget.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/inner_screen/product_details.dart';
import 'package:food_app/models/products_models.dart';
// import 'package:food_app/models/products_models.dart';
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/providers/viewed_provider.dart';
import 'package:food_app/providers/wishlist_providers.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../consts/fire_const.dart';
// import '../models/products_models.dart';

// import '../providers/cart_providers.dart';
// import '../providers/cart_providers.dart';
import '../services/utils.dart';
import 'heart_btt.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({
    super.key,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
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
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    bool? _isInWishList =
        wishlistProvider.getwishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            //GlobalMethods.navigateTo(
            //  ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.23,
                width: size.width * 0.22,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Textwidget(
                        text: productModel.title,
                        color: color,
                        maxLines: 1,
                        textSize: 17,
                        isTitle: false,
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: HeartBttm(
                          productId: productModel.id,
                          isInWishlist: _isInWishList,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: _quantityTextController.text,
                        isonsale: productModel.isOnsale,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: Textwidget(
                              text: productModel.isPiece ? 'Pcs' : 'Kg',
                              color: color,
                              textSize: 12,
                              isTitle: true,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                                controller: _quantityTextController,
                                key: const ValueKey('10\$'),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 18,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Quantity is missed';
                                  }
                                  return null;
                                },
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.green,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.,]')),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value.isEmpty) {
                                      _quantityTextController.text = '1';
                                    } else {
                                      // total = usedPrice *
                                      //     int.parse(_quantityTextController.text);
                                    }
                                  });
                                },
                                onSaved: (value) {}),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                //  width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : () async {
                          // if (_isInCart) {
                          //   return;
                          // }
                          final User? user = authInstance.currentUser;

                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subTitle:
                                    'No user found, thanks for login first ',
                                context: context);
                            return;
                          }
                          await GlobalMethods.addTocart(
                              productId: productModel.id,
                              quantity: int.parse(_quantityTextController.text),
                              context: context);
                          await cartProvider.featchCart();
                          // cartProvider.addProductsToCart(
                          //     productId: productModel.id,
                          //     quantity:
                          //         int.parse(_quantityTextController.text));
                        },
                  // ignore: sort_child_properties_last
                  child: Textwidget(
                    text: _isInCart ? 'In cart' : 'Add to cart',
                    maxLines: 1,
                    color: _isInCart ? Colors.red : color,
                    textSize: 17,
                    isTitle: true,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
