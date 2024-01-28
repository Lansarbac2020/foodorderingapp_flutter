import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/price_widget.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/inner_screen/product_details.dart';
import 'package:food_app/providers/viewed_provider.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:provider/provider.dart';

import '../consts/fire_const.dart';
import '../models/products_models.dart';
import '../providers/cart_providers.dart';
import '../providers/wishlist_providers.dart';
import 'heart_btt.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({super.key});

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    // ignore: unused_local_variable
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getscreenSize;

    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishList =
        wishlistProvider.getwishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);

            //  GlobalMethods.navigateTo(
            //    ctx: context, routeName: ProductDetails.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      height: size.width * 0.245,
                      width: size.width * 0.245,
                      boxFit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        Textwidget(
                          text: productModel.isPiece ? '1Pcs' : '1Kg',
                          color: color,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
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
                                          productId: productModel.id,
                                          quantity: 1,
                                          context: context);
                                      await cartProvider.featchCart();
                                      // cartProvider.addProductsToCart(
                                      //     productId: productModel.id,
                                      //     quantity: 1);
                                    },
                              child: Icon(
                                _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                size: 22,
                                color: _isInCart ? Colors.green : color,
                              ),
                            ),
                            HeartBttm(
                              productId: productModel.id,
                              isInWishlist: _isInWishList,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                  isonsale: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                Textwidget(
                  text: productModel.title,
                  color: color,
                  textSize: 15,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
