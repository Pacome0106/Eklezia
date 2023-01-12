// ignore_for_file: avoid_print, library_private_types_in_public_api, unused_import

import 'package:chewie/chewie.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/lign.dart';
import 'package:eklezia/widgets/rotation_animation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import '../pages/home_page.dart';
import '../pages/report_page.dart';
import '../pages/screens/search_screen.dart';

class PlayVideo extends StatefulWidget {
  const PlayVideo({
    super.key,
    required this.route,
    required this.videoUrl,
    required this.titre,
    required this.duration,
    required this.search,
    required this.videos,
    required this.allVideos,
    required this.theuserUid,
  });
  final String route;
  final String videoUrl;
  final String titre;
  final String duration;
  final String search;
  final List videos;
  final List allVideos;
  final String theuserUid;

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController controller;
  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(
                        controller: ChewieController(
                          videoPlayerController: controller,
                          autoPlay: true,
                          looping: true,
                          autoInitialize: true,
                          zoomAndPan: false,
                          allowedScreenSleep: false,
                          materialProgressColors: ChewieProgressColors(
                            backgroundColor: const Color(0x8D000000),
                            bufferedColor: const Color(0xFFECA233),
                            playedColor: AppColors.mainColor,
                          ),
                          placeholder: Container(
                            color: Colors.black87,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.activColor,
                                ),
                              ),
                            ),
                          ),
                          errorBuilder: (context, errorMessage) {
                            return const Center(
                              child: Icon(
                                Icons.report_problem,
                                size: 30,
                                color: AppColors.mainColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 35,
                      padding: const EdgeInsets.all(0),
                      color: AppColors.mainColor,
                      icon: const Icon(Icons.navigate_before),
                      onPressed: () {
                        widget.route == 'videos'
                            ? Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    currentIndex: 0,
                                  ),
                                ),
                                (route) => false,
                              )
                            : Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScreachScreen(
                                    search: widget.search,
                                    videos: widget.allVideos,
                                  ),
                                ),
                                (route) => false,
                              );
                      },
                    ),
                  ],
                ),
                sizedbox,
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: AppTextLarge(
                    text: widget.titre,
                    size: 16,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                sizedbox,
                const Lign(indent: 0, endIndent: 0),
                sizedbox,
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.videos.length,
                itemBuilder: (context, index) {
                  var now = DateTime.fromMicrosecondsSinceEpoch(
                      widget.videos[index]['date']);
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 10),
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Theme.of(context).focusColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Builder(builder: (context) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    widget.videos[index]['imageUrl'],
                                    width: 100,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    frameBuilder:
                                        (_, image, loadingBuilder, __) {
                                      if (loadingBuilder == null) {
                                        return const SizedBox(
                                          width: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                AppColors.activColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return image;
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget image,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return image;
                                      }
                                      return SizedBox(
                                        width: 100,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, e, ___) => Center(
                                      child: Center(
                                        child: Icon(
                                          Icons.report_problem,
                                          size: 35,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.titre == widget.videos[index]['title']
                                      ? const AnimatedLogo()
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0x8D000000),
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                ],
                              );
                            }),
                            onTap: () async {
                              var date = DateTime.now();
                              DateTime dateView =
                                  DateTime.utc(date.year, date.month, date.day);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayVideo(
                                    route: widget.route,
                                    videoUrl: widget.videos[index]['videoUrl'],
                                    titre: widget.videos[index]['title'],
                                    duration: widget.videos[index]['duration'],
                                    search: widget.search,
                                    videos: widget.videos,
                                    allVideos: const [],
                                    theuserUid: widget.theuserUid,
                                  ),
                                ),
                                (route) => false,
                              );
                              DatabaseReference ref = FirebaseDatabase.instance.ref(
                                  "playMovie/${widget.theuserUid}${widget.titre}");
                              await ref.set({
                                'uid': widget.theuserUid + widget.titre,
                                'date': dateView.microsecondsSinceEpoch,
                              }).catchError((error) {
                                print(error.toString());
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 180,
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.videos[index]['title'],
                                  style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                              sizedbox,
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: AppText(
                                  text: "Durée : ${widget.duration}",
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: AppText(
                                  text:
                                      "${now.day} ${months[now.month - 1]} ${now.year} ",
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
