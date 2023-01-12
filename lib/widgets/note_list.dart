// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'package:eklezia/add_pages/add_note.dart';
import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/notification.dart';
import 'package:flutter/material.dart';

class ListNote extends StatefulWidget {
  const ListNote({
    super.key,
    required this.titre,
    required this.theme,
    required this.notes,
    required this.id,
    required this.isNote,
    required this.date,
    required this.index,
  });
  final String titre;
  final String theme;
  final String notes;
  final String date;
  final int index;
  final int id;
  final bool isNote;

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'note${widget.index}',
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(
                titre: widget.titre,
                theme: widget.theme,
                notes: widget.notes,
                index: widget.index,
                id: widget.id,
              ),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    AlertDialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 40),
                      alignment: Alignment.bottomCenter,
                      contentPadding: const EdgeInsets.only(
                          left: 0, top: 0, right: 0, bottom: 0),
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      content: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: AppColors.alertColor2,
                            ),
                            child: InkWell(
                              onTap: () async {
                                int response = await SqlDb()
                                    .delete('blocNotes', 'id = ${widget.id}');
                                if (response != 0) {
                                  setState(() {
                                    Navigator.pushNamed(
                                        context, '/screens/bloc_note');
                                    notification(
                                        context, 'Note supprimée !', 50);
                                  });
                                } else {
                                  notification(context,
                                      'La suppression à échouer !', 50);
                                }
                              },
                              child: const Center(
                                heightFactor: 2,
                                child: Text(
                                  'Supprimer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.poweroffColor,
                                      fontSize: 18,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Theme.of(context).focusColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 10, left: 15, right: 15),
                      child: widget.isNote
                          ? Text(
                              widget.theme,
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0),
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // new
                            )
                          : Container(
                              height: 14,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: Theme.of(context).hoverColor,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: widget.isNote
                          ? Text(
                              widget.notes,
                              style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  decoration: TextDecoration.none,
                                  letterSpacing: 0),
                              softWrap: false,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis, // new
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: widget.isNote
                    ? Text(
                        widget.titre,
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // new
                      )
                    : Container(
                        height: 14,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).hoverColor,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 10, right: 10),
                child: widget.isNote
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.date,
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 12,
                                fontFamily: 'Nunito',
                                decoration: TextDecoration.none,
                                letterSpacing: 0),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // new
                          ),
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: Theme.of(context).hintColor,
                          )
                        ],
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).hoverColor,
                        ),
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).hintColor,
                            border: Border.all(
                              color: AppColors.mainColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
