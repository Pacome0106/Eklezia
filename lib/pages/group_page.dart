// ignore_for_file: non_constant_identifier_names, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/detail_principal_group.dart';
import 'package:eklezia/widgets/groupes_list.dart';
import 'package:flutter/material.dart';

import '../add_pages/adds.dart';
import '../widgets/app_text.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
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
        if (!mounted) {
          return;
        }
        setState(() => isUser);
      }
    }
  }

  bool isUser = false;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'Groupes',
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
              sizedbox,
              Container(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'C.E.V.B',
                  size: 20,
                  color: Theme.of(context).hintColor,
                ),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  //detail cveb
                  if (isUser) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPrincipalGroup(
                          groupe: userData!['cevb'],
                          type: 'cevb',
                          userData: userData!['role'],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).focusColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isUser
                                ? AppText(
                                    text: userData!['cevb'],
                                    size: 16,
                                    color: Theme.of(context).hintColor,
                                  )
                                : Container(
                                    width: 150,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: borderRadius,
                                      color: Theme.of(context).hoverColor,
                                    ),
                                  ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: borderRadius,
                              ),
                              child: Icon(
                                Icons.navigate_next,
                                color: Theme.of(context).buttonColor,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      sizedbox,
                    ],
                  ),
                ),
              ),
              sizedbox,
              sizedbox,
              Container(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: 'Charismes',
                  size: 20,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                AppTextLarge(
                  text: "Nombres ",
                  size: 18,
                  color: Theme.of(context).hintColor,
                ),
                AppText(
                  text: isUser
                      ? '(${userData!['charisme'].length + userData!['groupe'].length})'
                      : '',
                  size: 16,
                  color: Theme.of(context).hintColor,
                ),
              ]),
              Expanded(
                child: ListView.builder(
                  itemCount: isUser
                      ? userData!['charisme'].length +
                          userData!['groupe'].length
                      : 2,
                  itemBuilder: (context, index) {
                    return GroupesList(
                      index,
                      user: isUser,
                      type: isUser
                          ? userData!['charisme'] + userData!['groupe']
                          : [],
                      groupe: isUser ? userData!['groupe'] : [],
                      charisme: isUser ? userData!['charisme'] : [],
                      userData: isUser ? userData!['role'] : '',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isUser
          ? (userData!['role'] != 'Fidele' &&
                  userData!['role'] != 'Prêtre' &&
                  userData!['role'] != 'Chef de C.E.V.B')
              ? FloatingActionButton(
                  elevation: 10,
                  backgroundColor: Theme.of(context).dialogBackgroundColor,
                  shape: const CircleBorder(side: BorderSide.none),
                  onPressed: () {
                    Popup(
                        isUser
                            ? userData!['charisme'] + userData!['groupe']
                            : [],
                        context);
                  },
                  child: Icon(
                    Icons.note_add,
                    color: Theme.of(context).shadowColor,
                  ),
                )
              : userData!['role'] == 'Chef de C.E.V.B'
                  ? FloatingActionButton(
                      elevation: 10,
                      backgroundColor: Theme.of(context).dialogBackgroundColor,
                      shape: const CircleBorder(side: BorderSide.none),
                      onPressed: () {
                        // ajouter un communique
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Adds(
                                  route: 'cveb', groupe: userData!['cevb']),
                            ));
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

  Popup(List type, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          insetPadding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.4,
            right: 20,
            bottom: MediaQuery.of(context).size.height * 0.16,
          ),
          contentPadding: const EdgeInsets.all(5),
          content: ListView.builder(
            reverse: true,
            itemCount: type.length,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Theme.of(context).focusColor,
                focusColor: Theme.of(context).focusColor,
                hoverColor: Theme.of(context).focusColor,
                highlightColor: Theme.of(context).focusColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Adds(
                        route: 'charisme',
                        groupe: type[index],
                      ),
                    ),
                  );
                },
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.centerLeft,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: Theme.of(context).focusColor,
                    ),
                    child: AppText(
                      text: type[index],
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
