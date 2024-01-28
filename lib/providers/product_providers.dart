import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_app/models/products_models.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnsale).toList();
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _productsList = [];
      // _productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('title'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('productCategoryName'),
              price: double.parse(
                element.get('price'),
              ),
              salePrice: element.get('salePrice'),
              isOnsale: element.get('isOnSale'),
              isPiece: element.get('isPiece'),
            ));
      });
    });
    notifyListeners();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return _searchList;
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

//   static final List<ProductModel> _productsList = [
//     ProductModel(
//       id: 'Apricot',
//       title: 'Apricot',
//       price: 0.99,
//       salePrice: 0.49,
//       imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
//       productCategoryName: 'Fruits',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Bananas',
//       title: 'Bananas',
//       price: 0.88,
//       salePrice: 0.5,
//       imageUrl: 'https://www.linkpicture.com/q/bananas.png',
//       productCategoryName: 'Fruits',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Pizza',
//       title: 'Pizza',
//       price: 12.22,
//       salePrice: 11.7,
//       imageUrl: 'https://www.linkpicture.com/q/pizza12.png',
//       productCategoryName: 'Take-away',
//       isOnsale: true,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Orange',
//       title: 'Orange',
//       price: 1.5,
//       salePrice: 0.5,
//       imageUrl: 'https://www.linkpicture.com/q/orange_6.png',
//       productCategoryName: 'Fruits',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Strawberry',
//       title: 'Strawberry',
//       price: 0.99,
//       salePrice: 0.4,
//       imageUrl: 'https://www.linkpicture.com/q/straw.png',
//       productCategoryName: 'Fruits',
//       isOnsale: false,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Red apple',
//       title: 'Red apple',
//       price: 0.6,
//       salePrice: 0.2,
//       imageUrl: 'https://i.ibb.co/crwwSG2/red-apple.png',
//       productCategoryName: 'Fruits',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     // Vegi
//     ProductModel(
//       id: 'Carottes',
//       title: 'Carottes',
//       price: 0.99,
//       salePrice: 0.5,
//       imageUrl: 'https://i.ibb.co/TRbNL3c/Carottes.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Lahmacun',
//       title: 'Lahmacun',
//       price: 1.99,
//       salePrice: 0.99,
//       imageUrl: 'https://www.linkpicture.com/q/lahmacun-Turkiye.png',
//       productCategoryName: 'Take-away',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Attieke',
//       title: 'Attieke',
//       price: 0.99,
//       salePrice: 0.5,
//       imageUrl: 'https://www.linkpicture.com/q/Attieke.png',
//       productCategoryName: 'Food',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Salade',
//       title: 'Salade',
//       price: 1.99,
//       salePrice: 0.89,
//       imageUrl: 'https://www.linkpicture.com/q/saladedefruit.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Riz-maffe',
//       title: 'Riz-maffe',
//       price: 2.99,
//       salePrice: 1.59,
//       imageUrl: 'https://www.linkpicture.com/q/riz-maffe.png',
//       productCategoryName: 'Food',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Onions',
//       title: 'Onions',
//       price: 0.59,
//       salePrice: 0.28,
//       imageUrl: 'https://i.ibb.co/GFvm1Zd/Onions.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: false,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Biryani',
//       title: 'Biryani',
//       price: 0.99,
//       salePrice: 0.389,
//       imageUrl: 'https://www.linkpicture.com/q/biryaniiaa.png',
//       productCategoryName: 'Food',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Potato',
//       title: 'Potato',
//       price: 0.99,
//       salePrice: 0.59,
//       imageUrl: 'https://i.ibb.co/wRgtW55/Potato.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Burger',
//       title: 'Burger',
//       price: 0.99,
//       salePrice: 0.79,
//       imageUrl: 'https://www.linkpicture.com/q/burgerw.png',
//       productCategoryName: 'Take-away',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Juice',
//       title: 'Juice',
//       price: 0.99,
//       salePrice: 0.57,
//       imageUrl: 'https://www.linkpicture.com/q/juice.png',
//       productCategoryName: 'Juice',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Boisson-gazeuse',
//       title: 'Boisson',
//       price: 3.99,
//       salePrice: 2.99,
//       imageUrl: 'https://www.linkpicture.com/q/boisson-gazeuse.png',
//       productCategoryName: 'Juice',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Avocado',
//       title: 'Avocado',
//       price: 0.99,
//       salePrice: 0.39,
//       imageUrl: 'https://www.linkpicture.com/q/Avocado.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: true,
//       isPiece: true,
//     ),
//     // Grains
//     ProductModel(
//       id: 'Pineapple',
//       title: 'Pineapple',
//       price: 0.29,
//       salePrice: 0.19,
//       imageUrl: 'https://www.linkpicture.com/q/ananas.png',
//       productCategoryName: 'Fruits',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Peas',
//       title: 'Peas',
//       price: 0.99,
//       salePrice: 0.49,
//       imageUrl: 'https://i.ibb.co/7GHM7Dp/peas.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: false,
//       isPiece: false,
//     ),
//     // Herbs
//     ProductModel(
//       id: 'Patates-meal',
//       title: 'Patates-meal',
//       price: 6.99,
//       salePrice: 4.99,
//       imageUrl: 'https://www.linkpicture.com/q/viande-potatos.png',
//       productCategoryName: 'Food',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Milk-Shake',
//       title: 'Milk-Shake',
//       price: 0.99,
//       salePrice: 0.89,
//       imageUrl: 'https://www.linkpicture.com/q/milk-shake.png',
//       productCategoryName: 'Juice',
//       isOnsale: true,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Poisson-braise',
//       title: 'Poisson-Braiser',
//       price: 1.99,
//       salePrice: 0.99,
//       imageUrl: 'https://www.linkpicture.com/q/poisson-grille.png',
//       productCategoryName: 'Poissons',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Adana-kebap',
//       title: 'Adana-kebap',
//       price: 0.99,
//       salePrice: 0.5,
//       imageUrl: 'https://www.linkpicture.com/q/adana-kebap.png',
//       productCategoryName: 'Take-away',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Spaghetti',
//       title: 'Spaghetti',
//       price: 0.99,
//       salePrice: 0.5,
//       imageUrl: 'https://www.linkpicture.com/q/spaghetti.png',
//       productCategoryName: 'Food',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Chiken',
//       title: 'Chiken',
//       price: 0.99,
//       salePrice: 0.5,
//       imageUrl: 'https://www.linkpicture.com/q/chiken.png',
//       productCategoryName: 'Food',
//       isOnsale: false,
//       isPiece: true,
//     ),
//     ProductModel(
//       id: 'Tomatoes',
//       title: 'Tomatoes',
//       price: 0.89,
//       salePrice: 0.59,
//       imageUrl: 'https://www.linkpicture.com/q/tomatoes.png',
//       productCategoryName: 'Vegetables',
//       isOnsale: true,
//       isPiece: false,
//     ),
//     ProductModel(
//       id: 'Poisson Frais',
//       title: 'Poisson-Frais',
//       price: 8.99,
//       salePrice: 6.5,
//       imageUrl: 'https://www.linkpicture.com/q/poisson12.png',
//       productCategoryName: 'Poissons',
//       isOnsale: true,
//       isPiece: true,
//     ),
//   ];
}
