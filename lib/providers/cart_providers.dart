// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/consts/fire_const.dart';
import 'package:food_app/models/cat-model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  // void addProductsToCart({
  //   required String productId,
  //   required int quantity,
  // }) {
  //   _cartItems.putIfAbsent(
  //     productId,
  //     () => CartModel(
  //       id: DateTime.now().toString(),
  //       productId: productId,
  //       quantity: quantity,
  //     ),
  //   );
  //   notifyListeners();
  // }

  final usercollection = FirebaseFirestore.instance.collection('users');

  Future<void> featchCart() async {
    final User? user = authInstance.currentUser;

    final DocumentSnapshot userDoc = await usercollection.doc(user!.uid).get();
    if (userDoc == null) {
      return;
    }

    final leng = userDoc.get('userCart').length;
    for (int i = 0; i < leng; i++) {
      _cartItems.putIfAbsent(
          userDoc.get('userCart')[i]['productId'],
          () => CartModel(
                id: userDoc.get('userCart')[i]['cartId'],
                productId: userDoc.get('userCart')[i]['productId'],
                quantity: userDoc.get('userCart')[i]['quantity'],
              ));
    }
    notifyListeners();
  }

  void reduceQuatityByOne(String productId) {
    _cartItems.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    notifyListeners();
  }

  void IncreaseQuatityByOne(String productId) {
    _cartItems.update(
        productId,
        (value) => CartModel(
              id: value.id,
              productId: productId,
              quantity: value.quantity + 1,
            ));
    notifyListeners();
  }

  Future<void> removeOneItem(
      {required String cartId,
      required String productId,
      required int quantity}) async {
    final User? user = authInstance.currentUser;
    await usercollection.doc(user!.uid).update({
      'userCart': FieldValue.arrayRemove([
        {
          'cartId': cartId,
          'productId': productId,
          'quantity': quantity,
        }
      ])
    });
    _cartItems.remove(productId);
    await featchCart();

    notifyListeners();
  }

  Future<void> clearOnlineCart() async {
    final User? user = authInstance.currentUser;
    await usercollection.doc(user!.uid).update({
      'userCart': [],
    });
    _cartItems.clear();
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
