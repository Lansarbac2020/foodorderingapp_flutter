import 'package:flutter/widgets.dart';

class WishlistModel with ChangeNotifier {
  final String id, productId;

  WishlistModel({
    required this.id,
    required this.productId,
  });
}
