// ignore_for_file: must_be_immutable, avoid_print

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/group_page.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/pages/report_page.dart';
import 'package:eklezia/pages/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/notification.dart';

BorderRadius borderRadius = BorderRadius.circular(10);
SizedBox sizedbox = const SizedBox(height: 10);
SizedBox sizedbox2 = const SizedBox(width: 10);

class HomePage extends StatefulWidget {
  HomePage({super.key, this.currentIndex = 0});
  int currentIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SqlDb sqlDb = SqlDb();
  List user = [];

  getUser() async {
    List<Map> responses = await sqlDb.readDate('user');
    user.addAll(responses);
    if (responses.isNotEmpty) {
      isUser = true;
      setState(() {
        isUser;
        user;
      });
    }
  }

  testConnexion() async {
    final User? theuser = FirebaseAuth.instance.currentUser;
    var date = DateTime.now();
    DateTime dateView = DateTime.utc(date.year, date.month, date.day);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //mobil connexion
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("activity/${theuser!.uid}");
      await ref
          .set({
            'uid': theuser.uid,
            'date': dateView.microsecondsSinceEpoch,
          })
          .then((value) => {print("videos lu")})
          .catchError((error) {
            print(error.toString());
          });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //wifi connexion
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("activity/${theuser!.uid}");
      await ref
          .set({
            'uid': theuser.uid,
            'date': dateView.microsecondsSinceEpoch,
          })
          .then((value) => {print("videos lu")})
          .catchError((error) {
            print(error.toString());
          });
    } else {
      // ignore: use_build_context_synchronously
      notification(context, 'Pas de connexion internet', 50);
    }
  }

  bool isUser = false;
  @override
  void initState() {
    getUser();
    theuser != null ? testConnexion() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const MoviePage(),
      const ReportPage(),
      const GroupPage(),
      UserPage(
        image: user.isNotEmpty ? user[0]['path'] ?? '' : '',
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: tabs[widget.currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).backgroundColor,
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).bottomAppBarColor, size: 30),
        unselectedIconTheme:
            IconThemeData(color: Theme.of(context).hoverColor, size: 25),
        currentIndex: widget.currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.church),
            label: 'home',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timeline_sharp),
            label: '',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: '',
            backgroundColor: Theme.of(context).backgroundColor,
          ),
          BottomNavigationBarItem(
            icon: !isUser
                ? const Icon(Icons.person)
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: FileImage(
                        File(user[0]['path']),
                      ),
                    ),
                  ),
            label: '',
            backgroundColor: Theme.of(context).backgroundColor,
          )
        ],
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
      ),
    );
  }
}
