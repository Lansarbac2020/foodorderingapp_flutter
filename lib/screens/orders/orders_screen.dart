import 'package:flutter/material.dart';
import 'package:food_app/Widget/back_widget.dart';
import 'package:food_app/Widget/empty_screen.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/providers/orders_providers.dart';

import 'package:provider/provider.dart';

import '../../services/utils.dart';

import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ordersList.isEmpty
              ? const EmptyScreen(
                  title: 'You did\'nt place any order yet',
                  subtitle: 'order something and make me happy :)',
                  buttonText: 'Shop now',
                  imagePath:
                      'https://img.freepik.com/vecteurs-libre/illustration-concept-vide_114360-7416.jpg?size=626&ext=jpg&ga=GA1.2.1278914853.1685783879&semt=ais',
                )
              : Scaffold(
                  appBar: AppBar(
                    leading: const BackWidgets(),
                    elevation: 0.9,
                    centerTitle: false,
                    title: Textwidget(
                      text: 'Your orders (${ordersList.length})',
                      color: color,
                      textSize: 17.0,
                      isTitle: true,
                    ),
                    backgroundColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  body: ListView.separated(
                    itemCount: ordersList.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                          value: ordersList[index],
                          child: const OrderWidget(),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: color,
                        thickness: 1,
                      );
                    },
                  ));
        });
  }
}
