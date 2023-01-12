import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/note_list.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:flutter/material.dart';

import '../../add_pages/add_note.dart';
import '../movie_page.dart';

class BlocNote extends StatefulWidget {
  const BlocNote({super.key});

  @override
  State<BlocNote> createState() => _BlocNoteState();
}

class _BlocNoteState extends State<BlocNote> {
  SqlDb sqlDb = SqlDb();
  List notes = [];

  readNote() async {
    List<Map> responses = await sqlDb.readDataNotes('blocNotes');
    notes.addAll(responses);
    if (responses.isNotEmpty) {
      setState(() {});
      isNote = true;
    }
  }

  @override
  void initState() {
    readNote();
    super.initState();
  }

  bool isNote = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: ScrollAnimation(
                  'Bloc note', '/home', Theme.of(context).hintColor, 30),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppTextLarge(
                        text: 'Carnet ',
                        size: 18,
                        color: Theme.of(context).hintColor,
                      ),
                      AppText(
                        text: '(${isNote ? notes.length : 5})',
                        size: 16,
                        color: Theme.of(context).hintColor,
                      )
                    ],
                  ),
                )
              ]),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150.0,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
                mainAxisExtent: 198,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, index) {
                  var date = DateTime.fromMicrosecondsSinceEpoch(
                      isNote ? notes[index]['date'] : 0);
                  return ListNote(
                    titre: isNote ? notes[index]['titre'] : '',
                    theme: isNote ? notes[index]['theme'] : '',
                    notes: isNote ? notes[index]['notes'] : '',
                    date:
                        isNote ? "${date.day} ${months[date.month - 1]}  " : '',
                    index: index,
                    id: isNote ? notes[index]['id'] : 0,
                    isNote: isNote,
                  );
                },
                childCount: isNote ? notes.length : 5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNote(
                titre: '',
                theme: '',
                notes: '',
                index: -1,
                id: 0,
              ),
            ),
          );
        },
        child: Icon(
          Icons.edit_note,
          size: 30,
          color: Theme.of(context).shadowColor,
        ),
      ),
    );
  }
}
