// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/dark_theme_provider.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_large.dart';
import '../../widgets/lign.dart';
import '../home_page.dart';

//page qui donne les differents parametres de l'application
//comme l'acces dans le compte privé , le chagement de theme de l'appli et la page aide
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SqlDb sqlDb = SqlDb();
  int countCommunique = 0;
  int countCEVB = 0;

  readCountFile(String table) async {
    List responses = await sqlDb.readCount(table);
    if (responses.isNotEmpty) {
      if (table == 'communiques') {
        countCommunique = responses[0]['COUNT()'];
        if (!mounted) {
          return;
        }
        print(countCommunique);
        setState(() => countCommunique);
      } else {
        countCEVB = responses[0]['COUNT()'];
        if (!mounted) {
          return;
        }
        print(countCEVB);
        setState(() => countCEVB);
      }
    }
  }

  @override
  void initState() {
    readCountFile('communiques');
    readCountFile('cevbs');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isTheme = themeChange.darkTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.navigate_before),
                  iconSize: 35,
                  color: AppColors.activColor,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
                ),
                AppTextLarge(
                  text: 'Paramètres',
                  size: 20.0,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: borderRadius,
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // changer la langue
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Theme.of(context).focusColor,
                                  insetPadding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  title: Center(
                                    child: AppText(
                                      text: 'Choisiser votre langue',
                                      size: 16,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: borderRadius),
                                  contentPadding: const EdgeInsets.only(
                                      top: 20, bottom: 20, left: 10, right: 10),
                                  content: SizedBox(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            //choose french
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                width: 1,
                                              ),
                                            ),
                                            height: 30,
                                            width: 120,
                                            child: AppTextLarge(
                                              text: 'Français',
                                              size: 18,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ),
                                        ),
                                        sizedbox2,
                                        sizedbox2,
                                        InkWell(
                                          onTap: () {
                                            //choose Lingala
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                              text: 'Lingala',
                                              size: 18,
                                              color: AppColors.activColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor: MaterialStateProperty.all(
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  text: 'Langue',
                                  color: Theme.of(context).hintColor,
                                  size: 16),
                              Container(
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  sizedbox,
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: borderRadius,
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            isTheme = !isTheme;
                            themeChange.darkTheme = isTheme;
                            setState(
                              () {
                                isTheme;
                              },
                            );
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor: MaterialStateProperty.all(
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                  text: 'Mode nuit',
                                  color: Theme.of(context).hintColor,
                                  size: 16),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: borderRadius,
                                ),
                                child: Icon(
                                  !isTheme
                                      ? Icons.nights_stay_sharp
                                      : Icons.light_mode,
                                  color: Theme.of(context).buttonColor,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                        Lign(
                          indent: MediaQuery.of(context).size.width * 0.05,
                          endIndent: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Hero(
                          tag: 'aide',
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/screens/help_screen');
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor: MaterialStateProperty.all(
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                    text: 'Aide',
                                    color: Theme.of(context).hintColor,
                                    size: 16),
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
                        ),
                      ],
                    ),
                  ),
                  sizedbox,
                  sizedbox,
                  AppTextLarge(
                      text: 'Stockage',
                      size: 18,
                      color: Theme.of(context).hintColor),
                  sizedbox,
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 8),
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: borderRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder,
                              size: 30,
                              color: Theme.of(context).bottomAppBarColor,
                            ),
                            sizedbox2,
                            AppText(
                              text: '${countCommunique + countCEVB}',
                              color: Theme.of(context).hintColor,
                              size: 16,
                            ),
                            AppText(
                              text: ' fichiers disponibles',
                              color: Theme.of(context).hintColor,
                              size: 16,
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: AppColors.poweroffColor,
                              borderRadius: borderRadius,
                            ),
                            child: const Icon(
                              Icons.delete_forever,
                              color: AppColors.mainColor,
                              size: 25,
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
                                      text:
                                          'Souhaitez-vous supprimer les fichiers ?',
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
                                          if (countCommunique != 0) {
                                            int response = await sqlDb
                                                .deleteraw('communiques');
                                            if (response != 0) {
                                              countCommunique = 0;
                                              setState(() => countCommunique);
                                            }
                                          }
                                          if (countCEVB != 0) {
                                            int response =
                                                await sqlDb.deleteraw('cevbs');
                                            if (response != 0) {
                                              countCEVB = 0;
                                              setState(() => countCEVB);
                                            }
                                          }
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
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
                                            text: 'Supprimer',
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Theme.of(context)
                                                .indicatorColor,
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
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
