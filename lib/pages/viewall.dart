import 'package:yourappname/pages/blogdetail.dart';
import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/ebookdetails.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/pages/search.dart';
import 'package:yourappname/pages/tutorprofilepage.dart';
import 'package:yourappname/pages/videobyidviewall.dart';
import 'package:yourappname/provider/viewallprovider.dart';
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
import '../model/sectiondetailmodel.dart';

class ViewAll extends StatefulWidget {
  final String? contentId, title, viewAllType, screenLayout;
  const ViewAll(
      {super.key,
      this.contentId,
      this.viewAllType,
      this.title,
      this.screenLayout});

  @override
  State<ViewAll> createState() => ViewAllState();
}

class ViewAllState extends State<ViewAll> {
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
            onRefresh: () async {
              _fetchSectionDetail(0);
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 80),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  selectLayout(),
                  buildSection(),
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
                  await viewAllProvider.selectLayout(Constant.grid);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyImage(
                    width: 20,
                    height: 20,
                    imagePath: "ic_grid.png",
                    color: viewallprovider.layoutType == Constant.grid
                        ? colorPrimary
                        : gray,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  await viewAllProvider.selectLayout(Constant.square);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyImage(
                    width: 20,
                    height: 20,
                    imagePath: "ic_square.png",
                    color: viewallprovider.layoutType == Constant.square
                        ? colorPrimary
                        : gray,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  await viewAllProvider.selectLayout(Constant.list);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyImage(
                    width: 20,
                    height: 20,
                    imagePath: "ic_list.png",
                    color: viewallprovider.layoutType == Constant.list
                        ? colorPrimary
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
      {required int index, required List<Result>? sectionDetailList}) {
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
  Widget bigPortrait({required int index, required List<Result>? courseList}) {
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ResponsiveGridList(
                      minItemWidth: 120,
                      minItemsPerRow: 2,
                      maxItemsPerRow: 2,
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
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 1000),
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return BlogDetail(blogId: blogList?[index].id.toString() ?? "");
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ResponsiveGridList(
                      minItemWidth: 120,
                      minItemsPerRow: 3,
                      maxItemsPerRow: 3,
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
      onTap: () {
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  EbookDetails(
                ebookId: bookList?[index].id.toString() ?? "",
                ebookName: bookList?[index].title.toString() ?? "",
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
                  rating: double.parse(
                      (bookList?[index].avgRating.toString() ?? "")),
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ResponsiveGridList(
                      minItemWidth: 120,
                      minItemsPerRow: 3,
                      maxItemsPerRow: 3,
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
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  VideoByIdViewAll(
                apiType: widget.screenLayout,
                title: categoryList?[index].name.toString() ?? "",
                contentId: categoryList?[index].id.toString() ?? "",
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
      padding: const EdgeInsets.all(15),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: 3,
          maxItemsPerRow: 3,
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ResponsiveGridList(
                      minItemWidth: 120,
                      minItemsPerRow: 2,
                      maxItemsPerRow: 2,
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
        AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TutorProfilePage(
                tutorid: tutorList?[index].id.toString() ?? "",
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
      padding: const EdgeInsets.all(15),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: 2,
          maxItemsPerRow: 2,
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
    if (viewAllProvider.layoutType == Constant.grid) {
      return 2;
    } else if (viewAllProvider.layoutType == Constant.square) {
      return 1;
    } else {
      return 1;
    }
  }
}
