import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/provider/quizeprovider.dart';
import 'package:yourappname/quize/leaderboard.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Quize extends StatefulWidget {
  final int? courseId, chapterId;

  const Quize({
    super.key,
    required this.courseId,
    required this.chapterId,
  });

  @override
  State<Quize> createState() => _QuizeState();
}

class _QuizeState extends State<Quize> {
  SharedPre sharePref = SharedPre();
  late QuizeProvider quizeProvider;
  late CourseDetailsProvider courseDetailsProvider;
  final PageController _pageController = PageController(initialPage: 0);
  int pageIndex = 0;

  @override
  void initState() {
    quizeProvider = Provider.of<QuizeProvider>(context, listen: false);
    courseDetailsProvider =
        Provider.of<CourseDetailsProvider>(context, listen: false);
    super.initState();
    getQuestionList();
  }

  getQuestionList() async {
    await quizeProvider.getQuestionByChapter(widget.courseId, widget.chapterId);
  }

  getDetailPage() async {
    await courseDetailsProvider.getCourseDetails(widget.courseId);
  }

  @override
  void dispose() {
    getDetailPage();
    quizeProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: white,
      appBar: kIsWeb
          ? Utils.webMainAppbar()
          : PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: AppBar(
                elevation: 0,
                centerTitle: false,
                // backgroundColor: white,
                title: MyText(
                  multilanguage: true,
                  text: "quizelession",
                  fontsizeWeb: Dimens.textMedium,
                  fontsizeNormal: Dimens.textMedium,
                  fontwaight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.surface,
                ),
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.center,
                      child: MyImage(
                        width: 15,
                        height: 15,
                        imagePath: "ic_back.png",
                        color: gray,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      body: Consumer<QuizeProvider>(builder: (context, quizeprovider, child) {
        if (quizeProvider.loading) {
          return Utils.pageLoader();
        } else {
          if (quizeprovider.getQuestionByChapterModel.status == 200 &&
              quizeprovider.getQuestionByChapterModel.result != null) {
            if ((quizeprovider.getQuestionByChapterModel.result?.length ?? 0) >
                0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kIsWeb
                      ? Expanded(
                          child: Utils.hoverItemWithPage(
                            myWidget: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Utils.childPanel(context),
                                  Utils.pageTitleLayout(
                                      context, "quizelession", true),
                                  questionAndOption(),
                                  nextPage(),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            questionAndOption(),
                            nextPage(),
                          ],
                        ),
                ],
              );
            } else {
              return const NoData();
            }
          } else {
            return const NoData();
          }
        }
      }),
    );
  }

  Widget questionAndOption() {
    return SizedBox(
      width: kIsWeb ? 500 : null,
      height: 600,
      child: PageView.builder(
          controller: _pageController,
          itemCount:
              quizeProvider.getQuestionByChapterModel.result?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {},
          scrollDirection: Axis.horizontal,
          allowImplicitScrolling: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: gray.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    multilanguage: false,
                    fontstyle: FontStyle.normal,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    text:
                        "${index + 1} of ${quizeProvider.getQuestionByChapterModel.result?.length ?? 0} Questions",
                    color: Theme.of(context).colorScheme.surface,
                    fontwaight: FontWeight.w400,
                    fontsizeNormal: Dimens.textSmall,
                    fontsizeWeb: Dimens.textSmall,
                  ),
                  const SizedBox(height: 8),
                  /* Question */
                  AutoSizeText(
                    "Q ${index + 1}. ${quizeProvider.getQuestionByChapterModel.result?[index].question.toString() ?? ""}?",
                    style: GoogleFonts.inter(
                        fontSize: Dimens.textTitle,
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w700),
                    minFontSize: Dimens.textSmall,
                    textAlign: TextAlign.left,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 40),
                  /* Option A */
                  InkWell(
                    focusColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    hoverColor: transparentColor,
                    onTap: () async {
                      if (quizeProvider.isSelectAns == false) {
                        await quizeProvider.checkAnswer(
                          type: "1",
                          option: quizeProvider.getQuestionByChapterModel
                                  .result?[index].optionA
                                  .toString() ??
                              "",
                          rightAns: quizeProvider.getQuestionByChapterModel
                                  .result?[index].answer
                                  .toString() ??
                              "",
                          isSelect: true,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                        color: (quizeProvider.optionType == "1" &&
                                quizeProvider.isSelectAns == true)
                            ? quizeProvider.rightAnswer == true
                                ? green
                                : red
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            quizeProvider.getQuestionByChapterModel
                                    .result?[index].optionA
                                    .toString() ??
                                "",
                            style: GoogleFonts.inter(
                                fontSize: Dimens.textDesc,
                                color: (quizeProvider.optionType == "1" &&
                                        quizeProvider.isSelectAns == true)
                                    ? white
                                    : Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w400),
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          (quizeProvider.optionType == "1" &&
                                  quizeProvider.isSelectAns == true)
                              ? quizeProvider.rightAnswer == true
                                  ? const Icon(Icons.check,
                                      size: 22, color: white)
                                  : const Icon(Icons.close,
                                      size: 22, color: white)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  /* Option B */
                  InkWell(
                    focusColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    hoverColor: transparentColor,
                    onTap: () async {
                      if (quizeProvider.isSelectAns == false) {
                        await quizeProvider.checkAnswer(
                          type: "2",
                          option: quizeProvider.getQuestionByChapterModel
                                  .result?[index].optionB
                                  .toString() ??
                              "",
                          rightAns: quizeProvider.getQuestionByChapterModel
                                  .result?[index].answer
                                  .toString() ??
                              "",
                          isSelect: true,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                        color: (quizeProvider.optionType == "2" &&
                                quizeProvider.isSelectAns == true)
                            ? quizeProvider.rightAnswer == true
                                ? green
                                : red
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            quizeProvider.getQuestionByChapterModel
                                    .result?[index].optionB
                                    .toString() ??
                                "",
                            style: GoogleFonts.inter(
                                fontSize: Dimens.textDesc,
                                color: (quizeProvider.optionType == "2" &&
                                        quizeProvider.isSelectAns == true)
                                    ? white
                                    : Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w400),
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          (quizeProvider.optionType == "2" &&
                                  quizeProvider.isSelectAns == true)
                              ? quizeProvider.rightAnswer == true
                                  ? const Icon(Icons.check,
                                      size: 22, color: white)
                                  : const Icon(Icons.close,
                                      size: 22, color: white)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  /* Option C */
                  InkWell(
                    focusColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    hoverColor: transparentColor,
                    onTap: () async {
                      if (quizeProvider.isSelectAns == false) {
                        await quizeProvider.checkAnswer(
                          type: "3",
                          option: quizeProvider.getQuestionByChapterModel
                                  .result?[index].optionC
                                  .toString() ??
                              "",
                          rightAns: quizeProvider.getQuestionByChapterModel
                                  .result?[index].answer
                                  .toString() ??
                              "",
                          isSelect: true,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                        color: (quizeProvider.optionType == "3" &&
                                quizeProvider.isSelectAns == true)
                            ? quizeProvider.rightAnswer == true
                                ? green
                                : red
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            quizeProvider.getQuestionByChapterModel
                                    .result?[index].optionC
                                    .toString() ??
                                "",
                            style: GoogleFonts.inter(
                                fontSize: Dimens.textDesc,
                                color: (quizeProvider.optionType == "3" &&
                                        quizeProvider.isSelectAns == true)
                                    ? white
                                    : Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w400),
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          (quizeProvider.optionType == "3" &&
                                  quizeProvider.isSelectAns == true)
                              ? quizeProvider.rightAnswer == true
                                  ? const Icon(Icons.check,
                                      size: 22, color: white)
                                  : const Icon(Icons.close,
                                      size: 22, color: white)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  /* Option D */
                  InkWell(
                    focusColor: transparentColor,
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    hoverColor: transparentColor,
                    onTap: () async {
                      if (quizeProvider.isSelectAns == false) {
                        await quizeProvider.checkAnswer(
                          type: "4",
                          option: quizeProvider.getQuestionByChapterModel
                                  .result?[index].optionD
                                  .toString() ??
                              "",
                          rightAns: quizeProvider.getQuestionByChapterModel
                                  .result?[index].answer
                                  .toString() ??
                              "",
                          isSelect: true,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                        color: (quizeProvider.optionType == "4" &&
                                quizeProvider.isSelectAns == true)
                            ? quizeProvider.rightAnswer == true
                                ? green
                                : red
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            quizeProvider.getQuestionByChapterModel
                                    .result?[index].optionD
                                    .toString() ??
                                "",
                            style: GoogleFonts.inter(
                                fontSize: Dimens.textDesc,
                                color: (quizeProvider.optionType == "4" &&
                                        quizeProvider.isSelectAns == true)
                                    ? white
                                    : Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w400),
                            minFontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          (quizeProvider.optionType == "4" &&
                                  quizeProvider.isSelectAns == true)
                              ? quizeProvider.rightAnswer == true
                                  ? const Icon(Icons.check,
                                      size: 22, color: white)
                                  : const Icon(Icons.close,
                                      size: 22, color: white)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget nextPage() {
    return Container(
      width: kIsWeb ? MediaQuery.of(context).size.width : null,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      color: gray.withOpacity(0.15),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () async {
          if (quizeProvider.isSelectAns == true) {
            /* Pass This Atteded Question Count */
            await quizeProvider.totalAttendedQuestion();
          }
          if (quizeProvider.pageIndex !=
              (quizeProvider.getQuestionByChapterModel.result?.length ?? 0) -
                  1) {
            quizeProvider.clearOnlySelectedAnswer();

            await quizeProvider
                .setCurrentBanner(((quizeProvider.pageIndex) + 1));
            /* Attended  Question */

            _pageController.nextPage(
              duration: const Duration(milliseconds: 800),
              curve: Curves.linear,
            );
          } else {
            /* Open Scoore Page */
            await quizeProvider.getSavePraticeQuestionReport(
              courseId: widget.courseId.toString(),
              chapterId: widget.chapterId.toString(),
              totalQuestion:
                  (quizeProvider.getQuestionByChapterModel.result?.length ?? 0)
                      .toString(),
              questionsAttended: quizeProvider.attendedQuestion.toString(),
              correctAnswers: quizeProvider.rightAnsCount,
            );

            if (quizeProvider.saveQuestionReportModel.status == 200) {
              try {
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return LeaderBoard(
                        courseId: widget.courseId,
                        chapterId: widget.chapterId,
                        percentage: quizeProvider.saveQuestionReportModel
                                .result?[0].percentage ??
                            0,
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
              } catch (e) {
                printLog("catch");
                printLog(e.toString());
              }
            } else {
              if (!mounted) return;
              Utils().hideProgress(context);
              Utils.showSnackbar(context, "fail",
                  quizeProvider.saveQuestionReportModel.message ?? "", false);
            }
          }
        },
        child: Container(
          height: 50,
          width: kIsWeb && MediaQuery.of(context).size.width > 800
              ? 500
              : MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: colorPrimary,
          ),
          child: MyText(
            multilanguage: true,
            text: (quizeProvider.pageIndex !=
                    (quizeProvider.getQuestionByChapterModel.result?.length ??
                            0) -
                        1)
                ? "next"
                : "gotoleaderboard",
            color: white,
            fontwaight: FontWeight.w700,
            fontsizeNormal: Dimens.textTitle,
            fontsizeWeb: Dimens.textTitle,
          ),
        ),
      ),
    );
  }
}
