import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  const MembersList(
      {super.key,
      required this.name,
      required this.number,
      required this.request});
  final String name;
  final String number;
  final bool request;

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  Map<String, dynamic>? data;

  bool user = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).focusColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    !widget.request
                        ? CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).hoverColor,
                          )
                        : CircleAvatar(
                            radius: 25,
                            backgroundColor: Theme.of(context).hoverColor,
                            child: AppTextLarge(
                              text: widget.name[0],
                              color: AppColors.activColor,
                            ),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        !widget.request
                            ? Container(
                                width: 180,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: Theme.of(context).hoverColor,
                                ),
                              )
                            : AppTextLarge(
                                text: widget.name,
                                size: 18,
                                color: Theme.of(context).hintColor,
                              ),
                        const SizedBox(height: 5),
                        !widget.request
                            ? Container(
                                width: 150,
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  color: Theme.of(context).hoverColor,
                                ),
                              )
                            : AppText(
                                text: widget.number,
                                color: Theme.of(context).cardColor,
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          sizedbox,
        ],
      ),
    );
  }
}
