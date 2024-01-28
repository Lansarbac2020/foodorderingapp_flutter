import 'package:flutter/material.dart';
import 'package:food_app/Widget/text_widgets.dart';

import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {super.key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isonsale});
  final double salePrice, price;
  final String textPrice;
  final bool isonsale;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    double userPrice = isonsale ? salePrice : price;
    return FittedBox(
      child: Row(children: [
        Textwidget(
          text: '\$${(userPrice * int.parse(textPrice)).toStringAsFixed(2)}',
          color: Colors.orange,
          textSize: 17,
        ),
        SizedBox(
          width: 5,
        ),
        Visibility(
          visible: isonsale ? true : false,
          child: Text(
            '\$${(price * int.parse(textPrice)).toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 15,
                color: color,
                decoration: TextDecoration.lineThrough),
          ),
        ),
      ]),
    );
  }
}
