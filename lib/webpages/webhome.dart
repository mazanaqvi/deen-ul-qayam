import 'package:carousel_slider/carousel_slider.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/homeprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webblogdetail.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webpages/webebookdetail.dart';
import 'package:yourappname/webpages/webtutorprofile.dart';
import 'package:yourappname/webpages/webvideobyidviewall.dart';
import 'package:yourappname/webpages/webviewall.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../model/sectionlistmodel.dart';

class WebHome extends StatefulWidget {
  const WebHome({Key? key}) : super(key: key);

  @override
  State<WebHome> createState() => WebHomeState();
}

class WebHomeState extends State<WebHome> {
  CarouselController pageController = CarouselController();
  late ScrollController _scrollController;
  double? width;
  double? height;
  late HomeProvider homeProvider;

  @override
  void initState() {
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
    return Scaffold(
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.childPanel(context),
              buildPage(),
              const FooterWeb(),
            ],
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
            const SizedBox(height: 20)
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
                            padding: MediaQuery.of(context).size.width > 800
                                ? const EdgeInsets.fromLTRB(100, 25, 100, 0)
                                : const EdgeInsets.fromLTRB(20, 25, 20, 0),
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
                                          fontsizeNormal: Dimens.textExtraBig,
                                          fontsizeWeb: Dimens.textExtraBig,
                                          fontwaight: FontWeight.w600,
                                          maxline: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.start,
                                          fontstyle: FontStyle.normal,
                                          multilanguage: false),
                                      const SizedBox(height: 8),
                                      MyText(
                                          color: gray,
                                          multilanguage: false,
                                          text: homeProvider.sectionList?[index]
                                                  .shortTitle
                                                  .toString() ??
                                              "",
                                          textalign: TextAlign.center,
                                          fontsizeNormal: Dimens.textMedium,
                                          fontsizeWeb: Dimens.textMedium,
                                          maxline: 1,
                                          fontwaight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis,
                                          fontstyle: FontStyle.normal),
                                    ],
                                  ),
                                ),
                                homeProvider.sectionList?[index].viewAll == 1
                                    ? InkWell(
                                        hoverColor: transparentColor,
                                        highlightColor: transparentColor,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 1000),
                                              pageBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                                return WebViewAll(
                                                  screenLayout: homeProvider
                                                          .sectionList?[index]
                                                          .screenLayout
                                                          .toString() ??
                                                      "",
                                                  viewAllType: "section",
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
                                                );
                                              },
                                              transitionsBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
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
                                        },
                                        child: InteractiveContainer(
                                            child: (isHovered) {
                                          return Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 12, 20, 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5, color: black),
                                              color: isHovered
                                                  ? colorPrimary
                                                  : transparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: MyText(
                                                color: isHovered
                                                    ? white
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                text: "more",
                                                fontsizeNormal:
                                                    Dimens.textTitle,
                                                fontsizeWeb: Dimens.textTitle,
                                                fontwaight: FontWeight.w500,
                                                maxline: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textalign: TextAlign.right,
                                                fontstyle: FontStyle.normal,
                                                multilanguage: true),
                                          );
                                        }),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                    homeProvider.sectionList?[index].screenLayout == "banner"
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 25),
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
                          )
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
      return MediaQuery.of(context).size.width > 800 ? 500 : 340;
    } else if (screenLayout == "big_landscape") {
      return MediaQuery.of(context).size.width > 800 ? 300 : 270;
    } else if (screenLayout == "landscape") {
      return MediaQuery.of(context).size.width > 800 ? 280 : 250;
    } else if (screenLayout == "portrait") {
      return MediaQuery.of(context).size.width > 800 ? 280 : 250;
    } else if (screenLayout == "big_portrait") {
      return MediaQuery.of(context).size.width > 800 ? 300 : 270;
    } else if (screenLayout == "category") {
      return MediaQuery.of(context).size.width > 800 ? 200 : 115;
    } else if (screenLayout == "language") {
      return MediaQuery.of(context).size.width > 800 ? 200 : 115;
    } else if (screenLayout == "tutor") {
      return MediaQuery.of(context).size.width > 800 ? 260 : 200;
    } else if (screenLayout == "blog") {
      return MediaQuery.of(context).size.width > 800 ? 220 : 220;
    } else if (screenLayout == "book") {
      return MediaQuery.of(context).size.width > 800 ? 250 : 235;
    } else {
      return 0.0;
    }
  }

  Widget setSectionData(
      {required int index, required List<Result>? sectionList}) {
    if ((sectionList?[index].screenLayout.toString() ?? "") == "banner") {
      return buildBanner(index, sectionList);
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
      return buildTutor(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") == "blog") {
      return buildBlog(index, sectionList);
    } else if ((sectionList?[index].screenLayout.toString() ?? "") == "book") {
      return buildBook(index, sectionList);
    } else {
      return const SizedBox.shrink();
    }
  }

  /* Banner */

  buildBanner(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWebBanner(sectionindex, sectionList);
    } else {
      return buildMobileBanner(sectionindex, sectionList);
    }
  }

  Widget buildWebBanner(int sectionindex, List<Result>? sectionList) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 500,
          padding: MediaQuery.of(context).size.width > 800
              ? const EdgeInsets.fromLTRB(80, 0, 80, 0)
              : const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorPrimary,
                colorPrimary.withOpacity(0.35),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: CarouselSlider.builder(
            itemCount: sectionList?[sectionindex].data?.length ?? 0,
            carouselController: pageController,
            options: CarouselOptions(
              initialPage: 0,
              height: MediaQuery.of(context).size.height,
              enlargeCenterPage: false,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              autoPlay: true,
              autoPlayCurve: Curves.linear,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(seconds: 3),
              onPageChanged: (index, reason) async {
                await homeProvider.setCurrentBanner(index);
              },
            ),
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                splashColor: transparentColor,
                focusColor: transparentColor,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return WebDetail(
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
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: white,
                                text: sectionList?[sectionindex]
                                        .data?[index]
                                        .title
                                        .toString() ??
                                    "",
                                fontsizeNormal: 44,
                                fontsizeWeb: 44,
                                fontwaight: FontWeight.w700,
                                maxline: 3,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            const SizedBox(height: 18),
                            MyText(
                                color: white,
                                text: sectionList?[sectionindex]
                                        .data?[index]
                                        .description
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textlargeBig,
                                fontsizeWeb: Dimens.textlargeBig,
                                fontwaight: FontWeight.w400,
                                maxline: 4,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(
                                    color: white,
                                    text: Utils.kmbGenerator(int.parse(
                                        sectionList?[sectionindex]
                                                .data?[index]
                                                .totalView
                                                .toString() ??
                                            "")),
                                    fontsizeNormal: Dimens.textExtraBig,
                                    fontsizeWeb: Dimens.textExtraBig,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                                const SizedBox(width: 8),
                                MyText(
                                    color: white,
                                    text: "students",
                                    fontsizeNormal: Dimens.textExtraBig,
                                    fontsizeWeb: Dimens.textExtraBig,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    multilanguage: true,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyRating(
                                    rating: double.parse(
                                        sectionList?[sectionindex]
                                                .data?[index]
                                                .avgRating
                                                .toString() ??
                                            ""),
                                    spacing: 5,
                                    size: 25),
                                const SizedBox(width: 8),
                                MyText(
                                    color: colorAccent,
                                    text:
                                        "${double.parse(sectionList?[sectionindex].data?[index].avgRating.toString() ?? "")}",
                                    fontsizeNormal: Dimens.textTitle,
                                    fontsizeWeb: Dimens.textTitle,
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
                      const SizedBox(width: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: MyNetworkImage(
                            islandscap: true,
                            imgWidth: 390,
                            imgHeight: 270,
                            fit: BoxFit.fill,
                            imageUrl: sectionList?[sectionindex]
                                    .data?[index]
                                    .landscapeImg
                                    .toString() ??
                                ""),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned.fill(
          left: 20,
          right: 20,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                homeProvider.cBannerIndex == 0
                    ? const SizedBox.shrink()
                    : buildArrowBtns(
                        iconName: "ic_left",
                        onClick: () async {
                          await homeProvider.setCurrentBanner(
                              ((homeProvider.cBannerIndex ?? 0) - 1));
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.linear,
                          );
                        },
                      ),
                homeProvider.cBannerIndex ==
                        ((sectionList?[sectionindex].data?.length ?? 0) - 1)
                    ? const SizedBox.shrink()
                    : buildArrowBtns(
                        iconName: "ic_right",
                        onClick: () async {
                          await homeProvider.setCurrentBanner(
                              ((homeProvider.cBannerIndex ?? 0) + 1));
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.linear,
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMobileBanner(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 340,
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
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              splashColor: transparentColor,
              focusColor: transparentColor,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return WebDetail(
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyRating(
                                  rating: double.parse(
                                      sectionList?[sectionindex]
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
        ));
  }

  Widget bannerShimmer() {
    if (MediaQuery.of(context).size.width > 800) {
      return Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 500,
            padding: MediaQuery.of(context).size.width > 800
                ? const EdgeInsets.fromLTRB(80, 0, 80, 0)
                : const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorPrimary,
                  colorPrimary.withOpacity(0.35),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: PageView.builder(
              itemCount: 10,
              allowImplicitScrolling: true,
              itemBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.roundrectborder(
                                height: 15, width: 450),
                            SizedBox(height: 18),
                            CustomWidget.roundrectborder(
                                height: 10, width: 450),
                            CustomWidget.roundrectborder(
                                height: 10, width: 450),
                            SizedBox(height: 15),
                            CustomWidget.roundrectborder(
                                height: 10, width: 250),
                            SizedBox(height: 15),
                            CustomWidget.roundrectborder(
                                height: 10, width: 350),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      CustomWidget.roundcorner(
                        width: 390,
                        height: 270,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Positioned.fill(
          //   left: 20,
          //   right: 20,
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         _buildArrowBtns(
          //           iconName: "ic_left",
          //           onClick: () async {
          //             await homeProvider.setCurrentBanner(
          //                 ((homeProvider.cBannerIndex ?? 0) - 1));
          //             pageController.previousPage(
          //               duration: const Duration(milliseconds: 800),
          //               curve: Curves.linear,
          //             );
          //           },
          //         ),
          //         _buildArrowBtns(
          //           iconName: "ic_right",
          //           onClick: () async {
          //             await homeProvider.setCurrentBanner(
          //                 ((homeProvider.cBannerIndex ?? 0) + 1));
          //             pageController.nextPage(
          //               duration: const Duration(milliseconds: 800),
          //               curve: Curves.linear,
          //             );
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: CarouselSlider.builder(
          itemCount: 10,
          options: CarouselOptions(
            initialPage: 0,
            height: MediaQuery.of(context).size.height,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlay: false,
            autoPlayCurve: Curves.linear,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(seconds: 3),
            viewportFraction: 0.7,
            onPageChanged: (index, reason) async {},
          ),
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            return Container(
              margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 1.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomWidget.roundrectborder(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.roundrectborder(
                          width: MediaQuery.of(context).size.width,
                          height: 5,
                        ),
                        const SizedBox(height: 5),
                        const CustomWidget.roundrectborder(
                          width: 100,
                          height: 5,
                        ),
                        const SizedBox(height: 4),
                        const CustomWidget.roundrectborder(
                          width: 200,
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
      );
    }
  }

  Widget buildArrowBtns(
      {required String iconName, required Function() onClick}) {
    return InkWell(
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      splashColor: transparentColor,
      focusColor: transparentColor,
      borderRadius: BorderRadius.circular(50),
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: MyImage(
          height: 25,
          width: 25,
          imagePath: "$iconName.png",
          color: white,
        ),
      ),
    );
  }

  /* Category */

  Widget category(int sectionindex, List<Result>? sectionList) {
    return Container(
      alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.width > 800 ? 200 : 115,
      child: SingleChildScrollView(
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(90, 0, 90, 0)
            : const EdgeInsets.fromLTRB(15, 0, 15, 0),
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: -1, direction: Axis.vertical, children: [
          ...List.generate(
            sectionList?[sectionindex].data?.length ?? 0,
            (index) => InkWell(
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              splashColor: transparentColor,
              focusColor: transparentColor,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return WebVideoByIdViewAll(
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
                        apiType: "category",
                      );
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
              },
              child: InteractiveContainer(child: (isHovered) {
                return Container(
                  width: MediaQuery.of(context).size.width > 800 ? 150 : 130,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  height: MediaQuery.of(context).size.width > 800 ? 45 : 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isHovered ? colorPrimary : transparentColor,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                          width: 0.8, color: isHovered ? colorPrimary : gray)),
                  margin: const EdgeInsets.all(5),
                  child: MyText(
                      color: isHovered ? white : gray,
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
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }

  Widget language(int sectionindex, List<Result>? sectionList) {
    return Container(
      alignment: Alignment.centerLeft,
      height: MediaQuery.of(context).size.width > 800 ? 200 : 115,
      child: SingleChildScrollView(
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(90, 0, 90, 0)
            : const EdgeInsets.fromLTRB(15, 0, 15, 0),
        scrollDirection: Axis.horizontal,
        child: Wrap(spacing: -1, direction: Axis.vertical, children: [
          ...List.generate(
            sectionList?[sectionindex].data?.length ?? 0,
            (index) => InkWell(
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              splashColor: transparentColor,
              focusColor: transparentColor,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return WebVideoByIdViewAll(
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
                        apiType: "language",
                      );
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
              },
              child: InteractiveContainer(child: (isHovered) {
                return Container(
                  width: MediaQuery.of(context).size.width > 800 ? 150 : 130,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  height: MediaQuery.of(context).size.width > 800 ? 45 : 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isHovered ? colorPrimary : transparentColor,
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                          width: 0.8, color: isHovered ? colorPrimary : gray)),
                  margin: const EdgeInsets.all(5),
                  child: MyText(
                      color: isHovered ? white : gray,
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
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }

  /* bigLandscap List */

  bigLandscap(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWebBigLandscap(sectionindex, sectionList);
    } else {
      return buildMobileBigLandscap(sectionindex, sectionList);
    }
  }

  Widget buildWebBigLandscap(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 285,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 115, 106, 106)
                          .withOpacity(0.08),
                      spreadRadius: 1.5,
                      blurRadius: 0.5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AnimatedScale(
                      scale: isHovered ? 1.03 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: 170,
                            fit: BoxFit.fill,
                            islandscap: true,
                            imageUrl: sectionList?[sectionindex]
                                    .data?[index]
                                    .landscapeImg
                                    .toString() ??
                                ""),
                      ),
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
                                fontsizeWeb: Dimens.textBigSmall,
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
                                    fontsizeWeb: Dimens.textSmall,
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
                                    fontsizeWeb: Dimens.textSmall,
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
                                  size: 18,
                                  rating: double.parse(
                                      (sectionList?[sectionindex]
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
                                    fontsizeWeb: Dimens.textBigSmall,
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
              );
            }),
          );
        },
      ),
    );
  }

  Widget buildMobileBigLandscap(int sectionindex, List<Result>? sectionList) {
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
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 265,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 1.5,
                      blurRadius: 0.5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: ClipRRect(
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
                                fontsizeWeb: Dimens.textBigSmall,
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
                                    fontsizeWeb: Dimens.textBigSmall,
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
                                    fontsizeWeb: Dimens.textBigSmall,
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
                                  rating: double.parse(
                                      (sectionList?[sectionindex]
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
                                    fontsizeWeb: Dimens.textBigSmall,
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
              );
            }),
          );
        },
      ),
    );
  }

  /* landscap List */

  landscap(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWebLandscap(sectionindex, sectionList);
    } else {
      return buildMobileLandscap(sectionindex, sectionList);
    }
  }

  Widget buildWebLandscap(int sectionindex, List<Result>? sectionList) {
    return Container(
      color: colorPrimary.withOpacity(0.10),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 280,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 240,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: 145,
                            fit: BoxFit.fill,
                            islandscap: true,
                            imageUrl: sectionList?[sectionindex]
                                    .data?[index]
                                    .thumbnailImg
                                    .toString() ??
                                ""),
                      ),
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
                                fontsizeNormal: Dimens.textMedium,
                                fontsizeWeb: Dimens.textMedium,
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
                                    fontsizeNormal: Dimens.textDesc,
                                    fontsizeWeb: Dimens.textDesc,
                                    fontwaight: FontWeight.w500,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                                const SizedBox(width: 5),
                                MyText(
                                    color: gray,
                                    text: "students",
                                    fontsizeNormal: Dimens.textDesc,
                                    fontsizeWeb: Dimens.textDesc,
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
                                  size: 18,
                                  rating: double.parse(
                                      (sectionList?[sectionindex]
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
                                    fontsizeNormal: Dimens.textMedium,
                                    fontsizeWeb: Dimens.textMedium,
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
              );
            }),
          );
        },
      ),
    );
  }

  Widget buildMobileLandscap(int sectionindex, List<Result>? sectionList) {
    return Container(
      color: colorPrimary.withOpacity(0.10),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 250,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 200,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: 130,
                            fit: BoxFit.fill,
                            islandscap: true,
                            imageUrl: sectionList?[sectionindex]
                                    .data?[index]
                                    .thumbnailImg
                                    .toString() ??
                                ""),
                      ),
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
                                fontsizeWeb: Dimens.textBigSmall,
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
                                    fontsizeWeb: Dimens.textSmall,
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
                                    fontsizeWeb: Dimens.textSmall,
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
                                  rating: double.parse(
                                      (sectionList?[sectionindex]
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
                                    fontsizeWeb: Dimens.textBigSmall,
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
              );
            }),
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

  portrait(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWebportrait(sectionindex, sectionList);
    } else {
      return buildMobileportrait(sectionindex, sectionList);
    }
  }

  Widget buildWebportrait(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 280,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 240,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: MyNetworkImage(
                          imgWidth: MediaQuery.of(context).size.width,
                          imgHeight: 145,
                          fit: BoxFit.fill,
                          islandscap: true,
                          imageUrl: sectionList?[sectionindex]
                                  .data?[index]
                                  .thumbnailImg
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
                              fontsizeNormal: Dimens.textMedium,
                              fontsizeWeb: Dimens.textMedium,
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
                                  fontsizeNormal: Dimens.textDesc,
                                  fontsizeWeb: Dimens.textDesc,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 5),
                              MyText(
                                  color: gray,
                                  text: "students",
                                  fontsizeNormal: Dimens.textDesc,
                                  fontsizeWeb: Dimens.textDesc,
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
                                size: 18,
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
                                  fontsizeNormal: Dimens.textMedium,
                                  fontsizeWeb: Dimens.textMedium,
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
              );
            }),
          );
        },
      ),
    );
  }

  Widget buildMobileportrait(int sectionindex, List<Result>? sectionList) {
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
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 200,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
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
              );
            }),
          );
        },
      ),
    );
  }

  /* Listview  */

  Widget listView(int sectionindex, List<Result>? sectionList) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(90, 0, 90, 0)
            : const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: Utils.customCrossAxisCount(
              context: context,
              height1600: 3,
              height1200: 2,
              height800: 1,
              height400: 1),
          maxItemsPerRow: Utils.customCrossAxisCount(
              context: context,
              height1600: 3,
              height1200: 2,
              height800: 1,
              height400: 1),
          horizontalGridSpacing: 10,
          verticalGridSpacing: 10,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          ),
          children: List.generate(
            sectionList?[sectionindex].data?.length ?? 0,
            (index) {
              return InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                splashColor: transparentColor,
                focusColor: transparentColor,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return WebDetail(
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                                      rating: double.parse(
                                          sectionList?[sectionindex]
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
          ),
        ),
      ),
    );
  }

  /* Big Portrait */

  bigPortrait(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return webBigPortrait(sectionindex, sectionList);
    } else {
      return mobileBigPortrait(sectionindex, sectionList);
    }
  }

  Widget webBigPortrait(int sectionindex, List<Result>? sectionList) {
    return Container(
      color: colorPrimary.withOpacity(0.10),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 300,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 285,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: MyNetworkImage(
                          imgWidth: MediaQuery.sizeOf(context).width,
                          imgHeight: 170,
                          fit: BoxFit.fill,
                          islandscap: true,
                          imageUrl: sectionList?[sectionindex]
                                  .data?[index]
                                  .thumbnailImg
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
                              fontsizeWeb: Dimens.textBigSmall,
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
                                  fontsizeNormal: Dimens.textMedium,
                                  fontsizeWeb: Dimens.textMedium,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 5),
                              MyText(
                                  color: gray,
                                  text: "students",
                                  fontsizeNormal: Dimens.textMedium,
                                  fontsizeWeb: Dimens.textMedium,
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
                                size: 18,
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
                                  fontsizeNormal: Dimens.textTitle,
                                  fontsizeWeb: Dimens.textTitle,
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
              );
            }),
          );
        },
      ),
    );
  }

  Widget mobileBigPortrait(int sectionindex, List<Result>? sectionList) {
    return Container(
      color: colorPrimary.withOpacity(0.10),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      height: 270,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Container(
                width: 200,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: MyNetworkImage(
                          imgWidth: MediaQuery.sizeOf(context).width,
                          imgHeight: 140,
                          fit: BoxFit.fill,
                          islandscap: true,
                          imageUrl: sectionList?[sectionindex]
                                  .data?[index]
                                  .thumbnailImg
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
                              fontsizeWeb: Dimens.textBigSmall,
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
                                  fontsizeWeb: Dimens.textSmall,
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
                                  fontsizeWeb: Dimens.textSmall,
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
                                  fontsizeWeb: Dimens.textBigSmall,
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
              );
            }),
          );
        },
      ),
    );
  }

  /* Top Tutor */

  buildTutor(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWebTutorList(sectionindex, sectionList);
    } else {
      return buildMobileTutorlist(sectionindex, sectionList);
    }
  }

  Widget buildWebTutorList(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 260,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebTutorProfile(
                      tutorid: sectionList?[sectionindex]
                              .data?[index]
                              .id
                              .toString() ??
                          "",
                    );
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return AnimatedScale(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 500),
                scale: isHovered ? 1.03 : 1,
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  color: colorPrimary.withOpacity(0.12),
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
                                imgWidth: 80,
                                imgHeight: 80,
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                                    fontsizeNormal: Dimens.textBig,
                                    fontsizeWeb: Dimens.textBig,
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
                                    fontsizeNormal: Dimens.textMedium,
                                    fontsizeWeb: Dimens.textMedium,
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
                            fontsizeWeb: Dimens.textSmall,
                            fontwaight: FontWeight.w400,
                            maxline: 5,
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
                            color: isHovered ? colorPrimary : transparentColor,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 0.8, color: colorPrimary),
                          ),
                          child: MyText(
                              color: isHovered ? white : colorPrimary,
                              text: "View Profile",
                              fontsizeNormal: Dimens.textSmall,
                              fontsizeWeb: Dimens.textSmall,
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
            }),
          );
        },
      ),
    );
  }

  Widget buildMobileTutorlist(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebTutorProfile(
                      tutorid: sectionList?[sectionindex]
                              .data?[index]
                              .id
                              .toString() ??
                          "",
                    );
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return AnimatedScale(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 500),
                scale: isHovered ? 1.03 : 1,
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  color: colorPrimary.withOpacity(0.07),
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
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                            color: isHovered ? colorPrimary : transparentColor,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 0.8, color: colorPrimary),
                          ),
                          child: MyText(
                              color: isHovered ? white : colorPrimary,
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
            }),
          );
        },
      ),
    );
  }

  /* Blog  */

  Widget buildBlog(int sectionindex, List<Result>? sectionList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 220,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(90, 0, 90, 0)
            : const EdgeInsets.fromLTRB(15, 0, 15, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            splashColor: transparentColor,
            focusColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebBlogDetail(
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
            },
            child: SizedBox(
              width: 300,
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
                            maxline: 2,
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

  buildBook(int sectionindex, List<Result>? sectionList) {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWebBookList(sectionindex, sectionList);
    } else {
      return buildMobileBookList(sectionindex, sectionList);
    }
  }

  Widget buildWebBookList(int sectionindex, List<Result>? sectionList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
        itemCount: sectionList?[sectionindex].data?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            focusColor: transparentColor,
            highlightColor: transparentColor,
            hoverColor: transparentColor,
            splashColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebEbookDetails(
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
                    );
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
            },
            child: SizedBox(
              width: 155,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: MyNetworkImage(
                        imgWidth: width,
                        imgHeight: 170,
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

  Widget buildMobileBookList(int sectionindex, List<Result>? sectionList) {
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
            focusColor: transparentColor,
            highlightColor: transparentColor,
            hoverColor: transparentColor,
            splashColor: transparentColor,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebEbookDetails(
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
                    );
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
            },
            child: SizedBox(
              width: 155,
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

  sectionTitleRow(title) {
    return Row(
      children: [
        Expanded(
          child: MyText(
              color: colorPrimary,
              text: title,
              fontsizeNormal: Dimens.textExtraBig,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
        ),
        MyText(
            color: colorPrimary,
            text: "viewall",
            fontsizeNormal: Dimens.textMedium,
            fontwaight: FontWeight.w400,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            multilanguage: true),
      ],
    );
  }

  Widget rowTitle(title, onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Row(
        children: [
          Expanded(
            child: MyText(
                color: black,
                text: title,
                fontsizeNormal: Dimens.textBig,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                multilanguage: false),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyText(
                  color: colorPrimary,
                  text: "viewall",
                  fontsizeNormal: Dimens.textDesc,
                  fontwaight: FontWeight.w500,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.right,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
            ),
          ),
        ],
      ),
    );
  }

/* Comman Shimmer */

/* Banner Shimmer */
  shimmerTitle() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 25, 100, 0)
          : const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget.roundrectborder(height: 10, width: 250),
                SizedBox(height: 8),
                CustomWidget.roundrectborder(height: 5, width: 150),
              ],
            ),
          ),
          CustomWidget.roundrectborder(height: 8, width: 80),
        ],
      ),
    );
  }

  shimmerItem() {
    if (MediaQuery.of(context).size.width > 800) {
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        height: 290,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(90, 0, 90, 0),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return InteractiveContainer(child: (isHovered) {
              return Container(
                width: 285,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedScale(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      scale: isHovered ? 1.03 : 1,
                      child: CustomWidget.rectangular(
                        width: MediaQuery.sizeOf(context).width,
                        height: 170,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget.rectangular(
                            width: 200,
                            height: 5,
                          ),
                          SizedBox(height: 8),
                          CustomWidget.rectangular(
                            width: 150,
                            height: 5,
                          ),
                          SizedBox(height: 8),
                          CustomWidget.rectangular(
                            width: 200,
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return InteractiveContainer(child: (isHovered) {
              return Container(
                width: 200,
                height: MediaQuery.sizeOf(context).height,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: [
                    CustomWidget.rectangular(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                    ),
                    const SizedBox(height: 8),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.rectangular(
                          width: 250,
                          height: 5,
                        ),
                        SizedBox(height: 8),
                        CustomWidget.rectangular(
                          width: 200,
                          height: 5,
                        ),
                        SizedBox(height: 8),
                        CustomWidget.rectangular(
                          width: 200,
                          height: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
          },
        ),
      );
    }
  }

  Widget commanShimmer() {
    return Column(children: [
      bannerShimmer(),
      const SizedBox(height: 15),
      shimmerTitle(),
      shimmerItem(),
      shimmerTitle(),
      shimmerItem(),
      shimmerTitle(),
      shimmerItem(),
      shimmerTitle(),
      shimmerItem(),
    ]);
  }
}
