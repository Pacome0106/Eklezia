// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/pages/screens/edit_user_screen.dart';
import 'package:eklezia/pages/screens/seleted_image_user.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/lign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../camera_screen.dart';
import '../widgets/app_text.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.image});
  final String image;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  SqlDb sqlDb = SqlDb();
  List<CameraDescription>? cameras;
  final ImagePicker _picker = ImagePicker();
  File? imagePath;
  Map<String, dynamic>? userData;

  TextEditingController code = TextEditingController();

  Future getUser() async {
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
        if (!mounted) {
          return;
        }
        setState(() => isUser);
      }
    }
  }

  picker() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }

  selectImages() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      File? img = File(image.path);
      setState(() {
        imagePath = img;
      });
    }
    if (imagePath != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SelectedImageUser(
                    imagePath!.path,
                    isResponsive: true,
                  )),
          (route) => false);
    } else {
      // print("error");
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool isUser = false;
  bool isImage = false;

  @override
  void initState() {
    getUser();
    picker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: AppTextLarge(
                text: 'Profile',
                color: Theme.of(context).disabledColor,
              ),
            ),
            Expanded(
              child: ListView(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Hero(
                          tag: 'edit',
                          child: Card(
                            color: Theme.of(context).backgroundColor,
                            elevation: 0,
                            child: IconButton(
                              onPressed: () {
                                //modification user
                                isUser
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditUserScreen(
                                              name: userData!['name'],
                                              email: theuser!.email!,
                                              number: userData!['number'],
                                              sexe: userData!['sexe'],
                                              paroisse: paroisse,
                                              cevb: userData!['cevb'],
                                              role: userData!['role'],
                                              uid: theuser!.uid,
                                              image: widget.image),
                                        ),
                                      )
                                    : null;
                              },
                              icon: const Icon(Icons.edit),
                              iconSize: 30,
                              padding: const EdgeInsets.all(10),
                              color: AppColors.activColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      height: 130,
                      width: 130,
                      decoration: widget.image != ''
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 2,
                              ),
                              color: Theme.of(context).focusColor,
                              image: DecorationImage(
                                image: FileImage(
                                  File(widget.image),
                                ),
                                fit: BoxFit.cover,
                              ),
                            )
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 2,
                              ),
                              color: Theme.of(context).focusColor,
                            ),
                      child: InkWell(
                        onTap: () => PopupImageSelected(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 2,
                            ),
                            color: Theme.of(context).focusColor,
                          ),
                          child: const Icon(Icons.add_a_photo,
                              color: AppColors.activColor, size: 20),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          sizedbox,
                          sizedbox,
                          isUser
                              ? AppTextLarge(
                                  text: userData!['name'],
                                  size: 18,
                                  color: Theme.of(context).hintColor,
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                          sizedbox,
                          isUser
                              ? AppText(
                                  text: userData!['role'],
                                  size: 16,
                                  color: Theme.of(context).hintColor,
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          // Number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(Icons.phone,
                                        size: 30,
                                        color: Theme.of(context)
                                            .bottomAppBarColor),
                                    const SizedBox(width: 20),
                                    isUser
                                        ? AppTextLarge(
                                            text: userData!['number'],
                                            size: 16,
                                            color: Theme.of(context).hintColor,
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 16,
                                            decoration: BoxDecoration(
                                                borderRadius: borderRadius,
                                                color: Theme.of(context)
                                                    .focusColor),
                                          ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Theme.of(context).focusColor,
                                    child: const Icon(
                                      Icons.phone,
                                      size: 20,
                                      color: AppColors.activColor,
                                    ),
                                  ),
                                  sizedbox2,
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Theme.of(context).focusColor,
                                    child: const Icon(
                                      Icons.message_rounded,
                                      size: 20,
                                      color: AppColors.activColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Lign(indent: 0, endIndent: 0),
                          // Email
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(Icons.email,
                                        size: 30,
                                        color: Theme.of(context)
                                            .bottomAppBarColor),
                                    const SizedBox(width: 20),
                                    isUser
                                        ? AppTextLarge(
                                            text: theuser!.email,
                                            size: 16,
                                            color: Theme.of(context).hintColor,
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: 16,
                                            decoration: BoxDecoration(
                                                borderRadius: borderRadius,
                                                color: Theme.of(context)
                                                    .focusColor),
                                          ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).focusColor,
                                child: const Icon(
                                  Icons.email,
                                  size: 20,
                                  color: AppColors.activColor,
                                ),
                              ),
                            ],
                          ),
                          const Lign(indent: 0, endIndent: 0),
                          // c.v.b
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(Icons.home_filled,
                                        size: 30,
                                        color: Theme.of(context)
                                            .bottomAppBarColor),
                                    const SizedBox(width: 20),
                                    isUser
                                        ? AppTextLarge(
                                            text: userData!['cevb'],
                                            size: 16,
                                            color: Theme.of(context).hintColor,
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              borderRadius: borderRadius,
                                              color:
                                                  Theme.of(context).focusColor,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).focusColor,
                                child: const Icon(
                                  Icons.home_filled,
                                  size: 20,
                                  color: AppColors.activColor,
                                ),
                              ),
                            ],
                          ),
                          const Lign(indent: 0, endIndent: 0),
                          //genre
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.wc,
                                    size: 30,
                                    color: Theme.of(context).bottomAppBarColor),
                                const SizedBox(width: 20),
                                isUser
                                    ? AppTextLarge(
                                        text: userData!['sexe'],
                                        size: 16,
                                        color: Theme.of(context).hintColor,
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        height: 16,
                                        decoration: BoxDecoration(
                                            borderRadius: borderRadius,
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                              ],
                            ),
                          ),
                          const Lign(indent: 0, endIndent: 0),
                          // analityc
                          GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).focusColor,
                                    insetPadding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    title: Column(
                                      children: [
                                        Center(
                                          child: AppTextLarge(
                                            text: 'mot de passe statistique',
                                            size: 16,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        sizedbox,
                                        Container(
                                          alignment: Alignment.center,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Theme.of(context).focusColor,
                                          ),
                                          child: TextField(
                                            maxLines: 1,
                                            minLines: 1,
                                            controller: code,
                                            obscureText: true,
                                            textAlign: TextAlign.center,
                                            cursorColor:
                                                Theme.of(context).hintColor,
                                            style: TextStyle(
                                                color:
                                                    Theme.of(context).hintColor,
                                                fontSize: 16,
                                                fontFamily: 'Nunito'),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefix: const SizedBox(width: 10),
                                              suffix: const SizedBox(width: 10),
                                              hintText: 'code...',
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito'),
                                            ),
                                            keyboardType: TextInputType.text,
                                            onEditingComplete: () {
                                              if (code.text.trim() == '0000') {
                                                Navigator.pushNamed(context,
                                                    '/screens/analystic_screen');
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: borderRadius),
                                    contentPadding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                      left: 30,
                                      right: 30,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Icon(Icons.analytics_rounded,
                                      size: 30,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                  const SizedBox(width: 20),
                                  isUser
                                      ? AppTextLarge(
                                          text: 'Actif',
                                          size: 16,
                                          color: Theme.of(context).hintColor,
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              borderRadius: borderRadius,
                                              color:
                                                  Theme.of(context).focusColor),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        List count = await sqlDb.readCount('evengiles');
                        //se deconnecter ou se connect
                        if (theuser != null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).focusColor,
                                insetPadding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                title: Center(
                                  child: AppText(
                                    text: 'Souhaitez-vous vous déconnecter ?',
                                    size: 16,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadius),
                                contentPadding: const EdgeInsets.only(
                                    top: 20, bottom: 20, left: 10, right: 10),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await FirebaseAuth.instance.signOut();

                                        if (widget.image != '') {
                                          await sqlDb.deleteraw('user');
                                        }
                                        theuser = null;
                                        setState(() {
                                          theuser;
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/home',
                                              (route) => false);
                                        });
                                        if (count.isNotEmpty) {
                                          await sqlDb.deleteraw('evengiles');
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColors.poweroffColor,
                                            width: 1,
                                          ),
                                        ),
                                        height: 30,
                                        width: 120,
                                        child: AppTextLarge(
                                          text: 'Déconnecter',
                                          size: 18,
                                          color: AppColors.poweroffColor,
                                        ),
                                      ),
                                    ),
                                    sizedbox2,
                                    sizedbox2,
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color:
                                              Theme.of(context).indicatorColor,
                                        ),
                                        height: 30,
                                        width: 120,
                                        child: AppTextLarge(
                                          text: 'Annuler',
                                          size: 18,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, top: 40, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppTextLarge(
                                  text: theuser != null
                                      ? 'Se déconnecter'
                                      : 'Se connecter',
                                  size: 18,
                                  color: theuser != null
                                      ? AppColors.poweroffColor
                                      : AppColors.activColor,
                                ),
                                sizedbox2,
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: theuser == null
                                      ? BoxDecoration(
                                          color: Theme.of(context).focusColor,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            color: AppColors.activColor,
                                            width: 2,
                                          ),
                                        )
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                            color: AppColors.poweroffColor,
                                            width: 2,
                                          ),
                                        ),
                                  child: Icon(
                                    Icons.power_settings_new,
                                    color: theuser == null
                                        ? AppColors.activColor
                                        : AppColors.poweroffColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  PopupImageSelected() {
    showDialog(
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
                insetPadding:
                    const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                alignment: Alignment.bottomCenter,
                contentPadding:
                    const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                content: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Theme.of(context).focusColor,
                      ),
                      child: Column(
                        children: [
                          sizedbox,
                          InkWell(
                            onTap: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CameraScreen('', cameras!)),
                                (route) => false),
                            child: const Center(
                              heightFactor: 2,
                              child: Text(
                                'Prendre une photo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.activColor,
                                  fontSize: 18,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                          const Lign(indent: 0.0, endIndent: 0.0),
                          InkWell(
                            onTap: () {
                              selectImages();
                            },
                            child: const Center(
                              heightFactor: 2,
                              child: Text(
                                'Choisir une photo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.activColor,
                                  fontSize: 18,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                          sizedbox
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                      color: Colors.transparent,
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Theme.of(context).focusColor,
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context,
                            '/menu_screens/user_screen', (route) => false),
                        child: Center(
                          heightFactor: 2,
                          child: Text(
                            'Annuler',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
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
    );
  }
}
