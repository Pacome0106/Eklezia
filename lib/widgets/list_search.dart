// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unnecessary_null_comparison
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/play_movie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class ListSearch extends StatelessWidget {
  const ListSearch({
    super.key,
    required this.titre,
    required this.urlImage,
    required this.urlVideo,
    required this.duration,
    required this.date,
    required this.search,
    required this.videos,
    required this.allVideos,
    required this.theuserUid,
  });
  final String titre;
  final String urlImage;
  final String urlVideo;
  final String duration;
  final String date;
  final String search;
  final List videos;
  final List allVideos;
  final String theuserUid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
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
                      urlImage,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      frameBuilder: (_, image, loadingBuilder, __) {
                        if (loadingBuilder == null) {
                          return const SizedBox(
                            width: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return image;
                      },
                      loadingBuilder: (BuildContext context, Widget image,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return image;
                        }
                        return SizedBox(
                          width: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
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
                      route: 'search',
                      videoUrl: urlVideo,
                      titre: titre,
                      duration: duration,
                      search: search,
                      videos: videos,
                      allVideos: allVideos,
                      theuserUid: theuserUid,
                    ),
                  ),
                  (route) => false,
                );
                DatabaseReference ref = FirebaseDatabase.instance
                    .ref("playMovie/$theuserUid$titre");
                await ref.set({
                  'uid': theuserUid + titre,
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
                    titre,
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
                    text: "Duration : $duration",
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: AppText(
                    text: date,
                    color: Theme.of(context).cardColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
