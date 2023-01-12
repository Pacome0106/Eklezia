// ignore_for_file: unrelated_type_equality_checks, avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eklezia/add_pages/adds.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/repport_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../widgets/app_text.dart';
import '../widgets/colors.dart';

List dataHorLine = [];

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  SqlDb sqlDb = SqlDb();
  List communiques = [];

  late ScrollController _controller;
  Map<String, dynamic>? userData;

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
        testConnexion();
        if (!mounted) {
          return;
        }
        setState(() => isUser);
      }
    }
  }

  readCommunique() async {
    await FirebaseFirestore.instance
        .collection('paroisse')
        .where('church', isEqualTo: paroisse)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var video in value.docs) {
        communiques.add(video);
      }
    });
    if (communiques.isNotEmpty) {}
    if (!mounted) {
      return;
    }
    setState(() {
      communiques;
    });
  }

  Future saveLocalData() async {
    if (communiques.length > 5) {
      for (int i = 0; i < 5; i++) {
        Uint8List? byte;
        if (communiques[i]['imageUrl'] != '') {
          final storageRefPhotos =
              FirebaseStorage.instance.ref('communiques/paroisse');
          final islandRefPhoto = storageRefPhotos.child(communiques[i]['uid']);
          byte = await islandRefPhoto.getData();
        }

        await sqlDb.insertData(
          'communiques',
          {
            'date': communiques[i]['date'],
            'objet': communiques[i]['objet'],
            'message': communiques[i]['message'],
            'image': byte,
          },
        );
      }
    } else {
      for (int i = 0; i < communiques.length; i++) {
        Uint8List? byte;
        if (communiques[i]['imageUrl'] != '') {
          final storageRefPhotos =
              FirebaseStorage.instance.ref('communiques/paroisse');
          final islandRefPhoto = storageRefPhotos.child(communiques[i]['uid']);
          byte = await islandRefPhoto.getData();
        }
        await sqlDb.insertData(
          'communiques',
          {
            'date': communiques[i]['date'],
            'objet': communiques[i]['objet'],
            'message': communiques[i]['message'],
            'image': byte,
          },
        );
      }
    }
  }

  testConnexion() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnexion = true;
      setState(() => isConnexion);
      await sqlDb.deleteraw('communiques');
      if (communiques.isNotEmpty) {
        await saveLocalData();
        communiques = [];
      }
      dataHorLine = [];
      setState(() {
        communiques;
        dataHorLine;
      });
      readCommunique();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnexion = true;
      setState(() => isConnexion);

      await sqlDb.deleteraw('communiques');
      if (communiques.isNotEmpty) {
        await saveLocalData();
        communiques = [];
      }
      dataHorLine = [];
      setState(() {
        communiques;
        dataHorLine;
      });
      readCommunique();
    } else {
      print(dataHorLine);
      communiques = [];
      isConnexion = false;
      setState(() {
        communiques;
        isConnexion;
      });
      readHorLine();
    }
  }

  readHorLine() async {
    List<Map> responses = await sqlDb.readDataNotes('communiques');
    dataHorLine = [];
    dataHorLine.addAll(responses);
    if (responses != 0) {
      setState(() {
        dataHorLine;
      });
    }
  }

  List uid = [];
  bool isConnexion = false;
  bool isUser = false;
  @override
  void initState() {
    getUser();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print('bas');
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      testConnexion();
      setState(() {
        print('haut');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: AppTextLarge(
                text: 'Communique',
                color: Theme.of(context).disabledColor,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: AppTextLarge(
                text: paroisse,
                size: 18,
                color: AppColors.activColor,
              ),
            ),
            sizedbox,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppTextLarge(
                  text: "Nombres ",
                  size: 18,
                  color: Theme.of(context).hintColor,
                ),
                AppText(
                  text: isConnexion
                      ? '(${communiques.length})'
                      : '(${dataHorLine.length})',
                  size: 16,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
            sizedbox,
            isConnexion
                ? Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: communiques.isEmpty ? 4 : communiques.length,
                      itemBuilder: (context, index) {
                        var now = DateTime.fromMicrosecondsSinceEpoch(
                            communiques.isNotEmpty
                                ? communiques[index]['date']
                                : 0);
                        return ReportList(
                          id: communiques.isNotEmpty
                              ? communiques[index].id.toString()
                              : '',
                          groupe: 'paroisse',
                          objet: communiques.isNotEmpty
                              ? (communiques[index]['objet'] ?? '')
                              : '',
                          message: communiques.isNotEmpty
                              ? communiques[index]['message'] ?? ''
                              : '',
                          date:
                              "${now.day} ${months[now.month - 1]} ${now.year} à ${now.hour}:${now.minute}",
                          image: communiques.isNotEmpty
                              ? communiques[index]['imageUrl']
                              : '',
                          uid: communiques.isNotEmpty
                              ? communiques[index]['imageUrl'] != ''
                                  ? communiques[index]['uid']
                                  : ''
                              : '',
                          connexion: isConnexion,
                          user: isUser,
                          permission: isUser
                              ? userData!['role'] == 'Secretaire'
                                  ? true
                                  : false
                              : false,
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: dataHorLine.isEmpty ? 4 : dataHorLine.length,
                      itemBuilder: (context, index) {
                        var now = DateTime.fromMicrosecondsSinceEpoch(
                          dataHorLine.isNotEmpty
                              ? dataHorLine[index]['date']
                              : 0,
                        );

                        return ReportList(
                          id: '',
                          groupe: 'paroisse',
                          objet: dataHorLine.isNotEmpty
                              ? (dataHorLine[index]['objet'] ?? '')
                              : '',
                          message: dataHorLine.isNotEmpty
                              ? dataHorLine[index]['message'] ?? ''
                              : '',
                          date:
                              "${now.day} ${months[now.month - 1]} ${now.year} à ${now.hour}:${now.minute}",
                          image: dataHorLine.isNotEmpty
                              ? dataHorLine[index]['image']
                              : '',
                          uid: '',
                          connexion: isConnexion,
                          user: true,
                          permission: false,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: isUser
          ? userData!['role'] == 'Secretaire'
              ? FloatingActionButton(
                  elevation: 10,
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  shape: const CircleBorder(side: BorderSide.none),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const Adds(route: 'communique', groupe: 'paroisse'),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.note_add,
                    color: Theme.of(context).shadowColor,
                  ),
                )
              : const SizedBox()
          : const SizedBox(),
    );
  }
}
