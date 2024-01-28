import 'package:flutter/material.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/inner_screen/cat_screen.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class CategorieWidget extends StatelessWidget {
  const CategorieWidget(
      {super.key,
      required this.catText,
      required this.imgPath,
      required this.passedColor});
  final String catText, imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: catText);
      },
      child: Container(
        //height: _screenWidth * 0.7,
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: passedColor.withOpacity(0.7), width: 3),
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth * 0.4,
              width: _screenWidth * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      imgPath,
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            Textwidget(
              text: catText,
              color: color,
              textSize: 14,
              isTitle: true,
            )
          ],
        ),
      ),
    );
  }
}
