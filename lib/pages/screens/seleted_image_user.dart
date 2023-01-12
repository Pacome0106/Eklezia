// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:flutter/material.dart';
import '../../widgets/colors.dart';
import '../../widgets/notification.dart';
import '../home_page.dart';

//page qui donne la selection des photos apres les avoir selectionner dans la gallerie et qui propose de le accepter pour la publication
class SelectedImageUser extends StatefulWidget {
  const SelectedImageUser(this.imagePath,
      {Key? key, required this.isResponsive})
      : super(key: key);
  final String? imagePath;
  final bool isResponsive;

  @override
  State<SelectedImageUser> createState() => _SelectedImageUserState();
}

class _SelectedImageUserState extends State<SelectedImageUser> {
  SqlDb sqlDb = SqlDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bigTextColor,
      body: SafeArea(
        child: Stack(
            // PageView qui posse tout les photos selectionner
            children: [
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(widget.imagePath!)),
                      fit: BoxFit.contain),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColors.activColor,
                            ),
                            child: const Icon(Icons.close,
                                size: 20, color: AppColors.mainTextColor),
                          ),
                          onTap: () {
                            widget.isResponsive != true
                                ? Navigator.pushNamed(context, '/camera')
                                : Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        currentIndex: 3,
                                      ),
                                    ),
                                    (route) => false);
                          },
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                  //container qui a l'indicateur des photos
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        sizedbox, // button de publication
                        InkWell(
                          onTap: () async {
                            if (widget.imagePath != '') {
                              await sqlDb.deleteraw('user');
                              int responses = await sqlDb.insertData(
                                'user',
                                {'path': widget.imagePath!},
                              );

                              if (responses != 0) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(currentIndex: 3)),
                                    (route) => false);
                                notification(
                                    context, 'Mise à jour du profil', 60);
                              } else {
                                notification(
                                    context,
                                    'Une erreur s\'est produite au sauvegardage ! Esseyer plus tard !!!',
                                    60);
                              }
                            } else {
                              notification(
                                  context, 'Selectionner la photo', 60);
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.14,
                            width: MediaQuery.of(context).size.width * 0.14,
                            decoration: const BoxDecoration(
                                color: AppColors.activColor,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.mainTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
