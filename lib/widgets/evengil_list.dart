import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/detail_evengil.dart';
import 'package:flutter/material.dart';

class EvengilList extends StatelessWidget {
  const EvengilList({
    super.key,
    required this.verset,
    required this.temps,
    required this.evengile,
    required this.date,
    required this.isData,
    required this.index,
  });
  final String verset;
  final String temps;
  final String evengile;
  final String date;
  final int index;
  final bool isData;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'evengile$index',
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailEvengile(
                verset: verset,
                temps: temps,
                evengile: evengile,
                date: date,
                index: index,
              ),
            ),
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
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: isData
                          ? Text(
                              verset,
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
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: Theme.of(context).hoverColor,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 8, left: 8, right: 8),
                      child: isData
                          ? Text(
                              temps,
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
                          : const SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: isData
                          ? Text(
                              evengile,
                              style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  decoration: TextDecoration.none,
                                  letterSpacing: 0),
                              softWrap: false,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis, // new
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                child: isData
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 14,
                                fontFamily: 'Nunito',
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
                              color: Theme.of(context).backgroundColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
