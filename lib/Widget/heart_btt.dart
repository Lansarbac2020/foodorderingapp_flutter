import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/consts/fire_const.dart';
import 'package:food_app/providers/wishlist_providers.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:provider/provider.dart';

// ignore: duplicate_import
import '../providers/product_providers.dart';
// import '../providers/wishlist_providers.dart';

import '../services/utils.dart';

class HeartBttm extends StatefulWidget {
  const HeartBttm(
      {super.key, required this.productId, this.isInWishlist = false});
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBttm> createState() => _HeartBttmState();
}

class _HeartBttmState extends State<HeartBttm> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;

          // ignore: unnecessary_null_comparison
          if (user == null) {
            await GlobalMethods.errorDialog(
                subTitle: 'No user found, thanks for login first ',
                context: context);
            return;
          }

          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethods.addToWishList(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                wishlistId:
                    wishlistProvider.getwishlistItems[getCurrProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.featchwishlist();
          setState(() {
            loading = false;
          });
        } catch (error) {
          GlobalMethods.errorDialog(subTitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false;
          });
        }

        // print('user id is ${user.uid}');
        //  wishlistProvider.AddRemoveProductToWishlist(productId: productId);
      },
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 15, width: 15, child: CircularProgressIndicator()),
            )
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              size: 22,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? Colors.red
                  : color,
            ),
    );
  }
}
