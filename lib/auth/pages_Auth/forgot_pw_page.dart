// ignore_for_file: use_build_context_synchronously

import 'package:eklezia/widgets/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/home_page.dart';
import '../../widgets/app_text_large.dart';
import '../../widgets/notification.dart';
import '../../widgets/textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController email = TextEditingController();

  Future passwordRest() async {
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
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      notification(
          context, 'Consulter boite mail pour un nouveau mot de passe', 65);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      Navigator.of(context).pop();
      if (e.toString().contains('[firebase_auth/user-not-found]')) {
        notification(context, 'Votre e-mail est incorrect!!!', 50);
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
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              iconSize: 35,
              padding: const EdgeInsets.all(10),
              color: AppColors.activColor,
              icon: const Icon(Icons.navigate_before),
            ),
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
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextLarge(
                    text:
                        'Entrer votre Email et vous allez reçevoir un nouveau mot de passe ',
                    size: 16,
                    color: Theme.of(context).hintColor,
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
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.10),
                    child: GestureDetector(
                      onTap: () async {
                        //login onTap
                        passwordRest();
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
                            text: 'Restorer',
                            size: 18,
                            color: Theme.of(context).hintColor,
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
      )),
    );
  }
}
