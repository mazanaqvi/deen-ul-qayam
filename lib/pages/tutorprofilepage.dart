import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/courselistbytutoridprovider.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class TutorProfilePage extends StatefulWidget {
  final String tutorid;
  const TutorProfilePage({
    super.key,
    required this.tutorid,
  });

  @override
  State<TutorProfilePage> createState() => TutorProfilePageState();
}

class TutorProfilePageState extends State<TutorProfilePage> {
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
    await tutorProvider.getTutorprofile(widget.tutorid);
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
    return Stack(
      children: [
        Scaffold(
          appBar: Utils.myAppBarWithBack(context, "tutorprofile", true),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tutorAbout(),
                allcourse(),
              ],
            ),
          ),
        ),
        /* AdMob Banner */
        Utils.showBannerAd(context),
      ],
    );
  }

  Widget tutorAbout() {
    return Consumer<CourselistByTutoridProvider>(
        builder: (context, tutorprofile, child) {
      if (tutorprofile.loading) {
        return tutorAboutShimmer();
      } else {
        if (tutorprofile.tutorprofilemodel.status == 200) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Tutor Profile */
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorPrimary,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: colorAccent, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: MyNetworkImage(
                            imageUrl: tutorprofile
                                    .tutorprofilemodel.result?[0].image
                                    .toString() ??
                                "",
                            fit: BoxFit.fill,
                            imgHeight: 80,
                            imgWidth: 80),
                      ),
                    ),
                    const SizedBox(height: 15),
                    MyText(
                        color: white,
                        text: tutorprofile.tutorprofilemodel.result?[0].fullName
                                .toString() ??
                            "",
                        maxline: 2,
                        fontwaight: FontWeight.w700,
                        fontsizeNormal: Dimens.textBig,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                    const SizedBox(height: 8),
                    MyText(
                        color: white,
                        text: tutorprofile.tutorprofilemodel.result?[0].email
                                .toString() ??
                            "",
                        maxline: 2,
                        fontwaight: FontWeight.w400,
                        fontsizeNormal: Dimens.textBigSmall,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal),
                  ],
                ),
              ),
              /* Tutor About */
              Padding(
                padding: const EdgeInsets.all(15.0),
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
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                    const SizedBox(height: 15),
                    ReadMoreText(
                      tutorprofile.tutorprofilemodel.result?[0].description
                              .toString() ??
                          "",
                      trimLines: 5,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                          fontSize: Dimens.textMedium,
                          fontWeight: FontWeight.w400,
                          color: gray),
                      trimCollapsedText: 'Read More',
                      colorClickableText: black,
                      trimMode: TrimMode.Line,
                      trimExpandedText: 'Read less',
                      lessStyle: GoogleFonts.inter(
                          fontSize: Dimens.textMedium,
                          fontWeight: FontWeight.w600,
                          color: black),
                      moreStyle: GoogleFonts.inter(
                          fontSize: Dimens.textMedium,
                          fontWeight: FontWeight.w600,
                          color: black),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget tutorAboutShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Tutor Profile */
        Container(
          width: MediaQuery.of(context).size.width,
          color: colorPrimary,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: colorAccent, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const CustomWidget.circular(height: 80, width: 80),
              ),
              const SizedBox(height: 15),
              const CustomWidget.roundrectborder(height: 5, width: 100),
              const SizedBox(height: 8),
              const CustomWidget.roundrectborder(height: 5, width: 120),
            ],
          ),
        ),
        /* Tutor About */
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomWidget.roundrectborder(height: 5, width: 120),
              const SizedBox(height: 15),
              CustomWidget.roundrectborder(
                  height: 5, width: MediaQuery.of(context).size.width),
              CustomWidget.roundrectborder(
                  height: 5, width: MediaQuery.of(context).size.width),
              CustomWidget.roundrectborder(
                  height: 5, width: MediaQuery.of(context).size.width),
              CustomWidget.roundrectborder(
                  height: 5, width: MediaQuery.of(context).size.width),
            ],
          ),
        ),
      ],
    );
  }

  Widget allcourse() {
    return Consumer<CourselistByTutoridProvider>(
        builder: (context, tutorprovider, child) {
      if (tutorprovider.loading && !tutorprovider.loadMore) {
        return allcourseItemShimmer();
      } else {
        if (tutorprovider.courselistbytutoridModel.status == 200 &&
            tutorprovider.courseList != null) {
          if ((tutorprovider.courseList?.length ?? 0) > 0) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyText(
                          color: black,
                          text: "courses",
                          maxline: 1,
                          multilanguage: true,
                          fontwaight: FontWeight.w700,
                          fontsizeNormal: 16,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                      const SizedBox(width: 10),
                      MyText(
                          color: black,
                          text:
                              "(${tutorprovider.tutorprofilemodel.result?[0].totalCourse.toString() ?? ""})",
                          maxline: 1,
                          multilanguage: false,
                          fontwaight: FontWeight.w700,
                          fontsizeNormal: 16,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                  const SizedBox(height: 10),
                  allcourseItem(),
                  if (tutorprovider.loadMore)
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
            physics: const NeverScrollableScrollPhysics(),
          ),
          children:
              List.generate(tutorProvider.courseList?.length ?? 0, (index) {
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
                            courseId: tutorProvider.courseList?[index].id
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
                                  color: Theme.of(context).colorScheme.surface,
                                  text: tutorProvider
                                          .courseList?[index].description
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
                                children: [
                                  MyRating(
                                    size: 13,
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
                  tutorProvider.courseList?.length == index + 1
                      ? const SizedBox.shrink()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.9,
                          color: gray.withOpacity(0.15),
                        ),
                ],
              ),
            );
          })),
    );
  }

  Widget allcourseItemShimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomWidget.rectangular(
            width: 120,
            height: 5,
          ),
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
                  physics: const NeverScrollableScrollPhysics(),
                ),
                children: List.generate(10, (index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const CustomWidget.rectangular(
                              width: 115,
                              height: 100,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomWidget.rectangular(
                                    width: MediaQuery.of(context).size.width,
                                    height: 5,
                                  ),
                                  CustomWidget.rectangular(
                                    width: MediaQuery.of(context).size.width,
                                    height: 5,
                                  ),
                                  const SizedBox(height: 8),
                                  const CustomWidget.rectangular(
                                    width: 120,
                                    height: 5,
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
                })),
          ),
        ],
      ),
    );
  }
}
