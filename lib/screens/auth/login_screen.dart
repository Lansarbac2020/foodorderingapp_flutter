import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Widget/text_widgets.dart';
import 'package:food_app/consts/const.dart';
import 'package:food_app/fetch_screen.dart';
import 'package:food_app/screens/auth/forget_password.dart';
import 'package:food_app/screens/auth/register.dart';
// ignore: unused_import
import 'package:food_app/screens/bottom_bar.dart';
import 'package:food_app/screens/loading_manager.dart';
import 'package:food_app/services/global_methods.dart';

import '../../Widget/auth_bttm.dart';
import '../../Widget/googlebttm.dart';
import '../../consts/fire_const.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FetchScreen(),
          ),
        );
        print('Succefully logged in');
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
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 900,
              autoplayDelay: 2000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Consts.authimagePaths[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: Consts.authimagePaths.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.56),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 125.0,
                    ),
                    Textwidget(
                      text: 'Welcome Back',
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 9.0,
                    ),
                    Textwidget(
                      text: 'Sign-in to continue',
                      color: Colors.white,
                      textSize: 17,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email adress !';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Adress Email",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          // PASWORD
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            controller: _passTextController,
                            focusNode: _passFocusNode,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a valid password !';
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(
                              ctx: context,
                              routeName: ForgetPasswordScreen.routeName);
                        },
                        child: const Text(
                          'Forget password ?',
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 17.5,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthBottom(
                      fct: () {
                        _submitFormOnLogin();
                      },
                      buttonText: 'Login',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Googlebtm(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Textwidget(
                          text: 'OR',
                          color: Colors.white,
                          textSize: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthBottom(
                      fct: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FetchScreen(),
                        ));
                      },
                      buttonText: 'Continue as a guest',
                      primary: Colors.black87,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account ? ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.5,
                          ),
                          children: [
                            TextSpan(
                                text: ' Sign-UP',
                                style: const TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w400),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    GlobalMethods.navigateTo(
                                        ctx: context,
                                        routeName: RegisterScreen.routeName);
                                  }),
                          ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
