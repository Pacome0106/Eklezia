// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import '../pages/home_page.dart';
import '../widgets/app_text_large.dart';
import '../widgets/colors.dart';
import '../widgets/notification.dart';
import '../widgets/scroll_animation.dart';

class AddMovies extends StatefulWidget {
  const AddMovies({super.key, required String groupe, required String route});

  @override
  State<AddMovies> createState() => _AddMoviesState();
}

class _AddMoviesState extends State<AddMovies> {
  TextEditingController titre = TextEditingController();
  final storageRefVideo = FirebaseStorage.instance.ref('videos');
  final storageRefPhotos = FirebaseStorage.instance.ref('photos');
  String? fileName = '';
  File? file;
  String urlVideo = '';
  String urlPhoto = '';

  // select a file in the phone
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.first.path!;

        etatvideo = true;
        controller = VideoPlayerController.file(File(fileName!));
      });
    }
  }

  sendMovie() async {
    //save a file
    if (titre.text != '') {
      if (fileName! != '') {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                child: const CircularProgressIndicator.adaptive(),
              ),
            );
          },
        );
        // capturer une photo dans une video
        final thumbnailFile = await VideoCompress.getFileThumbnail(fileName!,
            quality: 75, // default(100)
            position: -1 // default(-1)
            );
        // enregistrer une video sur Storage Firebase
        var resulat = await storageRefVideo
            .child(titre.text.trim())
            .putFile(File(fileName!));
        if (resulat != null) {
          //si la video est envoyée en enregistre la photo aussi
          var resulat2 = await storageRefPhotos
              .child(titre.text.trim())
              .putFile(thumbnailFile);
          if (resulat2 != null) {
            //retrait des urls pour la video et la photo
            final islandRefVideo = storageRefVideo.child(titre.text.trim());
            urlVideo = await islandRefVideo.getDownloadURL();
            final islandRefPhoto = storageRefPhotos.child(titre.text.trim());
            urlPhoto = await islandRefPhoto.getDownloadURL();
            addVideo();
          }
        }
        notification(context, 'Video postée !!!', 50);
        fileName = "";
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              currentIndex: 0,
            ),
          ),
          (route) => false,
        );
      } else {
        notification(context, 'Veillez selectionner la video svp !!!', 50);
      }
    } else {
      notification(context, 'Veillez  écrire le titre de la video svp !!!', 50);
    }
  }

  // add video in firestore Database
  Future addVideo() async {
    DateTime now = DateTime.now();
    Duration duration = controller!.value.duration;
    await FirebaseFirestore.instance.collection('videos').add({
      'church': 'Saint Eloi',
      'title': titre.text.trim(),
      'imageUrl': urlPhoto,
      'videoUrl': urlVideo,
      'duration':
          "${duration.inHours}:${duration.inMinutes}:${duration.inSeconds}",
      'date': now.microsecondsSinceEpoch,
    });
  }

  @override
  void dispose() {
    titre.dispose();
    super.dispose();
  }

  VideoPlayerController? controller;
  bool etatvideo = false;
  bool etatTitre = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: ScrollAnimation(
                'Ajout video ',
                '/home',
                Theme.of(context).hintColor,
                30,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedbox,
                        sizedbox,
                        AppTextLarge(
                          text: 'Titre',
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                        sizedbox,
                        Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          decoration: !etatTitre
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).focusColor,
                                )
                              : const BoxDecoration(),
                          child: TextField(
                            maxLines: 1,
                            minLines: 1,
                            controller: titre,
                            cursorColor: Theme.of(context).hintColor,
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 16,
                                fontFamily: 'Nunito'),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefix: const SizedBox(width: 10),
                              hintText: 'ajouter un titre...',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 16,
                                  fontFamily: 'Nunito'),
                            ),
                            keyboardType: TextInputType.text,
                            onTap: () {
                              setState(() {
                                etatTitre = true;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: AppTextLarge(
                            text: 'Video',
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        sizedbox,
                        fileName != ""
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //select a movie
                                      selectFile();
                                    },
                                    child: AppTextLarge(
                                      text: "Modifier",
                                      size: 16,
                                      color: AppColors.activColor,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        sizedbox,
                        GestureDetector(
                          onTap: () {
                            //select a movie
                            selectFile();
                          },
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              height: 210,
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: Theme.of(context).focusColor,
                              ),
                              child: !etatvideo
                                  ? Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'images/play-button.png',
                                          ),
                                        ),
                                      ),
                                    )
                                  : !controller!.value.hasError
                                      ? Column(
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Chewie(
                                                controller: ChewieController(
                                                  videoPlayerController:
                                                      controller!,
                                                  autoPlay: false,
                                                  looping: true,
                                                  autoInitialize: true,
                                                  zoomAndPan: false,
                                                  allowedScreenSleep: false,
                                                  materialProgressColors:
                                                      ChewieProgressColors(
                                                    backgroundColor:
                                                        const Color(0x8D000000),
                                                    bufferedColor:
                                                        const Color(0xFFECA233),
                                                    playedColor:
                                                        AppColors.mainColor,
                                                  ),
                                                  placeholder: Container(
                                                    color: Colors.black87,
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          AppColors.activColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  errorBuilder:
                                                      (context, errorMessage) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.report_problem,
                                                        size: 35,
                                                        color:
                                                            AppColors.mainColor,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () async {
                      //push at database
                      sendMovie();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.activColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: AppTextLarge(
                          text: 'Poster',
                          size: 18,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
