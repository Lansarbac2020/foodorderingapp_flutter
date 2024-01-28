import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/text_widgets.dart';

import 'package:food_app/screens/Categories.dart';
import 'package:food_app/screens/HomePage.dart';
import 'package:food_app/screens/user.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../providers/cart_providers.dart';
import 'Cart/cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class BottomBarscreen extends StatefulWidget {
  const BottomBarscreen({super.key});

  @override
  State<BottomBarscreen> createState() => _BottomBarscreen();
}

class _BottomBarscreen extends State<BottomBarscreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'Page': const HomePage(), 'title': 'Home Screen'},
    {'Page': CategoriesScreen(), 'title': 'Categories Screen'},
    {'Page': const CartScreen(), 'title': 'Cart Screen'},
    {'Page': const UserScreen(), 'title': 'User Screen'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    bool _isDark = themeState.getDarkTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectedIndex]['title']),
      //  ),
      body: _pages[_selectedIndex]['Page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: _isDark ? Colors.white : Colors.black12,
        selectedItemColor: _isDark ? Colors.lightBlue : Colors.black87,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
              return badges.Badge(
                  badgeAnimation: badges.BadgeAnimation.slide(),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.circle,
                    badgeColor: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  position: badges.BadgePosition.topEnd(top: -7, end: -7),
                  badgeContent: FittedBox(
                      child: Textwidget(
                          text: myCart.getCartItems.length.toString(),
                          color: Colors.white,
                          textSize: 15)),
                  child: Icon(
                      _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy));
            }),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
