import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/inner_screen/feeds_screen.dart';
import 'package:food_app/services/global_methods.dart';

import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText});
  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    final themeState = Utils(context).getTheme;
    Size size = Utils(context).getscreenSize;
    // ignore: unused_local_variable
    final Color color = Utils(context).color;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/HomePage', // Replace '/cart' with the route name for CartPage
            (route) => false, // Pop all routes until CartPage is reached
          ),
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 17,
          ),
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Image.network(
              imagePath,
              width: double.infinity,
              height: size.height * 0.4,
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              "Whoops !",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 38,
                  fontWeight: FontWeight.w700),
            ),
            Textwidget(text: title, color: Colors.blueAccent, textSize: 19),
            const SizedBox(
              height: 20,
            ),
            Textwidget(text: subtitle, color: Colors.blueAccent, textSize: 19),
            SizedBox(
              height: size.height * 0.09,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  // primary: Theme.of(context).colorScheme.secondary,
                  //onPrimary: color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: FeedsScreen.routeName);
                },
                child: Textwidget(
                  text: buttonText,
                  color: themeState ? Colors.grey.shade300 : Colors.black,
                  textSize: 20,
                  isTitle: true,
                ))
          ],
        ),
      )),
    );
  }
}
