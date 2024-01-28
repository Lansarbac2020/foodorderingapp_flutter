import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/back_widget.dart';
import 'package:food_app/Widget/empty_prod.dart';
// ignore: unused_import
import 'package:food_app/consts/const.dart';
import 'package:food_app/models/products_models.dart';
import 'package:food_app/providers/product_providers.dart';
import 'package:provider/provider.dart';

import '../Widget/feed_items.dart';
import '../Widget/text_widgets.dart';
import '../services/utils.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedScreenState";
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.fetchProducts();
    super.initState();
  }

  List<ProductModel> listProductSearch = [];

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getscreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidgets(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Textwidget(
            text: 'All the Products',
            color: color,
            isTitle: true,
            textSize: 24),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {
                      listProductSearch = productProvider.searchQuery(value);
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1),
                    ),
                    hintText: "What's in your mind",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchTextController!.clear();
                        _searchTextFocusNode.unfocus();
                      },
                      icon: Icon(
                        Icons.close,
                        color:
                            _searchTextFocusNode.hasFocus ? Colors.red : color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _searchTextController!.text.isNotEmpty && listProductSearch.isEmpty
                ? const EmptyProductsWidget(
                    text: 'No products found, please try another keyword !',
                  )
                : GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    // crossAxisSpacing: 10,
                    childAspectRatio: size.width / (size.height * 0.71),
                    children: List.generate(
                      _searchTextController!.text.isNotEmpty
                          ? listProductSearch.length
                          : allProduct.length,
                      (index) {
                        return ChangeNotifierProvider.value(
                            value: _searchTextController!.text.isNotEmpty
                                ? listProductSearch[index]
                                : allProduct[index],
                            child: const FeedWidget());
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
