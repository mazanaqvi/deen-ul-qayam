import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yourappname/model/introscreenmodel.dart';
import 'package:yourappname/pages/bottombar.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';

class Intro extends StatefulWidget {
  final List<Result>? introList;
  const Intro({super.key, required this.introList});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  SharedPre sharedPre = SharedPre();
  PageController pageController = PageController();
  final currentPageNotifier = ValueNotifier<int>(0);
  int position = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: colorPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              PageView.builder(
                itemCount: widget.introList?.length ?? 0,
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: MyNetworkImage(
                            imageUrl:
                                widget.introList?[index].image.toString() ?? "",
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: MyText(
                              color: Theme.of(context).colorScheme.surface,
                              text: widget.introList?[index].title.toString() ??
                                  "",
                              textalign: TextAlign.center,
                              fontsizeNormal: Dimens.textBig,
                              multilanguage: false,
                              maxline: 5,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  );
                },
                onPageChanged: (index) {
                  position = index;
                  currentPageNotifier.value = index;
                  setState(() {});
                },
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SmoothPageIndicator(
                        controller: pageController,
                        count: widget.introList?.length ?? 0,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 6,
                          dotHeight: 6,
                          dotColor: colorPrimaryDark,
                          expansionFactor: 4,
                          offset: 1,
                          activeDotColor: colorAccent,
                          radius: 100,
                          strokeWidth: 1,
                          spacing: 8,
                        ),
                      ),
                      const SizedBox(height: 35),
                      // InkWell(
                      //   focusColor: transparentColor,
                      //   hoverColor: transparentColor,
                      //   highlightColor: transparentColor,
                      //   splashColor: transparentColor,
                      //   onTap: () async {
                      //     await sharedPre.save("seen", "1");
                      //     if (!context.mounted) return;
                      //     Navigator.of(context).pushReplacement(
                      //       PageRouteBuilder(
                      //         transitionDuration:
                      //             const Duration(milliseconds: 1000),
                      //         pageBuilder: (BuildContext context,
                      //             Animation<double> animation,
                      //             Animation<double> secondaryAnimation) {
                      //           return const Bottombar();
                      //         },
                      //         transitionsBuilder: (BuildContext context,
                      //             Animation<double> animation,
                      //             Animation<double> secondaryAnimation,
                      //             Widget child) {
                      //           return Align(
                      //             child: FadeTransition(
                      //               opacity: animation,
                      //               child: child,
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 45,
                      //     alignment: Alignment.center,
                      //     decoration: BoxDecoration(
                      //       color: gray,
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //     child: MyText(
                      //         // color: Theme.of(context).colorScheme.surface,
                      //         color: black,
                      //         text: "skip",
                      //         textalign: TextAlign.center,
                      //         maxline: 1,
                      //         fontsizeNormal: Dimens.textTitle,
                      //         multilanguage: true,
                      //         fontwaight: FontWeight.w600,
                      //         overflow: TextOverflow.ellipsis,
                      //         fontstyle: FontStyle.normal),
                      //   ),
                      // ),
                      // const SizedBox(height: 20),

                      InkWell(
                        focusColor: transparentColor,
                        hoverColor: transparentColor,
                        highlightColor: transparentColor,
                        splashColor: transparentColor,
                        onTap: () async {
                          if (position ==
                              ((widget.introList?.length ?? 0) - 1)) {
                            await sharedPre.save("seen", "1");
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 1000),
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return const Bottombar();
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
                          }
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: MyText(
                              color: white,
                              text: position ==
                                      ((widget.introList?.length ?? 0) - 1)
                                  ? "finish"
                                  : "next",
                              textalign: TextAlign.center,
                              fontsizeNormal: Dimens.textTitle,
                              multilanguage: true,
                              maxline: 1,
                              fontwaight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
