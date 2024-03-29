import 'package:flutter/material.dart';
import 'package:food_app/Widget/text_widgets.dart';

class AuthBottom extends StatelessWidget {
  const AuthBottom({
    super.key,
    required this.fct,
    required this.buttonText,
    this.primary = Colors.white38,
  });
  final Function fct;
  final String buttonText;
  final Color primary;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primary,
        ),
        onPressed: () {
          fct();
        },
        child: Textwidget(
          text: buttonText,
          color: Colors.white,
          textSize: 18,
        ),
      ),
    );
  }
}
