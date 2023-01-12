// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/lign.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ReportList extends StatefulWidget {
  const ReportList({
    super.key,
    required this.id,
    required this.objet,
    required this.message,
    required this.date,
    required this.user,
    required this.groupe,
    required this.connexion,
    required this.image,
    required this.uid,
    required this.permission,
  });
  final String id;
  final String groupe;
  final String objet;
  final String message;
  final String date;
  final image;
  final String uid;
  final bool permission;
  final bool connexion;
  final bool user;

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  var byte;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
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
                                        final storageRefPhotos =
                                            FirebaseStorage.instance.ref(
                                                'communiques/${widget.groupe}');
                                        final desertRefPhotos =
                                            storageRefPhotos.child(widget.uid);

                                        // Delete the file
                                        if (widget.uid != '') {
                                          await desertRefPhotos
                                              .delete()
                                              .then((value) async {})
                                              .catchError((error) {
                                            notification(
                                                context,
                                                'La suppression à échouer !',
                                                50);
                                            Navigator.of(context).pop();
                                          });
                                        }
                                        await FirebaseFirestore.instance
                                            .collection(widget.groupe)
                                            .doc(widget.id)
                                            .delete()
                                            .then((value) {
                                          notification(context,
                                              'Communique supprimée !', 50);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  currentIndex: widget.groupe !=
                                                          'paroisse'
                                                      ? 2
                                                      : 1,
                                                ),
                                              ),
                                              (route) => false);
                                        }).catchError((error) {
                                          notification(context,
                                              'La suppression à échouer !', 50);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Center(
                                        heightFactor: 2,
                                        child: Text(
                                          'Supprimer ce communique',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.poweroffColor,
                                            fontSize: 18,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.bold,
                                          ),
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
            width: double.maxFinite,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).focusColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.user && widget.objet != ''
                        ? AppTextLarge(
                            text: 'Objet : ${widget.objet}',
                            color: Theme.of(context).hintColor,
                            size: 16,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: Theme.of(context).hoverColor,
                            ),
                          ),
                  ],
                ),
                sizedbox,
                Column(
                  children: [
                    widget.connexion
                        ? widget.image != ''
                            ? Image.network(widget.image)
                            : const SizedBox()
                        : widget.image != '' && widget.image != null
                            ? Image.memory(widget.image)
                            : const SizedBox(),
                    sizedbox,
                  ],
                ),
                widget.user && widget.objet != ''
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: AppText(
                          text: widget.message,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    : Container(
                        width: double.maxFinite,
                        height: 150,
                        color: Theme.of(context).focusColor,
                      ),
                sizedbox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.user &&
                            widget.date != '1 jan 1970 à 2:0' &&
                            widget.date != '1 jan 1970 à 1:0'
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: Theme.of(context).focusColor),
                            child: AppText(
                              text: widget.date,
                              color: Theme.of(context).cardColor,
                            ),
                          )
                        : Container(
                            width: 150,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Theme.of(context).hoverColor,
                              borderRadius: borderRadius,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
        sizedbox,
        Lign(
            indent: MediaQuery.of(context).size.width * 0.20,
            endIndent: MediaQuery.of(context).size.width * 0.20),
      ],
    );
  }
}
