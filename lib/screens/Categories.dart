// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/Categories_widgets.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/fetch_screen.dart';
import 'package:food_app/inner_screen/feeds_screen.dart';
import 'package:food_app/screens/HomePage.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';

// ignore: must_be_immutable
class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});
  List<Color> gridColors = [
    const Color(0xffFDE598),
    const Color(0xff53B175),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
    Color.fromARGB(255, 213, 60, 4),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'lib/assets/images/bananes.jpg',
      'catText': 'Fruits',
    },
    {
      'imgPath': 'lib/assets/images/salade.jpg',
      'catText': 'vegetables',
    },
    {
      'imgPath': 'lib/assets/images/pizza.jpg',
      'catText': 'Take-away',
    },
    {
      'imgPath': 'lib/assets/images/makaroni.jpg',
      'catText': 'Food',
    },
    {
      'imgPath': 'lib/assets/images/poissongrille.jpg',
      'catText': 'Poissons',
    },
    {
      'imgPath': 'lib/assets/images/jusmango.webp',
      'catText': 'Juice',
    },
    {
      'imgPath': 'lib/assets/images/spcices.jpg',
      'catText': 'Spices',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
          text: 'Categories',
          color: color,
          textSize: 20,
          isTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 10, // vertical spacing
          mainAxisSpacing: 20, //horizontal spacing
          children: List.generate(
            7,
            (index) {
              return CategorieWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
