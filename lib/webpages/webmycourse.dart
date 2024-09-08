import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/mycourseprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../web_js/js_helper.dart';

class WebMyCourse extends StatefulWidget {
  const WebMyCourse({Key? key}) : super(key: key);

  @override
  State<WebMyCourse> createState() => WebMyCourseState();
}

class WebMyCourseState extends State<WebMyCourse> {
  late MyCourseProvider myCourseProvider;
  final JSHelper _jsHelper = JSHelper();
  late ScrollController _scrollController;
  double? width;
  double? height;

  @override
  void initState() {
    myCourseProvider = Provider.of<MyCourseProvider>(context, listen: false);
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
        (myCourseProvider.currentPage ?? 0) <
            (myCourseProvider.totalPage ?? 0)) {
      await myCourseProvider.setLoadMore(true);
      _fetchData(myCourseProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    await myCourseProvider.getMyCourse((nextPage ?? 0) + 1);
    await myCourseProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    myCourseProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: white,
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              Utils.childPanel(context),
              Utils.pageTitleLayout(context, "mycourse", true),
              buildPage(),
              const FooterWeb(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage() {
    return Consumer<MyCourseProvider>(
        builder: (context, mycourseProvider, child) {
      if (myCourseProvider.loading && !myCourseProvider.loadMore) {
        return buildShimmer();
      } else {
        if (myCourseProvider.myCourseModel.status == 200 &&
            myCourseProvider.mycourseList != null) {
          if ((myCourseProvider.mycourseList?.length ?? 0) > 0) {
            return Padding(
              padding: MediaQuery.of(context).size.width > 800
                  ? const EdgeInsets.fromLTRB(100, 50, 100, 20)
                  : const EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: Column(
                children: [
                  mycourselist(),
                  if (mycourseProvider.loadMore)
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

  Widget mycourselist() {
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
          myCourseProvider.mycourseList?.length ?? 0,
          (index) {
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
                          courseId: myCourseProvider.mycourseList?[index].id
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
                            imageUrl: myCourseProvider
                                    .mycourseList?[index].thumbnailImg
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
                                  text: myCourseProvider
                                          .mycourseList?[index].description
                                          .toString() ??
                                      "",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w600,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(height: 8),
                              MyText(
                                  color: gray,
                                  text:
                                      "${Utils.kmbGenerator(int.parse(myCourseProvider.mycourseList?[index].totalView.toString() ?? ""))} Students",
                                  fontsizeNormal: Dimens.textSmall,
                                  fontwaight: FontWeight.w400,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  MyRating(
                                    size: 13,
                                    rating: double.parse(myCourseProvider
                                            .mycourseList?[index].avgRating
                                            .toString() ??
                                        ""),
                                    spacing: 2,
                                  ),
                                  const SizedBox(width: 5),
                                  MyText(
                                      color: colorAccent,
                                      text:
                                          "${double.parse(myCourseProvider.mycourseList?[index].avgRating.toString() ?? "")}",
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
                        const SizedBox(width: 10),
                        generateCertificate(
                          myCourseProvider
                                  .mycourseList?[index].isDownloadCertificate ??
                              0,
                          myCourseProvider.mycourseList?[index].id ?? 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  myCourseProvider.mycourseList?.length == index + 1
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
    );
  }

  Widget buildShimmer() {
    return Padding(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 50, 100, 20)
          : const EdgeInsets.fromLTRB(20, 25, 20, 20),
      child: MediaQuery.removePadding(
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
            10,
            (index) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5)),
                          child: CustomWidget.rectangular(
                            width: 115,
                            height: 100,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomWidget.rectangular(
                                height: 5,
                              ),
                              SizedBox(height: 8),
                              CustomWidget.rectangular(
                                height: 5,
                              ),
                              SizedBox(height: 8),
                              CustomWidget.rectangular(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  myCourseProvider.mycourseList?.length == index + 1
                      ? const SizedBox.shrink()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.9,
                          color: gray.withOpacity(0.15),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget generateCertificate(int? isDownloadCertificate, courseId) {
    if ((isDownloadCertificate ?? 0) == 1 && Constant.userID != null) {
      return InkWell(
        onTap: () async {
          Utils().showProgress(context, "Generate Certificate...");
          await myCourseProvider.fetchCertificate(courseId);

          if (!myCourseProvider.certificateDownloading) {
            if (myCourseProvider.certificateModel.status == 200 &&
                myCourseProvider.certificateModel.result != null) {
              if (!mounted) return;
              Utils().hideProgress(context);
              _redirectToUrl(
                  myCourseProvider.certificateModel.result?.pdfUrl ?? "");
            } else {
              if (!mounted) return;
              Utils().hideProgress(context);
              Utils.showSnackbar(context, "fail", "somethingwentwronge", true);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: MyText(
              color: white,
              fontsizeNormal: Dimens.textMedium,
              maxline: 1,
              fontwaight: FontWeight.w600,
              multilanguage: true,
              overflow: TextOverflow.ellipsis,
              text: "downloadcertificate",
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
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
