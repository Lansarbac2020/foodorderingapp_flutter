import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/heart_btt.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/inner_screen/product_details.dart';
import 'package:food_app/models/wishlist_model.dart';
// import 'package:food_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../providers/product_providers.dart';
import '../../providers/wishlist_providers.dart';
import '../../services/utils.dart';

class Wishlistwidget extends StatelessWidget {
  const Wishlistwidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrProduct =
        productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrProduct.isOnsale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    bool? _isInWishList =
        wishlistProvider.getwishlistItems.containsKey(getCurrProduct.id);
    final Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: wishlistModel.productId);
          },
          child: Container(
            height: size.height * 0.25,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.6),
              border: Border.all(color: color, width: 0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    // width: size.width * 0.2,
                    height: size.width * 0.25,
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.imageUrl,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                IconlyLight.bag2,
                                color: color,
                              ),
                            ),
                            HeartBttm(
                              productId: getCurrProduct.id,
                              isInWishlist: _isInWishList,
                            ),
                          ],
                        ),
                      ),
                      Textwidget(
                        text: getCurrProduct.title,
                        color: color,
                        textSize: 20,
                        maxLines: 2,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Textwidget(
                        text: '\$${usedPrice.toStringAsFixed(2)}',
                        color: color,
                        textSize: 20,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
