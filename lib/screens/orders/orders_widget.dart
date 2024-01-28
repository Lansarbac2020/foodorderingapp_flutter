import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/models/orders_model.dart';
import 'package:food_app/providers/product_providers.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../services/utils.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final formatter = DateFormat('HH:mm');
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    final formattedTime = formatter.format(orderDate);
    orderDateToShow =
        '${orderDate.day}/${orderDate.month}/${orderDate.year} at $formattedTime';

    super.didChangeDependencies();
    // Text(
    //   orderDateToShow,
    //   style: TextStyle(fontSize: 14),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    return ListTile(
      subtitle:
          Text('Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}'),

      // onTap: () {
      //   GlobalMethods.navigateTo(
      //       ctx: context, routeName: ProductDetails.routeName);
      // },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: Textwidget(
          text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color,
          textSize: 14),
      trailing: Textwidget(text: orderDateToShow, color: color, textSize: 15),
    );
  }
}
