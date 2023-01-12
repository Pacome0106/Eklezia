import 'package:flutter/material.dart';
import '../pages/home_page.dart';

// page qui possede une fonction de bloc de notiffication
void notification(BuildContext context, String text, double height) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      elevation: 10,
      duration: const Duration(seconds: 3),
      content: Container(
        padding: const EdgeInsets.all(10),
        height: height,
        alignment: Alignment.center,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).focusColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 16,
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ),
    ),
  );
}
