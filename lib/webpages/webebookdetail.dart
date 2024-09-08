import 'package:yourappname/webpages/weblogin.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:yourappname/provider/ebookdetailprovider.dart';
import 'package:yourappname/subscription/allpayment.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import '../utils/utils.dart';
import '../web_js/js_helper.dart';

class WebEbookDetails extends StatefulWidget {
  final String ebookId, ebookName;
  const WebEbookDetails({
    super.key,
    required this.ebookId,
    required this.ebookName,
  });

  @override
  State<WebEbookDetails> createState() => WebEbookDetailsState();
}

class WebEbookDetailsState extends State<WebEbookDetails> {
  final JSHelper _jsHelper = JSHelper();
  late EbookDetailProvider ebookDetailProvider;
  late ScrollController _scrollController;
  TextEditingController commentController = TextEditingController();
  double? height, width;
  double bookrating = 0.0;

  @override
  void initState() {
    ebookDetailProvider =
        Provider.of<EbookDetailProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    getApi();
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (ebookDetailProvider.currentPage ?? 0) <
            (ebookDetailProvider.totalPage ?? 0)) {
      printLog("load more====>");
      ebookDetailProvider.setLoadMore(true);
      _fetchReviewData(ebookDetailProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchReviewData(int? nextPage) async {
    printLog("isMorePage  ======> ${ebookDetailProvider.isMorePage}");
    printLog("currentPage ======> ${ebookDetailProvider.currentPage}");
    printLog("totalPage   ======> ${ebookDetailProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    await ebookDetailProvider.getReviewByBook(
        "2", widget.ebookId, (nextPage ?? 0) + 1);
  }

  @override
  void dispose() {
    ebookDetailProvider.clearProvider();
    super.dispose();
  }

  getApi() async {
    await ebookDetailProvider.getEbooksDetail(widget.ebookId.toString());
    _fetchReviewData(0);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Utils.childPanel(context),
              bookInformation(),
              tabWithItem(),
              aboutAuthor(),
              buildStudentFeedback(),
              const FooterWeb(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookInformation() {
    return Consumer<EbookDetailProvider>(
        builder: (context, ebookdetailprovider, child) {
      if (ebookdetailprovider.loading) {
        return bookInformationShimmer();
      } else {
        if (ebookdetailprovider.ebookDetailModel.status == 200 &&
            ebookdetailprovider.ebookDetailModel.result!.isNotEmpty) {
          return Padding(
            padding: MediaQuery.of(context).size.width > 800
                ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
                : const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: MyNetworkImage(
                          imgWidth: 210,
                          imgHeight: 250,
                          imageUrl: ebookdetailprovider
                                  .ebookDetailModel.result?[0].thumbnailImg
                                  .toString() ??
                              "",
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: ebookdetailprovider
                                    .ebookDetailModel.result?[0].title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textExtralargeBig,
                            fontsizeWeb: Dimens.textExtralargeBig,
                            fontwaight: FontWeight.w700,
                            maxline: 3,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              color: gray,
                              text: "update",
                              fontsizeNormal: Dimens.textMedium,
                              fontsizeWeb: Dimens.textMedium,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              multilanguage: true,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal,
                            ),
                            const SizedBox(width: 10),
                            MyText(
                              color: gray,
                              text: Utils.formateDate(
                                  ebookdetailprovider
                                          .ebookDetailModel.result?[0].createdAt
                                          .toString() ??
                                      "",
                                  Constant.dateformat),
                              fontsizeNormal: Dimens.textMedium,
                              fontsizeWeb: Dimens.textMedium,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              color: gray,
                              text: "createdby",
                              fontsizeNormal: Dimens.textMedium,
                              fontsizeWeb: Dimens.textMedium,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              multilanguage: true,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                              color: gray,
                              text: ebookdetailprovider
                                      .ebookDetailModel.result?[0].tutorName
                                      .toString() ??
                                  "",
                              fontsizeNormal: Dimens.textMedium,
                              fontsizeWeb: Dimens.textMedium,
                              fontwaight: FontWeight.w600,
                              maxline: 2,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buyButton(),
                            const SizedBox(width: 15),
                            InkWell(
                              hoverColor: transparentColor,
                              highlightColor: transparentColor,
                              focusColor: transparentColor,
                              splashColor: transparentColor,
                              onTap: () async {
                                if (Constant.userID == null) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const WebLogin(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  await ebookdetailprovider.addRemoveWishlist(
                                      "2",
                                      ebookdetailprovider
                                              .ebookDetailModel.result?[0].id
                                              .toString() ??
                                          "");
                                }
                              },
                              child: InteractiveContainer(child: (isHovered) {
                                return Container(
                                  width: 45,
                                  height: 45,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 0.8,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    color: isHovered
                                        ? gray.withOpacity(0.20)
                                        : transparentColor,
                                  ),
                                  child: AnimatedScale(
                                    scale: isHovered ? 1.03 : 1,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: Icon(
                                      ebookdetailprovider.ebookDetailModel
                                                  .result?[0].isWishlist ==
                                              1
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: ebookdetailprovider
                                                  .ebookDetailModel
                                                  .result?[0]
                                                  .isWishlist ==
                                              1
                                          ? red
                                          : Theme.of(context)
                                              .colorScheme
                                              .surface,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 15),
                            InkWell(
                              hoverColor: transparentColor,
                              highlightColor: transparentColor,
                              focusColor: transparentColor,
                              splashColor: transparentColor,
                              onTap: () {
                                if (Constant.userID == null) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const WebLogin(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  addReviewBottomSheet(context);
                                }
                              },
                              child: InteractiveContainer(child: (isHovered) {
                                return Container(
                                  width: 45,
                                  height: 45,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: 0.8,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    color: isHovered
                                        ? gray.withOpacity(0.20)
                                        : transparentColor,
                                  ),
                                  child: AnimatedScale(
                                    scale: isHovered ? 1.03 : 1,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: const Icon(
                                      Icons.star,
                                      color: colorAccent,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget bookInformationShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 235,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: gray),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomWidget.roundcorner(
                        width: width ?? 0.0,
                        height: height ?? 0.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomWidget.roundrectborder(
                    width: width ?? 0.0,
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget.roundrectborder(
                  width: 150,
                  height: 10,
                ),
                SizedBox(width: 8),
                CustomWidget.roundrectborder(
                  width: 100,
                  height: 10,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidget.roundrectborder(
                  width: 150,
                  height: 10,
                ),
                SizedBox(width: 8),
                CustomWidget.roundrectborder(
                  width: 100,
                  height: 10,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidget.roundrectborder(
                  width: 150,
                  height: 10,
                ),
                SizedBox(width: 8),
                CustomWidget.roundrectborder(
                  width: 100,
                  height: 10,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidget.roundrectborder(
                  width: 150,
                  height: 10,
                ),
                SizedBox(width: 8),
                CustomWidget.roundrectborder(
                  width: 100,
                  height: 10,
                ),
              ],
            ),
            const SizedBox(height: 35),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomWidget.roundrectborder(
                  width: 120,
                  height: 45,
                ),
                SizedBox(width: 15),
                CustomWidget.roundrectborder(
                  width: 120,
                  height: 45,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tabWithItem() {
    return Consumer<EbookDetailProvider>(
        builder: (context, ebookprovider, child) {
      if (ebookprovider.loading) {
        return tabWithItemShimmer();
      } else {
        if (ebookprovider.ebookDetailModel.status == 200 &&
            ebookprovider.ebookDetailModel.result!.isNotEmpty) {
          return Padding(
            padding: MediaQuery.of(context).size.width > 800
                ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
                : const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: SizedBox(
                    height: 45,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: Constant().detailTab.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            focusColor: transparentColor,
                            autofocus: false,
                            highlightColor: transparentColor,
                            hoverColor: transparentColor,
                            splashColor: transparentColor,
                            onTap: () {
                              ebookprovider.ebookTab(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                      color: ebookprovider.ebookType == index
                                          ? colorPrimary
                                          : gray,
                                      text: Constant().detailTab[index],
                                      fontsizeNormal: Dimens.textMedium,
                                      fontsizeWeb: Dimens.textMedium,
                                      maxline: 1,
                                      multilanguage: true,
                                      overflow: TextOverflow.ellipsis,
                                      fontwaight: FontWeight.w600,
                                      textalign: TextAlign.center,
                                      fontstyle: FontStyle.normal),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 60,
                                    height: 2,
                                    color: ebookprovider.ebookType == index
                                        ? colorPrimary
                                        : transparentColor,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: width,
                      height: 1,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: gray,
                    ),
                    const SizedBox(height: 20),
                    if (ebookprovider.ebookType == 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: MyText(
                            color: gray,
                            text: ebookprovider
                                    .ebookDetailModel.result?[0].summary
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textDesc,
                            fontsizeWeb: Dimens.textDesc,
                            maxline: 20,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w500,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: MyText(
                            color: gray,
                            text: ebookprovider
                                    .ebookDetailModel.result?[0].specification
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textDesc,
                            fontsizeWeb: Dimens.textDesc,
                            maxline: 20,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w500,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                      )
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget tabWithItemShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SizedBox(
              height: 45,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: Constant().detailTab.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      focusColor: white,
                      autofocus: false,
                      highlightColor: white,
                      hoverColor: white,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: gray,
                                text: Constant().detailTab[index],
                                fontsizeNormal: Dimens.textSmall,
                                fontsizeWeb: Dimens.textSmall,
                                maxline: 1,
                                multilanguage: true,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w600,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal),
                            const Spacer(),
                            Container(
                              width: 60,
                              height: 2,
                              color: white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: width,
                height: 1,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: gray,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  CustomWidget.roundrectborder(
                    height: 10,
                    width: width ?? 0.0 * 0.75,
                  ),
                  const SizedBox(height: 10),
                  CustomWidget.roundrectborder(
                    height: 10,
                    width: width ?? 0.0 * 0.75,
                  ),
                  const SizedBox(height: 10),
                  CustomWidget.roundrectborder(
                    height: 10,
                    width: width ?? 0.0 * 0.75,
                  ),
                  const SizedBox(height: 10),
                  CustomWidget.roundrectborder(
                    height: 10,
                    width: width ?? 0.0 * 0.75,
                  ),
                  const SizedBox(height: 10),
                  CustomWidget.roundrectborder(
                    height: 10,
                    width: width ?? 0.0 * 0.75,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget aboutAuthor() {
    return Consumer<EbookDetailProvider>(
        builder: (context, ebookdetailprovider, child) {
      if (ebookdetailprovider.loading) {
        return aboutAuthorShimmer();
      } else {
        if (ebookdetailprovider.ebookDetailModel.status == 200 &&
            ebookdetailprovider.ebookDetailModel.result!.isNotEmpty) {
          return Padding(
            padding: MediaQuery.of(context).size.width > 800
                ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
                : const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                    color: colorPrimary,
                    text: "aboutauthor",
                    fontsizeNormal: Dimens.textExtraBig,
                    fontsizeWeb: Dimens.textExtraBig,
                    maxline: 1,
                    multilanguage: true,
                    overflow: TextOverflow.ellipsis,
                    fontwaight: FontWeight.w700,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MyNetworkImage(
                              imgWidth: 150,
                              imgHeight: 180,
                              fit: BoxFit.fill,
                              imageUrl: ebookdetailprovider
                                      .ebookDetailModel.result?[0].thumbnailImg
                                      .toString() ??
                                  ""),
                        ),
                        const SizedBox(height: 15),
                        MyText(
                            color: black,
                            text: ebookdetailprovider
                                    .ebookDetailModel.result?[0].tutorName
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textBig,
                            fontsizeWeb: Dimens.textBig,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w700,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: colorPrimary,
                            text: "reviews",
                            fontsizeNormal: Dimens.textBig,
                            fontsizeWeb: Dimens.textBig,
                            maxline: 1,
                            multilanguage: true,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w700,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 25),
                        MyText(
                            color: colorPrimary,
                            text: ebookdetailprovider
                                    .ebookDetailModel.result?[0].avgRating
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textExtraBig,
                            fontsizeWeb: Dimens.textExtraBig,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w800,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal),
                        const SizedBox(height: 25),
                        MyRating(
                            rating: double.parse(ebookdetailprovider
                                    .ebookDetailModel.result?[0].avgRating
                                    .toString() ??
                                ""),
                            spacing: 5,
                            size: 16),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MyText(
                    color: gray,
                    text: ebookdetailprovider
                            .ebookDetailModel.result?[0].description
                            .toString() ??
                        "",
                    fontsizeNormal: Dimens.textSmall,
                    fontsizeWeb: Dimens.textSmall,
                    maxline: 100,
                    overflow: TextOverflow.ellipsis,
                    fontwaight: FontWeight.w500,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget aboutAuthorShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomWidget.roundrectborder(height: 15, width: 200),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const CustomWidget.roundcorner(
                      width: 150,
                      height: 180,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const CustomWidget.roundrectborder(
                    width: 150,
                    height: 15,
                  ),
                ],
              ),
              const Spacer(),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundrectborder(
                    width: 150,
                    height: 15,
                  ),
                  SizedBox(height: 25),
                  CustomWidget.circular(
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(height: 25),
                  CustomWidget.roundrectborder(
                    width: 150,
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomWidget.roundrectborder(height: 10, width: width ?? 0.0 * 0.75),
          const SizedBox(height: 10),
          CustomWidget.roundrectborder(height: 10, width: width ?? 0.0 * 0.75),
          const SizedBox(height: 10),
          CustomWidget.roundrectborder(height: 10, width: width ?? 0.0 * 0.75),
          const SizedBox(height: 10),
          CustomWidget.roundrectborder(height: 10, width: width ?? 0.0 * 0.75),
          const SizedBox(height: 10),
          CustomWidget.roundrectborder(height: 10, width: width ?? 0.0 * 0.75),
        ],
      ),
    );
  }

/* Related BookList */

  Widget buildRelatedBook() {
    return Consumer<EbookDetailProvider>(
        builder: (context, ebookdetailprovider, child) {
      if (ebookdetailprovider.relatedBookLoading &&
          !ebookdetailprovider.relatedBookloadMore) {
        return relatedBookItemShimmer();
      } else {
        if (ebookdetailprovider.relatedBookModel.status == 200 &&
            ebookdetailprovider.relatedBookModel.result != null) {
          if ((ebookdetailprovider.relatedBookModel.result?.length ?? 0) > 0) {
            return Padding(
              padding: MediaQuery.of(context).size.width > 800
                  ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
                  : const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "relatedbooks",
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                      maxline: 2,
                      multilanguage: true,
                      overflow: TextOverflow.ellipsis,
                      fontwaight: FontWeight.w600,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(height: 25),
                  relatedBookItem(),
                  if (ebookdetailprovider.relatedBookloadMore)
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
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget relatedBookItem() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ResponsiveGridList(
          minItemWidth: 120,
          minItemsPerRow: 1,
          maxItemsPerRow: 1,
          horizontalGridSpacing: 5,
          verticalGridSpacing: 10,
          listViewBuilderOptions: ListViewBuilderOptions(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
          ),
          children: List.generate(
              ebookDetailProvider.relatedBookList?.length ?? 0, (index) {
            return InkWell(
              focusColor: transparentColor,
              splashColor: transparentColor,
              highlightColor: transparentColor,
              hoverColor: transparentColor,
              onTap: () {},
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: MyNetworkImage(
                        imgWidth: 125,
                        imgHeight: 110,
                        imageUrl: ebookDetailProvider
                                .relatedBookList?[index].landscapeImg
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
                            text: ebookDetailProvider
                                    .relatedBookList?[index].title
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textSmall,
                            fontsizeWeb: Dimens.textSmall,
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
                              child: ebookDetailProvider
                                          .relatedBookList?[index].isFree !=
                                      1
                                  ? MyText(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      text:
                                          "${Constant.currencyCode} ${ebookDetailProvider.relatedBookList?[index].price.toString() ?? ""}",
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
                                text: ebookDetailProvider
                                        .relatedBookList?[index].tutorName
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
                          children: [
                            MyRating(
                              size: 13,
                              rating: double.parse(ebookDetailProvider
                                      .relatedBookList?[index].avgRating
                                      .toString() ??
                                  ""),
                              spacing: 2,
                            ),
                            const SizedBox(width: 5),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(ebookDetailProvider.relatedBookList?[index].avgRating.toString() ?? "")}",
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
          })),
    );
  }

  Widget relatedBookItemShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
          : const EdgeInsets.fromLTRB(20, 20, 20, 20),
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

/* Review List  */

  Widget buildStudentFeedback() {
    return Consumer<EbookDetailProvider>(
        builder: (context, ebookdetailprovider, child) {
      if (ebookdetailprovider.reviewloading &&
          !ebookdetailprovider.reviewloadmore) {
        return const SizedBox.shrink();
      } else {
        if (ebookdetailprovider.getCourseReviewModel.status == 200 &&
            ebookdetailprovider.reviewList != null) {
          if ((ebookdetailprovider.reviewList?.length ?? 0) > 0) {
            return Padding(
              padding: MediaQuery.of(context).size.width > 800
                  ? const EdgeInsets.fromLTRB(100, 25, 100, 25)
                  : const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "studentfeedback",
                      fontsizeNormal: Dimens.textTitle,
                      fontwaight: FontWeight.w600,
                      maxline: 1,
                      multilanguage: true,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal),
                  const SizedBox(height: 15),
                  buildStudentFeedbackItem(),
                  if (ebookdetailprovider.reviewloadmore)
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
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget buildStudentFeedbackItem() {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 15,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        ebookDetailProvider.reviewList?.length ?? 0,
        (index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: gray.withOpacity(0.08),
                  spreadRadius: 1.5,
                  blurRadius: 0.5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
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
                        imgWidth: 30,
                        imgHeight: 30,
                        imageUrl:
                            ebookDetailProvider.reviewList?[index].image ?? "",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            ebookDetailProvider.reviewList?[index].fullName ==
                                    ""
                                ? MyText(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    text: ebookDetailProvider
                                            .reviewList?[index].userName
                                            .toString() ??
                                        "",
                                    fontsizeNormal: Dimens.textMedium,
                                    fontwaight: FontWeight.w700,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal)
                                : MyText(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    text: ebookDetailProvider
                                            .reviewList?[index].fullName
                                            .toString() ??
                                        "",
                                    fontsizeNormal: Dimens.textMedium,
                                    fontwaight: FontWeight.w700,
                                    maxline: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MyText(
                        color: colorPrimary,
                        text: Utils.formateDate(
                            ebookDetailProvider.reviewList?[index].createdAt
                                    .toString() ??
                                "",
                            Constant.dateformat),
                        fontsizeNormal: Dimens.textSmall,
                        fontwaight: FontWeight.w500,
                        maxline: 1,
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
                      size: 18,
                      rating: double.parse((ebookDetailProvider
                              .reviewList?[index].rating
                              .toString() ??
                          "")),
                      spacing: 3,
                    ),
                    const SizedBox(width: 5),
                    MyText(
                        color: colorAccent,
                        text:
                            "${double.parse((ebookDetailProvider.reviewList?[index].rating.toString() ?? ""))}",
                        fontsizeNormal: Dimens.textMedium,
                        fontwaight: FontWeight.w600,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ],
                ),
                const SizedBox(height: 10),
                MyText(
                    color: gray,
                    text: ebookDetailProvider.reviewList?[index].comment
                            .toString() ??
                        "",
                    fontsizeNormal: Dimens.textSmall,
                    fontwaight: FontWeight.w400,
                    maxline: 5,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ],
            ),
          );
        },
      ),
    );
  }

/* Buy Button in Bottom */

  Widget buyButton() {
    return Consumer<EbookDetailProvider>(
        builder: (context, ebookdetailprovider, child) {
      if (ebookdetailprovider.loading) {
        return const SizedBox.shrink();
      } else {
        return InkWell(
          hoverColor: transparentColor,
          highlightColor: transparentColor,
          focusColor: transparentColor,
          splashColor: transparentColor,
          onTap: () async {
            if (Constant.userID == null) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const WebLogin(),
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
            } else {
              if (ebookDetailProvider.ebookDetailModel.result?[0].isFree == 0 &&
                  ebookDetailProvider.ebookDetailModel.result?[0].isUserBuy !=
                      1) {
                /* Primium Page  */
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AllPayment(
                      /* ContentType 1 == Book */
                      /* ContentType 2 == Course */
                      contentType: "1",
                      payType: 'Content',
                      itemId: ebookDetailProvider.ebookDetailModel.result?[0].id
                              .toString() ??
                          "",
                      price: ebookDetailProvider
                              .ebookDetailModel.result?[0].price
                              .toString() ??
                          "",
                      itemTitle: ebookDetailProvider
                              .ebookDetailModel.result?[0].title
                              .toString() ??
                          "",
                      typeId: "",
                      videoType: "",
                      productPackage: "",
                      currency: Constant.currency,
                      coin: "",
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
              } else {
                if (ebookdetailprovider.ebookDetailModel.result?[0].bookUrl ==
                        "" ||
                    ebookdetailprovider.ebookDetailModel.result?[0].bookUrl ==
                        null) {
                  Utils.showSnackbar(
                      context, "fail", "bookcontentnotavailable", true);
                } else {
                  _redirectToUrl(
                      ebookdetailprovider.ebookDetailModel.result?[0].bookUrl ??
                          "");
                }
              }
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width > 800
                ? 250
                : MediaQuery.of(context).size.width,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: colorPrimary,
            ),
            child: MyText(
                color: white,
                text: ebookdetailprovider.ebookDetailModel.result?[0].isFree ==
                            1 ||
                        ebookdetailprovider
                                .ebookDetailModel.result?[0].isUserBuy ==
                            1
                    ? "readnow"
                    : "buynow",
                multilanguage: true,
                fontsizeNormal: Dimens.textTitle,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
          ),
        );
      }
    });
  }

/* Add Review BottomSheet */

  addReviewBottomSheet(BuildContext context) async {
    return showDialog(
        context: context,
        barrierColor: transparentColor,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            backgroundColor: Theme.of(context).cardColor,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              constraints: const BoxConstraints(
                minWidth: 500,
                maxWidth: 550,
                minHeight: 350,
                maxHeight: 380,
              ),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                          color: Theme.of(context).colorScheme.surface,
                          fontsizeNormal: Dimens.textBig,
                          fontsizeWeb: Dimens.textBig,
                          multilanguage: true,
                          maxline: 1,
                          fontwaight: FontWeight.w600,
                          text: "addreview",
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 25,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star,
                            color: colorAccent,
                          ),
                          half: const Icon(Icons.star_half, color: colorAccent),
                          empty:
                              const Icon(Icons.star_border, color: colorAccent),
                        ),
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          bookrating = rating;
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: commentController,
                      keyboardType: TextInputType.text,
                      cursorColor: Theme.of(context).colorScheme.surface,
                      maxLines: 8,
                      style: TextStyle(
                        fontSize: Dimens.textTitle,
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: Locales.string(context, "addcomment"),
                        hintStyle: TextStyle(
                          fontSize: Dimens.textTitle,
                          fontStyle: FontStyle.normal,
                          color: colorPrimary.withOpacity(0.40),
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0.8,
                            color: colorPrimary.withOpacity(0.40),
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.8,
                                color: gray,
                              ),
                            ),
                            child: MyText(
                                color: gray,
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
                                multilanguage: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                text: "cancel",
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () async {
                            final ebookdetailProvider =
                                Provider.of<EbookDetailProvider>(context,
                                    listen: false);
                            // Review Api
                            await ebookdetailProvider.addReview(
                              "2",
                              widget.ebookId,
                              commentController.text.toString(),
                              bookrating,
                            );
                            if (!ebookdetailProvider.loading) {
                              if (ebookdetailProvider.successModel.status ==
                                  200) {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                _fetchReviewData(0);
                                Utils.showSnackbar(
                                    context,
                                    "success",
                                    ebookdetailProvider.successModel.message ??
                                        "",
                                    false);
                              } else {
                                if (!context.mounted) return;
                                Utils.showSnackbar(
                                    context,
                                    "success",
                                    ebookdetailProvider.successModel.message ??
                                        "",
                                    false);
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            curve: Curves.bounceInOut,
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: colorPrimary,
                              border: Border.all(
                                width: 0.8,
                                color: gray.withOpacity(0.20),
                              ),
                            ),
                            child: MyText(
                                color: white,
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
                                multilanguage: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                text: "submit",
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _redirectToUrl(loadingUrl) async {
    printLog("loadingUrl -----------> $loadingUrl");
    /*
      _blank => open new Tab
      _self => open in current Tab
    */
    String dataFromJS = await _jsHelper.callOpenTab(loadingUrl, '_blank');
    printLog("dataFromJS -----------> $dataFromJS");
  }
}
