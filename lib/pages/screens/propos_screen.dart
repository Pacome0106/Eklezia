import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:flutter/material.dart';

class ProposScreen extends StatelessWidget {
  const ProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                delegate: ScrollAnimation(
                    'A propos', '/home', Theme.of(context).hintColor, 30.0)),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 300,
                        width: double.maxFinite,
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          image: const DecorationImage(
                              image: AssetImage('images/CDEX1515.JPG'),
                              fit: BoxFit.cover),
                        ),
                        child: Hero(
                          tag: 'contact',
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Hero(
                                    tag: 'contact',
                                    child: AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).focusColor,
                                      insetPadding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      title: Column(
                                        children: [
                                          Center(
                                            child: AppTextLarge(
                                              text: 'Contacts :',
                                              size: 16,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ),
                                          sizedbox,
                                          AppText(
                                            text: '+243 975 024 769',
                                            color: Theme.of(context).cardColor,
                                          ),
                                          AppText(
                                            text: '+243 972 876 858',
                                            color: Theme.of(context).cardColor,
                                          )
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: borderRadius),
                                      contentPadding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 30,
                                        right: 30,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 5,
                                ),
                                color: Theme.of(context).focusColor,
                              ),
                              child: const Icon(Icons.phone,
                                  color: AppColors.activColor, size: 30),
                            ),
                          ),
                        ),
                      ),
                      sizedbox,
                      AppTextLarge(
                        text: 'Bibliographie : ',
                        size: 20,
                        color: Theme.of(context).hintColor,
                      ),
                      sizedbox,
                      Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: AppText(
                          text: """
                        Deux garçons Congolais qui se sont rencontré au College Saint Anne et on fait les études en semble jusqu'à leur prochaine recontré à Kinshasa.
                        Il se sont mis en sembles pour apprendre et réaliser des differentes projet d'application mobile , jusqu'au point de s'imager sur l'application qui aidera à ameliorer la commication et la repatition des information à temps utile et à tout le temps!!! """,
                          color: Theme.of(context).cardColor,
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
