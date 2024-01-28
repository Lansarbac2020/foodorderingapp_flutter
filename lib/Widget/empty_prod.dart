import 'package:flutter/material.dart';
import 'package:food_app/services/utils.dart';

class EmptyProductsWidget extends StatelessWidget {
  const EmptyProductsWidget({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset('lib/assets/images/emptybox1.jpg'),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
