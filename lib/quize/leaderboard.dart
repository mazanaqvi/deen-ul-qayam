import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/provider/quizeprovider.dart';
import 'package:yourappname/quize/quize.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatefulWidget {
  final int? chapterId, courseId;
  final int? percentage;
  const LeaderBoard({
    super.key,
    required this.chapterId,
    required this.courseId,
    required this.percentage,
  });

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  late QuizeProvider quizeProvider;
  late CourseDetailsProvider courseDetailsProvider;

  @override
  void initState() {
    quizeProvider = Provider.of<QuizeProvider>(context, listen: false);
    courseDetailsProvider =
        Provider.of<CourseDetailsProvider>(context, listen: false);
    super.initState();
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
      appBar: kIsWeb
          ? Utils.webMainAppbar()
          : PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: AppBar(
                elevation: 0,
                centerTitle: false,
                // backgroundColor: white,
                title: MyText(
                  multilanguage: false,
                  text: "Leaderboard",
                  fontsizeWeb: Dimens.textMedium,
                  fontsizeNormal: Dimens.textMedium,
                  fontwaight: FontWeight.w500,
                  color: black,
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
      body: kIsWeb
          ? Utils.hoverItemWithPage(
              myWidget: Align(
                alignment: Alignment.center,
                child: resultItem(),
              ),
            )
          : Align(
              alignment: Alignment.center,
              child: resultItem(),
            ),
    );
  }

  Widget resultItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        kIsWeb ? Utils.childPanel(context) : const SizedBox.shrink(),
        // kIsWeb
        // ?
        MyImage(
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          imagePath:
              ((widget.percentage ?? 0) > 50) ? "ic_pass.png" : "ic_fail.png",
        ),
        // : const SizedBox.shrink(),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          alignment: Alignment.center,
          height: 200,
          width: kIsWeb
              ? MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * 0.50
                  : MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: gray.withOpacity(0.8))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                multilanguage: true,
                text: "yourscore",
                color: Theme.of(context).colorScheme.surface,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
                textalign: TextAlign.center,
                fontwaight: FontWeight.w400,
                fontsizeNormal: Dimens.textMedium,
                fontsizeWeb: Dimens.textMedium,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    multilanguage: false,
                    text: widget.percentage?.toString() ?? "",
                    textalign: TextAlign.center,
                    color: colorPrimary,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                    fontwaight: FontWeight.w500,
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                  ),
                  const SizedBox(width: 5),
                  MyText(
                    multilanguage: true,
                    text: "outof",
                    color: colorPrimary,
                    overflow: TextOverflow.ellipsis,
                    maxline: 1,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    fontwaight: FontWeight.w500,
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                  ),
                  const SizedBox(width: 5),
                  MyText(
                    multilanguage: false,
                    text: "100",
                    overflow: TextOverflow.ellipsis,
                    color: colorPrimary,
                    textalign: TextAlign.center,
                    maxline: 1,
                    fontstyle: FontStyle.normal,
                    fontwaight: FontWeight.w500,
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ((widget.percentage ?? 0) > 50)
                  ? MyText(
                      multilanguage: true,
                      text: "exampassingmessage",
                      color: green,
                      maxline: 2,
                      textalign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                      fontwaight: FontWeight.w700,
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                    )
                  : MyText(
                      multilanguage: true,
                      text: "examfailmessage",
                      color: red,
                      maxline: 2,
                      textalign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                      fontwaight: FontWeight.w700,
                      fontsizeNormal: Dimens.textTitle,
                      fontsizeWeb: Dimens.textTitle,
                    ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        InkWell(
          onTap: () async {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Quize(
                  courseId: widget.courseId ?? 0,
                  chapterId: widget.chapterId,
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
            await quizeProvider.clearProvider();
          },
          child: Container(
            height: 45,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: kIsWeb
                ? MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * 0.50
                    : MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: colorPrimary,
            ),
            child: MyText(
              multilanguage: true,
              text: "tryagain",
              color: white,
              fontwaight: FontWeight.w500,
              fontsizeNormal: Dimens.textMedium,
              fontsizeWeb: Dimens.textMedium,
            ),
          ),
        ),
      ],
    );
  }
}
