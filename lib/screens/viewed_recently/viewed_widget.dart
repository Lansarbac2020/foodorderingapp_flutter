import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/models/views_model.dart';
import 'package:provider/provider.dart';

import '../../consts/fire_const.dart';
// import '../../inner_screen/product_details.dart';
import '../../providers/cart_providers.dart';
import '../../providers/product_providers.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyWidgetState createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProdModel = Provider.of<ViewedProdModel>(context);
    final getCurrProduct =
        productProvider.findProdById(viewedProdModel.productId);
    double usedPrice = getCurrProduct.isOnsale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);
    Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // GlobalMethods.navigateTo(
          //     ctx: context, routeName: ProductDetails.routeName);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: getCurrProduct.imageUrl,
              boxFit: BoxFit.fill,
              height: size.width * 0.27,
              width: size.width * 0.25,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                Textwidget(
                  text: getCurrProduct.title,
                  color: color,
                  textSize: 17,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                Textwidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 15,
                  isTitle: false,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isInCart
                        ? null
                        : () async {
                            final User? user = authInstance.currentUser;

                            if (user == null) {
                              GlobalMethods.errorDialog(
                                  subTitle:
                                      'No user found, thanks for login first ',
                                  context: context);
                              return;
                            }
                            await GlobalMethods.addTocart(
                                productId: getCurrProduct.id,
                                quantity: 1,
                                context: context);
                            await cartProvider.featchCart();
                            // cartProvider.addProductsToCart(
                            //     productId: getCurrProduct.id, quantity: 1);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isInCart ? Icons.check : IconlyBold.plus,
                        color: Colors.white,
                        size: 17,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
