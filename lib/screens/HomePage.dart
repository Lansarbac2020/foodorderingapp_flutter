import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/feed_items.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/consts/const.dart';
import 'package:food_app/inner_screen/feeds_screen.dart';
import 'package:food_app/inner_screen/on_sale_screen.dart';
// ignore: unused_import
import 'package:food_app/providers/dark_theme_provider.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:food_app/services/utils.dart';
import 'package:provider/provider.dart';

import '../Widget/On_sale_widget.dart';
import '../models/products_models.dart';
import '../providers/product_providers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final Utils utils = Utils(context);
    // ignore: unused_local_variable
    final themeState = Utils(context).getTheme;
    final Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Center(
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      Consts.offerImages[index],
                      fit: BoxFit.fill,
                    );
                  },
                  autoplay: true,
                  itemCount: Consts.offerImages.length,
                  pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.orange),
                  ),
                  control: SwiperControl(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () {
                GlobalMethods.navigateTo(
                    ctx: context, routeName: OnSaleScreen.routeName);
              },
              child: Textwidget(
                  text: 'All the products on Sale',
                  color: Colors.orange,
                  maxLines: 1,
                  isTitle: true,
                  textSize: 17),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(
                    children: [
                      Textwidget(
                        text: "On Sale".toUpperCase(),
                        color: Colors.red,
                        textSize: 22,
                        isTitle: true,
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                      itemCount: productsOnSale.length < 10
                          ? productsOnSale.length
                          : 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: productsOnSale[index],
                            child: const OnSaleWidget());
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Textwidget(
                    text: 'Our Products',
                    color: color,
                    textSize: 17,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: Textwidget(
                        text: 'Browse all',
                        color: Colors.orange,
                        maxLines: 1,
                        isTitle: true,
                        textSize: 17),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.7),
              children: List.generate(
                allProduct.length < 4 ? allProduct.length : 4,
                (index) {
                  return ChangeNotifierProvider.value(
                      value: allProduct[index], child: const FeedWidget());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
