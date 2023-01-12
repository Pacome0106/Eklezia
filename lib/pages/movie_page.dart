// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/add_pages/add_movie.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/screens/search_screen.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/movie_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/app_text.dart';
import '../widgets/colors.dart';
import '../widgets/detail_evengil.dart';

const List months = [
  "jan",
  "feb",
  "mar",
  "apr",
  "may",
  "jun",
  "jul",
  "aug",
  "sep",
  "oct",
  "nov",
  "dec"
];

List files = [];
List names = [];
DateTime? evengilDate;
bool textEvengile = false;
User? theuser;
String paroisse = '';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  SqlDb sqlDb = SqlDb();
  List evengils = [];
  List videos = [];
  Map<String, dynamic>? userData;

  Future getUser() async {
    theuser = FirebaseAuth.instance.currentUser;
    if (theuser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(theuser!.uid)
          .get()
          .then((value) {
        userData = value.data();
      });
      if (userData != null) {
        isUser = true;
        paroisse = userData!['church'];
        if (!mounted) {
          return;
        }
        setState(() {
          isUser;
          paroisse;
        });
        readVideo();
      }
    }
  }

  textPopupEvengil() async {
    var date = DateTime.now();
    evengilDate = DateTime.utc(date.year, date.month, date.day);
    if (!textEvengile) {
      readOneEvengil();
      await sqlDb.deleteEvengil(evengilDate!.microsecondsSinceEpoch);
    }
  }

  readOneEvengil() async {
    List<Map> responses =
        await sqlDb.readOneEvengil(evengilDate!.microsecondsSinceEpoch);
    evengils.addAll(responses);
    if (responses.isNotEmpty) {
      textEvengile = true;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) {
          var date = DateTime.fromMicrosecondsSinceEpoch(evengils[0]['date']);
          return Hero(
            tag: 'evengile0',
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailEvengile(
                      verset: evengils[0]['verset'],
                      temps: evengils[0]['temps'],
                      evengile: evengils[0]['evengile'],
                      date:
                          "${date.day} ${months[date.month - 1]} ${date.year}",
                      index: 0,
                    ),
                  ),
                );
              },
              child: AlertDialog(
                backgroundColor: Theme.of(context).focusColor,
                insetPadding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                title: AppTextLarge(
                    text:
                        "Aujourd'hui ${date.day} ${months[date.month - 1]} ${date.year} ",
                    size: 18,
                    color: Theme.of(context).hintColor),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                alignment: Alignment.center,
                contentPadding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                content: SizedBox(
                  height: 170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evengils[0]['temps'],
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            letterSpacing: 0),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // new
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).focusColor,
                        ),
                        child: AppTextLarge(
                          text: 'Verset : ${evengils[0]['verset']}',
                          size: 16,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          evengils[0]['evengile'],
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            decoration: TextDecoration.none,
                            letterSpacing: 0,
                          ),
                          softWrap: false,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // new
                        ),
                      ),
                      sizedbox,
                      sizedbox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  color: Theme.of(context).indicatorColor),
                              height: 30,
                              width: 120,
                              child: AppTextLarge(
                                text: 'Fermer',
                                size: 18,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  bool isVideo = false;
  bool isUser = false;
  bool isData = false;
  var data;

  @override
  void initState() {
    getUser();
    textPopupEvengil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          // controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.27,
              toolbarHeight: MediaQuery.of(context).size.height * 0.2,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: borderRadius),
                            color: Theme.of(context).dividerColor,
                            icon: const Icon(Icons.more_vert,
                                color: AppColors.activColor, size: 30),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.church,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                        sizedbox2,
                                        AppText(
                                          text: 'Paroisse',
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                        const SizedBox(width: 10),
                                        AppText(
                                          text: 'Lectionnaire',
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit_note,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                        const SizedBox(width: 10),
                                        AppText(
                                          text: 'Bloc note',
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                        const SizedBox(width: 10),
                                        AppText(
                                          text: 'Paramètre',
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 5,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.report,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                        ),
                                        const SizedBox(width: 10),
                                        AppText(
                                          text: 'A propos',
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            onSelected: (value) async {
                              if (value == 1) {
                                //paroisses
                                Navigator.pushNamed(
                                    context, '/screens/church_screen');
                              } else if (value == 2) {
                                //evengile
                                Navigator.pushNamed(
                                    context, '/screens/evengil_screen');
                              } else if (value == 3) {
                                Navigator.pushNamed(
                                    context, '/screens/bloc_note');
                                //bloc note
                              } else if (value == 4) {
                                //paramètre
                                Navigator.pushNamed(
                                    context, '/screens/setting_screen');
                              } else if (value == 5) {
                                // a propos
                                Navigator.pushNamed(
                                    context, '/screens/propos_screen');
                              } else {
                                //null
                              }
                            })
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppTextLarge(
                        text: 'Eklezia',
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppTextLarge(
                        text: paroisse,
                        size: 18,
                        color: AppColors.activColor,
                      ),
                    ),
                  ],
                ),
              ),
              bottom: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 0,
                title: Hero(
                  tag: 'searchSreen',
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScreachScreen(
                          videos: videos,
                          search: '',
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 8),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: borderRadius,
                        border: Border.all(
                            color: Theme.of(context).dividerColor, width: 2),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Theme.of(context).cardColor,
                            ),
                            sizedbox2,
                            AppText(
                              text: 'Recherche...',
                              color: Theme.of(context).cardColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, index) {
                  var now = DateTime.fromMicrosecondsSinceEpoch(
                      videos.isNotEmpty ? videos[index]['date'] : 0);

                  return ListMovie(
                    id: videos.isNotEmpty ? videos[index].id.toString() : '',
                    titre: videos.isNotEmpty ? videos[index]['title'] : '',
                    imageUrl:
                        videos.isNotEmpty ? videos[index]['imageUrl'] : '',
                    videoUrl:
                        videos.isNotEmpty ? videos[index]['videoUrl'] : '',
                    duration:
                        videos.isNotEmpty ? videos[index]['duration'] : '',
                    date: "${now.day} ${months[now.month - 1]} ${now.year} ",
                    isVideo: isVideo,
                    videos: videos.isNotEmpty ? videos : [],
                    permission: isUser
                        ? userData!['role'] == 'Prêtre'
                            ? true
                            : false
                        : false,
                    theuserUid: theuser != null ? theuser!.uid.toString() : '',
                  );
                },
                childCount: videos.isNotEmpty ? videos.length : 5,
              ),
            )
          ],
        ),
        floatingActionButton: isUser
            ? userData!['role'] == 'Prêtre'
                ? FloatingActionButton(
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    shape: const CircleBorder(side: BorderSide.none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddMovies(
                              route: 'communique', groupe: 'paroisse'),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add_to_queue,
                      size: 30,
                      color: Theme.of(context).shadowColor,
                    ),
                  )
                : const SizedBox()
            : const SizedBox());
  }

  readVideo() async {
    await FirebaseFirestore.instance
        .collection('videos')
        .where('church', isEqualTo: paroisse)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var video in value.docs) {
        videos.add(video);
      }
    });
    if (videos.isNotEmpty) {
      isVideo = true;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      isVideo;
      videos;
    });
  }
}
