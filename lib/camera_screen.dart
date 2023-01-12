// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, import_of_legacy_library_into_null_safe, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables
import 'dart:io';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/screens/seleted_image_user.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

//page qui offret l'utilisation de l'appareil photo et de la gallerie pour la selection ou la prise des photos
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen(this.images, this.cameras);
  final images;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  //declaration de differentes variables
  SqlDb sqlDb = SqlDb();
  late Future<void> initializeControllerFuture;
  late CameraController _controller;
  int _selectedCameraIndex = -1;
  String lastImage = '';
  bool _loading = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFileList = [];

// fonction qui unitialise la camera qui est asynchrone et qui s'execute dans le future

  Future<void> initCamera(CameraDescription camera) async {
    _controller = CameraController(camera, ResolutionPreset.veryHigh);
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    if (_controller.value.hasError) {
      // print('camera error ${_controller.value.errorDescription}');
    }
    initializeControllerFuture = _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }
  // fonction qui change l'etat de la camera soit frontale ou back

  Future<void> _cameraToggle() async {
    if (lastImage != '') {
      lastImage = '';
    }
    setState(() {
      _selectedCameraIndex = _selectedCameraIndex > -1
          ? _selectedCameraIndex == 0
              ? 1
              : 0
          : 0;
    });
    await initCamera(widget.cameras[_selectedCameraIndex]);
  }

  // fonction qui se charge de la prise de photo

  Future<void> _takePhoto() async {
    try {
      await initializeControllerFuture;
      String pathImage = join((await getTemporaryDirectory()).path,
          '${DateTime.now().microsecondsSinceEpoch}.jpg');
      final image = await _controller.takePicture();
      await image.saveTo(pathImage);
      setState(() {
        lastImage = pathImage;
        _imageFileList.add(XFile(lastImage));
      });

      print(lastImage);
    } catch (e) {
      // print(e);
    }
  }
  // fonction d'initialisation où on initialise la fonction _cameraToggle qui change la position de la camera

  @override
  void initState() {
    super.initState();
    _cameraToggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //fonction qui gere la selection de photos dans la gallerie du telephone

  void selectImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      _imageFileList.addAll(images);
    }
    if (_imageFileList.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SelectedImageUser(
                    _imageFileList[0].path,
                    isResponsive: false,
                  )),
          (route) => false);
    } else {
      // print("error");
    }
  }

  // bloc qui contiens la page camera avec ses different button et condition d'affichage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bigTextColor,
        body: SafeArea(
          child: FutureBuilder(
              future: initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_imageFileList.isEmpty || lastImage != '') {
                    return Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        SizedBox(
                            child: lastImage != ''
                                ? Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.16),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(File(lastImage)),
                                          fit: BoxFit.fill),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.16),
                                    width: double.maxFinite,
                                    child: CameraPreview(_controller))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //button qui sert au retour soit  de la page d'ajout de l'immobilier soit
                            //dans l'appareil photo en cas de capture de la photo

                            Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: AppColors.activColor,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 25,
                                          color: AppColors.mainTextColor,
                                        ),
                                      ),
                                      onTap: () {
                                        if (lastImage != '') {
                                          setState(() {
                                            _imageFileList = [];
                                            lastImage = '';
                                          });
                                        } else {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  currentIndex: 3,
                                                ),
                                              ),
                                              (route) => false);
                                          setState(() {});
                                        }
                                      }),
                                  const SizedBox(),
                                ],
                              ),
                            ),

                            const SizedBox(),
                            Visibility(
                              visible: lastImage == '',
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.14,
                                      right: MediaQuery.of(context).size.width *
                                          0.14,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                    ),
                                    width: double.maxFinite,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //button qui donne l'acces à la gallerie en appelant la fonction selectImage

                                        InkWell(
                                          onTap: () {
                                            selectImages();
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.mainColor,
                                            ),
                                            child: const Icon(
                                                Icons.photo_size_select_actual,
                                                color: AppColors.bigTextColor),
                                          ),
                                        ),

                                        // button qui capture la photo en appelant la fonction _takePhoto

                                        InkWell(
                                          onTap: _takePhoto,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.23,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.23,
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    width: 5)),
                                          ),
                                        ),

                                        //button qui change la possition de la camera en appelant la fonction _cameraToggle

                                        InkWell(
                                          onTap: _cameraToggle,
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.14,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.14,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.mainColor,
                                              ),
                                              child: const Icon(
                                                  Icons.switch_camera,
                                                  color:
                                                      AppColors.bigTextColor)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }),
        ),

        // button utiliser et visible si la capture est faite deja qui offret la publication de se dernier

        floatingActionButton: lastImage != ''
            ? FloatingActionButton(
                elevation: 0.0,
                highlightElevation: 0.0,
                disabledElevation: 0.0,
                backgroundColor: Colors.transparent,
                onPressed: () async {
                  setState(() {
                    _loading = !_loading;
                  });
                  await Future.delayed(const Duration(seconds: 3));
                  setState(() {
                    lastImage = '';
                  });
                  setState(() {
                    _loading = !_loading;
                  });
                },
                child: InkWell(
                  onTap: () async {
                    await sqlDb.deleteraw('user');
                    int responses = await sqlDb.insertData(
                      'user',
                      {'path': lastImage},
                    );

                    if (responses != 0) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(currentIndex: 3)),
                          (route) => false);
                      notification(context, 'Mise à jour du profil', 60);
                    } else {
                      notification(
                          context,
                          'Une erreur s\'est produite au sauvegardage ! Esseyer plus tard !!!',
                          60);
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.14,
                    width: MediaQuery.of(context).size.width * 0.14,
                    decoration: const BoxDecoration(
                        color: AppColors.activColor, shape: BoxShape.circle),
                    child:
                        const Icon(Icons.check, color: AppColors.mainTextColor),
                  ),
                ),
              )
            : null);
  }
}
