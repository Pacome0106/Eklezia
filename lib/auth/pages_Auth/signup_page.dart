// ignore_for_file: use_build_context_synchronously

import 'package:eklezia/auth/pages_Auth/identity_page.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:flutter/material.dart';
import '../../widgets/app_text.dart';
import '../../widgets/colors.dart';
import '../../widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmePassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
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
                  Center(
                    child: AppTextLarge(
                      text:
                          'Inscrivez- vous pour avoir tout les fonctionnalité',
                      color: Theme.of(context).hintColor,
                      size: 16,
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
                    AppColors.activColor,
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
                    AppColors.activColor,
                    context,
                    true,
                    Icons.lock,
                  ),
                  sizedbox,
                  textEdit(
                    confirmePassword,
                    'mot de passe...',
                    1,
                    TextInputType.text,
                    true,
                    false,
                    'Confirmation',
                    AppColors.activColor,
                    context,
                    true,
                    Icons.lock,
                  ),
                  sizedbox,
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (email.text == '' || password.text == '') {
                        notification(
                            context, 'Informations incompletes!!!', 50);
                      } else {
                        if (password.text == confirmePassword.text) {
                          if (password.text.length > 6) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IdentityPage(
                                        email: email, password: password)));
                          } else {
                            notification(
                                context,
                                'Votre mot de passe comprend moins de 6 caractres!!!',
                                50);
                          }
                        } else {
                          notification(
                              context, 'Erreur de confirmation!!!', 50);
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.activColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: AppTextLarge(
                          text: 'Valider ',
                          size: 18,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(
                        text: 'Déjà un menbre ?',
                        size: 16,
                        color: Theme.of(context).hintColor,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false),
                        child: AppTextLarge(
                          text: ' se connecter !',
                          size: 16,
                          color: AppColors.activColor,
                        ),
                      ),
                    ],
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
