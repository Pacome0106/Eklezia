// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_key_in_widget_constructors, deprecated_member_use
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/widgets/app_text.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/list_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../home_page.dart';

class ScreachScreen extends StatefulWidget {
  const ScreachScreen({Key? key, required this.videos, required this.search})
      : super(key: key);
  final List videos;
  final String search;

  @override
  State<ScreachScreen> createState() => _ScreachScreenState();
}

class _ScreachScreenState extends State<ScreachScreen> {
  TextEditingController search = TextEditingController();
  List videoSearch = [];

  // readData avec la fonction readSearch
  @override
  void initState() {
    search.text = widget.search;
    readCount();
    if (widget.search == '') {
      videoSearch = [];
      setState(() => videoSearch);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: 'searchSreen',
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).backgroundColor,
                leading: Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    child: IconButton(
                      iconSize: 35,
                      color: AppColors.activColor,
                      icon: const Icon(Icons.navigate_before),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      },
                    ),
                  ),
                ),
                title: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Theme.of(context).focusColor,
                  ),
                  child: TextField(
                    onChanged: (search) {
                      if (search.trim() == '') {
                        videoSearch = [];
                        setState(() => videoSearch);
                      } else {
                        readCount();
                      }
                    },
                    controller: search,
                    cursorColor: Theme.of(context).hintColor,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10, top: 5),
                      border: InputBorder.none,
                      focusColor: AppColors.menuColor,
                      suffixIcon: IconButton(
                        onPressed: () {
                          search.text = '';
                          videoSearch = [];
                          setState(() {
                            videoSearch;
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.activColor,
                        ),
                      ),
                      hintText: 'Recherche...',
                      hintStyle: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 16,
                          fontFamily: 'Nunito'),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).dividerColor, width: 2),
                          borderRadius: borderRadius,
                          gapPadding: 0),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).dividerColor, width: 2),
                          borderRadius: borderRadius,
                          gapPadding: 0),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              SliverList(
                delegate: videoSearch.isNotEmpty
                    ? SliverChildBuilderDelegate(
                        (BuildContext context, index) {
                          var now = DateTime.fromMicrosecondsSinceEpoch(
                              videoSearch[index]['date']);
                          return ListSearch(
                            titre: videoSearch[index]['title'],
                            urlImage: videoSearch[index]['imageUrl'],
                            urlVideo: videoSearch[index]['videoUrl'],
                            duration: videoSearch[index]['duration'],
                            date:
                                "${now.day} ${months[now.month - 1]} ${now.year} ",
                            search: search.text.trim(),
                            allVideos: widget.videos,
                            videos: videoSearch,
                            theuserUid: theuser!.uid.toString(),
                          );
                        },
                        childCount: videoSearch.length,
                      )
                    : SliverChildListDelegate(
                        [
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.25),
                            child: SvgPicture.asset(
                              'images/search.svg',
                              height: 150,
                              width: 150,
                            ),
                          ),
                          Center(
                            child: AppText(
                              text: 'Recherche...',
                              size: 20,
                              color: Theme.of(context).cardColor,
                            ),
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  readCount() async {
    videoSearch = [];
    for (int i = 0; i < widget.videos.length; i++) {
      String string = widget.videos[i]['title'];
      if (string.contains(search.text.trim())) {
        videoSearch.add(widget.videos[i]);
      }
    }
    setState(() => videoSearch);
  }
}
