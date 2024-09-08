import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/wishlistprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webpages/webebookdetail.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class WebWishList extends StatefulWidget {
  const WebWishList({Key? key}) : super(key: key);

  @override
  State<WebWishList> createState() => WebWishListState();
}

class WebWishListState extends State<WebWishList> {
  late WishlistProvider wishlistProvider;
  late ScrollController _scrollController;
  double? width;
  double? height;

  @override
  initState() {
    wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    /* Course List Api */
    _fetchData("3", 0);
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (wishlistProvider.currentPage ?? 0) <
            (wishlistProvider.totalPage ?? 0)) {
      wishlistProvider.setLoadMore(true);
      if (wishlistProvider.tabindex == 0) {
        _fetchData("3", wishlistProvider.currentPage ?? 0);
      } else if (wishlistProvider.tabindex == 1) {
        _fetchData("2", wishlistProvider.currentPage ?? 0);
      } else {
        _fetchData("1", wishlistProvider.currentPage ?? 0);
      }
    }
  }

  Future<void> _fetchData(type, int? nextPage) async {
    printLog("isMorePage  ======> ${wishlistProvider.isMorePage}");
    printLog("currentPage ======> ${wishlistProvider.currentPage}");
    printLog("totalPage   ======> ${wishlistProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    await wishlistProvider.getWishList(type, (nextPage ?? 0) + 1);
  }

  @override
  void dispose() {
    wishlistProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Utils.childPanel(context),
              Utils.pageTitleLayout(context, "wishlist", true),
              const SizedBox(height: 25),
              tabButton(),
              const SizedBox(height: 25),
              buildLayout(),
              const SizedBox(height: 25),
              const FooterWeb(),
            ],
          ),
        ),
      ),
    );
  }

  tabButton() {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistprovider, child) {
        return Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: MediaQuery.of(context).size.width > 800
              ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
              : const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemCount: Constant.wishListTab.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                focusColor: transparentColor,
                highlightColor: transparentColor,
                hoverColor: transparentColor,
                splashColor: transparentColor,
                onTap: () async {
                  await wishlistprovider.chageTab(index);
                  await wishlistprovider.clearWishList();
                  if (index == 0) {
                    _fetchData("3", 0);
                  } else if (index == 1) {
                    _fetchData("2", 0);
                  } else {
                    _fetchData("1", 0);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  decoration: BoxDecoration(
                    color: wishlistprovider.tabindex == index
                        ? colorPrimary
                        : transparentColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: MyText(
                      color: wishlistprovider.tabindex == index
                          ? white
                          : Theme.of(context).colorScheme.surface,
                      multilanguage: true,
                      text: Constant.wishListTab[index],
                      textalign: TextAlign.center,
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      maxline: 1,
                      fontwaight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal),
                ),
              );
            },
          ),
        );
      },
    );
  }

  buildLayout() {
    return Consumer<WishlistProvider>(
        builder: (context, wishlistprovider, child) {
      if (wishlistProvider.tabindex == 0) {
        return buildCourse();
      } else {
        return buildBook();
      }
    });
  }

  Widget buildCourse() {
    return Consumer<WishlistProvider>(
        builder: (context, wishlistprovider, child) {
      if (wishlistprovider.loading && !wishlistprovider.loadMore) {
        return courseShimmer();
      } else {
        if (wishlistProvider.wishlistmodel.status == 200 &&
            wishlistProvider.wishList != null) {
          if ((wishlistProvider.wishList?.length ?? 0) > 0) {
            return Padding(
              padding: MediaQuery.of(context).size.width > 800
                  ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
                  : const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  buildCourseItem(),
                  if (wishlistprovider.loadMore)
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

  Widget buildCourseItem() {
    return MediaQuery.removePadding(
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
          horizontalGridSpacing: 15,
          verticalGridSpacing: 15,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          ),
          children:
              List.generate(wishlistProvider.wishList?.length ?? 0, (index) {
            return InkWell(
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return WebDetail(
                          courseId:
                              wishlistProvider.wishList?[index].id.toString() ??
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
                return SizedBox(
                  width: 285,
                  child: Column(
                    children: [
                      AnimatedScale(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500),
                        scale: isHovered ? 1.03 : 1,
                        child: Stack(
                          children: [
                            MyNetworkImage(
                                imgWidth: MediaQuery.sizeOf(context).width,
                                imgHeight: 170,
                                fit: BoxFit.fill,
                                islandscap: true,
                                imageUrl: wishlistProvider
                                        .wishList?[index].thumbnailImg
                                        .toString() ??
                                    ""),
                            isHovered
                                ? Positioned.fill(
                                    top: 5,
                                    left: 10,
                                    right: 10,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: (wishlistProvider.position ==
                                                  index &&
                                              wishlistProvider
                                                  .deleteWishlistloading)
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: colorPrimary,
                                                strokeWidth: 1,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                wishlistProvider
                                                    .addremoveWatchLater(
                                                  "3",
                                                  index,
                                                  wishlistProvider
                                                          .wishList?[index].id
                                                          .toString() ??
                                                      "",
                                                );
                                              },
                                              child: const Icon(
                                                Icons.favorite,
                                                color: red,
                                                size: 25,
                                              ),
                                            ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: wishlistProvider.wishList?[index].title
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
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
                                        wishlistProvider
                                                .wishList?[index].totalView
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
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                MyRating(
                                  size: 18,
                                  rating: double.parse(wishlistProvider
                                          .wishList?[index].avgRating
                                          .toString() ??
                                      ""),
                                  spacing: 2,
                                ),
                                const SizedBox(width: 5),
                                MyText(
                                    color: colorAccent,
                                    text:
                                        "${double.parse(wishlistProvider.wishList?[index].avgRating.toString() ?? "")}",
                                    fontsizeNormal: Dimens.textTitle,
                                    fontsizeWeb: Dimens.textTitle,
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
          })),
    );
  }

  Widget buildBook() {
    return Consumer<WishlistProvider>(
        builder: (context, wishlistprovider, child) {
      if (wishlistprovider.loading && !wishlistprovider.loadMore) {
        return courseShimmer();
      } else {
        if (wishlistProvider.wishlistmodel.status == 200 &&
            wishlistProvider.wishList != null) {
          if ((wishlistProvider.wishList?.length ?? 0) > 0) {
            return Padding(
              padding: MediaQuery.of(context).size.width > 800
                  ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
                  : const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  buildBookItem(),
                  if (wishlistprovider.loadMore)
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

  Widget buildBookItem() {
    return MediaQuery.removePadding(
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
        horizontalGridSpacing: 5,
        verticalGridSpacing: 10,
        listViewBuilderOptions: ListViewBuilderOptions(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
        ),
        children:
            List.generate(wishlistProvider.wishList?.length ?? 0, (index) {
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
                    ebookId:
                        wishlistProvider.wishList?[index].id.toString() ?? "",
                    ebookName:
                        wishlistProvider.wishList?[index].title.toString() ??
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
            },
            child: InteractiveContainer(child: (isHovered) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: MyNetworkImage(
                            imgWidth: width,
                            imgHeight: 170,
                            imageUrl: wishlistProvider
                                    .wishList?[index].thumbnailImg
                                    .toString() ??
                                "",
                            fit: BoxFit.cover),
                      ),
                      isHovered
                          ? Positioned.fill(
                              top: 5,
                              left: 10,
                              right: 10,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: (wishlistProvider.position == index &&
                                        wishlistProvider.deleteWishlistloading)
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: colorPrimary,
                                          strokeWidth: 1,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          wishlistProvider.addremoveWatchLater(
                                            "2",
                                            index,
                                            wishlistProvider.wishList?[index].id
                                                    .toString() ??
                                                "",
                                          );
                                        },
                                        child: const Icon(
                                          Icons.favorite,
                                          color: red,
                                          size: 25,
                                        ),
                                      ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text:
                          wishlistProvider.wishList?[index].title.toString() ??
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
                      text: wishlistProvider.wishList?[index].tutorName
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
                        rating: double.parse(
                          wishlistProvider.wishList?[index].avgRating
                                  .toString() ??
                              "",
                        ),
                        spacing: 3,
                      ),
                      const SizedBox(width: 5),
                      MyText(
                          color: colorAccent,
                          text: "${double.parse(
                            wishlistProvider.wishList?[index].avgRating
                                    .toString() ??
                                "",
                          )}",
                          fontsizeNormal: Dimens.textBigSmall,
                          fontwaight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }

  Widget courseShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
          : const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: MediaQuery.removePadding(
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
            10,
            (index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidget.rectangular(
                      width: width ?? 0,
                      height: 170,
                    ),
                    const SizedBox(height: 8),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.roundrectborder(
                          width: 250,
                          height: 5,
                        ),
                        CustomWidget.roundrectborder(
                          width: 250,
                          height: 5,
                        ),
                        CustomWidget.roundrectborder(
                          width: 250,
                          height: 5,
                        ),
                        CustomWidget.roundrectborder(
                          width: 250,
                          height: 5,
                        ),
                      ],
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
}
