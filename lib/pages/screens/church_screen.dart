import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eklezia/pages/home_page.dart';
import 'package:eklezia/pages/movie_page.dart';
import 'package:eklezia/widgets/app_text_large.dart';
import 'package:eklezia/widgets/colors.dart';
import 'package:eklezia/widgets/scroll_animation.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/app_text.dart';

class ChurchScreen extends StatefulWidget {
  const ChurchScreen({super.key});

  @override
  State<ChurchScreen> createState() => _ChurchScreenState();
}

class _ChurchScreenState extends State<ChurchScreen> {
  final controller = PageController();
  List<dynamic> images = [];
  String description = '';
  String localisation = '';
  bool isDescription = false;

  getDescription() async {
    await FirebaseFirestore.instance
        .collection("paroisses")
        .doc(paroisse)
        .get()
        .then((value) {
      images = value.data()!["images"];
      localisation = value.data()!["localisation"];
      description = value.data()!["description"];
    });
    if (!mounted) {
      return;
    } else {
      isDescription = true;
    }
    setState(() {
      images;
      description;
      isDescription;
    });
  }

  @override
  void initState() {
    getDescription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: ScrollAnimation(
                paroisse,
                '/home',
                Theme.of(context).hintColor,
                30,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: double.maxFinite,
                        child: PageView.builder(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: images.isNotEmpty ? images.length : 5,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.bottomRight,
                              margin: const EdgeInsets.only(right: 20),
                              height: double.maxFinite,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: Theme.of(context).focusColor,
                              ),
                              child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    images.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: borderRadius,
                                            child: Image.network(
                                              images[index],
                                              height: double.maxFinite,
                                              width: double.maxFinite,
                                              fit: BoxFit.cover,
                                              frameBuilder: (_, image,
                                                  loadingBuilder, __) {
                                                if (loadingBuilder == null) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        AppColors.activColor,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return image;
                                              },
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget image,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return image;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .activColor),
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, e, ___) =>
                                                  Center(
                                                child: Icon(
                                                  Icons.report_problem,
                                                  size: 30,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    InkWell(
                                      onTap: () {
                                        //localisation
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Theme.of(context).focusColor,
                                              insetPadding:
                                                  const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                              ),
                                              title: Column(
                                                children: [
                                                  Center(
                                                    child: AppTextLarge(
                                                      text: 'Localisation',
                                                      size: 16,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                  ),
                                                  sizedbox,
                                                  Container(
                                                    height: 370,
                                                    width: 250,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          borderRadius,
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                    ),
                                                    child: localisation != ''
                                                        ? Image.network(
                                                            localisation,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                            frameBuilder: (_,
                                                                image,
                                                                loadingBuilder,
                                                                __) {
                                                              if (loadingBuilder ==
                                                                  null) {
                                                                return const Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<
                                                                            Color>(
                                                                      AppColors
                                                                          .activColor,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              return image;
                                                            },
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        image,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return image;
                                                              }
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  valueColor: const AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      AppColors
                                                                          .activColor),
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              );
                                                            },
                                                            errorBuilder:
                                                                (context, e,
                                                                        ___) =>
                                                                    Center(
                                                              child: Icon(
                                                                Icons
                                                                    .report_problem,
                                                                size: 30,
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  )
                                                ],
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: borderRadius),
                                              contentPadding:
                                                  const EdgeInsets.all(0.0),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                Theme.of(context).dividerColor,
                                            width: 5,
                                          ),
                                          color: Theme.of(context).focusColor,
                                        ),
                                        child: const Icon(Icons.location_on,
                                            color: AppColors.activColor,
                                            size: 30),
                                      ),
                                    ),
                                  ]),
                            );
                          },
                        ),
                      ),
                      sizedbox,
                      Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: images.isNotEmpty ? images.length : 5,
                          effect: ExpandingDotsEffect(
                            expansionFactor: 2,
                            offset: 10,
                            radius: 8,
                            spacing: 4,
                            dotHeight: 10,
                            dotWidth: 10,
                            dotColor: Theme.of(context).focusColor,
                            activeDotColor: AppColors.activColor,
                          ),
                        ),
                      ),
                      sizedbox,
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: AppTextLarge(
                          text: 'Descriptions',
                          size: 18,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: AppText(
                          text: description,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
