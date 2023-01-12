import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/detail_communique.dart';
import 'package:eklezia/widgets/detail_principal_group.dart';
import 'package:eklezia/widgets/members_list.dart';
import 'package:flutter/material.dart';
import '../../widgets/colors.dart';

class MembersScrenn extends StatefulWidget {
  const MembersScrenn({
    super.key,
    required this.groupe,
    required this.type,
    required this.userData,
  });
  final String groupe;
  final String type;
  final String userData;

  @override
  State<MembersScrenn> createState() => _MembersScrennState();
}

class _MembersScrennState extends State<MembersScrenn> {
  get sizedbox2 => null;
  List data = [];
  Future getUser() async {
    widget.type != 'cevb'
        ? await FirebaseFirestore.instance
            .collection('users')
            .where(widget.type == 'groupe' ? 'groupe' : 'charisme',
                arrayContains: widget.groupe)
            .get()
            .then((value) {
            for (var element in value.docs) {
              setState(() {
                data.add(element.data());
              });
            }
          })
        : await FirebaseFirestore.instance
            .collection('users')
            .where(widget.type, isEqualTo: widget.groupe)
            .get()
            .then((value) {
            for (var element in value.docs) {
              setState(() {
                data.add(element.data());
              });
            }
          });
    if (data.isNotEmpty) {
      request = true;
    }
  }

  bool request = false;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                iconSize: 35,
                padding: const EdgeInsets.all(0),
                color: AppColors.activColor,
                icon: const Icon(Icons.navigate_before),
                onPressed: () {
                  if (widget.type != 'cevb') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailCommmique(
                          groupe: widget.groupe,
                          type: widget.type,
                          userData: widget.userData,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPrincipalGroup(
                          groupe: widget.groupe,
                          type: widget.type,
                          userData: widget.userData,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextLarge(
                    text: 'Membres',
                    color: Theme.of(context).hintColor,
                    size: 22,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: request ? data.length : 6,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return MembersList(
                      name: request ? data[index]['name'] : '',
                      number: request ? data[index]['number'] : '',
                      request: request,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
