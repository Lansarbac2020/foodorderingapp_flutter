import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/consts/const.dart';
import 'package:food_app/consts/fire_const.dart';
import 'package:food_app/providers/cart_providers.dart';
// import 'package:food_app/providers/orders_providers.dart';
import 'package:food_app/providers/product_providers.dart';
import 'package:food_app/providers/wishlist_providers.dart';
import 'package:food_app/screens/bottom_bar.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Consts.authimagePaths;

  @override
  void initState() {
    images.shuffle();
    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      // final ordersProvider =
      //   Provider.of<OrdersProvider>(context, listen: false);
      final User? user = authInstance.currentUser;
      if (user == null) {
        await productsProvider.fetchProducts();
        cartProvider.clearLocalCart();
        wishlistProvider.clearLocalWishlist();
        //ordersProvider.clearLocalOrders();
      } else {
        await productsProvider.fetchProducts();
        await cartProvider.featchCart();
        await wishlistProvider.featchwishlist();
      }

      // // ignore: use_build_context_synchronously
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomBarscreen(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          images[0],
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        const Center(
          child: SpinKitFadingFour(color: Colors.white),
        ),
      ],
    ));
  }
}
