// ignore_for_file: non_constant_identifier_names

import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/lign.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

WidgetMovie(BuildContext context) {
  return Container(
    color: AppColors.mainColor,
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Theme.of(context).focusColor,
        ),
        sizedbox,
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).focusColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: 200,
                height: 15,
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        Lign(
            indent: MediaQuery.of(context).size.width * 0.20,
            endIndent: MediaQuery.of(context).size.width * 0.20),
      ],
    ),
  );
}
