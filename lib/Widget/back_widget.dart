import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../services/utils.dart';

class BackWidgets extends StatelessWidget {
  const BackWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        IconlyLight.arrowLeft2,
        color: color,
        size: 17,
      ),
    );
  }
}
