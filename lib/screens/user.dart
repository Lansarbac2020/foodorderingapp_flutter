// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/consts/fire_const.dart';
import 'package:food_app/screens/Wishlist/wishlist_screen.dart';
import 'package:food_app/screens/auth/forget_password.dart';
import 'package:food_app/screens/auth/login_screen.dart';
import 'package:food_app/screens/loading_manager.dart';
import 'package:food_app/screens/orders/orders_screen.dart';
import 'package:food_app/screens/viewed_recently/viewed_screen.dart';
import 'package:food_app/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../Widget/ContactFormPage.dart';
import '../providers/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: '');
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;

  bool _isLoading = false;

  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping addres');
        _addressTextController.text = userDoc.get('shipping addres');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subTitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
// ignore: unused_local_variable
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      text: 'Hi,    ',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: _name == null ? 'user' : _name,
                          style: TextStyle(
                            color: color,
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('My name is pressed');
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Textwidget(
                    text: _email == null ? 'user email' : _email!,
                    color: color,
                    textSize: 17,
                    isTitle: true,
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.blue,
                    thickness: 2,
                  ),
                  const SizedBox(height: 20),
                  _ListTitle(
                    title: 'Address',
                    subtitle: address,
                    icon: IconlyBold.profile,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                    color: color,
                  ),
                  _ListTitle(
                    title: 'Orders',
                    icon: IconlyBold.bag,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: OrdersScreen.routeName);
                    },
                    color: color,
                  ),
                  _ListTitle(
                    title: 'Wishlist',
                    icon: IconlyBold.heart,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: WishListScreen.routeName);
                    },
                    color: color,
                  ),
                  _ListTitle(
                    title: 'Viewed',
                    icon: IconlyBold.show,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ViewedRecentlyScreen.routeName);
                    },
                    color: color,
                  ),
                  _ListTitle(
                    title: 'Forget password',
                    icon: IconlyBold.unlock,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    color: color,
                  ),
                  SwitchListTile(
                    title: Textwidget(
                      text:
                          themeState.getDarkTheme ? 'Dark mode' : ' Light mode',
                      color: color,
                      textSize: 14,
                      isTitle: true,
                    ),
                    secondary: Icon(themeState.getDarkTheme
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _ListTitle(
                    title: user == null ? 'Login' : 'Logout',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        return;
                      }
                      GlobalMethods.WarningDialog(
                          title: 'Log Out',
                          subTitle: "Are you sure to Logout",
                          fct: () async {
                            await authInstance.signOut();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                          },
                          context: context);
                    },
                    color: color,
                  ),
                  _ListTitle(
                    title: 'About-Us',
                    icon: IconlyBold.infoSquare,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: ContactUsScreen.routeName);
                    },
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Adress'),
          content: TextField(
            //onChanged: (value) {
            //  print(
            //      ' _addressTextController.text ${_addressTextController.text}');
            // },
            controller: _addressTextController,
            maxLines: 5,

            decoration: const InputDecoration(hintText: "Users's adrress"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String _uid = user!.uid;
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(_uid)
                      .update({
                    'shipping addres': _addressTextController.text,
                  });

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  setState(() {
                    address = _addressTextController.text;
                  });
                } catch (err) {
                  GlobalMethods.errorDialog(
                      subTitle: err.toString(), context: context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

Widget _ListTitle({
  required String title,
  String? subtitle,
  required IconData icon,
  required Function onPressed,
  required Color color,
}) {
  return ListTile(
    title: Textwidget(
      text: title,
      color: color,
      textSize: 14,
      isTitle: true,
    ),
    subtitle: Textwidget(
      text: subtitle == null ? "" : subtitle,
      color: color,
      textSize: 18,
    ),
    leading: Icon(icon),
    trailing: const Icon(IconlyLight.arrowRight2),
    onTap: () {
      onPressed();
    },
  );
}
