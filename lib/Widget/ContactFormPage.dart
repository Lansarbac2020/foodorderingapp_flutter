//import 'package:clippy_flutter/message.dart';
// ignore: unused_import
// import 'dart:html';

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:food_app/Widget/text_widgets.dart';
// ignore: unused_import
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/services/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  static const routeName = '/ContactUsScreen';

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool isFaqOpen = false;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getscreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () =>
              Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 17,
          ),
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Contact-Us',
          style: TextStyle(color: color, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Adress'),
              subtitle: Text(
                'kemalpasa mahallesi, serdivan, sakarya',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Phone Number'),
              subtitle: Text(
                '+905346603826',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () async {
                final phoneNumber = '+905346603826';
                final url = 'tel:$phoneNumber';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  // Handle the case where the app can't launch the phone app.
                  // You can display an error message or take other actions here.
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('E-mail'),
              subtitle: Text(
                'info.lansardevflutter@gmail.com',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () async {
                final emailAddress =
                    'info.lansardevflutter@gmail.com'; // Replace with your actual email address
                final subject =
                    'Contact Us'; // You can specify the email subject

                final url = 'mailto:$emailAddress?subject=$subject';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Email App Not Found'),
                        content: Text(
                            'Unable to open the email app. Please check if you have an email app installed.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isFaqOpen = !isFaqOpen; // Inverser l'état actuel
                });
              },
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Textwidget(
                          text: isFaqOpen ? 'Close FAQ' : 'Open FAQ',
                          color: isFaqOpen ? Colors.red : color,
                          isTitle: true,
                          textSize: 15)),
                  Icon(
                    isFaqOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: color,
                  ),
                ],
              ),
            ),
            if (isFaqOpen)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text('How can I place an order?'),
                    subtitle: Text(
                        'To place an order, go to the menu, select your items, and click on the "Add to cart button" then go to cart page and click on "confirm the ordering" button after we will contact you .'),
                  ),
                  SizedBox(height: 8.0),
                  ListTile(
                    title: Text('What payment methods do you accept?'),
                    subtitle: Text(
                        'Actually we only accept cash on delivery for payments.'),
                  ),
                  SizedBox(height: 8.0),
                  ListTile(
                    title: Text('How long does delivery take?'),
                    subtitle: Text(
                        'Delivery times vary depending on your location. It usually takes between 30 minutes to 1 hour.'),
                  ),
                  SizedBox(height: 8.0),
                  ListTile(
                    title: Text('What are your delivery hours?'),
                    subtitle: Text(
                        'Our delivery service is available from 10:00 AM to 10:00 PM every day.'),
                  ),
                  SizedBox(height: 8.0),
                  ListTile(
                    title: Text('Do you have a loyalty program?'),
                    subtitle: Text(
                        'Yes, we have a loyalty program where you can earn points for every order.'),
                  ),
                  // Ajoutez autant de questions et réponses que nécessaire
                ],
              ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
