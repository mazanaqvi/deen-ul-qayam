import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:yourappname/pages/ebookdetails.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/pages/search.dart';
import 'package:yourappname/provider/ebookprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import '../utils/utils.dart';

class Ebook extends StatefulWidget {
  const Ebook({super.key});

  @override
  State<Ebook> createState() => _EbookState();
}

class _EbookState extends State<Ebook> {
  late EbookProvider ebookProvider;
  late ScrollController _scrollController;
  double? height, width;

  @override
  initState() {
    ebookProvider = Provider.of<EbookProvider>(context, listen: false);
    _fetchData(0);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (ebookProvider.currentPage ?? 0) < (ebookProvider.totalPage ?? 0)) {
      ebookProvider.setLoadMore(true);
      _fetchData(ebookProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("nextpage   ======> $nextPage");
    await ebookProvider.getEbooks((nextPage ?? 0) + 1);
    ebookProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    super.dispose();
    ebookProvider.clearProvider();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: colorPrimary,
        ),
        centerTitle: false,
        backgroundColor: colorPrimary,
        automaticallyImplyLeading: false,
        title: MyText(
            color: white,
            text: "ebook",
            fontsizeNormal: Dimens.textTitle,
            maxline: 1,
            fontwaight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            multilanguage: true),
        actions: [
          /* Pending This Api Ebook Search */
          InkWell(
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Search(
                      searchType: "2",
                      type: "book",
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
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.search,
                color: white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEbook(),
          ],
        ),
      ),
    );
  }

  Widget buildEbook() {
    return Consumer<EbookProvider>(builder: (context, ebookProvider, child) {
      if (ebookProvider.loading && !ebookProvider.loadMore) {
        return shimmer();
      } else {
        if ((ebookProvider.getEbookModel.status == 200) &&
            ebookProvider.ebookList != null) {
          if ((ebookProvider.ebookList?.length ?? 0) > 0) {
            return Column(
              children: [
                buildEbookItem(),
                const SizedBox(height: 20),
                if (ebookProvider.loadMore)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                    child: Utils.pageLoader(),
                  )
                else
                  const SizedBox.shrink(),
              ],
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

  Widget buildEbookItem() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: ResponsiveGridList(
        minItemWidth: 160,
        minItemsPerRow: 1,
        maxItemsPerRow: 1,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          ebookProvider.ebookList?.length ?? 0,
          (index) {
            return InkWell(
              focusColor: transparentColor,
              splashColor: transparentColor,
              highlightColor: transparentColor,
              hoverColor: transparentColor,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return EbookDetails(
                          ebookId:
                              ebookProvider.ebookList?[index].id.toString() ??
                                  "",
                          ebookName: ebookProvider.ebookList?[index].title
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: MyNetworkImage(
                        imgWidth: 125,
                        imgHeight: 110,
                        imageUrl: ebookProvider.ebookList?[index].landscapeImg
                                .toString() ??
                            "",
                        fit: BoxFit.fill),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: ebookProvider.ebookList?[index].title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textMedium,
                            fontsizeWeb: Dimens.textMedium,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w600,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: colorAccent.withOpacity(0.50),
                              ),
                              child: ebookProvider.ebookList?[index].isFree == 0
                                  ? MyText(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      text:
                                          "${Constant.currencyCode} ${ebookProvider.ebookList?[index].price.toString() ?? ""}",
                                      fontsizeNormal: Dimens.textMedium,
                                      fontsizeWeb: Dimens.textMedium,
                                      maxline: 2,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w600,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal)
                                  : MyText(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      text: "free",
                                      fontsizeNormal: Dimens.textSmall,
                                      fontsizeWeb: Dimens.textSmall,
                                      maxline: 1,
                                      multilanguage: true,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w600,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                            ),
                            const SizedBox(width: 8),
                            MyText(
                                color: gray,
                                text: ebookProvider.ebookList?[index].tutorName
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textSmall,
                                fontsizeWeb: Dimens.textSmall,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w600,
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
                              size: 13,
                              rating: double.parse(ebookProvider
                                      .ebookList?[index].avgRating
                                      .toString() ??
                                  ""),
                              spacing: 2,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(ebookProvider.ebookList?[index].avgRating.toString() ?? "")}",
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
            );
          },
        ),
      ),
    );
  }

  Widget shimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: ResponsiveGridList(
        minItemWidth: 160,
        minItemsPerRow: 1,
        maxItemsPerRow: 1,
        listViewBuilderOptions: ListViewBuilderOptions(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        children: List.generate(
          10,
          (index) {
            return const Row(
              children: [
                CustomWidget.roundrectborder(
                  width: 125,
                  height: 110,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomWidget.roundcorner(
                        width: 180,
                        height: 5,
                      ),
                      SizedBox(height: 8),
                      CustomWidget.roundcorner(
                        width: 180,
                        height: 5,
                      ),
                      SizedBox(height: 8),
                      CustomWidget.roundcorner(
                        width: 180,
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
