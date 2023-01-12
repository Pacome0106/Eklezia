// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:eklezia/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../local _database/sqldb.dart';
import '../../widgets/notification.dart';

class CharismesModel {
  String name;
  bool isSelected;
  CharismesModel(this.name, this.isSelected);
}

class IdentityPage extends StatefulWidget {
  const IdentityPage({super.key, required this.email, required this.password});
  final TextEditingController email;
  final TextEditingController password;

  @override
  State<IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<IdentityPage> {
  final theuser = FirebaseAuth.instance.currentUser;
  SqlDb sqlDb = SqlDb();
  List paroisses = [];
  List evengiles = [];
  Map<String, dynamic>? data;
  TextEditingController number = TextEditingController();
  TextEditingController name = TextEditingController();

  bool loading = false;

  String valueChoose = '';
  String valueChoose2 = '';
  String valueChoose3 = '';
  String valueParoisse = '';

  List role = [
    'Prêtre',
    'SŒur',
    'Secretaire',
    'Chef de C.E.V.B',
    'Chef d\'un groupe',
    'Chef d\'un charisme',
    'Fidele',
  ];
  List cevb = [];
  List<CharismesModel> groupes = [];
  List<CharismesModel> charismes = [];
  List charismesChoose = [];
  List groupeChoose = [];
  bool isChurch = false;

  @override
  void dispose() {
    widget.email.dispose();
    widget.password.dispose();
    name.dispose();
    number.dispose();
    super.dispose();
  }

  getparoisse() async {
    await FirebaseFirestore.instance
        .collection("paroisses")
        .orderBy('name')
        .get()
        .then((value) {
      for (var paroisse in value.docs) {
        paroisses.add(paroisse);
      }
    });
    if (!mounted) {
      return;
    }
    setState(() {
      paroisses;
    });
  }

  getCEVB(String key) async {
    List<dynamic> allCharisme = [];
    List<dynamic> allGroupe = [];
    await FirebaseFirestore.instance
        .collection("paroisses")
        .doc(key)
        .get()
        .then((value) {
      cevb = value.data()!["c.e.v.b"];
      allCharisme = value.data()!["charismes"];
      allGroupe = value.data()!["commissions"];
    });
    if (!mounted) {
      return;
    } else {
      for (var groupe in allGroupe) {
        groupes.add(CharismesModel(groupe, false));
      }
      for (var charisme in allCharisme) {
        charismes.add(CharismesModel(charisme, false));
      }
      isChurch = true;
    }
    setState(() {
      cevb;
      groupes;
      charismes;
      isChurch;
    });
  }

  Future signup() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            child: const CircularProgressIndicator.adaptive(),
          ));
        });
    // authentificate user
    try {
      //create user
      dynamic result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: widget.email.text.trim(),
              password: widget.password.text.trim());
      if (result != null) {
        getEvengiles();
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      Navigator.of(context).pop();
      if (e.toString().contains('[firebase_auth/email-already-in-use]')) {
        notification(context, 'Cet adress email est prise déjà!', 50);
      } else if (e.toString().contains('[firebase_auth/invalid-email]')) {
        notification(context, 'Caractere incorrect !!!', 50);
      } else if (e
          .toString()
          .contains('[firebase_auth/network-request-failed]')) {
        notification(context, 'Verifier votre connexion !!!', 50);
      } else {
        notification(context,
            'Une erreur s\'est produit veillez essayé plus tard!!!', 65);
      }
    }
    final theuser = FirebaseAuth.instance.currentUser;
    // add user details
    addUserDetails(
      name.text.trim(),
      number.text.trim(),
      valueChoose2.trim(),
      valueParoisse.trim(),
      valueChoose.trim(),
      valueChoose3.trim(),
      groupeChoose,
      charismesChoose,
      theuser!.uid,
    );
  }

  Future addUserDetails(
      String name,
      String number,
      String sexe,
      String paroisse,
      String cevb,
      String role,
      List groupe,
      List charisme,
      uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'number': number,
      'sexe': sexe,
      'church': paroisse,
      'cevb': cevb,
      'role': role,
      'groupe': groupe,
      'charisme': charisme,
    });
  }

  Future getEvengiles() async {
    await FirebaseFirestore.instance
        .collection('evengiles')
        .orderBy('date')
        .get()
        .then((value) {
      for (var evengil in value.docs) {
        evengiles.add(evengil.data());
      }
    });
    if (evengiles.isNotEmpty) {
      for (int i = 0; i < evengiles.length; i++) {
        insertEvengile(evengiles[i]['verset'], evengiles[i]['temps'],
            evengiles[i]['evengile'], evengiles[i]['date']);
      }
    }
  }

  Future insertEvengile(
      String verset, String temps, String evengile, int date) async {
    int responses = await sqlDb.insertData("evengiles", {
      'verset': verset,
      'temps': temps,
      'evengile': evengile,
      'date': date,
    });
    if (responses != 0) {
      print('Okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
    }
  }

  @override
  void initState() {
    getparoisse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                delegate: ScrollAnimation('Completer votre profile', '/signup',
                    Theme.of(context).hintColor, 30.0,
                    currentIndex: 0)),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      sizedbox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          GestureDetector(
                            onTap: () async {
                              signup();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AppTextLarge(
                                  text: "Enregistrer ",
                                  size: 18,
                                  color: AppColors.activColor,
                                ),
                                const Icon(
                                  Icons.system_update_alt,
                                  color: AppColors.activColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      sizedbox,
                      sizedbox,
                      textEdit(
                        name,
                        'nom ...',
                        1,
                        TextInputType.text,
                        false,
                        true,
                        '',
                        Theme.of(context).bottomAppBarColor,
                        context,
                        false,
                        Icons.person,
                      ),
                      sizedbox,
                      textEdit(
                        number,
                        'numero ...',
                        1,
                        TextInputType.number,
                        false,
                        true,
                        '',
                        Theme.of(context).bottomAppBarColor,
                        context,
                        false,
                        Icons.phone,
                      ),
                      sizedbox,
                      sizedbox,
                      InkWell(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  sizedbox2,
                                  Icon(Icons.wc,
                                      size: 30,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                  sizedbox2,
                                  sizedbox2,
                                  AppText(
                                    text: valueChoose2 == ''
                                        ? 'Votre sexe  '
                                        : valueChoose2,
                                    size: 16,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: borderRadius,
                                  ),
                                  child: Icon(
                                    Icons.filter_none,
                                    color: Theme.of(context).buttonColor,
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        onTap: () {
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
                                      text: 'Choisissez votre sexe :',
                                      size: 16,
                                      color: Theme.of(context).hintColor),
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
                                      onTap: () {
                                        setState(() {
                                          valueChoose2 = 'Masculin';
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(valueChoose2);
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
                                          border: Border.all(
                                            color: AppColors.activColor,
                                            width: 1,
                                          ),
                                        ),
                                        height: 30,
                                        width: 120,
                                        child: AppTextLarge(
                                          text: 'Masculin',
                                          size: 18,
                                          color: AppColors.activColor,
                                        ),
                                      ),
                                    ),
                                    sizedbox2,
                                    sizedbox2,
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          valueChoose2 = 'Féminin';
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(valueChoose2);
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
                                          border: Border.all(
                                            color: AppColors.activColor,
                                            width: 1,
                                          ),
                                        ),
                                        height: 30,
                                        width: 120,
                                        child: AppTextLarge(
                                          text: 'Féminin',
                                          size: 18,
                                          color: AppColors.activColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      sizedbox,
                      InkWell(
                        onTap: () {
                          Popup('paroisse');
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  sizedbox2,
                                  Icon(Icons.church,
                                      size: 30,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                  sizedbox2,
                                  sizedbox2,
                                  AppText(
                                    text: valueParoisse == ''
                                        ? 'Selectionner votre paroisse'
                                        : valueParoisse,
                                    size: 16,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: borderRadius,
                                ),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context).buttonColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedbox,
                      isChurch
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Popup('cevb');
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).focusColor,
                                      borderRadius: borderRadius,
                                      border: Border.all(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            sizedbox2,
                                            Icon(Icons.home_filled,
                                                size: 30,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor),
                                            sizedbox2,
                                            sizedbox2,
                                            AppText(
                                              text: valueChoose == ''
                                                  ? 'Selectionner votre C.E.V.B '
                                                  : valueChoose,
                                              size: 16,
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                          ],
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              borderRadius: borderRadius,
                                            ),
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color:
                                                  Theme.of(context).buttonColor,
                                              size: 30,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                sizedbox
                              ],
                            )
                          : Container(),
                      InkWell(
                        onTap: () {
                          Popup('role');
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: borderRadius,
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  sizedbox2,
                                  Icon(Icons.work,
                                      size: 30,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                  sizedbox2,
                                  sizedbox2,
                                  AppText(
                                    text: valueChoose3 == ''
                                        ? 'Role dans l\'église '
                                        : valueChoose3,
                                    size: 16,
                                    color: Theme.of(context).cardColor,
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: borderRadius,
                                ),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context).buttonColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedbox,
                      isChurch
                          ? Container(
                              alignment: Alignment.centerLeft,
                              child: AppTextLarge(
                                text: 'Commissions : ',
                                size: 20,
                                color: Theme.of(context).hintColor,
                              ),
                            )
                          : const SizedBox(),
                      sizedbox,
                    ],
                  ),
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(childCount: groupes.length,
                  (BuildContext context, index) {
                return CharismList(groupes[index].name,
                    groupes[index].isSelected, index, 'groupes');
              }),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                sizedbox,
                isChurch
                    ? Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        child: AppTextLarge(
                          text: 'Charismes : ',
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.priority_high,
                              color: Theme.of(context).hintColor,
                              size: 35,
                            ),
                            AppTextLarge(
                              text: 'Veillez selectionner la paroisse...',
                              size: 20,
                              color: Theme.of(context).hintColor,
                            ),
                          ],
                        ),
                      ),
                sizedbox
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: charismes.length,
                (BuildContext context, index) {
                  return CharismList(charismes[index].name,
                      charismes[index].isSelected, index, 'charismes');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CharismList(String name, bool isSelected, int index, String type) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 30, top: 0, bottom: 0),
      horizontalTitleGap: 1,
      minVerticalPadding: 0,
      dense: true,
      leading: isSelected
          ? const Icon(
              Icons.circle,
              color: AppColors.activColor,
            )
          : Icon(
              Icons.circle_outlined,
              color: Theme.of(context).hoverColor,
            ),
      title: AppText(
        text: name,
        size: 16,
        color: Theme.of(context).cardColor,
      ),
      onTap: () {
        setState(() {
          type == 'groupes'
              ? groupes[index].isSelected = !groupes[index].isSelected
              : charismes[index].isSelected = !charismes[index].isSelected;
          if (type == 'groupes') {
            if (groupes[index].isSelected == true) {
              groupeChoose.add(groupes[index].name);
            } else if (groupes[index].isSelected == false) {
              groupeChoose
                  .removeWhere((element) => element == groupes[index].name);
            }
          }
          if (type == 'charismes') {
            if (charismes[index].isSelected == true) {
              charismesChoose.add(charismes[index].name);
            } else if (charismes[index].isSelected == false) {
              charismesChoose
                  .removeWhere((element) => element == charismes[index].name);
            }
          }
        });
      },
    );
  }

  Popup(String type) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          insetPadding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.4,
            right: 20,
            top: type == 'cevb'
                ? MediaQuery.of(context).size.height * (0.43 + 0.07)
                : type == 'role'
                    ? MediaQuery.of(context).size.height * (0.43 + 0.14)
                    : MediaQuery.of(context).size.height * 0.43,
          ),
          contentPadding: const EdgeInsets.all(5),
          content: ListView.builder(
            itemCount: type == 'cevb'
                ? cevb.length
                : type == 'role'
                    ? role.length
                    : paroisses.length,
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: Theme.of(context).hoverColor,
                focusColor: Theme.of(context).hoverColor,
                hoverColor: Theme.of(context).hoverColor,
                highlightColor: Theme.of(context).hoverColor,
                onTap: () {
                  setState(() {
                    type == 'cevb'
                        ? valueChoose = cevb[index]
                        : type == 'role'
                            ? valueChoose3 = role[index]
                            : valueParoisse = paroisses[index]['name'];
                    if (type == "paroisse") {
                      if (valueParoisse != "") {
                        cevb = [];
                        groupes = [];
                        charismes = [];
                        getCEVB(valueParoisse);
                      }
                    }
                    Navigator.of(context, rootNavigator: true).pop(
                      type == 'cevb'
                          ? valueChoose
                          : type == 'role'
                              ? valueChoose3
                              : valueParoisse,
                    );
                  });
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
                      text: type == 'cevb'
                          ? cevb[index]
                          : type == 'role'
                              ? role[index]
                              : paroisses[index]['name'],
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
