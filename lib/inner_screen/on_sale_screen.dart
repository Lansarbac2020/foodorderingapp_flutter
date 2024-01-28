import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/On_sale_widget.dart';
import 'package:food_app/Widget/back_widget.dart';
import 'package:food_app/Widget/empty_prod.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:provider/provider.dart';

import '../models/products_models.dart';
import '../providers/product_providers.dart';
import '../services/utils.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productOnSale = productProviders.getOnSaleProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidgets(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Textwidget(
            text: 'Products on Sale',
            color: color,
            isTitle: true,
            textSize: 24),
      ),
      body: productOnSale.isEmpty
          ? const EmptyProductsWidget(
              text: 'No Products on Sale yet !, \nStay tuned ')
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.48),
              children: List.generate(
                productOnSale.length,
                (index) {
                  return ChangeNotifierProvider.value(
                    value: productOnSale[index],
                    child: const OnSaleWidget(),
                  );
                },
              ),
            ),
    );
  }
}
