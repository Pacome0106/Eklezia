import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/screens/graphique_screen.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../movie_page.dart';

class AnalysticScreen extends StatefulWidget {
  const AnalysticScreen({super.key});

  @override
  State<AnalysticScreen> createState() => _AnalysticScreenState();
}

class _AnalysticScreenState extends State<AnalysticScreen> {
  int userCount = 0;
  int playMovie = 0;
  int videoCount = 0;
  int activity = 0;
  Future getUsersCount() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('church', isEqualTo: paroisse)
        .get()
        .then((value) {
      userCount = value.docs.length;
      setState(() => userCount);
    });
  }

  Future getMoviesCount() async {
    var date = DateTime.now();
    DateTime dateView = DateTime.utc(date.year, date.month, date.day);
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('playMovie/');
    starCountRef.onValue.listen((event) async {
      final data = event.snapshot.value as Map;
      List view = [];
      view.addAll(data.values);

      for (int i = 0; i < view.length; i++) {
        if (view[i]['date'] < dateView.microsecondsSinceEpoch) {
          await starCountRef.child(view[i]['uid']).remove();
        }
      }
    });
    starCountRef
        .orderByChild('date')
        .equalTo(dateView.microsecondsSinceEpoch)
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List view = [];
      view.addAll(data);
      playMovie = view.length;
      setState(() => playMovie);
    });
  }

  Future getMovies() async {
    await FirebaseFirestore.instance
        .collection('videos')
        .where('church', isEqualTo: paroisse)
        .get()
        .then((value) {
      videoCount = value.docs.length;
      setState(() => videoCount);
    });
  }

  Future getActivity() async {
    var date = DateTime.now();
    DateTime dateActif = DateTime.utc(date.year, date.month, date.day);
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('activity/');
    starCountRef.onValue.listen((event) async {
      final data = event.snapshot.value as Map;
      List actifs = [];
      actifs.addAll(data.values);

      for (int i = 0; i < actifs.length; i++) {
        if (actifs[i]['date'] < dateActif.microsecondsSinceEpoch) {
          await starCountRef.child(actifs[i]['uid']).remove();
        }
      }
    });
    starCountRef
        .orderByChild('date')
        .equalTo(dateActif.microsecondsSinceEpoch)
        .onValue
        .listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List actifs = [];
      actifs.addAll(data);
      activity = actifs.length;
      setState(() => activity);
    });
  }

  @override
  void initState() {
    getUsersCount();
    getMoviesCount();
    getActivity();
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: ScrollAnimation(
                'Analyse',
                'analyse',
                Theme.of(context).hintColor,
                30,
                currentIndex: 3,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedbox,
                        AppTextLarge(
                          text:
                              "L'analyse jounalier de la paroisse sera indiqué ici pour les statistiques.",
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                        sizedbox,
                        sizedbox,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Graphique(
                                  userCount: userCount,
                                  playMovie: playMovie,
                                  videoCount: videoCount,
                                  activity: activity,
                                ),
                              ),
                            );
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.graphic_eq_rounded,
                                  size: 30,
                                  color: AppColors.activColor,
                                )
                              ]),
                        ),
                        sizedbox,
                        sizedbox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cardAnalystic(
                              Icons.groups_outlined,
                              "Nombre d'utilisateur : ",
                              userCount,
                            ),
                            cardAnalystic(
                              Icons.play_circle_outline,
                              "Vidéos lus /jour : ",
                              playMovie,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cardAnalystic(
                              Icons.accessibility_sharp,
                              "Personnes actives / jour : ",
                              activity,
                            ),
                            cardAnalystic(
                              Icons.movie_creation_outlined,
                              "Nombres de video : ",
                              videoCount,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardAnalystic(IconData icon, String title, int value) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).focusColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: Theme.of(context).hintColor,
            ),
            sizedbox,
            AppTextLarge(
              text: title,
              color: Theme.of(context).hintColor,
              size: 20,
            ),
            sizedbox,
            AppTextLarge(
              text: '$value',
              color: AppColors.activColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
