import 'package:flutter/material.dart';
// import 'package:food_app/models/cat-model.dart';

import '../models/views_model.dart';
// ignore: unused_import
import '../models/wishlist_model.dart';

class ViewedProdProvider with ChangeNotifier {
  Map<String, ViewedProdModel> _viewedProdlistItems = {};

  Map<String, ViewedProdModel> get getviewedProdlistItems {
    return _viewedProdlistItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdlistItems.putIfAbsent(
        productId,
        () => ViewedProdModel(
            id: DateTime.now().toString(), productId: productId));
    notifyListeners();
  }

  void clearHistory() {
    _viewedProdlistItems.clear();
    notifyListeners();
  }
}
