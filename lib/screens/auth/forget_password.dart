import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_app/Widget/auth_bttm.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/consts/const.dart';
import 'package:food_app/consts/fire_const.dart';
import 'package:food_app/screens/loading_manager.dart';
import 'package:food_app/services/global_methods.dart';

import '../../services/utils.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  bool _isLoading = false;
  void _forgetPassFCT() async {
    if (_emailTextController.text.isEmpty ||
        !_emailTextController.text.contains('@')) {
      GlobalMethods.errorDialog(
          subTitle: 'Please enter a correct email address', context: context);
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await authInstance.sendPasswordResetEmail(
            email: _emailTextController.text.toLowerCase());
        Fluttertoast.showToast(
          msg: "An email has been sent to your email address",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subTitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subTitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getscreenSize;
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Consts.authimagePaths[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: Consts.authimagePaths.length,

              // control: const SwiperControl(),
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  const BackButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  Textwidget(
                    text: 'Forget password',
                    color: Colors.white,
                    textSize: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: _emailTextController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthBottom(
                    buttonText: 'Reset now',
                    fct: () {
                      _forgetPassFCT();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
