import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/ebookdetails.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/wishlistprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => WishListState();
}

class WishListState extends State<WishList> {
  late WishlistProvider wishlistProvider;
  late ScrollController _scrollController;
  double? width;
  double? height;

  @override
  void initState() {
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
      printLog("load more====>");
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
    wishlistProvider.setLoadMore(false);
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
      appBar: Utils.myAppBarWithBack(context, "wishlist", true),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tabButton(),
              setLayout(),
            ],
          ),
          /* AdMob Banner */
          Utils.showBannerAd(context),
        ],
      ),
    );
  }

  tabButton() {
    return Consumer<WishlistProvider>(
        builder: (context, wishlistprovider, child) {
      return SizedBox(
        height: 50,
        child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 1),
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
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: MyText(
                              color: Theme.of(context).colorScheme.surface,
                              multilanguage: true,
                              text: Constant.wishListTab[index],
                              textalign: TextAlign.center,
                              fontsizeNormal: Dimens.textMedium,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1.5,
                        color: wishlistprovider.tabindex == index
                            ? black
                            : transparentColor,
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }

  setLayout() {
    return Consumer<WishlistProvider>(
        builder: (context, wishlistprovider, child) {
      if (wishlistProvider.loading && !wishlistProvider.loadMore) {
        return (wishlistProvider.tabindex == 0)
            ? courseShimmer()
            : bookShimmer();
      } else {
        if (wishlistProvider.wishlistmodel.status == 200 &&
            wishlistProvider.wishList != null) {
          if ((wishlistProvider.wishList?.length ?? 0) > 0) {
            return Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: (wishlistProvider.tabindex == 0)
                    ? buildCourse()
                    : buildBook(),
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

  Widget buildCourse() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: [
          courseItem(),
          if (wishlistProvider.loadMore)
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
  }

  Widget courseItem() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: 2,
          maxItemsPerRow: 2,
          horizontalGridSpacing: 5,
          verticalGridSpacing: 5,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          children:
              List.generate(wishlistProvider.wishList?.length ?? 0, (index) {
            return InkWell(
              onTap: () {
                AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                    () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return Detail(
                            courseId: wishlistProvider.wishList?[index].id
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
                width: 200,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        MyNetworkImage(
                            imgWidth: MediaQuery.sizeOf(context).width,
                            imgHeight: 110,
                            fit: BoxFit.fill,
                            islandscap: true,
                            imageUrl: wishlistProvider
                                    .wishList?[index].thumbnailImg
                                    .toString() ??
                                ""),
                        Positioned.fill(
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
                                        "3",
                                        index,
                                        wishlistProvider.wishList?[index].id
                                                .toString() ??
                                            "",
                                      );
                                    },
                                    child: const Icon(
                                      Icons.favorite,
                                      color: red,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                              fontsizeNormal: Dimens.textMedium,
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
          })),
    );
  }

  Widget buildBook() {
    if (wishlistProvider.loading && !wishlistProvider.loadMore) {
      return bookShimmer();
    } else {
      if (wishlistProvider.wishlistmodel.status == 200 &&
          wishlistProvider.wishList != null) {
        if ((wishlistProvider.wishList?.length ?? 0) > 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              children: [
                buildBookItem(),
                if (wishlistProvider.loadMore)
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
  }

  Widget buildBookItem() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ResponsiveGridList(
        minItemWidth: 120,
        minItemsPerRow: 3,
        maxItemsPerRow: 3,
        horizontalGridSpacing: 5,
        verticalGridSpacing: 10,
        listViewBuilderOptions: ListViewBuilderOptions(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children:
            List.generate(wishlistProvider.wishList?.length ?? 0, (index) {
          return InkWell(
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        EbookDetails(
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
              });
            },
            child: SizedBox(
              width: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: MyNetworkImage(
                            imgWidth: width,
                            imgHeight: 155,
                            imageUrl: wishlistProvider
                                    .wishList?[index].thumbnailImg
                                    .toString() ??
                                "",
                            fit: BoxFit.cover),
                      ),
                      Positioned.fill(
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
                                  ),
                                ),
                        ),
                      ),
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
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget courseShimmer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: MediaQuery.removePadding(
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
              physics: const NeverScrollableScrollPhysics(),
            ),
            children: List.generate(
              10,
              (index) {
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
                            CustomWidget.roundrectborder(
                              width: MediaQuery.sizeOf(context).width,
                              height: 5,
                            ),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.sizeOf(context).width,
                              height: 5,
                            ),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.sizeOf(context).width,
                              height: 5,
                            ),
                            CustomWidget.roundrectborder(
                              width: MediaQuery.sizeOf(context).width,
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
        ),
      ),
    );
  }

  Widget bookShimmer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ResponsiveGridList(
            minItemWidth: 120,
            minItemsPerRow: 3,
            maxItemsPerRow: 3,
            horizontalGridSpacing: 5,
            verticalGridSpacing: 10,
            listViewBuilderOptions: ListViewBuilderOptions(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            children: List.generate(10, (index) {
              return SizedBox(
                width: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidget.roundrectborder(
                      width: width ?? 0,
                      height: 155,
                    ),
                    const SizedBox(height: 10),
                    CustomWidget.roundrectborder(
                      width: MediaQuery.sizeOf(context).width,
                      height: 5,
                    ),
                    const SizedBox(height: 5),
                    CustomWidget.roundrectborder(
                      width: MediaQuery.sizeOf(context).width,
                      height: 5,
                    ),
                    const SizedBox(height: 5),
                    CustomWidget.roundrectborder(
                      width: MediaQuery.sizeOf(context).width,
                      height: 5,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
