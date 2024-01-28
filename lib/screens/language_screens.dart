import 'package:flutter/material.dart';
import 'package:food_app/controlller/language_controller.dart';
import 'package:food_app/models/language_model.dart';
import 'package:food_app/screens/language_widget.dart';
import 'package:food_app/services/utils.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return Column(
          children: [
            Expanded(
              child: Center(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  'lib/assets/images/marketicone.png',
                                  width: 120,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Your food ordering App',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 190),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'select_language'.tr,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                ),
                                itemCount: 2,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => LanguageWidget(
                                  languageModel:
                                      localizationController.languages[index],
                                  localizationController:
                                      localizationController,
                                  index: index,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'you_can_change_language'.tr,
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      })),
    );
  }
}
