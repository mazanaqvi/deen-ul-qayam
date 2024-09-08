import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/videobyidviewallprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:yourappname/model/videobyidmodel.dart' as videobyid;

class WebVideoByIdViewAll extends StatefulWidget {
  final String? contentId, title, apiType;
  const WebVideoByIdViewAll({
    super.key,
    this.contentId,
    this.apiType,
    this.title,
  });

  @override
  State<WebVideoByIdViewAll> createState() => ViewAllState();
}

class ViewAllState extends State<WebVideoByIdViewAll> {
  late VideoByIdViewAllProvider videoByIdViewAllProvider;
  late ScrollController _scrollController;
  double? width;
  double? height;

  @override
  void initState() {
    videoByIdViewAllProvider =
        Provider.of<VideoByIdViewAllProvider>(context, listen: false);
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
        (videoByIdViewAllProvider.currentPage ?? 0) <
            (videoByIdViewAllProvider.totalPage ?? 0)) {
      await videoByIdViewAllProvider.setLoadMore(true);
      _fetchData(videoByIdViewAllProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("isMorePage  ======> ${videoByIdViewAllProvider.isMorePage}");
    printLog("currentPage ======> ${videoByIdViewAllProvider.currentPage}");
    printLog("totalPage   ======> ${videoByIdViewAllProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    printLog("Call MyCourse");
    printLog("Pageno:== ${(nextPage ?? 0) + 1}");
    await videoByIdViewAllProvider.getVideoById(
        widget.contentId.toString(), widget.apiType, (nextPage ?? 0) + 1);

    await videoByIdViewAllProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    super.dispose();
    videoByIdViewAllProvider.clearProvider();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          appBar: Utils.webMainAppbar(),
          body: Utils.hoverItemWithPage(
            myWidget: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Utils.childPanel(context),
                  Utils.pageTitleLayout(context, widget.title ?? "", false),
                  selectLayout(),
                  buildVideoById(),
                  const FooterWeb(),
                ],
              ),
            ),
          ),
        ),
        /* AdMob Banner */
        Utils.showBannerAd(context),
      ],
    );
  }

  Widget selectLayout() {
    return Consumer<VideoByIdViewAllProvider>(
        builder: (context, viewallprovider, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(100, 20, 100, 20)
            : const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              splashColor: transparentColor,
              focusColor: transparentColor,
              onTap: () async {
                await viewallprovider.selectLayout(Constant.grid);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: viewallprovider.layoutType == Constant.grid
                      ? colorPrimary
                      : transparentColor,
                ),
                child: MyImage(
                  width: 20,
                  height: 20,
                  imagePath: "ic_grid.png",
                  color: viewallprovider.layoutType == Constant.grid
                      ? white
                      : gray,
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              splashColor: transparentColor,
              focusColor: transparentColor,
              onTap: () async {
                await viewallprovider.selectLayout(Constant.list);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: viewallprovider.layoutType == Constant.list
                      ? colorPrimary
                      : transparentColor,
                ),
                child: MyImage(
                  width: 20,
                  height: 20,
                  imagePath: "ic_list.png",
                  color: viewallprovider.layoutType == Constant.list
                      ? white
                      : gray,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildVideoById() {
    return Consumer<VideoByIdViewAllProvider>(
        builder: (context, videobyidviewallprovider, child) {
      if (videoByIdViewAllProvider.loading &&
          !videoByIdViewAllProvider.loadmore) {
        return buildShimmer();
      } else {
        if (videobyidviewallprovider.videobyIdModel.status == 200 &&
            videobyidviewallprovider.getCourseList != null) {
          if ((videobyidviewallprovider.getCourseList?.length ?? 0) > 0) {
            return Padding(
              padding: MediaQuery.of(context).size.width > 800
                  ? const EdgeInsets.fromLTRB(100, 20, 100, 20)
                  : const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Column(
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ResponsiveGridList(
                      minItemWidth: 120,
                      minItemsPerRow: itemCount(),
                      maxItemsPerRow: itemCount(),
                      horizontalGridSpacing: 5,
                      verticalGridSpacing: 10,
                      listViewBuilderOptions: ListViewBuilderOptions(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                      children: List.generate(
                          videobyidviewallprovider.getCourseList?.length ?? 0,
                          (index) {
                        return buildVideoByIdLayout(index);
                      }),
                    ),
                  ),
                  if (videobyidviewallprovider.loadmore)
                    Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Utils.pageLoader(),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            );
          } else {
            return const NoData();
          }
        } else {
          return const NoData();
        }
      }
    });
  }

  Widget buildVideoByIdLayout(index) {
    if (videoByIdViewAllProvider.layoutType == Constant.grid) {
      return bigPortraitVideoById(
          index: index,
          courseList: videoByIdViewAllProvider.getCourseList ?? []);
    } else if (videoByIdViewAllProvider.layoutType == Constant.square) {
      return squareVideoById(
          index: index,
          courseList: videoByIdViewAllProvider.getCourseList ?? []);
    } else {
      return listViewVideoById(
          index: index,
          courseList: videoByIdViewAllProvider.getCourseList ?? []);
    }
  }

/* Category And Language Layouts Start */

  /* ListView */
  Widget listViewVideoById(
      {required int index, required List<videobyid.Result>? courseList}) {
    return InkWell(
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      splashColor: transparentColor,
      focusColor: transparentColor,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return WebDetail(
                  courseId: courseList?[index].id.toString() ?? "");
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  AnimatedScale(
                    scale: isHovered ? 1.05 : 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5)),
                      child: MyNetworkImage(
                        imgWidth: 125,
                        imgHeight: 100,
                        imageUrl:
                            courseList?[index].thumbnailImg.toString() ?? "",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text:
                                courseList?[index].description.toString() ?? "",
                            fontsizeNormal: Dimens.textBigSmall,
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
                                text: Utils.kmbGenerator(int.parse(
                                    courseList?[index].totalView.toString() ??
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyRating(
                              size: 15,
                              rating: double.parse(
                                  courseList?[index].avgRating.toString() ??
                                      ""),
                              spacing: 2,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(courseList?[index].avgRating.toString() ?? "")}",
                                fontsizeNormal: Dimens.textBigSmall,
                                fontsizeWeb: Dimens.textMedium,
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 0.9,
              color: gray.withOpacity(0.15),
            ),
          ],
        );
      }),
    );
  }

  /* Square */
  Widget squareVideoById(
      {required int index, required List<videobyid.Result>? courseList}) {
    return InkWell(
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      splashColor: transparentColor,
      focusColor: transparentColor,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return WebDetail(
                  courseId: courseList?[index].id.toString() ?? "");
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
        width: 200,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [
            MyNetworkImage(
                imgWidth: MediaQuery.sizeOf(context).width,
                imgHeight: 170,
                fit: BoxFit.fill,
                islandscap: true,
                imageUrl: courseList?[index].thumbnailImg.toString() ?? ""),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: courseList?[index].title.toString() ?? "",
                      fontsizeNormal: Dimens.textTitle,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      MyRating(
                        size: 15,
                        rating: double.parse(
                            courseList?[index].avgRating.toString() ?? ""),
                        spacing: 2,
                      ),
                      const SizedBox(width: 5),
                      MyText(
                          color: colorAccent,
                          text:
                              "${double.parse(courseList?[index].avgRating.toString() ?? "")}",
                          fontsizeNormal: Dimens.textMedium,
                          fontwaight: FontWeight.w600,
                          maxline: 2,
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
  }

  /* Big Portrait */
  Widget bigPortraitVideoById(
      {required int index, required List<videobyid.Result>? courseList}) {
    return InkWell(
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      splashColor: transparentColor,
      focusColor: transparentColor,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return WebDetail(
                  courseId: courseList?[index].id.toString() ?? "");
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
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Column(
            children: [
              AnimatedScale(
                scale: isHovered ? 1.05 : 1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: MyNetworkImage(
                    imgWidth: MediaQuery.sizeOf(context).width,
                    imgHeight: 170,
                    fit: BoxFit.fill,
                    islandscap: true,
                    imageUrl: courseList?[index].thumbnailImg.toString() ?? ""),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        color: Theme.of(context).colorScheme.surface,
                        text: courseList?[index].title.toString() ?? "",
                        fontsizeNormal: Dimens.textBigSmall,
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
                            text: Utils.kmbGenerator(int.parse(
                                courseList?[index].totalView.toString() ?? "")),
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
                          size: 15,
                          rating: double.parse(
                              courseList?[index].avgRating.toString() ?? ""),
                          spacing: 2,
                        ),
                        const SizedBox(width: 5),
                        MyText(
                            color: colorAccent,
                            text:
                                "${double.parse(courseList?[index].avgRating.toString() ?? "")}",
                            fontsizeNormal: Dimens.textBigSmall,
                            fontsizeWeb: Dimens.textMedium,
                            fontwaight: FontWeight.w600,
                            maxline: 2,
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
  }

/* Category And Language Layouts End */

/* Shimmer Widget */
  Widget buildShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 20, 100, 20)
          : const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: Column(
        children: [
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ResponsiveGridList(
              minItemWidth: 120,
              minItemsPerRow: itemCount(),
              maxItemsPerRow: itemCount(),
              horizontalGridSpacing: 5,
              verticalGridSpacing: 10,
              listViewBuilderOptions: ListViewBuilderOptions(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
              ),
              children: List.generate(10, (index) {
                return SizedBox(
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidget.rectangular(
                        width: MediaQuery.sizeOf(context).width,
                        height: 170,
                      ),
                      const SizedBox(height: 8),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.rectangular(
                              width: 150,
                              height: 5,
                            ),
                            CustomWidget.rectangular(
                              width: 100,
                              height: 5,
                            ),
                            CustomWidget.rectangular(
                              width: 40,
                              height: 5,
                            ),
                            CustomWidget.rectangular(
                              width: 100,
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /* Item Count */
  int itemCount() {
    if (videoByIdViewAllProvider.layoutType == Constant.grid) {
      return Utils.customCrossAxisCount(
          context: context,
          height1600: 6,
          height1200: 5,
          height800: 3,
          height400: 2);
    } else {
      return Utils.customCrossAxisCount(
          context: context,
          height1600: 3,
          height1200: 2,
          height800: 1,
          height400: 1);
    }
  }
}
