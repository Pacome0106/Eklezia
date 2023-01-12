import 'package:eklezia/local%20_database/sqldb.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/evengil_list.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';

class EvengilScreen extends StatefulWidget {
  const EvengilScreen({super.key});

  @override
  State<EvengilScreen> createState() => _EvengilScreenState();
}

class _EvengilScreenState extends State<EvengilScreen> {
  SqlDb sqlDb = SqlDb();
  List evengils = [];

  readDataEvengil() async {
    List<Map> responses = await sqlDb.readDataEvengil();
    evengils.addAll(responses);
    if (responses.isNotEmpty) {
      setState(() {});
      isData = true;
    }
  }

  @override
  void initState() {
    readDataEvengil();
    super.initState();
  }

  bool isData = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: ScrollAnimation(
                  'Lectionnaire', '/home', Theme.of(context).hintColor, 30),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  child: AppTextLarge(
                    text: 'Année liturgique A',
                    size: 18,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Theme.of(context).hintColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: AppText(
                        text: ' ${isData ? evengils.length : 5} jours restants',
                        size: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                )
              ]),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150.0,
                mainAxisSpacing: 30,
                childAspectRatio: 1,
                mainAxisExtent: 180,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, index) {
                  var date = DateTime.fromMicrosecondsSinceEpoch(
                      isData ? evengils[index]['date'] : 0);
                  return EvengilList(
                    verset: isData ? evengils[index]['verset'] : '',
                    temps: isData ? evengils[index]['temps'] : '',
                    evengile: isData ? evengils[index]['evengile'] : '',
                    date:
                        isData ? "${date.day} ${months[date.month - 1]}  " : '',
                    index: index,
                    isData: isData,
                  );
                },
                childCount: isData ? evengils.length : 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
