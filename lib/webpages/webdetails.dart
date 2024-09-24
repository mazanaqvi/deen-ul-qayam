import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/quize/quize.dart';
import 'package:yourappname/subscription/allpayment.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/weblogin.dart';
import 'package:yourappname/webpages/webtutorprofile.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../web_js/js_helper.dart';

class WebDetail extends StatefulWidget {
  final String courseId;
  const WebDetail({Key? key, required this.courseId}) : super(key: key);

  @override
  State<WebDetail> createState() => WebDetailState();
}

class WebDetailState extends State<WebDetail> {
  late CourseDetailsProvider detailProvider;
  final JSHelper _jsHelper = JSHelper();
  late ScrollController _scrollController;
  final commentController = TextEditingController();
  double addrating = 0.0;

  @override
  void initState() {
    detailProvider = Provider.of<CourseDetailsProvider>(context, listen: false);
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
        (detailProvider.reviewcurrentPage ?? 0) <
            (detailProvider.reviewtotalPage ?? 0)) {
      printLog("load more====>");
      await detailProvider.setReviewLoadMore(true);
      getReviewList(detailProvider.reviewcurrentPage ?? 0);
    }
  }

  getApi() async {
    await detailProvider.getCourseDetails(widget.courseId);
    getRelatedList(0);
    getReviewList(0);
    if (detailProvider.courseDetailsModel.result?[0].chapter != null ||
        (detailProvider.courseDetailsModel.result?[0].chapter?.length ?? 0) !=
            0) {
      await detailProvider.openChapterVideo(0, true);
      getVideoByChapter(
          detailProvider.courseDetailsModel.result?[0].chapter?[0].id ?? 0,
          0,
          false);
    }
  }

  Future<void> getReviewList(int? nextPage) async {
    await detailProvider.getReviewByCourse(
        "3", widget.courseId, (nextPage ?? 0) + 1);
    await detailProvider.setReviewLoadMore(false);
  }

  Future<void> getRelatedList(int? nextPage) async {
    await detailProvider.getRelatedCourse(widget.courseId, (nextPage ?? 0) + 1);
    await detailProvider.setRelatedCourseLoadMore(false);
  }

  Future<void> getVideoByChapter(chapterId, int? nextPage, isViewAll) async {
    await detailProvider.getVideoByChapter(
        widget.courseId, chapterId, (nextPage ?? 0) + 1, isViewAll);
    await detailProvider.setVideoLoadMore(false);
  }

  @override
  void dispose() {
    detailProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printLog("width==> ${MediaQuery.of(context).size.width}");
    return Scaffold(
      // backgroundColor: white,
      appBar: Utils.webMainAppbar(),
      body: Utils.hoverItemWithPage(
        myWidget: Consumer<CourseDetailsProvider>(
            builder: (context, detailprovider, child) {
          if (detailprovider.loading) {
            return commanShimmer();
          } else {
            if (detailprovider.courseDetailsModel.status == 200) {
              return buildLayout();
            } else {
              return const NoData();
            }
          }
        }),
      ),
    );
  }

  Widget buildLayout() {
    if (MediaQuery.of(context).size.width > 800) {
      return buildWeb();
    } else {
      return buildMobile();
    }
  }

  /* Web Layouts Start */

  Widget buildWeb() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.childPanel(context),
              Container(
                width: MediaQuery.of(context).size.width,
                color: colorPrimary,
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.60,
                  ),
                  height: 400,
                  // color: gray,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width > 1600
                        ? 100
                        : MediaQuery.of(context).size.width > 1200
                            ? 100
                            : 20,
                  ),
                  child: parentConainerWeb(),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.60,
                ),
                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 50,
                  left: MediaQuery.of(context).size.width > 1600
                      ? 100
                      : MediaQuery.of(context).size.width > 1200
                          ? 100
                          : 20,
                  // right: MediaQuery.of(context).size.width > 1200
                  //     ? 100
                  //     : MediaQuery.of(context).size.width > 1000
                  //         ? 50
                  //         : 20,
                ),
                // color: orange,
                child: childItem(),
              ),
              const FooterWeb(),
            ],
          ),
          Positioned.fill(
            top: 100,
            left: 20,
            right: MediaQuery.of(context).size.width > 1600
                ? 150
                : MediaQuery.of(context).size.width > 1200
                    ? 100
                    : MediaQuery.of(context).size.width > 1000
                        ? 50
                        : 20,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width > 1600
                        ? MediaQuery.of(context).size.width * 0.20
                        : MediaQuery.of(context).size.width > 1200
                            ? MediaQuery.of(context).size.width * 0.22
                            : MediaQuery.of(context).size.width > 1000
                                ? MediaQuery.of(context).size.width * 0.28
                                : MediaQuery.of(context).size.width * 0.34),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(width: 0.8, color: colorPrimary),
                  color: Theme.of(context).cardColor,
                ),
                height: (detailProvider.courseDetailsModel.result?[0]
                                .isDownloadCertificate ??
                            0) ==
                        1
                    ? 680
                    : 620,
                child: rightLayout(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget parentConainerWeb() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DetailVideo Title Text
          MyText(
              color: white,
              text: detailProvider.courseDetailsModel.result?[0].title
                      .toString() ??
                  "",
              fontsizeNormal: Dimens.textExtralargeBig,
              fontsizeWeb: Dimens.textExtralargeBig,
              fontwaight: FontWeight.w500,
              maxline: 3,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal),
          const SizedBox(height: 15),
          // Course Discription
          ReadMoreText(
            "${detailProvider.courseDetailsModel.result?[0].description.toString() ?? ""}  ",
            trimLines: 5,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: Dimens.textMedium,
                fontWeight: FontWeight.w400,
                color: white),
            trimCollapsedText: 'Read More',
            colorClickableText: black,
            trimMode: TrimMode.Line,
            trimExpandedText: 'Read less',
            lessStyle: TextStyle(
                fontSize: Dimens.textMedium,
                fontWeight: FontWeight.w600,
                color: colorAccent),
            moreStyle: TextStyle(
                fontSize: Dimens.textMedium,
                fontWeight: FontWeight.w600,
                color: colorAccent),
          ),
          const SizedBox(height: 15),
          //  Course Rating with Rating Count
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyRating(
                  rating: double.parse(
                    detailProvider.courseDetailsModel.result?[0].avgRating
                            .toString() ??
                        "",
                  ),
                  spacing: 1,
                  size: 20),
              const SizedBox(width: 10),
              MyText(
                  color: colorAccent,
                  text:
                      "${double.parse(detailProvider.courseDetailsModel.result?[0].avgRating.toString() ?? "")}",
                  fontsizeNormal: Dimens.textTitle,
                  fontsizeWeb: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyImage(
                width: 20,
                height: 20,
                imagePath: "ic_bottomNavAccount.png",
                color: colorAccent,
              ),
              const SizedBox(width: 5),
              MyText(
                  color: white,
                  text: Utils.kmbGenerator(
                      (detailProvider.courseDetailsModel.result?[0].totalView ??
                              0)
                          .round()),
                  fontsizeNormal: Dimens.textTitle,
                  fontsizeWeb: Dimens.textTitle,
                  fontwaight: FontWeight.w400,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal),
              const SizedBox(width: 5),
              MyText(
                  color: white,
                  text: "enroll",
                  fontsizeNormal: Dimens.textTitle,
                  fontsizeWeb: Dimens.textTitle,
                  fontwaight: FontWeight.w400,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
            ],
          ),
          const SizedBox(height: 20),

          // Created By List
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  color: white,
                  text: "createdby",
                  fontsizeNormal: Dimens.textBig,
                  fontsizeWeb: Dimens.textBig,
                  fontwaight: FontWeight.w600,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
              const SizedBox(width: 3),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return WebTutorProfile(
                            tutorid: detailProvider
                                    .courseDetailsModel.result?[0].tutorId
                                    .toString() ??
                                "",
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
                  child: MyText(
                      color: white,
                      text: detailProvider
                                  .courseDetailsModel.result?[0].tutorName ==
                              ""
                          ? "Guest User"
                          : detailProvider
                                  .courseDetailsModel.result?[0].tutorName
                                  .toString() ??
                              "",
                      fontsizeNormal: Dimens.textBig,
                      fontsizeWeb: Dimens.textBig,
                      fontwaight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                      color: white,
                      text: "totalhours",
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      multilanguage: true,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 3),
                  MyText(
                      color: white,
                      text: Utils.formatDuration(double.parse(detailProvider
                              .courseDetailsModel.result?[0].totalDuration
                              .toString() ??
                          "")),
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                      color: white,
                      text: "update",
                      multilanguage: true,
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 3),
                  MyText(
                      color: white,
                      text: Utils.formateDate(
                          detailProvider.courseDetailsModel.result?[0].updatedAt
                                  .toString() ??
                              "",
                          Constant.dateformat),
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                      color: white,
                      text: "languages_",
                      multilanguage: true,
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 3),
                  MyText(
                      color: white,
                      text: detailProvider
                              .courseDetailsModel.result?[0].languageName
                              .toString() ??
                          "",
                      fontsizeNormal: Dimens.textMedium,
                      fontsizeWeb: Dimens.textMedium,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget childItem() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          courseInclude(),
          const SizedBox(height: 20),
          whatYouLearn(),
          const SizedBox(height: 20),
          requirementBox(),
          const SizedBox(height: 20),
          discription(),
          const SizedBox(height: 20),
          courseEpisodes(),
          const SizedBox(height: 20),
          relatedCourse(),
          const SizedBox(height: 20),
          buildStudentFeedback(),
        ],
      ),
    );
  }

  Widget rightLayout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(15),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Course Image */
          InteractiveContainer(child: (isHovered) {
            return AnimatedScale(
              scale: isHovered ? 1.03 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: () {
                    if (Constant.userID == null) {
                      /* Login Page */
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return const WebLogin();
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
                    } else {
                      if (detailProvider.courseDetailsModel.result?[0].isFree ==
                              0 &&
                          detailProvider
                                  .courseDetailsModel.result?[0].isUserBuy !=
                              1) {
                        /* Primium Page  */

                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return AllPayment(
                                /* ContentType 1 == Book */
                                /* ContentType 2 == Course */
                                contentType: "2",
                                payType: 'Content',
                                itemId: detailProvider
                                        .courseDetailsModel.result?[0].id
                                        .toString() ??
                                    "",
                                price: detailProvider
                                        .courseDetailsModel.result?[0].price
                                        .toString() ??
                                    "",
                                itemTitle: detailProvider
                                        .courseDetailsModel.result?[0].title
                                        .toString() ??
                                    "",
                                typeId: "",
                                videoType: "",
                                productPackage: "",
                                currency: Constant.currency,
                                coin: "",
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
                      } else {
                        /* Open Video Player */
                        if ((detailProvider.videoList == null ||
                                (detailProvider.videoList?.length ?? 0) == 0) &&
                            (detailProvider.courseDetailsModel.result?[0]
                                        .chapter ==
                                    null ||
                                (detailProvider.courseDetailsModel.result?[0]
                                            .chapter?.length ??
                                        0) ==
                                    0)) {
                          Utils.showSnackbar(
                              context, "info", "video_not_found", true);
                        } else {
                          printLog(
                              "vUploadType==> ${detailProvider.videoList?[0].videoType.toString() ?? ""}");
                          printLog(
                              "videoUrl==> ${detailProvider.videoList?[0].videoUrl.toString() ?? ""}");

                          Utils.openPlayer(
                              context: context,
                              type: "video",
                              secreateKey: "",
                              videoId: detailProvider.videoList?[0].id ?? 0,
                              videoUrl: detailProvider.videoList?[0].videoUrl
                                      .toString() ??
                                  "",
                              vUploadType: detailProvider
                                      .videoList?[0].videoType
                                      .toString() ??
                                  "",
                              videoThumb: detailProvider
                                      .videoList?[0].landscapeImg
                                      .toString() ??
                                  "",
                              courseId: detailProvider
                                      .courseDetailsModel.result?[0].id ??
                                  0,
                              chepterId: detailProvider.courseDetailsModel
                                      .result?[0].chapter?[0].id ??
                                  0);
                        }
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      MyNetworkImage(
                          imgHeight: 180,
                          fit: BoxFit.fill,
                          islandscap: true,
                          imageUrl: detailProvider
                                  .courseDetailsModel.result?[0].thumbnailImg
                                  .toString() ??
                              ""),
                      const Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.play_arrow_outlined,
                              size: 65, color: white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 15),
          /* Free And Paid Text */
          MyText(
              color: colorPrimary,
              text: detailProvider.courseDetailsModel.result?[0].isFree == 0
                  ? "free"
                  : "paid",
              multilanguage: true,
              fontsizeNormal: Dimens.textlargeBig,
              fontsizeWeb: Dimens.textlargeBig,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal),
          const SizedBox(height: 15),
          /* Category Name */
          const SizedBox(height: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyImage(
                        width: 18,
                        height: 18,
                        imagePath: "ic_bottomNavcategory.png",
                        color: colorAccent,
                      ),
                      const SizedBox(width: 15),
                      MyText(
                          color: Theme.of(context).colorScheme.surface,
                          text: "category",
                          multilanguage: true,
                          fontsizeNormal: Dimens.textTitle,
                          fontsizeWeb: Dimens.textTitle,
                          fontwaight: FontWeight.w500,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: (detailProvider
                              .courseDetailsModel.result?[0].categoryName
                              .toString() ??
                          ""),
                      multilanguage: false,
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 0.8,
                color: gray.withOpacity(0.20),
              ),
            ],
          ),
          /* Total Chepter Count */
          const SizedBox(height: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyImage(
                        width: 18,
                        height: 18,
                        imagePath: "ic_chapter.png",
                        color: colorAccent,
                      ),
                      const SizedBox(width: 15),
                      MyText(
                          color: Theme.of(context).colorScheme.surface,
                          text: "chepter",
                          multilanguage: true,
                          fontsizeNormal: Dimens.textTitle,
                          fontsizeWeb: Dimens.textTitle,
                          fontwaight: FontWeight.w500,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text:
                          "${(detailProvider.courseDetailsModel.result?[0].chapter?.length ?? 0)}",
                      multilanguage: false,
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 0.8,
                color: gray.withOpacity(0.20),
              ),
            ],
          ),
          /* Studens Enroll Count */
          const SizedBox(height: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyImage(
                        width: 18,
                        height: 18,
                        imagePath: "ic_bottomNavAccount.png",
                        color: colorAccent,
                      ),
                      const SizedBox(width: 15),
                      MyText(
                          color: Theme.of(context).colorScheme.surface,
                          text: "students",
                          multilanguage: true,
                          fontsizeNormal: Dimens.textTitle,
                          fontsizeWeb: Dimens.textTitle,
                          fontwaight: FontWeight.w500,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    ],
                  ),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: detailProvider
                              .courseDetailsModel.result?[0].totalView
                              .toString() ??
                          "",
                      multilanguage: false,
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 0.8,
                color: gray.withOpacity(0.20),
              ),
            ],
          ),
          const SizedBox(height: 15),
          /* Wishlist Button */
          InkWell(
            onTap: () async {
              if (Constant.userID == null) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return const WebLogin();
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
              } else {
                await detailProvider.addRemoveWishlist(
                    "3",
                    detailProvider.courseDetailsModel.result?[0].id
                            .toString() ??
                        "");
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InteractiveContainer(child: (isHovered) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.8,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        color: isHovered
                            ? gray.withOpacity(0.20)
                            : transparentColor,
                      ),
                      child: AnimatedScale(
                        scale: isHovered ? 1.03 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: detailProvider.courseDetailsModel.result?[0]
                                        .isWishlist ==
                                    1
                                ? "removetowishlist"
                                : "addtowishlist",
                            multilanguage: true,
                            fontsizeNormal: Dimens.textTitle,
                            fontsizeWeb: Dimens.textTitle,
                            fontwaight: FontWeight.w600,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 5),
                InteractiveContainer(child: (isHovered) {
                  return Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.8,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      color:
                          isHovered ? gray.withOpacity(0.20) : transparentColor,
                    ),
                    child: AnimatedScale(
                      scale: isHovered ? 1.03 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Icon(
                        detailProvider
                                    .courseDetailsModel.result?[0].isWishlist ==
                                1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: detailProvider
                                    .courseDetailsModel.result?[0].isWishlist ==
                                1
                            ? red
                            : Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          /* Add Review */
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              if (Constant.userID == null) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return const WebLogin();
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
              } else {
                addReviewBottomSheet(
                  context,
                  detailProvider.courseDetailsModel.result?[0].id.toString() ??
                      "",
                );
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: InteractiveContainer(child: (isHovered) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.8,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        color: isHovered
                            ? gray.withOpacity(0.20)
                            : transparentColor,
                      ),
                      child: AnimatedScale(
                        scale: isHovered ? 1.03 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: "addreviewandcomment",
                            multilanguage: true,
                            fontsizeNormal: Dimens.textTitle,
                            fontsizeWeb: Dimens.textTitle,
                            fontwaight: FontWeight.w600,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 5),
                InteractiveContainer(child: (isHovered) {
                  return Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.8,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      color:
                          isHovered ? gray.withOpacity(0.20) : transparentColor,
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
              ],
            ),
          ),
          /* Enroll Button */
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              if (Constant.userID == null) {
                /* Login Page */
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return const WebLogin();
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
              } else {
                if (detailProvider.courseDetailsModel.result?[0].isFree == 0 &&
                    detailProvider.courseDetailsModel.result?[0].isUserBuy !=
                        1) {
                  /* Primium Page  */

                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return AllPayment(
                          /* ContentType 1 == Book */
                          /* ContentType 2 == Course */
                          contentType: "2",
                          payType: 'Content',
                          itemId: detailProvider
                                  .courseDetailsModel.result?[0].id
                                  .toString() ??
                              "",
                          price: detailProvider
                                  .courseDetailsModel.result?[0].price
                                  .toString() ??
                              "",
                          itemTitle: detailProvider
                                  .courseDetailsModel.result?[0].title
                                  .toString() ??
                              "",
                          typeId: "",
                          videoType: "",
                          productPackage: "",
                          currency: Constant.currency,
                          coin: "",
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
                } else {
                  /* Open Video Player */
                  if ((detailProvider.videoList == null ||
                          (detailProvider.videoList?.length ?? 0) == 0) &&
                      (detailProvider.courseDetailsModel.result?[0].chapter ==
                              null ||
                          (detailProvider.courseDetailsModel.result?[0].chapter
                                      ?.length ??
                                  0) ==
                              0)) {
                    Utils.showSnackbar(
                        context, "info", "video_not_found", true);
                  } else {
                    printLog(
                        "vUploadType==> ${detailProvider.videoList?[0].videoType.toString() ?? ""}");
                    printLog(
                        "videoUrl==> ${detailProvider.videoList?[0].videoUrl.toString() ?? ""}");

                    Utils.openPlayer(
                        context: context,
                        type: "video",
                        secreateKey: "",
                        videoId: detailProvider.videoList?[0].id ?? 0,
                        videoUrl:
                            detailProvider.videoList?[0].videoUrl.toString() ??
                                "",
                        vUploadType:
                            detailProvider.videoList?[0].videoType.toString() ??
                                "",
                        videoThumb: detailProvider.videoList?[0].landscapeImg
                                .toString() ??
                            "",
                        courseId:
                            detailProvider.courseDetailsModel.result?[0].id ??
                                0,
                        chepterId: detailProvider
                                .courseDetailsModel.result?[0].chapter?[0].id ??
                            0);
                  }
                }
              }
            },
            child: InteractiveContainer(child: (isHovered) {
              return AnimatedScale(
                scale: isHovered ? 1.03 : 1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  decoration: const BoxDecoration(
                    color: colorPrimary,
                  ),
                  child: MyText(
                      color: white,
                      text: "enrollnow",
                      multilanguage: true,
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                      fontwaight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ),
              );
            }),
          ),
          const SizedBox(height: 15),
          generateCertificate(),
        ],
      ),
    );
  }

/* Web Layouts End */

/* Mobile Layouts Start */

  Widget buildMobile() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Utils.childPanel(context),
                parentConainerMobile(),
                childContainerMobile(),
                const FooterWeb(),
              ],
            ),
          ),
        ),
        Container(
          height: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: MediaQuery.of(context).size.width,
          color: gray.withOpacity(0.15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              detailProvider.courseDetailsModel.result?[0].isFree == 0
                  ? Container(
                      height: 45,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 0.7, color: gray),
                      ),
                      child: MyText(
                          color: colorPrimary,
                          text: "free",
                          multilanguage: true,
                          fontsizeNormal: Dimens.textTitle,
                          fontsizeWeb: Dimens.textTitle,
                          fontwaight: FontWeight.w700,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: MyImage(
                          width: 35,
                          height: 35,
                          imagePath: "appicon_transparent.png")),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (Constant.userID == null) {
                      /* Login Page */
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return const WebLogin();
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
                    } else {
                      if (detailProvider.courseDetailsModel.result?[0].isFree ==
                              0 &&
                          detailProvider
                                  .courseDetailsModel.result?[0].isUserBuy !=
                              1) {
                        /* Primium Page  */

                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return AllPayment(
                                /* ContentType 1 == Book */
                                /* ContentType 2 == Course */
                                contentType: "2",
                                payType: 'Content',
                                itemId: detailProvider
                                        .courseDetailsModel.result?[0].id
                                        .toString() ??
                                    "",
                                price: detailProvider
                                        .courseDetailsModel.result?[0].price
                                        .toString() ??
                                    "",
                                itemTitle: detailProvider
                                        .courseDetailsModel.result?[0].title
                                        .toString() ??
                                    "",
                                typeId: "",
                                videoType: "",
                                productPackage: "",
                                currency: Constant.currency,
                                coin: "",
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
                      } else {
                        /* Open Video Player */
                        if ((detailProvider.videoList == null ||
                                (detailProvider.videoList?.length ?? 0) == 0) &&
                            (detailProvider.courseDetailsModel.result?[0]
                                        .chapter ==
                                    null ||
                                (detailProvider.courseDetailsModel.result?[0]
                                            .chapter?.length ??
                                        0) ==
                                    0)) {
                          Utils.showSnackbar(
                              context, "info", "video_not_found", true);
                        } else {
                          printLog(
                              "vUploadType==> ${detailProvider.videoList?[0].videoType.toString() ?? ""}");
                          printLog(
                              "videoUrl==> ${detailProvider.videoList?[0].videoUrl.toString() ?? ""}");

                          Utils.openPlayer(
                              context: context,
                              type: "video",
                              secreateKey: "",
                              videoId: detailProvider.videoList?[0].id ?? 0,
                              videoUrl: detailProvider.videoList?[0].videoUrl
                                      .toString() ??
                                  "",
                              vUploadType: detailProvider
                                      .videoList?[0].videoType
                                      .toString() ??
                                  "",
                              videoThumb: detailProvider
                                      .videoList?[0].landscapeImg
                                      .toString() ??
                                  "",
                              courseId: detailProvider
                                      .courseDetailsModel.result?[0].id ??
                                  0,
                              chepterId: detailProvider.courseDetailsModel
                                      .result?[0].chapter?[0].id ??
                                  0);
                        }
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colorPrimary,
                    ),
                    child: MyText(
                        color: white,
                        text: "enrollnow",
                        multilanguage: true,
                        fontsizeNormal: Dimens.textTitle,
                        fontsizeWeb: Dimens.textTitle,
                        fontwaight: FontWeight.w600,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget parentConainerMobile() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                    color: black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MyNetworkImage(
                      imgHeight: 350,
                      fit: BoxFit.fill,
                      islandscap: true,
                      imageUrl: detailProvider
                              .courseDetailsModel.result?[0].thumbnailImg
                              .toString() ??
                          ""),
                ),
              ),
              Positioned.fill(
                child: InkWell(
                  onTap: () async {
                    if (Constant.userID == null) {
                      /* Login Page */
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return const WebLogin();
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
                    } else {
                      if (detailProvider.courseDetailsModel.result?[0].isFree ==
                              0 &&
                          detailProvider
                                  .courseDetailsModel.result?[0].isUserBuy !=
                              1) {
                        /* Primium Page  */

                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return AllPayment(
                                /* ContentType 1 == Book */
                                /* ContentType 2 == Course */
                                contentType: "2",
                                payType: 'Content',
                                itemId: detailProvider
                                        .courseDetailsModel.result?[0].id
                                        .toString() ??
                                    "",
                                price: detailProvider
                                        .courseDetailsModel.result?[0].price
                                        .toString() ??
                                    "",
                                itemTitle: detailProvider
                                        .courseDetailsModel.result?[0].title
                                        .toString() ??
                                    "",
                                typeId: "",
                                videoType: "",
                                productPackage: "",
                                currency: Constant.currency,
                                coin: "",
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
                      } else {
                        /* Open Video Player */
                        if ((detailProvider.videoList == null ||
                                (detailProvider.videoList?.length ?? 0) == 0) &&
                            (detailProvider.courseDetailsModel.result?[0]
                                        .chapter ==
                                    null ||
                                (detailProvider.courseDetailsModel.result?[0]
                                            .chapter?.length ??
                                        0) ==
                                    0)) {
                          Utils.showSnackbar(
                              context, "info", "video_not_found", true);
                        } else {
                          printLog(
                              "vUploadType==> ${detailProvider.videoList?[0].videoType.toString() ?? ""}");
                          printLog(
                              "videoUrl==> ${detailProvider.videoList?[0].videoUrl.toString() ?? ""}");

                          Utils.openPlayer(
                              context: context,
                              type: "video",
                              secreateKey: "",
                              videoId: detailProvider.videoList?[0].id ?? 0,
                              videoUrl: detailProvider.videoList?[0].videoUrl
                                      .toString() ??
                                  "",
                              vUploadType: detailProvider
                                      .videoList?[0].videoType
                                      .toString() ??
                                  "",
                              videoThumb: detailProvider
                                      .videoList?[0].landscapeImg
                                      .toString() ??
                                  "",
                              courseId: detailProvider
                                      .courseDetailsModel.result?[0].id ??
                                  0,
                              chepterId: detailProvider.courseDetailsModel
                                      .result?[0].chapter?[0].id ??
                                  0);
                        }
                      }
                    }
                  },
                  child: const Align(
                    alignment: Alignment.center,
                    child:
                        Icon(Icons.play_arrow_outlined, size: 65, color: white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // DetailVideo Title Text
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: detailProvider.courseDetailsModel.result?[0].title
                            .toString() ??
                        "",
                    fontsizeNormal: Dimens.textBig,
                    fontsizeWeb: Dimens.textBig,
                    fontwaight: FontWeight.w700,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ),
              const SizedBox(width: 15),
              InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () async {
                  if (Constant.userID == null) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const WebLogin();
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
                  } else {
                    await detailProvider.addRemoveWishlist(
                        "3",
                        detailProvider.courseDetailsModel.result?[0].id
                                .toString() ??
                            "");
                  }
                },
                child: InteractiveContainer(child: (isHovered) {
                  return Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 0.8,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      color:
                          isHovered ? gray.withOpacity(0.20) : transparentColor,
                    ),
                    child: AnimatedScale(
                      scale: isHovered ? 1.03 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Icon(
                        detailProvider
                                    .courseDetailsModel.result?[0].isWishlist ==
                                1
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: detailProvider
                                    .courseDetailsModel.result?[0].isWishlist ==
                                1
                            ? red
                            : Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 15),
              InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () {
                  if (Constant.userID == null) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const WebLogin();
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
                  } else {
                    addReviewBottomSheet(
                      context,
                      detailProvider.courseDetailsModel.result?[0].id
                              .toString() ??
                          "",
                    );
                  }
                },
                child: InteractiveContainer(child: (isHovered) {
                  return Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 0.8,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      color:
                          isHovered ? gray.withOpacity(0.20) : transparentColor,
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
          const SizedBox(height: 10),

          //  Course Rating with Rating Count
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyRating(
                  rating: double.parse(
                    detailProvider.courseDetailsModel.result?[0].avgRating
                            .toString() ??
                        "",
                  ),
                  spacing: 1,
                  size: 20),
              const SizedBox(width: 10),
              MyText(
                  color: colorAccent,
                  text:
                      "${double.parse(detailProvider.courseDetailsModel.result?[0].avgRating.toString() ?? "")}",
                  fontsizeNormal: Dimens.textTitle,
                  fontsizeWeb: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
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
              MyText(
                  color: gray,
                  text: Utils.kmbGenerator(
                      (detailProvider.courseDetailsModel.result?[0].totalView ??
                              0)
                          .round()),
                  fontsizeNormal: Dimens.textSmall,
                  fontsizeWeb: Dimens.textSmall,
                  fontwaight: FontWeight.w400,
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
                  fontwaight: FontWeight.w400,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
            ],
          ),
          const SizedBox(height: 10),
          // Course Discription
          ReadMoreText(
            "${detailProvider.courseDetailsModel.result?[0].description.toString() ?? ""}  ",
            trimLines: 5,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: Dimens.textSmall,
                fontWeight: FontWeight.w400,
                color: gray),
            trimCollapsedText: 'Read More',
            colorClickableText: black,
            trimMode: TrimMode.Line,
            trimExpandedText: 'Read less',
            lessStyle: TextStyle(
                fontSize: Dimens.textSmall,
                fontWeight: FontWeight.w600,
                color: black),
            moreStyle: TextStyle(
                fontSize: Dimens.textSmall,
                fontWeight: FontWeight.w600,
                color: black),
          ),

          const SizedBox(height: 10),

          // Created By List
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  color: Theme.of(context).colorScheme.surface,
                  text: "createdby",
                  fontsizeNormal: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
              const SizedBox(width: 3),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return WebTutorProfile(
                            tutorid: detailProvider
                                    .courseDetailsModel.result?[0].tutorId
                                    .toString() ??
                                "",
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
                  child: MyText(
                      color: colorPrimary,
                      text: detailProvider
                                  .courseDetailsModel.result?[0].tutorName ==
                              ""
                          ? "Guest User"
                          : detailProvider
                                  .courseDetailsModel.result?[0].tutorName
                                  .toString() ??
                              "",
                      fontsizeNormal: Dimens.textTitle,
                      fontwaight: FontWeight.w700,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                      color: gray,
                      text: "totalhours",
                      fontsizeNormal: Dimens.textSmall,
                      multilanguage: true,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      fontsizeWeb: Dimens.textSmall,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 3),
                  MyText(
                      color: gray,
                      text: Utils.formatDuration(double.parse(detailProvider
                              .courseDetailsModel.result?[0].totalDuration
                              .toString() ??
                          "")),
                      fontsizeNormal: Dimens.textSmall,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      fontsizeWeb: Dimens.textSmall,
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
                  MyText(
                      color: gray,
                      text: "update",
                      multilanguage: true,
                      fontsizeNormal: Dimens.textSmall,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 3),
                  MyText(
                      color: gray,
                      text: Utils.formateDate(
                          detailProvider.courseDetailsModel.result?[0].updatedAt
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
                  MyText(
                      color: gray,
                      text: "language",
                      multilanguage: true,
                      fontsizeNormal: Dimens.textSmall,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                  const SizedBox(width: 3),
                  MyText(
                      color: gray,
                      text: detailProvider
                              .courseDetailsModel.result?[0].languageName
                              .toString() ??
                          "",
                      fontsizeNormal: Dimens.textSmall,
                      fontwaight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget childContainerMobile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // color: white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Column(
          children: [
            courseInclude(),
            const SizedBox(height: 15),
            whatYouLearn(),
            const SizedBox(height: 15),
            requirementBox(),
            const SizedBox(height: 15),
            discription(),
            const SizedBox(height: 15),
            relatedCourse(),
            const SizedBox(height: 15),
            courseEpisodes(),
            generateCertificate(),
            const SizedBox(height: 20),
            buildStudentFeedback(),
          ],
        ),
      ),
    );
  }

/* Mobile Layouts End */

/* This Course Include */

  Widget courseInclude() {
    if (detailProvider.courseDetailsModel.result?[0].inlcude != null &&
        (detailProvider.courseDetailsModel.result?[0].inlcude?.length ?? 0) >
            0) {
      return InteractiveContainer(child: (isHovered) {
        return AnimatedScale(
          scale: isHovered ? 1.03 : 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.10),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyText(
                    color: Theme.of(context).colorScheme.surface,
                    fontwaight: FontWeight.w600,
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                    overflow: TextOverflow.ellipsis,
                    maxline: 1,
                    text: "thiscouurseincludes",
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    multilanguage: true),
                const SizedBox(height: 10),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: detailProvider
                      .courseDetailsModel.result?[0].inlcude?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyImage(
                            width: 15,
                            height: 15,
                            imagePath: "ic_tick.png",
                            color: colorPrimary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: MyText(
                                color: gray,
                                fontwaight: FontWeight.w500,
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
                                overflow: TextOverflow.ellipsis,
                                maxline: 2,
                                text: detailProvider.courseDetailsModel
                                        .result?[0].inlcude?[index].title
                                        .toString() ??
                                    "",
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      });
    } else {
      return const SizedBox.shrink();
    }
  }

/* What You Learn */

  Widget whatYouLearn() {
    if (detailProvider.courseDetailsModel.result?[0].whatYouLearn != null &&
        (detailProvider.courseDetailsModel.result?[0].whatYouLearn?.length ??
                0) >
            0) {
      return InteractiveContainer(child: (isHovered) {
        return AnimatedScale(
          scale: isHovered ? 1.03 : 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.10),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                    color: Theme.of(context).colorScheme.surface,
                    fontwaight: FontWeight.w600,
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                    overflow: TextOverflow.ellipsis,
                    maxline: 1,
                    text: "whatyoulearn",
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal,
                    multilanguage: true),
                const SizedBox(height: 10),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: detailProvider
                          .courseDetailsModel.result?[0].whatYouLearn?.length ??
                      0,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          MyImage(
                            width: 15,
                            height: 15,
                            imagePath: "ic_tick.png",
                            color: colorPrimary,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: MyText(
                                color: gray,
                                fontwaight: FontWeight.w400,
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
                                overflow: TextOverflow.ellipsis,
                                maxline: 3,
                                text: detailProvider.courseDetailsModel
                                        .result?[0].whatYouLearn?[index].title
                                        .toString() ??
                                    "",
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      });
    } else {
      return const SizedBox.shrink();
    }
  }

/* Requirmemt Box */

  Widget requirementBox() {
    if (detailProvider.courseDetailsModel.result![0].requrirment != null &&
        (detailProvider.courseDetailsModel.result![0].requrirment?.length ??
                0) >
            0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
              color: Theme.of(context).colorScheme.surface,
              fontwaight: FontWeight.w600,
              fontsizeNormal: Dimens.textlargeBig,
              fontsizeWeb: Dimens.textlargeBig,
              overflow: TextOverflow.ellipsis,
              maxline: 1,
              text: "requirments",
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(height: 10),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detailProvider
                    .courseDetailsModel.result?[0].requrirment?.length ??
                0,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyImage(
                          width: 15,
                          height: 15,
                          imagePath: "ic_tick.png",
                          color: colorPrimary,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: MyText(
                              color: gray,
                              fontwaight: FontWeight.w400,
                              fontsizeNormal: Dimens.textTitle,
                              fontsizeWeb: Dimens.textTitle,
                              overflow: TextOverflow.ellipsis,
                              maxline: 3,
                              text: detailProvider.courseDetailsModel.result?[0]
                                      .requrirment?[index].title
                                      .toString() ??
                                  "",
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

/* Discription */

  Widget discription() {
    if (detailProvider.courseDetailsModel.result?[0].description != "") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
              color: Theme.of(context).colorScheme.surface,
              fontwaight: FontWeight.w600,
              fontsizeNormal: Dimens.textlargeBig,
              fontsizeWeb: Dimens.textlargeBig,
              overflow: TextOverflow.ellipsis,
              maxline: 1,
              text: "description",
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(height: 10),
          MyText(
              color: gray,
              fontsizeNormal: Dimens.textTitle,
              fontsizeWeb: Dimens.textTitle,
              text: detailProvider.courseDetailsModel.result?[0].description
                      .toString() ??
                  "",
              maxline: 5,
              fontwaight: FontWeight.w400,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

/* Related Course */

  Widget relatedCourse() {
    return Consumer<CourseDetailsProvider>(
        builder: (context, detailprovider, child) {
      if (detailprovider.loading && !detailprovider.relatedCourseloadmore) {
        return Utils.pageLoader();
      } else {
        if (detailprovider.relatedCourseModel.status == 200 &&
            detailProvider.relatedCourseList != null &&
            (detailProvider.relatedCourseModel.result?.length ?? 0) > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  color: black,
                  fontwaight: FontWeight.w600,
                  fontsizeNormal: Dimens.textlargeBig,
                  fontsizeWeb: Dimens.textlargeBig,
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  text: "Related Course",
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  multilanguage: false),
              const SizedBox(height: 20),
              relatedCourseItem(),
              if (detailprovider.relatedCourseloadmore)
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
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget relatedCourseItem() {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 25,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        detailProvider.relatedCourseList?.length ?? 0,
        (index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return WebDetail(
                        courseId: detailProvider.relatedCourseList?[index].id
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
            child: InteractiveContainer(child: (isHovered) {
              return AnimatedScale(
                scale: isHovered ? 1.03 : 1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: gray.withOpacity(0.50),
                        blurRadius: 2,
                        offset: const Offset(0.1, 0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        child: MyNetworkImage(
                          imgWidth: MediaQuery.of(context).size.width > 800
                              ? 135
                              : 110,
                          imgHeight: MediaQuery.of(context).size.width > 800
                              ? 110
                              : 100,
                          imageUrl: detailProvider
                                  .relatedCourseList?[index].thumbnailImg
                                  .toString() ??
                              "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: detailProvider
                                        .relatedCourseList?[index].title
                                        .toString() ??
                                    "",
                                fontsizeNormal:
                                    MediaQuery.of(context).size.width > 800
                                        ? Dimens.textTitle
                                        : Dimens.textBigSmall,
                                fontsizeWeb:
                                    MediaQuery.of(context).size.width > 800
                                        ? Dimens.textTitle
                                        : Dimens.textBigSmall,
                                fontwaight: FontWeight.w600,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                            const SizedBox(height: 8),
                            MyText(
                                color: gray,
                                text:
                                    "${Utils.kmbGenerator(int.parse(detailProvider.relatedCourseList?[index].totalView.toString() ?? ""))} Students",
                                fontsizeNormal:
                                    MediaQuery.of(context).size.width > 800
                                        ? Dimens.textDesc
                                        : Dimens.textSmall,
                                fontsizeWeb:
                                    MediaQuery.of(context).size.width > 800
                                        ? Dimens.textDesc
                                        : Dimens.textSmall,
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
                                    rating: double.parse((detailProvider
                                            .relatedCourseList?[index].avgRating
                                            .toString() ??
                                        "")),
                                    spacing: 1,
                                    size: 18),
                                const SizedBox(width: 8),
                                MyText(
                                    color: colorAccent,
                                    text:
                                        "${(detailProvider.relatedCourseList?[index].avgRating ?? 0)}",
                                    fontsizeNormal:
                                        MediaQuery.of(context).size.width > 800
                                            ? Dimens.textDesc
                                            : Dimens.textSmall,
                                    fontsizeWeb:
                                        MediaQuery.of(context).size.width > 800
                                            ? Dimens.textDesc
                                            : Dimens.textSmall,
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
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

/* course Episodes */

  Widget courseEpisodes() {
    if (detailProvider.courseDetailsModel.result![0].chapter != null &&
        (detailProvider.courseDetailsModel.result?[0].chapter?.length ?? 0) >
            0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
              color: Theme.of(context).colorScheme.surface,
              text: "Curriculum",
              fontsizeNormal: Dimens.textlargeBig,
              fontsizeWeb: Dimens.textlargeBig,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(height: 20),
          // Course Episodes
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                detailProvider.courseDetailsModel.result?[0].chapter?.length ??
                    0,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                focusColor: transparentColor,
                splashColor: transparentColor,
                onTap: () async {
                  if (detailProvider.chapterIndex == index &&
                      detailProvider.isOpen == true) {
                    await detailProvider.openChapterVideo(index, false);
                    detailProvider.clearVideoChapter();
                  } else {
                    await detailProvider.openChapterVideo(index, true);
                    getVideoByChapter(
                        detailProvider.courseDetailsModel.result?[0]
                                .chapter?[index].id
                                .toString() ??
                            "",
                        0,
                        false);
                  }
                },
                child: InteractiveContainer(child: (isHovered) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeIn,
                      height: detailProvider.chapterIndex == index &&
                              detailProvider.isOpen == true
                          ? null
                          : 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isHovered
                                  ? colorPrimary.withOpacity(0.50)
                                  : gray.withOpacity(0.50),
                              width: 0.5)),
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: MyText(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontsizeNormal: Dimens.textTitle,
                                      fontsizeWeb: Dimens.textTitle,
                                      maxline: 2,
                                      fontwaight: FontWeight.w600,
                                      text:
                                          "${(index + 1)}.  ${detailProvider.courseDetailsModel.result?[0].chapter?[index].name.toString() ?? ""}",
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                ),
                                Icon(
                                  detailProvider.chapterIndex == index &&
                                          detailProvider.isOpen == true
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: gray,
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            chapterVideoList(
                                index,
                                detailProvider.courseDetailsModel.result?[0]
                                        .chapter?[index].id ??
                                    0),
                            const SizedBox(height: 10),
                            /* ViewAll Button  */
                            if ((detailProvider.videocurrentPage ?? 0) <
                                    (detailProvider.videototalPage ?? 0) &&
                                !detailProvider.videoloadmore)
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () async {
                                    await detailProvider.setVideoLoadMore(true);
                                    getVideoByChapter(
                                        detailProvider.courseDetailsModel
                                                .result?[0].chapter?[index].id
                                                .toString() ??
                                            "",
                                        detailProvider.videocurrentPage ?? 0,
                                        true);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 20, 15, 20),
                                    child: MyText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        fontsizeNormal: Dimens.textMedium,
                                        maxline: 2,
                                        multilanguage: true,
                                        fontwaight: FontWeight.w600,
                                        text: "viewall",
                                        textalign: TextAlign.left,
                                        fontstyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            /* ViewAll ProgressBar  */
                            if (detailProvider.videoloadmore)
                              const Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: colorPrimary,
                                    strokeWidth: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

/* Chepter Video List in DropDown */

  Widget chapterVideoList(index, chapterId) {
    if (detailProvider.chapterIndex == index && detailProvider.isOpen == true) {
      if (detailProvider.videoloading && !detailProvider.videoloadmore) {
        return const Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: colorPrimary,
              strokeWidth: 1,
            ),
          ),
        );
      } else {
        if (detailProvider.getVideoByChapterModel.status == 200 &&
            detailProvider.videoList != null) {
          if ((detailProvider.videoList?.length ?? 0) > 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, indexSaprate) =>
                      const SizedBox(height: 25),
                  itemCount: detailProvider.videoList?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return InkWell(
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      focusColor: transparentColor,
                      splashColor: transparentColor,
                      onTap: () {
                        if (Constant.userID == null) {
                          /* Login Page */
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 1000),
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return const WebLogin();
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
                        } else {
                          if (detailProvider
                                      .courseDetailsModel.result?[0].isFree ==
                                  0 &&
                              detailProvider.courseDetailsModel.result?[0]
                                      .isUserBuy !=
                                  1) {
                            /* Primium Page  */

                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 1000),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return AllPayment(
                                    /* ContentType 1 == Book */
                                    /* ContentType 2 == Course */
                                    contentType: "2",
                                    payType: 'Content',
                                    itemId: detailProvider
                                            .courseDetailsModel.result?[0].id
                                            .toString() ??
                                        "",
                                    price: detailProvider
                                            .courseDetailsModel.result?[0].price
                                            .toString() ??
                                        "",
                                    itemTitle: detailProvider
                                            .courseDetailsModel.result?[0].title
                                            .toString() ??
                                        "",
                                    typeId: "",
                                    videoType: "",
                                    productPackage: "",
                                    currency: Constant.currency,
                                    coin: "",
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
                          } else {
                            /* Open Video Player */
                            if (detailProvider.videoList == null ||
                                (detailProvider.videoList?.length ?? 0) == 0) {
                              Utils.showSnackbar(
                                  context, "info", "video_not_found", true);
                            } else {
                              printLog(
                                  "vUploadType==> ${detailProvider.videoList?[position].videoType.toString() ?? ""}");
                              printLog(
                                  "videoUrl==> ${detailProvider.videoList?[position].videoUrl.toString() ?? ""}");
                              if ((detailProvider.videoList == null ||
                                      (detailProvider.videoList?.length ?? 0) ==
                                          0) &&
                                  (detailProvider.courseDetailsModel.result?[0]
                                              .chapter ==
                                          null ||
                                      (detailProvider.courseDetailsModel
                                                  .result?[0].chapter?.length ??
                                              0) ==
                                          0)) {
                                Utils.showSnackbar(
                                    context, "info", "video_not_found", true);
                              } else {
                                Utils.openPlayer(
                                  context: context,
                                  type: "video",
                                  secreateKey: "",
                                  videoId:
                                      detailProvider.videoList?[position].id ??
                                          0,
                                  videoUrl: detailProvider
                                          .videoList?[position].videoUrl
                                          .toString() ??
                                      "",
                                  vUploadType: detailProvider
                                          .videoList?[position].videoType
                                          .toString() ??
                                      "",
                                  videoThumb: detailProvider
                                          .videoList?[position].landscapeImg
                                          .toString() ??
                                      "",
                                  courseId: detailProvider
                                          .courseDetailsModel.result?[0].id ??
                                      0,
                                  chepterId: chapterId,
                                );
                              }
                            }
                          }
                        }
                      },
                      child: InteractiveContainer(child: (isHovered) {
                        return AnimatedScale(
                          scale: isHovered ? 1.01 : 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                  color: colorPrimary,
                                  fontsizeNormal: Dimens.textBig,
                                  fontsizeWeb: Dimens.textBig,
                                  maxline: 2,
                                  fontwaight: FontWeight.w600,
                                  text: "${(position + 1)}.",
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyText(
                                    color: colorPrimary,
                                    fontsizeNormal: Dimens.textDesc,
                                    fontsizeWeb: Dimens.textDesc,
                                    maxline: 3,
                                    fontwaight: FontWeight.w600,
                                    text: detailProvider
                                            .videoList?[position].title
                                            .toString() ??
                                        "",
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              const SizedBox(width: 10),
                              detailProvider.videoList?[position].isRead == 1
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: colorAccent,
                                        border:
                                            Border.all(width: 1, color: white),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 18,
                                        color: white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.play_circle,
                                      color: colorPrimary,
                                      size: 25,
                                    )
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
                detailProvider.courseDetailsModel.result?[0].chapter?[index]
                            .quizStatus ==
                        0
                    ? const SizedBox.shrink()
                    : InkWell(
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        focusColor: transparentColor,
                        splashColor: transparentColor,
                        onTap: () {
                          if (Constant.userID == null) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 1000),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return const WebLogin();
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
                          } else {
                            if (detailProvider.courseDetailsModel.result?[0]
                                    .chapter?[index].isQuizPlay ==
                                0) {
                              Utils.showSnackbar(context, "fail",
                                  "pleasewatchallvideos", true);
                            } else {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Quize(
                                    courseId: int.parse(widget.courseId),
                                    chapterId: chapterId,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                  color: colorPrimary,
                                  fontsizeNormal: Dimens.textBig,
                                  fontsizeWeb: Dimens.textBig,
                                  maxline: 2,
                                  fontwaight: FontWeight.w600,
                                  text:
                                      "${((detailProvider.videoList?.length ?? 0) + 1).toString()}.",
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyText(
                                    color: colorPrimary,
                                    fontsizeNormal: Dimens.textDesc,
                                    fontsizeWeb: Dimens.textDesc,
                                    maxline: 3,
                                    fontwaight: FontWeight.w600,
                                    text: "Play Quiz",
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              const SizedBox(width: 10),
                              detailProvider.courseDetailsModel.result?[0]
                                          .chapter?[index].isQuizPlay ==
                                      1
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: colorAccent,
                                        border:
                                            Border.all(width: 1, color: white),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.play_circle,
                                      color: colorPrimary,
                                      size: 25,
                                    )
                            ],
                          ),
                        ),
                      ),
              ],
            );
          } else {
            return Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                  color: colorPrimary,
                  fontsizeNormal: Dimens.textMedium,
                  maxline: 2,
                  fontwaight: FontWeight.w600,
                  text: "No Video Found",
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal),
            );
          }
        } else {
          return Align(
            alignment: Alignment.centerLeft,
            child: MyText(
                color: colorPrimary,
                fontsizeNormal: Dimens.textMedium,
                maxline: 2,
                fontwaight: FontWeight.w600,
                text: "No Video Found",
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
          );
        }
      }
    } else {
      return const SizedBox.shrink();
    }
  }

/* Student Comments And Review List */

  Widget buildStudentFeedback() {
    return Consumer<CourseDetailsProvider>(
        builder: (context, detailprovider, child) {
      if (detailprovider.reviewloading && !detailprovider.reviewloadmore) {
        return Utils.pageLoader();
      } else {
        if (detailprovider.getCourseReviewModel.status == 200 &&
            detailprovider.reviewList != null) {
          if ((detailprovider.reviewList?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: "studentfeedback",
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                    fontwaight: FontWeight.w600,
                    maxline: 1,
                    multilanguage: true,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
                const SizedBox(height: 20),
                MediaQuery.of(context).size.width > 800
                    ? buildStudentFeedbackItemWeb()
                    : buildStudentFeedbackItemMobile(),
                if (detailprovider.reviewloadmore)
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
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget buildStudentFeedbackItemMobile() {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 15,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
      children: List.generate(
        detailProvider.reviewList?.length ?? 0,
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
                        imageUrl: detailProvider.reviewList?[index].image ?? "",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: detailProvider.reviewList?[index].fullName == ""
                            ? MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: detailProvider.reviewList?[index].userName
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textMedium,
                                fontwaight: FontWeight.w700,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal)
                            : MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: detailProvider.reviewList?[index].fullName
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
                            detailProvider.reviewList?[index].createdAt
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
                      size: 15,
                      rating: double.parse((detailProvider
                              .reviewList?[index].rating
                              .toString() ??
                          "")),
                      spacing: 3,
                    ),
                    const SizedBox(width: 5),
                    MyText(
                        color: colorAccent,
                        text:
                            "${double.parse((detailProvider.reviewList?[index].rating.toString() ?? ""))}",
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
                    text:
                        detailProvider.reviewList?[index].comment.toString() ??
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

  Widget buildStudentFeedbackItemWeb() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ResponsiveGridList(
        minItemWidth: 120,
        minItemsPerRow: Utils.customCrossAxisCount(
            context: context,
            height1600: 3,
            height1200: 3,
            height800: 2,
            height400: 1),
        maxItemsPerRow: Utils.customCrossAxisCount(
            context: context,
            height1600: 3,
            height1200: 3,
            height800: 2,
            height400: 1),
        horizontalGridSpacing: 40,
        verticalGridSpacing: 20,
        listViewBuilderOptions: ListViewBuilderOptions(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
        children: List.generate(
          detailProvider.reviewList?.length ?? 0,
          (index) {
            return Column(
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
                        imgWidth: 40,
                        imgHeight: 40,
                        imageUrl: detailProvider.reviewList?[index].image ?? "",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          detailProvider.reviewList?[index].fullName == ""
                              ? MyText(
                                  color: Theme.of(context).colorScheme.surface,
                                  text: detailProvider
                                          .reviewList?[index].userName
                                          .toString() ??
                                      "",
                                  fontsizeNormal: Dimens.textTitle,
                                  fontsizeWeb: Dimens.textTitle,
                                  fontwaight: FontWeight.w700,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal)
                              : MyText(
                                  color: Theme.of(context).colorScheme.surface,
                                  text: detailProvider
                                          .reviewList?[index].fullName
                                          .toString() ??
                                      "",
                                  fontsizeNormal: Dimens.textTitle,
                                  fontsizeWeb: Dimens.textTitle,
                                  fontwaight: FontWeight.w700,
                                  maxline: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyRating(
                                size: 18,
                                rating: double.parse((detailProvider
                                        .reviewList?[index].rating
                                        .toString() ??
                                    "")),
                                spacing: 3,
                              ),
                              const SizedBox(width: 5),
                              MyText(
                                  color: colorAccent,
                                  text:
                                      "${double.parse((detailProvider.reviewList?[index].rating.toString() ?? ""))}",
                                  fontsizeNormal: Dimens.textTitle,
                                  fontsizeWeb: Dimens.textTitle,
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
                  ],
                ),
                const SizedBox(height: 15),
                MyText(
                    color: gray,
                    text:
                        detailProvider.reviewList?[index].comment.toString() ??
                            "",
                    fontsizeNormal: Dimens.textSmall,
                    fontwaight: FontWeight.w400,
                    maxline: 5,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ],
            );
          },
        ),
      ),
    );
  }

/* Add Review BottomSheet */

  addReviewBottomSheet(BuildContext context, String courseId) async {
    return showDialog(
        context: context,
        barrierColor: transparentColor,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            backgroundColor: Theme.of(context).cardColor,
            child: Consumer<CourseDetailsProvider>(
                builder: (context, detailprovider, child) {
              return Container(
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
                            half:
                                const Icon(Icons.star_half, color: colorAccent),
                            empty: const Icon(Icons.star_border,
                                color: colorAccent),
                          ),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            addrating = rating;
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
                              padding:
                                  const EdgeInsets.fromLTRB(18, 10, 18, 10),
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
                              if (addrating == 0.0) {
                                Utils.showSnackbar(
                                    context, "fail", "pleaseenterrating", true);
                              } else if (commentController.text.toString() ==
                                  "") {
                                Utils.showSnackbar(context, "fail",
                                    "pleaseentercomment", true);
                              } else {
                                Utils().showProgress(context, "Review Adding");
                                await detailprovider.addReview("3", courseId,
                                    commentController.text, addrating);

                                if (detailprovider.successModel.status == 200) {
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  Utils.showSnackbar(
                                      context,
                                      "success",
                                      detailprovider.successModel.message ?? "",
                                      false);
                                  commentController.clear();
                                  addrating = 0;
                                  getReviewList(0);
                                  Utils().hideProgress(context);
                                } else {
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  Utils.showSnackbar(
                                      context,
                                      "fail",
                                      detailprovider.successModel.message ?? "",
                                      false);
                                  Utils().hideProgress(context);
                                }
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 1000),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              curve: Curves.bounceInOut,
                              padding:
                                  const EdgeInsets.fromLTRB(18, 10, 18, 10),
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
              );
            }),
          );
        });
  }

/* Shimmer */

  Widget commanShimmer() {
    if (MediaQuery.of(context).size.width > 800) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Parent Item Shimmer */
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: colorPrimary,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.60,
                    ),
                    height: 400,
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width > 1600
                          ? 100
                          : MediaQuery.of(context).size.width > 1200
                              ? 100
                              : 20,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DetailVideo Title Text
                          CustomWidget.roundrectborder(
                              height: 10,
                              width: MediaQuery.of(context).size.width),
                          const SizedBox(height: 15),
                          // Course Discription
                          CustomWidget.roundrectborder(
                              height: 5,
                              width: MediaQuery.of(context).size.width),
                          CustomWidget.roundrectborder(
                              height: 5,
                              width: MediaQuery.of(context).size.width),
                          const SizedBox(height: 15),
                          const CustomWidget.roundrectborder(
                              height: 8, width: 150),
                          const SizedBox(height: 15),

                          const CustomWidget.roundrectborder(
                              height: 5, width: 200),
                          const SizedBox(height: 20),

                          const CustomWidget.roundrectborder(
                              height: 8, width: 250),
                          const SizedBox(height: 15),
                          CustomWidget.roundrectborder(
                              height: 5,
                              width: MediaQuery.of(context).size.width),
                        ],
                      ),
                    ),
                  ),
                ),
                /* Child Item Shimmer */
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.60,
                  ),
                  padding: EdgeInsets.only(
                    top: 50,
                    bottom: 50,
                    left: MediaQuery.of(context).size.width > 1600
                        ? 100
                        : MediaQuery.of(context).size.width > 1200
                            ? 100
                            : 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        decoration: BoxDecoration(
                          color: colorPrimary.withOpacity(0.10),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CustomWidget.roundrectborder(
                              height: 10,
                              width: 200,
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomWidget.circular(
                                        height: 15,
                                        width: 15,
                                      ),
                                      SizedBox(width: 14),
                                      CustomWidget.roundrectborder(
                                        height: 5,
                                        width: 200,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        decoration: BoxDecoration(
                          color: colorPrimary.withOpacity(0.10),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CustomWidget.roundrectborder(
                              height: 10,
                              width: 200,
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomWidget.circular(
                                        height: 15,
                                        width: 15,
                                      ),
                                      SizedBox(width: 14),
                                      CustomWidget.roundrectborder(
                                        height: 5,
                                        width: 200,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        decoration: BoxDecoration(
                          color: colorPrimary.withOpacity(0.10),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CustomWidget.roundrectborder(
                              height: 10,
                              width: 200,
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomWidget.circular(
                                        height: 15,
                                        width: 15,
                                      ),
                                      SizedBox(width: 14),
                                      CustomWidget.roundrectborder(
                                        height: 5,
                                        width: 200,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            /* Right Item Shimmer */
            Positioned.fill(
              top: 100,
              left: 20,
              right: MediaQuery.of(context).size.width > 1600
                  ? 150
                  : MediaQuery.of(context).size.width > 1200
                      ? 100
                      : MediaQuery.of(context).size.width > 1000
                          ? 50
                          : 20,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width > 1600
                          ? MediaQuery.of(context).size.width * 0.20
                          : MediaQuery.of(context).size.width > 1200
                              ? MediaQuery.of(context).size.width * 0.22
                              : MediaQuery.of(context).size.width > 1000
                                  ? MediaQuery.of(context).size.width * 0.28
                                  : MediaQuery.of(context).size.width * 0.34),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).cardColor,
                  ),
                  height: 600,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.topCenter,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomWidget.roundcorner(height: 180),
                        const SizedBox(height: 15),
                        const CustomWidget.roundrectborder(
                          height: 5,
                          width: 120,
                        ),
                        const SizedBox(height: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomWidget.circular(
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(width: 15),
                                    CustomWidget.roundrectborder(
                                      height: 5,
                                      width: 100,
                                    ),
                                  ],
                                ),
                                CustomWidget.circular(
                                  height: 20,
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 0.8,
                              color: gray.withOpacity(0.20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomWidget.circular(
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(width: 15),
                                    CustomWidget.roundrectborder(
                                      height: 5,
                                      width: 100,
                                    ),
                                  ],
                                ),
                                CustomWidget.circular(
                                  height: 20,
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 0.8,
                              color: gray.withOpacity(0.20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomWidget.circular(
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(width: 15),
                                    CustomWidget.roundrectborder(
                                      height: 5,
                                      width: 100,
                                    ),
                                  ],
                                ),
                                CustomWidget.circular(
                                  height: 20,
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 0.8,
                              color: gray.withOpacity(0.20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomWidget.rectangular(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const CustomWidget.rectangular(
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomWidget.rectangular(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const CustomWidget.rectangular(
                              width: 40,
                              height: 40,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        CustomWidget.rectangular(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomWidget.roundcorner(
                width: MediaQuery.of(context).size.width,
                height: 200,
              ),
            ),
            const SizedBox(height: 15),
            CustomWidget.roundrectborder(
              height: 10,
              width: MediaQuery.of(context).size.width,
            ),
            const CustomWidget.roundrectborder(
              height: 10,
              width: 200,
            ),
            const SizedBox(height: 10),

            const CustomWidget.roundrectborder(
              height: 10,
              width: 150,
            ),
            const SizedBox(height: 10),

            const CustomWidget.roundrectborder(
              height: 10,
              width: 100,
            ),
            const SizedBox(height: 10),
            // Course Discription
            CustomWidget.roundrectborder(
              height: 5,
              width: MediaQuery.of(context).size.width,
            ),
            CustomWidget.roundrectborder(
              height: 5,
              width: MediaQuery.of(context).size.width,
            ),
            CustomWidget.roundrectborder(
              height: 5,
              width: MediaQuery.of(context).size.width,
            ),
            CustomWidget.roundrectborder(
              height: 5,
              width: MediaQuery.of(context).size.width,
            ),
            CustomWidget.roundrectborder(
              height: 5,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 10),
            const CustomWidget.roundrectborder(
              height: 10,
              width: 200,
            ),
            const SizedBox(height: 10),
            const CustomWidget.roundrectborder(
              height: 10,
              width: 200,
            ),
            const SizedBox(height: 10),
            const CustomWidget.roundrectborder(
              height: 10,
              width: 200,
            ),
            const SizedBox(height: 10),
            const CustomWidget.roundrectborder(
              height: 10,
              width: 200,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.10),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomWidget.roundrectborder(
                    height: 10,
                    width: 200,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomWidget.circular(
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(width: 14),
                            CustomWidget.roundrectborder(
                              height: 5,
                              width: 200,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

/* Generate Certificate Button With Api Calling */

  Widget generateCertificate() {
    if ((detailProvider.courseDetailsModel.result?[0].isDownloadCertificate ??
                0) ==
            1 &&
        Constant.userID != null) {
      return InkWell(
        onTap: () async {
          Utils().showProgress(context, "Generate Certificate...");
          await detailProvider.fetchCertificate(widget.courseId);

          if (!detailProvider.certificateDownloading) {
            if (detailProvider.certificateModel.status == 200 &&
                detailProvider.certificateModel.result != null) {
              if (!mounted) return;
              Utils().hideProgress(context);
              _redirectToUrl(
                  detailProvider.certificateModel.result?.pdfUrl ?? "");
            } else {
              if (!mounted) return;
              Utils().hideProgress(context);
              Utils.showSnackbar(context, "fail", "somethingwentwronge", true);
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorPrimary,
            borderRadius: BorderRadius.circular(0),
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
