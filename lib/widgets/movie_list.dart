// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unnecessary_null_comparison
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/lign.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eklezia/widgets/play_movie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class ListMovie extends StatefulWidget {
  const ListMovie({
    super.key,
    required this.id,
    required this.titre,
    required this.imageUrl,
    required this.videoUrl,
    required this.duration,
    required this.date,
    required this.isVideo,
    required this.videos,
    required this.permission,
    required this.theuserUid,
  });
  final String id;
  final String titre;
  final String imageUrl;
  final String videoUrl;
  final String duration;
  final String date;
  final bool isVideo;
  final List videos;
  final bool permission;
  final String theuserUid;

  @override
  State<ListMovie> createState() => _ListMovieState();
}

class _ListMovieState extends State<ListMovie> {
  ChewieController? chewieController;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        widget.permission
            ? showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        AlertDialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.only(
                              left: 40, right: 40, bottom: 40),
                          alignment: Alignment.bottomCenter,
                          contentPadding: const EdgeInsets.only(
                              left: 0, top: 0, right: 0, bottom: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: borderRadius),
                          content: Column(
                            children: [
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: AppColors.alertColor2,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 30,
                                            height: 30,
                                            child:
                                                const CircularProgressIndicator
                                                    .adaptive(),
                                          ),
                                        );
                                      },
                                    );
                                    final storageRefVideo =
                                        FirebaseStorage.instance.ref('videos');
                                    final storageRefPhotos =
                                        FirebaseStorage.instance.ref('photos');
                                    final desertRefPhotos =
                                        storageRefPhotos.child(widget.titre);
                                    final desertRefVideos =
                                        storageRefVideo.child(widget.titre);
                                    // Delete the file
                                    await desertRefPhotos
                                        .delete()
                                        .then((value) async {
                                      await desertRefVideos
                                          .delete()
                                          .then((value) async {
                                        await FirebaseFirestore.instance
                                            .collection('videos')
                                            .doc(widget.id)
                                            .delete()
                                            .then((value) {
                                          notification(
                                              context, 'Video supprimée !', 50);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  currentIndex: 0,
                                                ),
                                              ),
                                              (route) => false);
                                        }).catchError((error) {
                                          notification(context,
                                              'La suppression à échouer !', 50);
                                          Navigator.of(context).pop();
                                        });
                                      }).catchError((error) {
                                        notification(context,
                                            'La suppression à échouer !', 50);
                                        Navigator.of(context).pop();
                                      });
                                    }).catchError((error) {
                                      notification(context,
                                          'La suppression à échouer !', 50);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Center(
                                    heightFactor: 2,
                                    child: Text(
                                      'Supprimer la video',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColors.poweroffColor,
                                          fontSize: 18,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : null;
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            widget.isVideo
                ? Stack(alignment: Alignment.center, children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Image.network(
                            widget.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            frameBuilder: (_, image, loadingBuilder, __) {
                              if (loadingBuilder == null) {
                                return const AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.activColor,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return image;
                            },
                            loadingBuilder: (BuildContext context, Widget image,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return image;
                              return AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.activColor),
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, e, ___) => Center(
                              child: Icon(
                                Icons.report_problem,
                                size: 30,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            height: 20,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: borderRadius,
                            ),
                            child: AppText(
                              text: widget.duration,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var date = DateTime.now();
                        DateTime dateView =
                            DateTime.utc(date.year, date.month, date.day);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayVideo(
                              route: 'videos',
                              videoUrl: widget.videoUrl,
                              titre: widget.titre,
                              duration: widget.duration,
                              search: '',
                              videos: widget.videos,
                              allVideos: const [],
                              theuserUid: widget.theuserUid,
                            ),
                          ),
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
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(141, 0, 0, 0),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 30,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                  ])
                : AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
            SizedBox(
              height: 65,
              width: double.infinity,
              child: Row(
                children: [
                  widget.isVideo
                      ? CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).focusColor,
                          backgroundImage: NetworkImage(widget.imageUrl),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).focusColor,
                        ),
                  widget.isVideo
                      ? Container(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 230,
                                child: Text(
                                  widget.titre,
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
                              const SizedBox(height: 8),
                              AppText(
                                text: widget.date,
                                color: Theme.of(context).cardColor,
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hoverColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 100,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hoverColor,
                                  borderRadius: borderRadius,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Lign(
                indent: MediaQuery.of(context).size.width * 0.20,
                endIndent: MediaQuery.of(context).size.width * 0.20),
          ],
        ),
      ),
    );
  }
}
