import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yourappname/pages/blogdetail.dart';
import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/ebookdetails.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/pages/tutorprofilepage.dart';
import 'package:yourappname/pages/videobyidviewall.dart';
import 'package:yourappname/pages/viewall.dart';
import 'package:yourappname/provider/homeprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../model/sectionlistmodel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late HomeProvider homeProvider;
  PageController pageController = PageController();
  late ScrollController _scrollController;
  double? width;
  double? height;

  @override
  void initState() {
    printLog("Enter Home");
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _fetchData(0);
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (homeProvider.sectioncurrentPage ?? 0) <
            (homeProvider.sectiontotalPage ?? 0)) {
      printLog("load more====>");
      await homeProvider.setLoadMore(true);
      _fetchData(homeProvider.sectioncurrentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("isMorePage  ======> ${homeProvider.sectionisMorePage}");
    printLog("currentPage ======> ${homeProvider.sectioncurrentPage}");
    printLog("totalPage   ======> ${homeProvider.sectiontotalPage}");
    printLog("nextpage   ======> $nextPage");
    printLog("Call MyCourse");
    printLog("Pageno:== ${(nextPage ?? 0) + 1}");
    await homeProvider.getSeactionList((nextPage ?? 0) + 1);
    await homeProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    super.dispose();
    homeProvider.clearProvider();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvoked: (didPop) => alertdilog(context),
      child: Scaffold(
        appBar: Utils.mainAppBar(context, true),
        body: RefreshIndicator(
          backgroundColor: white,
          color: colorPrimary,
          displacement: 40,
          edgeOffset: 1.0,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          strokeWidth: 3,
          onRefresh: () async {
            homeProvider.clearProvider();
            _fetchData(0);
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              children: [
                buildPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPage() {
    return Consumer<HomeProvider>(builder: (context, homeprovider, child) {
      if (homeprovider.loading && !homeprovider.loadmore) {
        return commanShimmer();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            setSectionByType(),
            if (homeProvider.loadmore)
              SizedBox(
                height: 50,
                child: Utils.pageLoader(),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      }
    });
  }

  Widget setSectionByType() {
    if (homeProvider.sectionListModel.status == 200 &&
        homeProvider.sectionList != null) {
      if ((homeProvider.sectionList?.length ?? 0) > 0) {
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemCount: homeProvider.sectionList?.length ?? 0,
            shrinkWrap: true,
            reverse: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (homeProvider.sectionList?[index].data != null &&
                  (homeProvider.sectionList?[index].data?.length ?? 0) > 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    homeProvider.sectionList?[index].screenLayout == "banner"
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          text: homeProvider
                                                  .sectionList?[index].title
                                                  .toString() ??
                                              "",
                                          fontsizeNormal: Dimens.textBig,
                                          fontwaight: FontWeight.w600,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.start,
                                          fontstyle: FontStyle.normal,
                                          multilanguage: false),
                                      const SizedBox(height: 5),
                                      MyText(
                                          color: gray,
                                          multilanguage: false,
                                          text: homeProvider.sectionList?[index]
                                                  .shortTitle
                                                  .toString() ??
                                              "",
                                          textalign: TextAlign.center,
                                          fontsizeNormal: 12,
                                          fontsizeWeb: 12,
                                          maxline: 1,
                                          fontwaight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                ),
                                homeProvider.sectionList?[index].viewAll == 1
                                    ? InkWell(
                                        splashColor: transparentColor,
                                        focusColor: transparentColor,
                                        hoverColor: transparentColor,
                                        highlightColor: transparentColor,
                                        onTap: () {
                                          AdHelper.showFullscreenAd(context,
                                              Constant.interstialAdType, () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    ViewAll(
                                                  screenLayout: homeProvider
                                                          .sectionList?[index]
                                                          .screenLayout
                                                          .toString() ??
                                                      "",
                                                  title: homeProvider
                                                          .sectionList?[index]
                                                          .title
                                                          .toString() ??
                                                      "",
                                                  contentId: homeProvider
                                                          .sectionList?[index]
                                                          .id
                                                          .toString() ??
                                                      "",
                                                  viewAllType: "section",
                                                ),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  const begin =
                                                      Offset(1.0, 0.0);
                                                  const end = Offset.zero;
                                                  const curve = Curves.ease;

                                                  var tween = Tween(
                                                          begin: begin,
                                                          end: end)
                                                      .chain(CurveTween(
                                                          curve: curve));

                                                  return SlideTransition(
                                                    position:
                                                        animation.drive(tween),
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: MyText(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              text: "viewall",
                                              fontsizeNormal: Dimens.textDesc,
                                              fontwaight: FontWeight.w500,
                                              maxline: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textalign: TextAlign.right,
                                              fontstyle: FontStyle.normal,
                                              multilanguage: true),
                                        ))
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                    const SizedBox(height: 10),
                    // Section Data List
                    homeProvider.sectionList?[index].screenLayout == "list_view"
                        ? listView(index, homeProvider.sectionList)
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: getRemainingDataHeight(
                              homeProvider.sectionList?[index].screenLayout
                                      .toString() ??
                                  "",
                            ),
                            child: setSectionData(
                                index: index,
                                sectionList: homeProvider.sectionList),
                          ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      } else {
        return const NoData();
      }
    } else {
      return const NoData();
    }
  }

  double getRemainingDataHeight(String? screenLayout) {
    if (screenLayout == "banner") {
      return 320;
    } else if (screenLayout == "big_landscape") {
      return 260;
    } else if (screenLayout == "landscape") {
      return 240;
    } else if (screenLayout == "portrait") {
      return 250;
    } else if (screenLayout == "big_portrait") {
      return 260;
    } else if (screenLayout == "category") {
      return 115;
    } else if (screenLayout == "language") {
      return 115;
    } else if (screenLayout == "tutor") {
      return 180;
    } else if (screenLayout == "blog") {
      return 220;
    } else if (screenLayout == "book") {
      return 235;
    } else {
      return 0.0;
    }
  }

  Widget setSectionData(
      {required int index, required List<Result>? sectionList}) {
    if ((sectionList?[index].screenLayout.toString() ?? "") == "banner") {
      return banner(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "big_landscape") {
      return bigLandscap(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "landscape") {
      return landscap(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "portrait") {
      return portrait(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "big_portrait") {
      return bigPortrait(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "list_view") {
      return listView(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "category") {
      return category(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") ==
        "language") {
      return language(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") == "tutor") {
      return tutorlist(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") == "blog") {
      return blogList(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") == "book") {
      return bookList(index, sectionList);
    } else {
      return const SizedBox.shrink();
    }
  }

  /* Banner */
  Widget banner(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 320,
      child: CarouselSlider.builder(
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        options: CarouselOptions(
          initialPage: 0,
          height: MediaQuery.of(context).size.height,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
          autoPlay: true,
          autoPlayCurve: Curves.linear,
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(seconds: 1),
          viewportFraction: 0.7,
          onPageChanged: (index, reason) async {},
        ),
        itemBuilder: (BuildContext context, int index, int pageViewIndex) {
          printLog(
              "title===> ${sectionList?[sectionindex].data?[index].title.toString() ?? ""}");
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Detail(
                          courseId: sectionList?[sectionindex]
                                  .data?[index]
                                  .id
                                  .toString() ??
                              "");
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.7, color: gray),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    child: MyNetworkImage(
                        islandscap: true,
                        imgWidth: MediaQuery.of(context).size.width,
                        imgHeight: 170,
                        fit: BoxFit.fill,
                        imageUrl: sectionList?[sectionindex]
                                .data?[index]
                                .landscapeImg
                                .toString() ??
                            ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: sectionList?[sectionindex]
                                    .data?[index]
                                    .title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textDesc,
                            fontwaight: FontWeight.w600,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                                color: gray,
                                text: Utils.kmbGenerator(int.parse(
                                    sectionList?[sectionindex]
                                            .data?[index]
                                            .totalView
                                            .toString() ??
                                        "")),
                                fontsizeNormal: Dimens.textSmall,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            const SizedBox(width: 5),
                            MyText(
                                color: gray,
                                text: "students",
                                fontsizeNormal: Dimens.textSmall,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                multilanguage: true,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyRating(
                                rating: double.parse(sectionList?[sectionindex]
                                        .data?[index]
                                        .avgRating
                                        .toString() ??
                                    ""),
                                spacing: 5,
                                size: 15),
                            const SizedBox(width: 4),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                fontsizeNormal: Dimens.textMedium,
                                fontwaight: FontWeight.w600,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bannerShimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 500,
          child: PageView.builder(
            itemCount: 3,
            controller: pageController,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomWidget.roundcorner(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 20,
          alignment: Alignment.topCenter,
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
                spacing: 5,
                radius: 50,
                dotWidth: 5,
                expansionFactor: 7,
                dotColor: gray.withOpacity(0.40),
                dotHeight: 5,
                activeDotColor: gray),
          ),
        ),
      ],
    );
  }

  /* Category */
  Widget category(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      height: 115,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: -1, direction: Axis.vertical, children: [
          ...List.generate(
            sectionList?[sectionindex].data?.length ?? 0,
            (index) => InkWell(
              splashColor: transparentColor,
              focusColor: transparentColor,
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () {
                AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                    () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          VideoByIdViewAll(
                        apiType: "category",
                        title: sectionList?[sectionindex]
                                .data?[index]
                                .name
                                .toString() ??
                            "",
                        contentId: sectionList?[sectionindex]
                                .data?[index]
                                .id
                                .toString() ??
                            "",
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              child: Container(
                width: 160,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    border: Border.all(width: 0.8, color: gray)),
                margin: const EdgeInsets.all(5),
                child: MyText(
                    color: gray,
                    text: sectionList?[sectionindex]
                            .data?[index]
                            .name
                            .toString() ??
                        "",
                    fontsizeNormal: Dimens.textBigSmall,
                    overflow: TextOverflow.ellipsis,
                    maxline: 1,
                    fontwaight: FontWeight.w600,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget language(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      height: 115,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: -1, direction: Axis.vertical, children: [
          ...List.generate(
            sectionList?[sectionindex].data?.length ?? 0,
            (index) => InkWell(
              splashColor: transparentColor,
              focusColor: transparentColor,
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () {
                AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                    () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          VideoByIdViewAll(
                        apiType: "language",
                        title: sectionList?[sectionindex]
                                .data?[index]
                                .name
                                .toString() ??
                            "",
                        contentId: sectionList?[sectionindex]
                                .data?[index]
                                .id
                                .toString() ??
                            "",
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              child: Container(
                width: 160,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  border: Border.all(width: 0.8, color: gray),
                ),
                margin: const EdgeInsets.all(5),
                child: MyText(
                    color: gray,
                    text: sectionList?[sectionindex]
                            .data?[index]
                            .name
                            .toString() ??
                        "",
                    fontsizeNormal: Dimens.textBigSmall,
                    overflow: TextOverflow.ellipsis,
                    maxline: 1,
                    fontwaight: FontWeight.w600,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  /* bigLandscap List */
  Widget bigLandscap(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Detail(
                          courseId: sectionList?[sectionindex]
                                  .data?[index]
                                  .id
                                  .toString() ??
                              "");
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              width: 265,
              height: MediaQuery.sizeOf(context).height,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                // border: Border.all(width: 1,color: gray),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.10),
                    spreadRadius: 1.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: MyNetworkImage(
                        imgWidth: MediaQuery.of(context).size.width,
                        imgHeight: 145,
                        fit: BoxFit.fill,
                        islandscap: true,
                        imageUrl: sectionList?[sectionindex]
                                .data?[index]
                                .landscapeImg
                                .toString() ??
                            ""),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                              color: Theme.of(context).colorScheme.surface,
                              text: sectionList?[sectionindex]
                                      .data?[index]
                                      .title
                                      .toString() ??
                                  "",
                              fontsizeNormal: Dimens.textBigSmall,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                  color: gray,
                                  text: Utils.kmbGenerator(int.parse(
                                      sectionList?[sectionindex]
                                              .data?[index]
                                              .totalView
                                              .toString() ??
                                          "")),
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 5),
                              MyText(
                                  color: gray,
                                  text: "students",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  multilanguage: true,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              MyRating(
                                size: 13,
                                rating: double.parse((sectionList?[sectionindex]
                                        .data?[index]
                                        .avgRating
                                        .toString() ??
                                    "")),
                                spacing: 3,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                  color: colorAccent,
                                  text:
                                      "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w600,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bidLandscapShimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.roundrectborder(
                  height: 15, width: MediaQuery.of(context).size.width * 0.30),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomWidget.roundrectborder(
                      height: 15,
                      width: MediaQuery.of(context).size.width * 0.20),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: 220,
                  height: 220,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: colorAccent),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CustomWidget.roundrectborder(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.20),
                            const SizedBox(height: 10),
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.25),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                RatingBar(
                                  initialRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 10,
                                  ratingWidget: RatingWidget(
                                    full: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    half: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    empty: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                  ),
                                  itemPadding:
                                      const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  onRatingUpdate: (rating) {
                                    printLog("$rating");
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomWidget.roundrectborder(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    width: MediaQuery.of(context).size.width *
                                        0.30),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

/* landscap List */
  Widget landscap(int sectionindex, List<Result>? sectionList) {
    return Container(
      color: gray.withOpacity(0.20),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 240,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Detail(
                          courseId: sectionList?[sectionindex]
                                  .data?[index]
                                  .id
                                  .toString() ??
                              "");
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              width: 200,
              height: MediaQuery.sizeOf(context).height,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: 120,
                            fit: BoxFit.fill,
                            islandscap: true,
                            imageUrl: sectionList?[sectionindex]
                                    .data?[index]
                                    .thumbnailImg
                                    .toString() ??
                                ""),
                      ),
                      sectionList?[sectionindex].data?[index].isFree != 1
                          ? Positioned.fill(
                              top: 10,
                              left: 10,
                              right: 10,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorAccent,
                                  ),
                                  child: MyImage(
                                    width: 18,
                                    height: 18,
                                    imagePath: "ic_premium.png",
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                              color: Theme.of(context).colorScheme.surface,
                              text: sectionList?[sectionindex]
                                      .data?[index]
                                      .title
                                      .toString() ??
                                  "",
                              fontsizeNormal: Dimens.textBigSmall,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                  color: gray,
                                  text: Utils.kmbGenerator(
                                    int.parse(sectionList?[sectionindex]
                                            .data?[index]
                                            .totalView
                                            .toString() ??
                                        ""),
                                  ),
                                  fontsizeNormal: Dimens.textSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 5),
                              MyText(
                                  color: gray,
                                  text: "students",
                                  fontsizeNormal: Dimens.textSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  multilanguage: true,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              MyRating(
                                size: 13,
                                rating: double.parse((sectionList?[sectionindex]
                                        .data?[index]
                                        .avgRating
                                        .toString() ??
                                    "")),
                                spacing: 3,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                  color: colorAccent,
                                  text:
                                      "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w600,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget landscapShimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.roundrectborder(
                  height: 15, width: MediaQuery.of(context).size.width * 0.30),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomWidget.roundrectborder(
                      height: 15,
                      width: MediaQuery.of(context).size.width * 0.20),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: 220,
                  height: 220,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: colorAccent),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CustomWidget.roundrectborder(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.20),
                            const SizedBox(height: 10),
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.25),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                RatingBar(
                                  initialRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 10,
                                  ratingWidget: RatingWidget(
                                    full: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    half: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    empty: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                  ),
                                  itemPadding:
                                      const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  onRatingUpdate: (rating) {
                                    printLog("$rating");
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomWidget.roundrectborder(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    width: MediaQuery.of(context).size.width *
                                        0.30),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /* Portrait List */
  Widget portrait(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Detail(
                          courseId: sectionList?[sectionindex]
                                  .data?[index]
                                  .id
                                  .toString() ??
                              "");
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              width: 200,
              height: MediaQuery.sizeOf(context).height,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  MyNetworkImage(
                      imgWidth: MediaQuery.of(context).size.width,
                      imgHeight: 140,
                      fit: BoxFit.fill,
                      islandscap: true,
                      imageUrl: sectionList?[sectionindex]
                              .data?[index]
                              .landscapeImg
                              .toString() ??
                          ""),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: sectionList?[sectionindex]
                                    .data?[index]
                                    .title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textBigSmall,
                            fontwaight: FontWeight.w600,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                                color: gray,
                                text: Utils.kmbGenerator(
                                  int.parse(sectionList?[sectionindex]
                                          .data?[index]
                                          .totalView
                                          .toString() ??
                                      ""),
                                ),
                                fontsizeNormal: Dimens.textSmall,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            const SizedBox(width: 5),
                            MyText(
                                color: gray,
                                text: "students",
                                fontsizeNormal: Dimens.textSmall,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                multilanguage: true,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            MyRating(
                              size: 15,
                              rating: double.parse((sectionList?[sectionindex]
                                      .data?[index]
                                      .avgRating
                                      .toString() ??
                                  "")),
                              spacing: 3,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                fontsizeNormal: Dimens.textBigSmall,
                                fontwaight: FontWeight.w600,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget portraitShimmer() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.roundrectborder(
                  height: 15, width: MediaQuery.of(context).size.width * 0.30),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomWidget.roundrectborder(
                      height: 15,
                      width: MediaQuery.of(context).size.width * 0.20),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 70,
                    height: 1,
                    color: gray,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: 220,
                  height: 220,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(width: 1, color: colorAccent),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CustomWidget.roundrectborder(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.20),
                            const SizedBox(height: 10),
                            CustomWidget.roundrectborder(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                width:
                                    MediaQuery.of(context).size.width * 0.25),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                RatingBar(
                                  initialRating: 5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 10,
                                  ratingWidget: RatingWidget(
                                    full: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    half: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                    empty: const CustomWidget.roundrectborder(
                                        height: 15, width: 15),
                                  ),
                                  itemPadding:
                                      const EdgeInsets.fromLTRB(1, 0, 1, 0),
                                  onRatingUpdate: (rating) {
                                    printLog("$rating");
                                  },
                                ),
                                const SizedBox(width: 5),
                                CustomWidget.roundrectborder(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                    width: MediaQuery.of(context).size.width *
                                        0.30),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /* Listview  */
  Widget listView(int sectionindex, List<Result>? sectionList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      itemCount: sectionList?[sectionindex].data?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          splashColor: transparentColor,
          focusColor: transparentColor,
          hoverColor: transparentColor,
          highlightColor: transparentColor,
          onTap: () {
            AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return Detail(
                        courseId: sectionList?[sectionindex]
                                .data?[index]
                                .id
                                .toString() ??
                            "");
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return Align(
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                ),
              );
            });
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      child: MyNetworkImage(
                        imgWidth: 115,
                        imgHeight: 100,
                        imageUrl: sectionList?[sectionindex]
                                .data?[index]
                                .landscapeImg
                                .toString() ??
                            "",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                              color: Theme.of(context).colorScheme.surface,
                              text: sectionList?[sectionindex]
                                      .data?[index]
                                      .description
                                      .toString() ??
                                  "",
                              fontsizeNormal: Dimens.textBigSmall,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                  color: gray,
                                  text: Utils.kmbGenerator(int.parse(
                                      sectionList?[sectionindex]
                                              .data?[index]
                                              .totalView
                                              .toString() ??
                                          "")),
                                  fontsizeNormal: Dimens.textSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 5),
                              MyText(
                                  color: gray,
                                  text: "students",
                                  fontsizeNormal: Dimens.textSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  multilanguage: true,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyRating(
                                size: 13,
                                rating: double.parse(sectionList?[sectionindex]
                                        .data?[index]
                                        .avgRating
                                        .toString() ??
                                    ""),
                                spacing: 2,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                  color: colorAccent,
                                  text:
                                      "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w600,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              sectionList?[sectionindex].data?.length == index + 1
                  ? const SizedBox.shrink()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 0.9,
                      color: gray.withOpacity(0.15),
                    ),
            ],
          ),
        );
      },
    );
  }

  /* Big Portrait */
  Widget bigPortrait(int sectionindex, List<Result>? sectionList) {
    return Container(
      color: gray.withOpacity(0.20),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 260,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Detail(
                          courseId: sectionList?[sectionindex]
                                  .data?[index]
                                  .id
                                  .toString() ??
                              "");
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              width: 200,
              height: MediaQuery.sizeOf(context).height,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                children: [
                  MyNetworkImage(
                      imgWidth: MediaQuery.sizeOf(context).width,
                      imgHeight: 140,
                      fit: BoxFit.fill,
                      islandscap: true,
                      imageUrl: sectionList?[sectionindex]
                              .data?[index]
                              .thumbnailImg
                              .toString() ??
                          ""),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: sectionList?[sectionindex]
                                    .data?[index]
                                    .title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textBigSmall,
                            fontwaight: FontWeight.w600,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                                color: gray,
                                text: Utils.kmbGenerator(int.parse(
                                    sectionList?[sectionindex]
                                            .data?[index]
                                            .totalView
                                            .toString() ??
                                        "")),
                                fontsizeNormal: Dimens.textSmall,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            const SizedBox(width: 5),
                            MyText(
                                color: gray,
                                text: "students",
                                fontsizeNormal: Dimens.textSmall,
                                fontwaight: FontWeight.w500,
                                maxline: 1,
                                multilanguage: true,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            MyRating(
                              size: 13,
                              rating: double.parse((sectionList?[sectionindex]
                                      .data?[index]
                                      .avgRating
                                      .toString() ??
                                  "")),
                              spacing: 3,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                fontsizeNormal: Dimens.textBigSmall,
                                fontwaight: FontWeight.w600,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* Top Tutor */
  Widget tutorlist(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        TutorProfilePage(
                      tutorid: sectionList?[sectionindex]
                              .data?[index]
                              .id
                              .toString() ??
                          "",
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              width: 260,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              color: Theme.of(context).secondaryHeaderColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: MyNetworkImage(
                            imgWidth: 60,
                            imgHeight: 60,
                            fit: BoxFit.cover,
                            imageUrl: sectionList?[sectionindex]
                                    .data?[index]
                                    .image
                                    .toString() ??
                                ""),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: sectionList?[sectionindex]
                                            .data?[index]
                                            .fullName ==
                                        ""
                                    ? "Guest User"
                                    : sectionList?[sectionindex]
                                            .data?[index]
                                            .fullName
                                            .toString() ??
                                        "",
                                fontsizeNormal: Dimens.textDesc,
                                fontwaight: FontWeight.w600,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal),
                            const SizedBox(height: 5),
                            MyText(
                                color: gray,
                                text: sectionList?[sectionindex]
                                        .data?[index]
                                        .email
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textBigSmall,
                                fontwaight: FontWeight.w400,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: MyText(
                        color: gray,
                        text: sectionList?[sectionindex]
                                .data?[index]
                                .description
                                .toString() ??
                            "",
                        fontsizeNormal: Dimens.textSmall,
                        fontwaight: FontWeight.w400,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 0.8, color: colorPrimary),
                      ),
                      child: MyText(
                          color: colorPrimary,
                          text: "View Profile",
                          fontsizeNormal: Dimens.textSmall,
                          fontwaight: FontWeight.w500,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* Blog  */
  Widget blogList(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return BlogDetail(
                          blogId: sectionList?[sectionindex]
                                  .data?[index]
                                  .id
                                  .toString() ??
                              "");
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              });
            },
            child: SizedBox(
              width: 265,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: MyNetworkImage(
                        imgWidth: width,
                        imgHeight: 145,
                        fit: BoxFit.fill,
                        islandscap: true,
                        imageUrl: sectionList?[sectionindex]
                                .data?[index]
                                .image
                                .toString() ??
                            ""),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: sectionList?[sectionindex]
                                    .data?[index]
                                    .title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textBigSmall,
                            fontwaight: FontWeight.w600,
                            maxline: 3,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 5),
                        MyText(
                            color: gray,
                            text: Utils.timeAgoCustom(DateTime.parse(
                                sectionList?[sectionindex]
                                        .data?[index]
                                        .createdAt
                                        .toString() ??
                                    "")),
                            fontsizeNormal: Dimens.textSmall,
                            fontwaight: FontWeight.w600,
                            maxline: 3,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* Book  */
  Widget bookList(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 235,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        EbookDetails(
                      ebookId: sectionList?[sectionindex]
                              .data?[index]
                              .id
                              .toString() ??
                          "",
                      ebookName: sectionList?[sectionindex]
                              .data?[index]
                              .name
                              .toString() ??
                          "",
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              });
            },
            child: SizedBox(
              width: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: MyNetworkImage(
                        imgWidth: width,
                        imgHeight: 155,
                        imageUrl: sectionList?[sectionindex]
                                .data?[index]
                                .thumbnailImg
                                .toString() ??
                            "",
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 10),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: sectionList?[sectionindex]
                              .data?[index]
                              .title
                              .toString() ??
                          "",
                      fontsizeNormal: Dimens.textSmall,
                      fontsizeWeb: Dimens.textSmall,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontwaight: FontWeight.w600,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(height: 5),
                  MyText(
                      color: gray,
                      text: sectionList?[sectionindex]
                              .data?[index]
                              .tutorName
                              .toString() ??
                          "",
                      fontsizeNormal: Dimens.textSmall,
                      fontsizeWeb: Dimens.textSmall,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      fontwaight: FontWeight.w600,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      MyRating(
                        size: 13,
                        rating: double.parse((sectionList?[sectionindex]
                                .data?[index]
                                .avgRating
                                .toString() ??
                            "")),
                        spacing: 3,
                      ),
                      const SizedBox(width: 5),
                      MyText(
                          color: colorAccent,
                          text:
                              "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                          fontsizeNormal: Dimens.textBigSmall,
                          fontwaight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

/* Other Methods */
  alertdilog(BuildContext buildContext) {
    return showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Dialog(
              elevation: 16,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    MyText(
                        color: colorPrimary,
                        text: "onlinelearningapp",
                        maxline: 1,
                        fontwaight: FontWeight.w600,
                        fontsizeNormal: 16,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: true),
                    const SizedBox(height: 15),
                    MyText(
                        color: colorPrimary,
                        text: "areyousureexit",
                        maxline: 1,
                        fontwaight: FontWeight.w500,
                        fontsizeNormal: 14,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: true),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: transparentColor,
                          focusColor: transparentColor,
                          hoverColor: transparentColor,
                          highlightColor: transparentColor,
                          onTap: () {
                            exit(0);
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: colorPrimary,
                                borderRadius: BorderRadius.circular(5)),
                            child: MyText(
                                color: white,
                                text: "yes",
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                fontsizeNormal: 14,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal,
                                multilanguage: true),
                          ),
                        ),
                        InkWell(
                          splashColor: transparentColor,
                          focusColor: transparentColor,
                          hoverColor: transparentColor,
                          highlightColor: transparentColor,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: colorPrimary,
                                borderRadius: BorderRadius.circular(5)),
                            child: MyText(
                                color: white,
                                text: "cancel",
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                fontsizeNormal: 14,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal,
                                multilanguage: true),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              bottom: 200,
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: MyImage(
                    width: 70,
                    height: 70,
                    imagePath: "appicon_transparent.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /* Comman Shimmer */
  Widget commanShimmer() {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: 320,
          child: CarouselSlider.builder(
            itemCount: 10,
            options: CarouselOptions(
              initialPage: 0,
              height: height,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              autoPlay: true,
              autoPlayCurve: Curves.linear,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              viewportFraction: 0.7,
            ),
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return Container(
                margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0.7, color: gray),
                ),
                child: Column(
                  children: [
                    CustomWidget.roundrectborder(
                      width: width ?? 0.0,
                      height: 170,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.roundrectborder(
                            width: width ?? 0.0,
                            height: 5,
                          ),
                          const SizedBox(height: 5),
                          CustomWidget.roundrectborder(
                            width: width ?? 0.0,
                            height: 5,
                          ),
                          const SizedBox(height: 8),
                          CustomWidget.roundrectborder(
                            width: width ?? 0.0,
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundrectborder(height: 10, width: 150),
                  SizedBox(height: 5),
                  CustomWidget.roundrectborder(height: 10, width: 80),
                ],
              ),
              CustomWidget.roundrectborder(height: 10, width: 50),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          color: gray.withOpacity(0.20),
          width: width,
          alignment: Alignment.centerLeft,
          height: 240,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 200,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: CustomWidget.rectangular(
                        width: width ?? 0.0,
                        height: 120,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                              width: width ?? 0.0,
                              height: 5,
                            ),
                            const SizedBox(height: 8),
                            const CustomWidget.roundrectborder(
                              width: 100,
                              height: 5,
                            ),
                            const SizedBox(height: 8),
                            CustomWidget.roundrectborder(
                              width: width ?? 0.0,
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundrectborder(height: 10, width: 150),
                  SizedBox(height: 5),
                  CustomWidget.roundrectborder(height: 10, width: 80),
                ],
              ),
              CustomWidget.roundrectborder(height: 10, width: 50),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          color: gray.withOpacity(0.20),
          width: width,
          alignment: Alignment.centerLeft,
          height: 240,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 200,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: CustomWidget.rectangular(
                        width: width ?? 0.0,
                        height: 120,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                              width: width ?? 0.0,
                              height: 5,
                            ),
                            const SizedBox(height: 8),
                            const CustomWidget.roundrectborder(
                              width: 100,
                              height: 5,
                            ),
                            const SizedBox(height: 8),
                            CustomWidget.roundrectborder(
                              width: width ?? 0.0,
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundrectborder(height: 10, width: 150),
                  SizedBox(height: 5),
                  CustomWidget.roundrectborder(height: 10, width: 80),
                ],
              ),
              CustomWidget.roundrectborder(height: 10, width: 50),
            ],
          ),
        ),
        const SizedBox(height: 15),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: gray.withOpacity(0.50),
                          blurRadius: 2,
                          offset: const Offset(0.1, 0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5)),
                          child: CustomWidget.rectangular(
                            width: 110,
                            height: 100,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidget.roundrectborder(
                                width: width ?? 0.0,
                                height: 5,
                              ),
                              const SizedBox(height: 8),
                              const CustomWidget.roundrectborder(
                                width: 100,
                                height: 5,
                              ),
                              const SizedBox(height: 8),
                              CustomWidget.roundrectborder(
                                width: width ?? 0.0,
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
