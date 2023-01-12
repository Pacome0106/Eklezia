// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use
import 'package:eklezia/widgets/detail_communique.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class GroupesList extends StatelessWidget {
  const GroupesList(
    this.index, {
    super.key,
    required this.type,
    required this.user,
    required this.groupe,
    required this.charisme,
    required this.userData,
  });
  final index;
  final List type;
  final List groupe;
  final List charisme;
  final bool user;
  final String userData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        if (user) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCommmique(
                groupe: type[index],
                type: groupe.contains(type[index]) ? 'groupe' : 'charisme',
                userData: userData,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 10),
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).focusColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  user
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: Text(
                            type[index],
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                letterSpacing: 0),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // new
                          ),
                        )
                      : Container(
                          width: 150,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            color: Theme.of(context).hoverColor,
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }
}
