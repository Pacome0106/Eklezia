// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:uuid/uuid.dart';

import '../widgets/app_text.dart';

class Adds extends StatefulWidget {
  const Adds({super.key, required this.route, required this.groupe});
  final String route;
  final String groupe;

  @override
  State<Adds> createState() => _AddsState();
}

class _AddsState extends State<Adds> {
  File? fileBytes;
  String urlPhoto = '';
  String? fileName = '';

  TextEditingController objet = TextEditingController();
  TextEditingController message = TextEditingController();

  bool etatMessage = false;
  bool etatTitre = false;
  int currentIndex = 0;

  // select a file in the phone
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        fileName = result.files.first.path!;
      });
    }
  }

  sendMessage(String groupe) async {
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
    //save the messages
    if (fileName! != '') {
      addCommuniquePhoto(groupe);
    } else {
      addCommunique(groupe);
    }
  }

  // add Communique avec Photo in firestore Database
  Future addCommuniquePhoto(String groupe) async {
    var uid = const Uuid().v4();
    DateTime now = DateTime.now();
    File compressedFile = await FlutterNativeImage.compressImage(
      fileName!,
      quality: 75,
    );
    if (compressedFile != null) {
      var response = await FirebaseStorage.instance
          .ref('communiques/$groupe/$uid')
          .putFile(
            compressedFile,
          );
      if (response != null) {
        final storageRefPhotos =
            FirebaseStorage.instance.ref('communiques/$groupe');
        final islandRefPhoto = storageRefPhotos.child(uid);
        urlPhoto = await islandRefPhoto.getDownloadURL();
        if (urlPhoto != '') {
          await FirebaseFirestore.instance.collection(groupe).add(
            {
              'church': 'Saint Eloi',
              'objet': objet.text.trim(),
              'message': message.text.trim(),
              'imageUrl': urlPhoto,
              'date': now.microsecondsSinceEpoch,
              'uid': uid
            },
          );
          notification(context, 'Message envoyer !!!', 50);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                currentIndex: currentIndex,
              ),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  // add Communique sans Photo in firestore Database
  Future addCommunique(String groupe) async {
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance.collection(groupe).add(
      {
        'church': 'Saint Eloi',
        'objet': objet.text.trim(),
        'message': message.text.trim(),
        'imageUrl': urlPhoto,
        'date': now.microsecondsSinceEpoch,
      },
    );
    notification(context, 'Message envoyer !!!', 50);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          currentIndex: currentIndex,
        ),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    objet.dispose();
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.route == 'communique') {
      currentIndex = 1;
    } else {
      currentIndex = 2;
    }
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: ScrollAnimation(
                'Ajout communiquer ',
                'adds',
                Theme.of(context).hintColor,
                30,
                currentIndex: currentIndex,
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
                          text: 'Objet',
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
                            controller: objet,
                            cursorColor: Theme.of(context).hintColor,
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 16,
                                fontFamily: 'Nunito'),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefix: const SizedBox(width: 10),
                              hintText: 'ajouter un objet...',
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
                        sizedbox,
                        sizedbox,
                        AppTextLarge(
                          text: 'Référence',
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                        sizedbox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Ajouter une image',
                              size: 16,
                              color: Theme.of(context).hintColor,
                            ),
                            InkWell(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainTextColor,
                                    borderRadius: borderRadius,
                                  ),
                                  child: const Icon(
                                    Icons.filter_none,
                                    color: AppColors.mainColor,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  selectFile();
                                }),
                          ],
                        ),
                        sizedbox,
                        fileName! != ''
                            ? Image.file(
                                File(fileName!),
                              )
                            : const SizedBox(),
                        sizedbox,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: AppTextLarge(
                            text: 'Message',
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        sizedbox,
                        Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          decoration: !etatMessage
                              ? BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: Theme.of(context).focusColor,
                                )
                              : const BoxDecoration(),
                          child: TextField(
                            maxLines: 10,
                            minLines: 10,
                            controller: message,
                            cursorColor: Theme.of(context).hintColor,
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 16,
                                fontFamily: 'Nunito'),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefix: const SizedBox(width: 10),
                              hintText: 'ajouter un message...',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 16,
                                  fontFamily: 'Nunito'),
                            ),
                            keyboardType: TextInputType.text,
                            onTap: () {
                              setState(() {
                                etatMessage = true;
                              });
                            },
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
                  GestureDetector(
                    onTap: () async {
                      //push at database
                      if (objet.text != '') {
                        if (message.text != '' || fileName! != '') {
                          sendMessage(widget.groupe);
                        } else {
                          notification(
                              context,
                              'Veillez suscrire une reference ou écrire un message !!!',
                              60);
                        }
                      } else {
                        notification(context,
                            'Veillez sucrire un objet au message !!!', 50);
                      }
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
                          text: 'Publier',
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
