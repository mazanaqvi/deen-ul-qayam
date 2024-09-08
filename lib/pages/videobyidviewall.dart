import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/pages/search.dart';
import 'package:yourappname/provider/videobyidviewallprovider.dart';
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
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:yourappname/model/videobyidmodel.dart' as videobyid;

class VideoByIdViewAll extends StatefulWidget {
  final String? contentId, title, apiType;
  const VideoByIdViewAll({
    super.key,
    this.contentId,
    this.apiType,
    this.title,
  });

  @override
  State<VideoByIdViewAll> createState() => ViewAllState();
}

class ViewAllState extends State<VideoByIdViewAll> {
  late VideoByIdViewAllProvider videoByIdViewAllProvider;
  PageController pageController = PageController();
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
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              autofocus: true,
              focusColor: white.withOpacity(0.5),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: MyImage(
                imagePath: "ic_left.png",
                height: 16,
                width: 16,
                color: gray,
              ),
            ),
            title: MyText(
              text: widget.title ?? "",
              multilanguage: false,
              fontsizeNormal: Dimens.textTitle,
              fontsizeWeb: Dimens.textTitle,
              fontstyle: FontStyle.normal,
              fontwaight: FontWeight.bold,
              textalign: TextAlign.center,
              color: Theme.of(context).colorScheme.surface,
            ),
            actions: [
              IconButton(
                autofocus: true,
                focusColor: white.withOpacity(0.5),
                onPressed: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const Search(
                            type: "course",
                            searchType: "3",
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
                  });
                },
                icon: MyImage(
                  imagePath: "ic_search.png",
                  height: 16,
                  width: 16,
                  color: black,
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            backgroundColor: white,
            color: colorPrimary,
            displacement: 40,
            edgeOffset: 1.0,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            strokeWidth: 3,
            onRefresh: () async {},
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  selectLayout(),
                  buildVideoById(),
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
        builder: (context, videobyidprovider, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                await videoByIdViewAllProvider.selectLayout(Constant.grid);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: MyImage(
                  width: 20,
                  height: 20,
                  imagePath: "ic_grid.png",
                  color: videobyidprovider.layoutType == Constant.grid
                      ? colorPrimary
                      : gray,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await videoByIdViewAllProvider.selectLayout(Constant.square);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: MyImage(
                  width: 20,
                  height: 20,
                  imagePath: "ic_square.png",
                  color: videobyidprovider.layoutType == Constant.square
                      ? colorPrimary
                      : gray,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await videoByIdViewAllProvider.selectLayout(Constant.list);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: MyImage(
                  width: 20,
                  height: 20,
                  imagePath: "ic_list.png",
                  color: videobyidprovider.layoutType == Constant.list
                      ? colorPrimary
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
              padding: const EdgeInsets.all(15),
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

  /* Listview  */
  Widget listView(
      {required int index,
      required List<videobyid.Result>? sectionDetailList}) {
    return InkWell(
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Detail(
                    courseId: sectionDetailList?[index].id.toString() ?? "");
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
                    imageUrl:
                        sectionDetailList?[index].thumbnailImg.toString() ?? "",
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
                          text: sectionDetailList?[index]
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
                                  sectionDetailList?[index]
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
                            rating: double.parse(sectionDetailList?[index]
                                    .avgRating
                                    .toString() ??
                                ""),
                            spacing: 2,
                          ),
                          const SizedBox(width: 5),
                          MyText(
                              color: colorAccent,
                              text:
                                  "${double.parse(sectionDetailList?[index].avgRating.toString() ?? "")}",
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
          sectionDetailList?.length == index + 1
              ? const SizedBox.shrink()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.9,
                  color: gray.withOpacity(0.15),
                ),
        ],
      ),
    );
  }

  /* Square */
  Widget square(
      {required int index,
      required List<videobyid.Result>? sectionDetailList}) {
    return InkWell(
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Detail(
                    courseId: sectionDetailList?[index].id.toString() ?? "");
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
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [
            MyNetworkImage(
                imgWidth: MediaQuery.sizeOf(context).width,
                imgHeight: 170,
                fit: BoxFit.fill,
                islandscap: true,
                imageUrl:
                    sectionDetailList?[index].thumbnailImg.toString() ?? ""),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: sectionDetailList?[index].title.toString() ?? "",
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
                            sectionDetailList?[index].avgRating.toString() ??
                                ""),
                        spacing: 2,
                      ),
                      const SizedBox(width: 5),
                      MyText(
                          color: colorAccent,
                          text:
                              "${double.parse(sectionDetailList?[index].avgRating.toString() ?? "")}",
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
  Widget bigPortrait(
      {required int index, required List<videobyid.Result>? courseList}) {
    return InkWell(
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Detail(courseId: courseList?[index].id.toString() ?? "");
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
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [
            MyNetworkImage(
                imgWidth: MediaQuery.sizeOf(context).width,
                imgHeight: 110,
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
                              courseList?[index].totalView.toString() ?? "")),
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

  /* Section Layout's End */

/* Category And Language Layouts Start */

  /* ListView */
  Widget listViewVideoById(
      {required int index, required List<videobyid.Result>? courseList}) {
    return InkWell(
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Detail(courseId: courseList?[index].id.toString() ?? "");
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
                    imageUrl: courseList?[index].thumbnailImg.toString() ?? "",
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
                          text: courseList?[index].description.toString() ?? "",
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
                                  courseList?[index].totalView.toString() ??
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
                                courseList?[index].avgRating.toString() ?? ""),
                            spacing: 2,
                          ),
                          const SizedBox(width: 5),
                          MyText(
                              color: colorAccent,
                              text:
                                  "${double.parse(courseList?[index].avgRating.toString() ?? "")}",
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
          courseList?.length == index + 1
              ? const SizedBox.shrink()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.9,
                  color: gray.withOpacity(0.15),
                ),
        ],
      ),
    );
  }

  /* Square */
  Widget squareVideoById(
      {required int index, required List<videobyid.Result>? courseList}) {
    return InkWell(
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Detail(courseId: courseList?[index].id.toString() ?? "");
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
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return Detail(courseId: courseList?[index].id.toString() ?? "");
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
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [
            MyNetworkImage(
                imgWidth: MediaQuery.sizeOf(context).width,
                imgHeight: 110,
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
                              courseList?[index].totalView.toString() ?? "")),
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

/* Category And Language Layouts End */

/* Shimmer Widget */
  Widget buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
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
                return Container(
                  width: 200,
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    children: [
                      CustomWidget.rectangular(
                        width: MediaQuery.sizeOf(context).width,
                        height: 110,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomWidget.rectangular(
                              width: MediaQuery.sizeOf(context).width,
                              height: 5,
                            ),
                            CustomWidget.rectangular(
                              width: MediaQuery.sizeOf(context).width,
                              height: 5,
                            ),
                            CustomWidget.rectangular(
                              width: MediaQuery.sizeOf(context).width,
                              height: 5,
                            ),
                            CustomWidget.rectangular(
                              width: MediaQuery.sizeOf(context).width,
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
      return 2;
    } else if (videoByIdViewAllProvider.layoutType == Constant.square) {
      return 1;
    } else {
      return 1;
    }
  }
}
