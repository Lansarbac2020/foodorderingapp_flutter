import 'package:flutter/material.dart';
import 'package:food_app/fetch_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome(); // Appel de la fonction de navigation au démarrage de l'écran
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500)); // Délai de 1.5 secondes

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => FetchScreen()), // Remplace l'écran actuel par FetchScreen
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Image.asset(
                'lib/assets/images/marketicone.png',
                width: 200,
                height: 100,
              ),
            ]),
            Container(
              child: Text(
                'Your Ordering App',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
