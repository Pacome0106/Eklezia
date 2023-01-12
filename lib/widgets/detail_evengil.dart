// ignore_for_file: unrelated_type_equality_checks

import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:flutter/material.dart';

class DetailEvengile extends StatelessWidget {
  const DetailEvengile({
    super.key,
    required this.verset,
    required this.temps,
    required this.evengile,
    required this.date,
    required this.index,
  });
  final String verset;
  final String temps;
  final String evengile;
  final String date;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  iconSize: 35,
                  padding: const EdgeInsets.all(0),
                  color: AppColors.activColor,
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    if (verset != '' &&
                        temps != '' &&
                        evengile != '' &&
                        date != 0) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/screens/evengil_screen', (route) => false);
                    }
                  }),
              Hero(
                tag: 'evengile$index',
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppTextLarge(
                            text: 'Evengile',
                            color: Theme.of(context).hintColor,
                            size: 22,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: AppText(
                              text: date,
                              size: 16,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Flexible(
                            child: AppText(
                              text: temps,
                              size: 16,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      sizedbox,
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: Theme.of(context).focusColor,
                              ),
                              child: AppTextLarge(
                                  text: 'Verset : $verset',
                                  size: 18,
                                  color: Theme.of(context).bottomAppBarColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: AppText(
                          text: evengile,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
