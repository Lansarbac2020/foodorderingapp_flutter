// ignore: unused_import

import 'dart:convert';
// ignore: unused_import
import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/screens/Cart/cart_screen.dart';
import 'package:food_app/screens/HomePage.dart';
import 'package:http/http.dart' as http;
// import 'package:food_app/card_form_screen.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:food_app/controlller/language_controller.dart';
import 'package:food_app/inner_screen/cat_screen.dart';
import 'package:food_app/inner_screen/feeds_screen.dart';
import 'package:food_app/inner_screen/on_sale_screen.dart';
import 'package:food_app/inner_screen/product_details.dart';
import 'package:food_app/providers/dark_theme_provider.dart';
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/providers/orders_providers.dart';
import 'package:food_app/providers/product_providers.dart';
import 'package:food_app/providers/viewed_provider.dart';
import 'package:food_app/providers/wishlist_providers.dart';

import 'package:food_app/screens/Wishlist/wishlist_screen.dart';
import 'package:food_app/screens/auth/forget_password.dart';
import 'package:food_app/screens/auth/login_screen.dart';
import 'package:food_app/screens/auth/register.dart';

import 'package:food_app/screens/orders/orders_screen.dart';
import 'package:food_app/screens/viewed_recently/viewed_screen.dart';
// import 'package:food_app/services/app_consts.dart';
// import 'package:food_app/services/app_routes.dart';
// import 'package:food_app/services/messages.dart';
// import 'package:mailer/mailer.dart';
import 'package:provider/provider.dart';

import 'Widget/ContactFormPage.dart';
import 'card_form_screen.dart';
import 'consts/theme_data.dart';
import 'fetch_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:appwrite/appwrite.dart';

Client client = Client();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     "pk_test_51NpWarCPgLzS29LzmvQQHvDcXuOvziP8LTUFmcYQGzbhdJ0D6sqNwRlIM9B6kKyxNXAHEw3TkTB2zTg7iiHDVytF00rg4Gyyy5";
  // Stripe.instance.applySettings();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //_MyAppState();

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                    body: Center(
                  child: CircularProgressIndicator(),
                )));
          } else if (Snapshot.hasError) {
            const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                    body: Center(
                  child: Text('An error ocurred'),
                )));
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(create: (_) => ProductsProvider()),
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(create: (_) => CartProvider()),
                ChangeNotifierProvider(create: (_) => WishlistProvider()),
                ChangeNotifierProvider(create: (_) => ViewedProdProvider()),
                ChangeNotifierProvider(create: (_) => OrdersProvider()),
              ],
              child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Food App ',
                    theme:
                        Styles.themeData(themeProvider.getDarkTheme, context),
                    home: AnimatedSplashScreen(
                      nextScreen: FetchScreen(),
                      splashTransition: SplashTransition.fadeTransition,
                      backgroundColor: Colors.white,
                      duration: 5000,
                      centered: true,
                      splash: 'lib/assets/images/appliicone.png',
                    ),
                    routes: {
                      OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                      FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                      ProductDetails.routeName: (ctx) => const ProductDetails(),
                      WishListScreen.routeName: (ctx) => const WishListScreen(),
                      OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                      ViewedRecentlyScreen.routeName: (ctx) =>
                          const ViewedRecentlyScreen(),
                      RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                      LoginScreen.routeName: (ctx) => const LoginScreen(),
                      ForgetPasswordScreen.routeName: (ctx) =>
                          const ForgetPasswordScreen(),
                      CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                      ContactUsScreen.routeName: (ctx) => ContactUsScreen(),
                      CardFormScreen.routeName: (ctx) => CardFormScreen(),
                      '/cart': (context) => CartScreen(),
                      '/HomePage': (context) => FetchScreen(),
                    },
                  );
                },
              ));
        });
  }
}
