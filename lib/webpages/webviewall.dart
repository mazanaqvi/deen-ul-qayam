import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/viewallprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webblogdetail.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webpages/webebookdetail.dart';
import 'package:yourappname/webpages/webtutorprofile.dart';
import 'package:yourappname/webpages/webvideobyidviewall.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../model/sectiondetailmodel.dart';
import 'package:yourappname/model/videobyidmodel.dart' as videobyid;

class WebViewAll extends StatefulWidget {
  final String? contentId, title, viewAllType, screenLayout;
  const WebViewAll(
      {super.key,
      this.contentId,
      this.viewAllType,
      this.title,
      this.screenLayout});

  @override
  State<WebViewAll> createState() => WebViewAllState();
}

class WebViewAllState extends State<WebViewAll> {
  late ViewAllProvider viewAllProvider;
  PageController pageController = PageController();
  late ScrollController _scrollController;
  double? width;
  double? height;

  @override
  void initState() {
    viewAllProvider = Provider.of<ViewAllProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _fetchSectionDetail(0);
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (viewAllProvider.currentPage ?? 0) < (viewAllProvider.totalPage ?? 0)) {
      await viewAllProvider.setLoadMore(true);
      _fetchSectionDetail(viewAllProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchSectionDetail(int? nextPage) async {
    printLog("isMorePage  ======> ${viewAllProvider.isMorePage}");
    printLog("currentPage ======> ${viewAllProvider.currentPage}");
    printLog("totalPage   ======> ${viewAllProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    printLog("Call MyCourse");
    printLog("Pageno:== ${(nextPage ?? 0) + 1}");
    await viewAllProvider.getSeactionDetail(
        widget.contentId.toString(), (nextPage ?? 0) + 1);

    await viewAllProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    super.dispose();
    viewAllProvider.clearProvider();
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
            children: [
              Utils.childPanel(context),
              Utils.pageTitleLayout(context, widget.title ?? "", false),
              selectLayout(),
              buildSection(),
              const FooterWeb(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectLayout() {
    if (widget.viewAllType == "section" &&
        widget.screenLayout != "blog" &&
        widget.screenLayout != "tutor" &&
        widget.screenLayout != "category" &&
        widget.screenLayout != "language" &&
        widget.screenLayout != "book") {
      return Consumer<ViewAllProvider>(
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
                  await viewAllProvider.selectLayout(Constant.grid);
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
                  await viewAllProvider.selectLayout(Constant.list);
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
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildSection() {
    if (widget.screenLayout == "blog") {
      return buildBlog();
    } else if (widget.screenLayout == "book") {
      return buildBook();
    } else if (widget.screenLayout == "category" ||
        widget.screenLayout == "language") {
      return buildCategoryAndLanguage();
    } else if (widget.screenLayout == "tutor") {
      return buildTutor();
    } else {
      return buildSectionItem();
    }
  }

  Widget buildSectionItem() {
    return Consumer<ViewAllProvider>(
        builder: (context, viewallprovider, child) {
      if (viewAllProvider.loading && !viewallprovider.loadmore) {
        return buildShimmer();
      } else {
        if (viewallprovider.sectionDetailModel.status == 200 &&
            viewallprovider.sectionDetailList != null) {
          if ((viewallprovider.sectionDetailList?.length ?? 0) > 0) {
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
                          viewallprovider.sectionDetailList?.length ?? 0,
                          (index) {
                        return buildSectionLayout(index);
                      }),
                    ),
                  ),
                  if (viewallprovider.loadmore)
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

  /* Section Layout's Start */

  Widget buildSectionLayout(index) {
    if (viewAllProvider.layoutType == Constant.grid) {
      return bigPortrait(
          index: index, courseList: viewAllProvider.sectionDetailList ?? []);
    } else if (viewAllProvider.layoutType == Constant.square) {
      return square(
          index: index,
          sectionDetailList: viewAllProvider.sectionDetailList ?? []);
    } else {
      return listView(
          index: index,
          sectionDetailList: viewAllProvider.sectionDetailList ?? []);
    }
  }

  /* Listview  */
  Widget listView(
      {required int index, required List<Result>? sectionDetailList}) {
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
                            sectionDetailList?[index].thumbnailImg.toString() ??
                                "",
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
                            text: sectionDetailList?[index]
                                    .description
                                    .toString() ??
                                "",
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
                                    sectionDetailList?[index]
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyRating(
                              size: 15,
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
            sectionDetailList?.length == index + 1
                ? const SizedBox.shrink()
                : Container(
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
  Widget square(
      {required int index, required List<Result>? sectionDetailList}) {
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
  Widget bigPortrait({required int index, required List<Result>? courseList}) {
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

  /* Section Layout's End */

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

/* Blog Item  */

  Widget buildBlog() {
    return Consumer<ViewAllProvider>(
        builder: (context, viewallprovider, child) {
      if (viewAllProvider.loading && !viewallprovider.loadmore) {
        return buildShimmer();
      } else {
        if (viewallprovider.sectionDetailModel.status == 200 &&
            viewallprovider.sectionDetailList != null) {
          if ((viewallprovider.sectionDetailList?.length ?? 0) > 0) {
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
                      minItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 6,
                          height1200: 5,
                          height800: 3,
                          height400: 2),
                      maxItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 6,
                          height1200: 5,
                          height800: 3,
                          height400: 2),
                      horizontalGridSpacing: 5,
                      verticalGridSpacing: 10,
                      listViewBuilderOptions: ListViewBuilderOptions(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                      children: List.generate(
                          viewallprovider.sectionDetailList?.length ?? 0,
                          (index) {
                        return buildBlogItem(
                            index: index,
                            blogList: viewallprovider.sectionDetailList ?? []);
                      }),
                    ),
                  ),
                  if (viewallprovider.loadmore)
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

  Widget buildBlogItem({required int index, required List<Result>? blogList}) {
    return InkWell(
      focusColor: transparentColor,
      highlightColor: transparentColor,
      hoverColor: transparentColor,
      splashColor: transparentColor,
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return WebBlogDetail(
                    blogId: blogList?[index].id.toString() ?? "");
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MyNetworkImage(
                  imgWidth: MediaQuery.sizeOf(context).width,
                  imgHeight: 110,
                  fit: BoxFit.fill,
                  islandscap: true,
                  imageUrl: blogList?[index].image.toString() ?? ""),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: blogList?[index].title.toString() ?? "",
                      fontsizeNormal: Dimens.textBigSmall,
                      fontwaight: FontWeight.w600,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(height: 5),
                  MyText(
                      color: gray,
                      text: Utils.timeAgoCustom(
                        DateTime.parse(
                            blogList?[index].createdAt.toString() ?? ""),
                      ),
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
  }

/* Book Item */

  Widget buildBook() {
    return Consumer<ViewAllProvider>(
        builder: (context, viewallprovider, child) {
      if (viewAllProvider.loading && !viewallprovider.loadmore) {
        return buildShimmer();
      } else {
        if (viewallprovider.sectionDetailModel.status == 200 &&
            viewallprovider.sectionDetailList != null) {
          if ((viewallprovider.sectionDetailList?.length ?? 0) > 0) {
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
                      minItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 9,
                          height1200: 8,
                          height800: 6,
                          height400: 3),
                      maxItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 9,
                          height1200: 8,
                          height800: 6,
                          height400: 3),
                      horizontalGridSpacing: 10,
                      verticalGridSpacing: 10,
                      listViewBuilderOptions: ListViewBuilderOptions(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                      children: List.generate(
                          viewallprovider.sectionDetailList?.length ?? 0,
                          (index) {
                        return buildBookItem(
                            index: index,
                            bookList: viewallprovider.sectionDetailList ?? []);
                      }),
                    ),
                  ),
                  if (viewallprovider.loadmore)
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

  Widget buildBookItem({required int index, required List<Result>? bookList}) {
    return InkWell(
      focusColor: transparentColor,
      highlightColor: transparentColor,
      hoverColor: transparentColor,
      splashColor: transparentColor,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                WebEbookDetails(
              ebookId: bookList?[index].id.toString() ?? "",
              ebookName: bookList?[index].title.toString() ?? "",
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: MyNetworkImage(
                imgWidth: width,
                imgHeight: 170,
                imageUrl: bookList?[index].thumbnailImg.toString() ?? "",
                fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          MyText(
              color: Theme.of(context).colorScheme.surface,
              text: bookList?[index].title.toString() ?? "",
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
              text: bookList?[index].tutorName.toString() ?? "",
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
                rating:
                    double.parse((bookList?[index].avgRating.toString() ?? "")),
                spacing: 3,
              ),
              const SizedBox(width: 5),
              MyText(
                  color: colorAccent,
                  text:
                      "${double.parse(bookList?[index].avgRating.toString() ?? "")}",
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
    );
  }

/* Category And Language Layout Item */

  Widget buildCategoryAndLanguage() {
    return Consumer<ViewAllProvider>(
        builder: (context, viewallprovider, child) {
      if (viewAllProvider.loading && !viewallprovider.loadmore) {
        return buildCategoryAndLanguageShimmer();
      } else {
        if (viewallprovider.sectionDetailModel.status == 200 &&
            viewallprovider.sectionDetailList != null) {
          if ((viewallprovider.sectionDetailList?.length ?? 0) > 0) {
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
                      minItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 8,
                          height1200: 6,
                          height800: 4,
                          height400: 2),
                      maxItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 8,
                          height1200: 6,
                          height800: 4,
                          height400: 2),
                      horizontalGridSpacing: 2,
                      verticalGridSpacing: 2,
                      listViewBuilderOptions: ListViewBuilderOptions(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                      children: List.generate(
                          viewallprovider.sectionDetailList?.length ?? 0,
                          (index) {
                        return buildCategoryAndLangageItem(
                            index: index,
                            categoryList:
                                viewallprovider.sectionDetailList ?? []);
                      }),
                    ),
                  ),
                  if (viewallprovider.loadmore)
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

  Widget buildCategoryAndLangageItem(
      {required int index, required List<Result>? categoryList}) {
    return InkWell(
      splashColor: transparentColor,
      focusColor: transparentColor,
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return WebVideoByIdViewAll(
                title: categoryList?[index].name.toString() ?? "",
                contentId: categoryList?[index].id.toString() ?? "",
                apiType: widget.screenLayout,
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
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(width: 0.8, color: gray)),
        margin: const EdgeInsets.all(5),
        child: MyText(
            color: gray,
            text: categoryList?[index].name.toString() ?? "",
            fontsizeNormal: Dimens.textBigSmall,
            overflow: TextOverflow.ellipsis,
            maxline: 1,
            fontwaight: FontWeight.w600,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal),
      ),
    );
  }

  Widget buildCategoryAndLanguageShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 20, 100, 20)
          : const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: Utils.customCrossAxisCount(
              context: context,
              height1600: 8,
              height1200: 6,
              height800: 4,
              height400: 2),
          maxItemsPerRow: Utils.customCrossAxisCount(
              context: context,
              height1600: 8,
              height1200: 6,
              height800: 4,
              height400: 2),
          horizontalGridSpacing: 2,
          verticalGridSpacing: 2,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          ),
          children: List.generate(40, (index) {
            return const CustomWidget.circleborder(height: 40);
          }),
        ),
      ),
    );
  }

/* Tutor Item */

  Widget buildTutor() {
    return Consumer<ViewAllProvider>(
        builder: (context, viewallprovider, child) {
      if (viewAllProvider.loading && !viewallprovider.loadmore) {
        return buildTutorShimmer();
      } else {
        if (viewallprovider.sectionDetailModel.status == 200 &&
            viewallprovider.sectionDetailList != null) {
          if ((viewallprovider.sectionDetailList?.length ?? 0) > 0) {
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
                      minItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 8,
                          height1200: 6,
                          height800: 4,
                          height400: 2),
                      maxItemsPerRow: Utils.customCrossAxisCount(
                          context: context,
                          height1600: 8,
                          height1200: 6,
                          height800: 4,
                          height400: 2),
                      horizontalGridSpacing: 10,
                      verticalGridSpacing: 10,
                      listViewBuilderOptions: ListViewBuilderOptions(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                      children: List.generate(
                          viewallprovider.sectionDetailList?.length ?? 0,
                          (index) {
                        return buildTutorItem(
                            index: index,
                            tutorList: viewallprovider.sectionDetailList ?? []);
                      }),
                    ),
                  ),
                  if (viewallprovider.loadmore)
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

  Widget buildTutorItem(
      {required int index, required List<Result>? tutorList}) {
    return InkWell(
      splashColor: transparentColor,
      focusColor: transparentColor,
      hoverColor: transparentColor,
      highlightColor: transparentColor,
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                WebTutorProfile(
              tutorid: tutorList?[index].id.toString() ?? "",
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        color: Theme.of(context).secondaryHeaderColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: MyNetworkImage(
                  imgWidth: 60,
                  imgHeight: 60,
                  fit: BoxFit.cover,
                  imageUrl: tutorList?[index].image.toString() ?? ""),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: MyText(
                  color: Theme.of(context).colorScheme.surface,
                  text: tutorList?[index].fullName == ""
                      ? "Guest User"
                      : tutorList?[index].fullName.toString() ?? "",
                  fontsizeNormal: Dimens.textDesc,
                  fontwaight: FontWeight.w600,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
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
  }

  Widget buildTutorShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 20, 100, 20)
          : const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: Utils.customCrossAxisCount(
              context: context,
              height1600: 8,
              height1200: 6,
              height800: 4,
              height400: 2),
          maxItemsPerRow: Utils.customCrossAxisCount(
              context: context,
              height1600: 8,
              height1200: 6,
              height800: 4,
              height400: 2),
          horizontalGridSpacing: 10,
          verticalGridSpacing: 10,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          ),
          children: List.generate(40, (index) {
            return Container(
              width: 260,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              color: Theme.of(context).secondaryHeaderColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: const CustomWidget.circular(
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomWidget.roundrectborder(
                    width: MediaQuery.of(context).size.width,
                    height: 5,
                  ),
                  const SizedBox(height: 10),
                  CustomWidget.circleborder(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

/* Shimmer Widget */
  Widget buildShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 20, 100, 20)
          : const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: itemCount(),
          maxItemsPerRow: itemCount(),
          horizontalGridSpacing: 15,
          verticalGridSpacing: 15,
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
    );
  }

  int itemCount() {
    if (viewAllProvider.layoutType == Constant.grid) {
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
