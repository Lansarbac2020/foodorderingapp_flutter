import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/back_widget.dart';
import 'package:food_app/providers/viewed_provider.dart';
import 'package:food_app/screens/viewed_recently/viewed_widget.dart';

import 'package:provider/provider.dart';

import '../../Widget/empty_screen.dart';
import '../../Widget/text_widgets.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class ViewedRecentlyScreen extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';

  const ViewedRecentlyScreen({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyScreenState createState() => _ViewedRecentlyScreenState();
}

class _ViewedRecentlyScreenState extends State<ViewedRecentlyScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    // bool _isEmpty = true;
    // Size size = Utils(context).getScreenSize;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemsList = viewedProdProvider.getviewedProdlistItems.values
        .toList()
        .reversed
        .toList();
    if (viewedProdItemsList.isEmpty) {
      return const EmptyScreen(
        title: 'Your history is empty ',
        subtitle: 'No products has been viewed yet',
        buttonText: 'Shop now',
        imagePath:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs0bA0GCZyuAenfvJET3s8A6VWEHrcUdpcPw&usqp=CAU',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.WarningDialog(
                    title: 'Empty your history',
                    fct: () {
                      viewedProdProvider.clearHistory();
                    },
                    context: context,
                    subTitle: 'Are you sure ? ');
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            )
          ],
          leading: const BackWidgets(),
          automaticallyImplyLeading: false,
          elevation: 1,
          centerTitle: true,
          title: Textwidget(
            text: 'History',
            color: color,
            textSize: 19.0,
            isTitle: true,
          ),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.builder(
            itemCount: viewedProdItemsList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: ChangeNotifierProvider.value(
                    value: viewedProdItemsList[index],
                    child: const ViewedRecentlyWidget()),
              );
            }),
      );
    }
  }
}
