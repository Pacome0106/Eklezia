// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eklezia/pages/screens/members_screen.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/repport_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../local _database/sqldb.dart';
import '../pages/home_page.dart';
import '../pages/movie_page.dart';
import '../pages/report_page.dart';

List dataHorLine1 = [];

class DetailPrincipalGroup extends StatefulWidget {
  const DetailPrincipalGroup({
    super.key,
    required this.groupe,
    required this.type,
    required this.userData,
  });
  final String groupe;
  final String type;
  final String userData;

  @override
  State<DetailPrincipalGroup> createState() => _DetailPrincipalGroupState();
}

class _DetailPrincipalGroupState extends State<DetailPrincipalGroup> {
  SqlDb sqlDb = SqlDb();
  List messages = [];

  late ScrollController _controller;

  getcommunique() async {
    await FirebaseFirestore.instance
        .collection(widget.groupe)
        .where('church', isEqualTo: paroisse)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var video in value.docs) {
        messages.add(video);
      }
    });
    if (messages.isNotEmpty) {}
    if (!mounted) {
      return;
    }
    setState(() {
      messages;
    });
  }

  saveLocalData() async {
    if (messages.length > 5) {
      for (int i = 0; i < 5; i++) {
        Uint8List? byte;
        if (messages[i]['imageUrl'] != '') {
          final storageRefPhotos =
              FirebaseStorage.instance.ref('communiques/${widget.groupe}');
          final islandRefPhoto = storageRefPhotos.child(messages[i]['uid']);
          byte = await islandRefPhoto.getData();
        }

        await sqlDb.insertData('cevbs', {
          'date': messages[i]['date'],
          'objet': messages[i]['objet'],
          'message': messages[i]['message'],
          'image': byte,
        });
      }
    } else {
      for (int i = 0; i < messages.length; i++) {
        Uint8List? byte;
        if (messages[i]['imageUrl'] != '') {
          final storageRefPhotos =
              FirebaseStorage.instance.ref('communiques/${widget.groupe}');
          final islandRefPhoto = storageRefPhotos.child(messages[i]['uid']);
          byte = await islandRefPhoto.getData();
        }
        await sqlDb.insertData(
          'cevbs',
          {
            'date': messages[i]['date'],
            'objet': messages[i]['objet'],
            'message': messages[i]['message'],
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
      if (messages.isNotEmpty) {
        await saveLocalData();
        messages = [];
      }
      dataHorLine = [];
      setState(() {
        messages;
        dataHorLine;
      });
      getcommunique();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnexion = true;
      setState(() => isConnexion);

      await sqlDb.deleteraw('communiques');
      if (messages.isNotEmpty) {
        await saveLocalData();
        messages = [];
      }
      dataHorLine = [];
      setState(() {
        messages;
        dataHorLine;
      });
      getcommunique();
    } else {
      print(dataHorLine);
      messages = [];
      isConnexion = false;
      setState(() {
        messages;
        isConnexion;
      });
      readHorLine();
    }
  }

  readHorLine() async {
    List<Map> responses = await sqlDb.readDataNotes('cevbs');
    dataHorLine1 = [];
    dataHorLine1.addAll(responses);
    if (responses != 0) {
      setState(() {
        dataHorLine1;
      });
    }
  }

  bool user = false;
  List uid = [];
  bool isConnexion = false;
  @override
  void initState() {
    testConnexion();
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              iconSize: 35,
              padding: const EdgeInsets.all(0),
              color: AppColors.activColor,
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        currentIndex: 2,
                      ),
                    ),
                    (route) => false);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTextLarge(
                        text: widget.groupe,
                        color: Theme.of(context).hintColor,
                        size: 22,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MembersScrenn(
                              groupe: widget.groupe,
                              type: widget.type,
                              userData: widget.userData,
                            ),
                          ),
                          (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppTextLarge(
                          text: 'Membres',
                          color: AppColors.activColor,
                          size: 18,
                        ),
                        const Icon(
                          Icons.group,
                          color: AppColors.activColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            sizedbox,
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: AppTextLarge(
                text: isConnexion
                    ? "Nombres (${messages.length})"
                    : "Nombres (${dataHorLine.length})",
                size: 18,
                color: Theme.of(context).disabledColor,
              ),
            ),
            sizedbox,
            isConnexion
                ? Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: messages.isEmpty ? 5 : messages.length,
                      itemBuilder: (context, index) {
                        var now = DateTime.fromMicrosecondsSinceEpoch(
                            messages.isNotEmpty ? messages[index]['date'] : 0);
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ReportList(
                            id: messages.isNotEmpty
                                ? messages[index].id.toString()
                                : '',
                            groupe: widget.groupe,
                            objet: messages.isNotEmpty
                                ? (messages[index]['objet'] ?? '')
                                : '',
                            message: messages.isNotEmpty
                                ? messages[index]['message'] ?? ''
                                : '',
                            date:
                                "${now.day} ${months[now.month - 1]} ${now.year} à ${now.hour}:${now.minute}",
                            image: messages.isNotEmpty
                                ? messages[index]['imageUrl']
                                : '',
                            uid: messages.isNotEmpty
                                ? messages[index]['imageUrl'] != ''
                                    ? messages[index]['uid']
                                    : ''
                                : '',
                            connexion: isConnexion,
                            user: true,
                            permission: widget.userData == 'Chef de C.E.V.B'
                                ? true
                                : false,
                          ),
                        );
                      },
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: dataHorLine1.isEmpty ? 5 : dataHorLine1.length,
                      itemBuilder: (context, index) {
                        var now = DateTime.fromMicrosecondsSinceEpoch(
                          dataHorLine1.isNotEmpty
                              ? dataHorLine1[index]['date']
                              : 0,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ReportList(
                            id: '',
                            groupe: widget.groupe,
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
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
