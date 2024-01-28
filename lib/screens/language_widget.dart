import 'package:flutter/material.dart';
import 'package:food_app/controlller/language_controller.dart';
import 'package:food_app/models/language_model.dart';
import 'package:food_app/services/app_consts.dart';

import '../services/utils.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;

  LanguageWidget(
      {required this.languageModel,
      required this.localizationController,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return InkWell(
      onTap: () {
        localizationController.setLanguage(Locale(
            AppConstants.languages[index].languageCode,
            AppConstants.languages[index].countryCode));
        localizationController.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1)
          ],
        ),
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  languageModel.languageName,
                ),
              ],
            ),
          ),
          localizationController.selectedIndex == index
              ? Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 40,
                  child: Icon(Icons.check_circle, color: color, size: 25),
                )
              : SizedBox(),
        ]),
      ),
    );
  }
}
