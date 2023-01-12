// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/colors.dart';
import '../../widgets/notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final theuser = FirebaseAuth.instance.currentUser;
  SqlDb sqlDb = SqlDb();
  Map<String, dynamic>? data;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  List evengiles = [];
  Future signIn() async {
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
    try {
      dynamic result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      if (result != null) {
        getEvengiles();
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (e) {
      Navigator.of(context).pop();
      if (e.toString().contains('[firebase_auth/wrong-password]')) {
        notification(context, 'Mot de passe incorrect!!!', 50);
      } else if (e.toString().contains('[firebase_auth/too-many-requests]')) {
        notification(context,
            'Vous avez dépasser les tentatives ! Esseyer après !!!', 65);
      } else if (e.toString().contains('[firebase_auth/user-not-found]')) {
        notification(context, 'Votre e-mail est incorrect!!!', 50);
      } else if (e
          .toString()
          .contains('[firebase_auth/network-request-failed]')) {
        notification(context, 'Verifier votre connexion !!!', 50);
      } else {
        notification(context,
            'Une erreur s\'est produit veillez essayé plus tard!!!', 65);
      }
    }
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
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: _fromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                  ),
                  sizedbox,
                  sizedbox,
                  textEdit(
                    email,
                    'e-mail...',
                    1,
                    TextInputType.text,
                    true,
                    false,
                    'E-mail',
                    const Color(0xFFECA233),
                    context,
                    false,
                    Icons.mail,
                  ),
                  sizedbox,
                  textEdit(
                    password,
                    'mot de passe...',
                    1,
                    TextInputType.text,
                    true,
                    false,
                    'Mot de passe',
                    const Color(0xFFECA233),
                    context,
                    true,
                    Icons.lock,
                  ),
                  sizedbox,
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: GestureDetector(
                      onTap: () async {
                        //login onTap
                        if (_fromKey.currentState!.validate()) {
                          signIn();
                        }
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFECA233),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: AppTextLarge(
                            text: 'Se connecter',
                            size: 18,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).focusColor,
                          border: Border.all(color: AppColors.activColor)),
                      child: AppTextLarge(
                        text: 'Créer votre compte',
                        size: 18,
                        color: AppColors.activColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/forgot'),
                            child: AppTextLarge(
                              text: 'Mot de passe oublié?',
                              size: 16,
                              color: Theme.of(context).hintColor,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
