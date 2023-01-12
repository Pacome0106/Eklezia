// ignore_for_file: use_build_context_synchronously

import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({
    super.key,
    required this.titre,
    required this.theme,
    required this.notes,
    required this.id,
    required this.index,
  });
  final String titre;
  final String theme;
  final String notes;
  final int index;
  final int id;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  //initialise database
  SqlDb sqlDb = SqlDb();

  TextEditingController titre = TextEditingController();
  TextEditingController theme = TextEditingController();
  TextEditingController notes = TextEditingController();

  @override
  void dispose() {
    titre.dispose();
    theme.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  void initState() {
    titre.text = widget.titre;
    theme.text = widget.theme;
    notes.text = widget.notes;
    if (widget.titre != '') {
      etatTitre = true;
    }
    if (widget.theme != '') {
      etatTheme = true;
    }
    if (widget.notes != '') {
      etatNote = true;
    }
    super.initState();
  }

  bool etatTitre = false;
  bool etatTheme = false;
  bool etatNote = false;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'note${widget.index}',
      child: ScaffoldMessenger(
        child: Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ScrollAnimation('Note', '/screens/bloc_note',
                      Theme.of(context).hintColor, 30),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Column(
                        children: [
                          sizedbox,
                          GestureDetector(
                            onTap: () async {
                              // save  note
                              if (widget.titre == '' &&
                                  widget.theme == '' &&
                                  widget.notes == '' &&
                                  widget.id == 0) {
                                if (titre.text != '') {
                                  int responses =
                                      await sqlDb.insertData('blocNotes', {
                                    'titre': titre.text.trim(),
                                    'theme': theme.text.trim(),
                                    'notes': notes.text.trim(),
                                    'date':
                                        DateTime.now().microsecondsSinceEpoch,
                                  });
                                  if (responses != 0) {
                                    notification(
                                        context, 'Note enregistrée', 50);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/screens/bloc_note', (route) => false);
                                  } else {
                                    notification(
                                        context,
                                        'Une erreur s\'est produite ! Veillez reessayer!!!',
                                        60);
                                  }
                                } else {
                                  notification(context,
                                      'Veillez donné le titre svp!!!', 50);
                                }
                              } else {
                                if (titre.text != '') {
                                  int responses = await sqlDb.updateData(
                                      'blocNotes',
                                      {
                                        'titre': titre.text.trim(),
                                        'theme': theme.text.trim(),
                                        'notes': notes.text.trim(),
                                        'date': DateTime.now()
                                            .microsecondsSinceEpoch
                                      },
                                      'id = ${widget.id}');
                                  if (responses != 0) {
                                    notification(
                                        context, 'Mise à jour enregistrée', 50);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        '/screens/bloc_note', (route) => false);
                                  } else {
                                    notification(
                                        context,
                                        'Une erreur s\'est produite ! Veillez reessayer!!!',
                                        60);
                                  }
                                } else {
                                  notification(context,
                                      'Veillez donné le titre svp!!!', 50);
                                }
                              }
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
                          ),
                          sizedbox,
                          sizedbox,
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppTextLarge(
                              text: 'Titre',
                              size: 20,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          sizedbox,
                          Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              decoration: !etatTitre
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).focusColor,
                                    )
                                  : const BoxDecoration(),
                              child: TextField(
                                maxLines: 1,
                                minLines: 1,
                                controller: titre,
                                cursorColor: Theme.of(context).hintColor,
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 16,
                                    fontFamily: 'Nunito'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefix: const SizedBox(width: 10),
                                  hintText: 'ajouter un titre...',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).cardColor,
                                      fontSize: 16,
                                      fontFamily: 'Nunito'),
                                ),
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  setState(() {
                                    etatTitre = true;
                                  });
                                },
                              )),
                          sizedbox,
                          sizedbox,
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppTextLarge(
                                text: 'Thème',
                                size: 20,
                                color: Theme.of(context).hintColor),
                          ),
                          sizedbox,
                          Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              decoration: !etatTheme
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).focusColor,
                                    )
                                  : const BoxDecoration(),
                              child: TextField(
                                maxLines: 2,
                                minLines: 2,
                                controller: theme,
                                cursorColor: Theme.of(context).hintColor,
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 16,
                                    fontFamily: 'Nunito'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefix: const SizedBox(width: 10),
                                  hintText: 'ajouter un thème...',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).cardColor,
                                      fontSize: 16,
                                      fontFamily: 'Nunito'),
                                ),
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  setState(() {
                                    etatTheme = true;
                                  });
                                },
                              )),
                          sizedbox,
                          sizedbox,
                          Container(
                            alignment: Alignment.centerLeft,
                            child: AppTextLarge(
                              text: 'Notes',
                              size: 20,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          sizedbox,
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            decoration: !etatNote
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).focusColor,
                                  )
                                : const BoxDecoration(),
                            child: TextField(
                              maxLines: 13,
                              minLines: 13,
                              controller: notes,
                              cursorColor: Theme.of(context).hintColor,
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 16,
                                  fontFamily: 'Nunito'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefix: const SizedBox(width: 10),
                                hintText: 'ajouter un note...',
                                hintStyle: TextStyle(
                                    color: Theme.of(context).cardColor,
                                    fontSize: 16,
                                    fontFamily: 'Nunito'),
                              ),
                              keyboardType: TextInputType.text,
                              onTap: () {
                                setState(() {
                                  etatNote = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
