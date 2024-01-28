// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/back_widget.dart';
import 'package:food_app/Widget/empty_screen.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/models/wishlist_model.dart';
import 'package:food_app/providers/wishlist_providers.dart';

import 'package:food_app/screens/Wishlist/wishlist_widget.dart';
import 'package:provider/provider.dart';

// import '../../providers/cart_providers.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WishListScreen extends StatelessWidget {
  static const routeName = "/WishListScreen";
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size size = Utils(context).getscreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final WishlistItemsList =
        wishlistProvider.getwishlistItems.values.toList().reversed.toList();
    final Color color = Utils(context).color;
    return WishlistItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your Wishlist is empty ',
            subtitle: 'Explore more and shorlist some items',
            buttonText: 'Add a wish',
            imagePath:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7NRcN-pmti5EYK9rZRALoKpg6O4ZT1owj4A&usqp=CAU',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidgets(),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Textwidget(
                text: 'Whishlist(${WishlistItemsList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.WarningDialog(
                        title: 'Empty your wishlist ? ',
                        subTitle: "Are you sure ? ",
                        fct: () async {
                          await wishlistProvider.clearOnlineWishlist();
                          wishlistProvider.clearLocalWishlist();
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
            body: MasonryGridView.count(
              itemCount: WishlistItemsList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 10,
              // crossAxisSpacing: 14,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: WishlistItemsList[index],
                    child: const Wishlistwidget());
              },
            ),
          );
  }
}
