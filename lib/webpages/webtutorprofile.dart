import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/courselistbytutoridprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class WebTutorProfile extends StatefulWidget {
  final String tutorid;
  const WebTutorProfile({
    super.key,
    required this.tutorid,
  });

  @override
  State<WebTutorProfile> createState() => WebTutorProfileState();
}

class WebTutorProfileState extends State<WebTutorProfile> {
  late CourselistByTutoridProvider tutorProvider;
  late ScrollController _scrollController;
  double? height;
  double? width;

  @override
  initState() {
    tutorProvider =
        Provider.of<CourselistByTutoridProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    getApi();
  }

  getApi() async {
    await tutorProvider.getTutorprofile(widget.tutorid.toString());
    _fetchData(0);
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("isMorePage  ======> ${tutorProvider.isMorePage}");
    printLog("currentPage ======> ${tutorProvider.currentPage}");
    printLog("totalPage   ======> ${tutorProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    await tutorProvider.getCourseByTutor(
        "3", widget.tutorid, (nextPage ?? 0) + 1);
    await tutorProvider.setLoadMore(false);
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (tutorProvider.currentPage ?? 0) < (tutorProvider.totalPage ?? 0)) {
      await tutorProvider.setLoadMore(true);
      _fetchData(tutorProvider.currentPage ?? 0);
    }
  }

  @override
  void dispose() {
    tutorProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.childPanel(context),
              Utils.pageTitleLayout(context, "tutorprofile", true),
              buildTutor(),
              const FooterWeb(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTutor() {
    return Consumer<CourselistByTutoridProvider>(
      builder: (context, tutoritem, child) {
        if (tutoritem.loading) {
          return shimmer();
        } else {
          return Container(
            padding: MediaQuery.of(context).size.width > 800
                ? const EdgeInsets.fromLTRB(100, 50, 100, 20)
                : const EdgeInsets.fromLTRB(20, 25, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                tutorProfile(),
                tutorAbout(),
                allcourse(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget tutorProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: MyNetworkImage(
              imageUrl:
                  tutorProvider.tutorprofilemodel.result?[0].image.toString() ??
                      "",
              fit: BoxFit.fill,
              imgHeight: 80,
              imgWidth: 80),
        ),
        const SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
                color: Theme.of(context).colorScheme.surface,
                text: tutorProvider.tutorprofilemodel.result?[0].fullName
                        .toString() ??
                    "",
                maxline: 2,
                fontwaight: FontWeight.w700,
                fontsizeNormal: Dimens.textlargeBig,
                fontsizeWeb: Dimens.textlargeBig,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
            const SizedBox(height: 8),
            MyText(
                color: Theme.of(context).colorScheme.surface,
                text: tutorProvider.tutorprofilemodel.result?[0].email
                        .toString() ??
                    "",
                maxline: 2,
                fontwaight: FontWeight.w400,
                fontsizeNormal: Dimens.textMedium,
                fontsizeWeb: Dimens.textMedium,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal),
          ],
        ),
      ],
    );
  }

  Widget tutorAbout() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
              color: Theme.of(context).colorScheme.surface,
              text: "About Me",
              maxline: 2,
              fontwaight: FontWeight.w700,
              fontsizeNormal: Dimens.textBig,
              fontsizeWeb: Dimens.textBig,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal),
          const SizedBox(height: 15),
          ReadMoreText(
            tutorProvider.tutorprofilemodel.result?[0].description.toString() ??
                "",
            trimLines: 5,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: Dimens.textMedium,
                fontWeight: FontWeight.w400,
                color: gray),
            trimCollapsedText: 'Read More',
            colorClickableText: black,
            trimMode: TrimMode.Line,
            trimExpandedText: 'Read less',
            lessStyle: TextStyle(
                fontSize: Dimens.textMedium,
                fontWeight: FontWeight.w600,
                color: black),
            moreStyle: TextStyle(
                fontSize: Dimens.textMedium,
                fontWeight: FontWeight.w600,
                color: black),
          ),
        ],
      ),
    );
  }

  Widget allcourse() {
    if (tutorProvider.courselistbytutoridModel.status == 200 &&
        tutorProvider.courseList != null) {
      if ((tutorProvider.courseList?.length ?? 0) > 0) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "courses",
                      maxline: 1,
                      multilanguage: true,
                      fontwaight: FontWeight.w700,
                      fontsizeNormal: Dimens.textBig,
                      fontsizeWeb: Dimens.textBig,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 10),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text:
                          "(${tutorProvider.tutorprofilemodel.result?[0].totalCourse.toString() ?? ""})",
                      maxline: 1,
                      multilanguage: false,
                      fontwaight: FontWeight.w700,
                      fontsizeNormal: Dimens.textBig,
                      fontsizeWeb: Dimens.textBig,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
              const SizedBox(height: 10),
              allcourseItem(),
              if (tutorProvider.loadMore)
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

  Widget allcourseItem() {
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
          tutorProvider.courseList?.length ?? 0,
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
                          courseId:
                              tutorProvider.courseList?[index].id.toString() ??
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
                return Column(
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
                              imageUrl: tutorProvider
                                      .courseList?[index].thumbnailImg
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
                                    text: tutorProvider.courseList?[index].title
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
                                        text: Utils.kmbGenerator(tutorProvider
                                                .courseList?[index].totalView ??
                                            0),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MyRating(
                                      size: 15,
                                      rating: double.parse(tutorProvider
                                              .courseList?[index].avgRating
                                              .toString() ??
                                          ""),
                                      spacing: 2,
                                    ),
                                    const SizedBox(width: 5),
                                    MyText(
                                        color: colorAccent,
                                        text:
                                            "${double.parse(tutorProvider.courseList?[index].avgRating.toString() ?? "")}",
                                        fontsizeNormal: Dimens.textTitle,
                                        fontsizeWeb: Dimens.textTitle,
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
                    tutorProvider.courseList?.length == index + 1
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
          },
        ),
      ),
    );
  }

  Widget shimmer() {
    return Container(
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 50, 100, 20)
          : const EdgeInsets.fromLTRB(20, 25, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: gray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomWidget.circular(height: 80, width: 80),
              SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundrectborder(height: 10, width: 350),
                  SizedBox(height: 8),
                  CustomWidget.roundrectborder(height: 8, width: 250),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget.roundrectborder(height: 10, width: 250),
                SizedBox(height: 15),
                CustomWidget.roundrectborder(height: 5, width: 400),
                CustomWidget.roundrectborder(height: 5, width: 400),
                CustomWidget.roundrectborder(height: 5, width: 400),
                CustomWidget.roundrectborder(height: 5, width: 400),
                CustomWidget.roundrectborder(height: 5, width: 400),
                CustomWidget.roundrectborder(height: 5, width: 400),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomWidget.rectangular(height: 10, width: 250),
                const SizedBox(height: 10),
                MediaQuery.removePadding(
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
                        return InteractiveContainer(child: (isHovered) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    CustomWidget.roundrectborder(
                                      width: 115,
                                      height: 100,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomWidget.roundrectborder(
                                            width: 400,
                                            height: 8,
                                          ),
                                          SizedBox(height: 8),
                                          CustomWidget.roundrectborder(
                                            width: 250,
                                            height: 8,
                                          ),
                                          SizedBox(height: 8),
                                          CustomWidget.roundrectborder(
                                            width: 300,
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              tutorProvider.courseList?.length == index + 1
                                  ? const SizedBox.shrink()
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 0.9,
                                      color: gray.withOpacity(0.15),
                                    ),
                            ],
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
