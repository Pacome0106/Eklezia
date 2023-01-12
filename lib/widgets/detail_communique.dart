import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/pages/screens/members_screen.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/repport_list.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/movie_page.dart';

class DetailCommmique extends StatefulWidget {
  const DetailCommmique({
    super.key,
    required this.groupe,
    required this.type,
    required this.userData,
  });
  final String groupe;
  final String type;
  final String userData;

  @override
  State<DetailCommmique> createState() => _DetailCommmiqueState();
}

class _DetailCommmiqueState extends State<DetailCommmique> {
  late ScrollController _controller;
  List messages = [];

  getcommunique() async {
    await FirebaseFirestore.instance
        .collection(widget.groupe)
        .where('church', isEqualTo: paroisse)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      for (var video in value.docs) {
        messages.add(video);
      }
    });
    if (messages.isNotEmpty) {}
    if (!mounted) {
      return;
    }
    setState(() {
      messages;
    });
  }

  @override
  void initState() {
    getcommunique();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      getcommunique();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              iconSize: 35,
              padding: const EdgeInsets.all(0),
              color: AppColors.activColor,
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        currentIndex: 2,
                      ),
                    ),
                    (route) => false);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.groupe,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 22,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                        ),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // new
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MembersScrenn(
                              groupe: widget.groupe,
                              type: widget.type,
                              userData: widget.userData,
                            ),
                          ),
                          (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppTextLarge(
                          text: 'Membres',
                          color: AppColors.activColor,
                          size: 18,
                        ),
                        const Icon(
                          Icons.group,
                          color: AppColors.activColor,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            sizedbox,
            Expanded(
              child: ListView.builder(
                itemCount: messages.isEmpty ? 5 : messages.length,
                itemBuilder: (context, index) {
                  var now = DateTime.fromMicrosecondsSinceEpoch(
                      messages.isNotEmpty ? messages[index]['date'] : 0);
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ReportList(
                        id: messages.isNotEmpty
                            ? messages[index].id.toString()
                            : '',
                        groupe: widget.groupe,
                        objet: messages.isNotEmpty
                            ? (messages[index]['objet'] ?? '')
                            : '',
                        message: messages.isNotEmpty
                            ? messages[index]['message'] ?? ''
                            : '',
                        date:
                            "${now.day} ${months[now.month - 1]} ${now.year} à ${now.hour}:${now.minute}",
                        image: messages.isNotEmpty
                            ? messages[index]['imageUrl']
                            : '',
                        uid: messages.isNotEmpty
                            ? messages[index]['imageUrl'] != ''
                                ? messages[index]['uid']
                                : ''
                            : '',
                        connexion: true,
                        user: true,
                        permission: (widget.userData != 'Fidele' &&
                                widget.userData != 'Prêtre' &&
                                widget.userData != 'Chef de C.E.V.B')
                            ? true
                            : false),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
