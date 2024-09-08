import 'package:yourappname/provider/exploreprovider.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webviewall.dart';
import 'package:yourappname/webwidget/interactive_icon.dart';
import 'package:yourappname/webwidget/interactive_networkicon.dart';
import 'package:yourappname/webwidget/interactive_text.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../web_js/js_helper.dart';

class FooterWeb extends StatefulWidget {
  const FooterWeb({super.key});

  @override
  State<FooterWeb> createState() => _FooterWebState();
}

class _FooterWebState extends State<FooterWeb> {
  final JSHelper _jsHelper = JSHelper();
  SharedPre sharedPref = SharedPre();
  late ProfileProvider profileProvider;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    super.initState();
    getApi();
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

  getApi() async {
    final generaProvider = Provider.of<GeneralProvider>(context, listen: false);
    final exploreProvider =
        Provider.of<ExploreProvider>(context, listen: false);
    await generaProvider.getGeneralsetting(context);
    await exploreProvider.getCategory(0);
    await profileProvider.getPages();
    await profileProvider.getSocialLink();
    if (Constant.userID != null) {
      if (!mounted) return;
      await profileProvider.getprofile(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          (MediaQuery.of(context).size.width > 800) ? 100 : 20,
          50,
          (MediaQuery.of(context).size.width > 800) ? 100 : 20,
          50),
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle, color: colorPrimaryDark),
      child: (MediaQuery.of(context).size.width < 1250)
          ? _buildColumnFooter()
          : _buildRowFooter(),
    );
  }

  Widget _buildRowFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* App Icon & Desc. */
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyImage(
                width: Dimens.appiconFooterWidth,
                height: Dimens.appiconFooterheight,
                fit: BoxFit.fill,
                imagePath: "appicon_transparent.png",
              ),
              const SizedBox(height: 30),
              Consumer<GeneralProvider>(
                builder: (context, generalProvider, child) {
                  return MyText(
                    color: white,
                    multilanguage: false,
                    text: generalProvider.appDescription ?? "",
                    fontwaight: FontWeight.w500,
                    fontsizeWeb: Dimens.textSmall,
                    fontsizeNormal: Dimens.textSmall,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                    maxline: 10,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),

        /* Quick Links */
        Expanded(
          child: _buildPages(),
        ),
        const SizedBox(width: 30),

        /* Category */
        Expanded(
          child: _buildCategory(),
        ),
        const SizedBox(width: 30),

        /* Contact With us & Available On */
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Social Icons */
              _buildSocialLink(),
              const SizedBox(height: 20),

              /* Available On */
              Row(
                children: [
                  MyText(
                    color: white,
                    multilanguage: false,
                    text: Constant.appName,
                    fontwaight: FontWeight.w600,
                    fontsizeWeb: Dimens.textSmall,
                    fontsizeNormal: Dimens.textSmall,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 5),
                  MyText(
                    color: white,
                    multilanguage: true,
                    text: "avalableon",
                    fontwaight: FontWeight.w600,
                    fontsizeWeb: Dimens.textSmall,
                    fontsizeNormal: Dimens.textSmall,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              /* Store Icons */
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      _redirectToUrl(Constant.androidAppUrl);
                    },
                    borderRadius: BorderRadius.circular(3),
                    child: InteractiveIcon(
                      imagePath: "playstore.png",
                      height: 25,
                      width: 25,
                      withBG: true,
                      bgRadius: 3,
                      bgColor: transparentColor,
                      bgHoverColor: colorPrimary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      _redirectToUrl(Constant.iosAppUrl);
                    },
                    borderRadius: BorderRadius.circular(3),
                    child: InteractiveIcon(
                      height: 25,
                      width: 25,
                      imagePath: "applestore.png",
                      iconColor: white,
                      withBG: true,
                      bgRadius: 3,
                      bgColor: transparentColor,
                      bgHoverColor: colorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnFooter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* App Icon & Desc. */
        MyImage(
          width: Dimens.appiconFooterWidth,
          height: Dimens.appiconFooterheight,
          fit: BoxFit.fill,
          imagePath: "appicon_transparent.png",
        ),
        const SizedBox(height: 30),
        Consumer<GeneralProvider>(
          builder: (context, generalProvider, child) {
            return MyText(
              color: gray,
              multilanguage: false,
              text: generalProvider.appDescription ?? "",
              fontwaight: FontWeight.w500,
              fontsizeWeb: Dimens.textSmall,
              fontsizeNormal: Dimens.textSmall,
              textalign: TextAlign.start,
              fontstyle: FontStyle.normal,
              maxline: 5,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        const SizedBox(height: 40),

        /* Quick Links */
        _buildPages(),
        const SizedBox(height: 30),

        /* Quick Links */
        _buildCategory(),
        const SizedBox(height: 30),

        /* Contact With us & Store Icons */
        /* Social Icons */
        _buildSocialLink(),
        const SizedBox(height: 20),

        /* Available On */
        Row(
          children: [
            MyText(
              color: white,
              multilanguage: false,
              text: Constant.appName,
              fontwaight: FontWeight.w600,
              fontsizeWeb: Dimens.textMedium,
              fontsizeNormal: Dimens.textMedium,
              textalign: TextAlign.start,
              fontstyle: FontStyle.normal,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 5),
            MyText(
              color: white,
              multilanguage: true,
              text: "avalableon",
              fontwaight: FontWeight.w600,
              fontsizeWeb: Dimens.textMedium,
              fontsizeNormal: Dimens.textMedium,
              textalign: TextAlign.start,
              fontstyle: FontStyle.normal,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 8),

        /* Store Icons */
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _redirectToUrl(Constant.androidAppUrl);
              },
              borderRadius: BorderRadius.circular(3),
              child: InteractiveIcon(
                imagePath: "playstore.png",
                height: 25,
                width: 25,
                withBG: true,
                bgRadius: 3,
                bgColor: transparentColor,
                bgHoverColor: colorPrimary,
              ),
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                _redirectToUrl(Constant.iosAppUrl);
              },
              borderRadius: BorderRadius.circular(3),
              child: InteractiveIcon(
                height: 25,
                width: 25,
                imagePath: "applestore.png",
                iconColor: white,
                withBG: true,
                bgRadius: 3,
                bgColor: transparentColor,
                bgHoverColor: colorPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Consumer<ExploreProvider>(
        builder: (context, exploreprovider, child) {
      if (exploreprovider.loading) {
        return const SizedBox.shrink();
      } else {
        if (exploreprovider.categoryModel.status == 200 &&
            exploreprovider.categoryModel.result != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: 2,
                      decoration: Utils.setBackground(colorPrimary, 1),
                    ),
                    const SizedBox(width: 20),
                    MyText(
                      color: colorAccent,
                      multilanguage: true,
                      text: "footercategorytitle",
                      fontwaight: FontWeight.w600,
                      fontsizeWeb: Dimens.textBig,
                      fontsizeNormal: Dimens.textBig,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.start,
                      fontstyle: FontStyle.normal,
                    ),
                  ],
                ),
              ),
              AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                itemCount:
                    (exploreprovider.categoryModel.result?.length ?? 0) > 5
                        ? 5
                        : exploreprovider.categoryModel.result?.length ?? 0,
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int position) {
                  return buildCategoryItem(
                    pageName:
                        exploreprovider.categoryModel.result?[position].name ??
                            "",
                    onClick: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return WebViewAll(
                              screenLayout: "",
                              title: exploreprovider
                                      .categoryModel.result?[position].name
                                      .toString() ??
                                  "",
                              contentId: exploreprovider
                                      .categoryModel.result?[position].id
                                      .toString() ??
                                  "",
                              viewAllType: "category",
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
                  );
                },
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget buildCategoryItem({
    required String pageName,
    required Function() onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Row(
        children: [
          MyText(
            color: white,
            text: "-",
            fontsizeWeb: Dimens.textTitle,
            fontsizeNormal: Dimens.textTitle,
            fontwaight: FontWeight.w500,
            textalign: TextAlign.justify,
            fontstyle: FontStyle.normal,
            multilanguage: false,
          ),
          const SizedBox(width: 8),
          InteractiveText(
            text: pageName,
            multilanguage: false,
            maxline: 2,
            textalign: TextAlign.justify,
            fontstyle: FontStyle.normal,
            fontsizeWeb: Dimens.textTitle,
            fontweight: FontWeight.w500,
            activeColor: colorAccent,
            inctiveColor: white,
          ),
        ],
      ),
    );
  }

  Widget _buildPages() {
    return Consumer<ProfileProvider>(
        builder: (context, profileprovider, child) {
      if (profileprovider.loading) {
        return const SizedBox.shrink();
      } else {
        if (profileprovider.getpagemodel.status == 200 &&
            profileprovider.getpagemodel.result != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: 2,
                      decoration: Utils.setBackground(colorPrimary, 1),
                    ),
                    const SizedBox(width: 20),
                    MyText(
                      color: colorAccent,
                      multilanguage: true,
                      text: "quicklink",
                      fontsizeWeb: Dimens.textBig,
                      fontsizeNormal: Dimens.textBig,
                      fontwaight: FontWeight.w600,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.start,
                      fontstyle: FontStyle.normal,
                    ),
                  ],
                ),
              ),
              AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                itemCount: (profileprovider.getpagemodel.result?.length ?? 0),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int position) {
                  return _buildPageItem(
                    pageName:
                        profileprovider.getpagemodel.result?[position].title ??
                            "",
                    onClick: () {
                      _redirectToUrl(
                          profileprovider.getpagemodel.result?[position].url ??
                              "");
                    },
                  );
                },
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget _buildPageItem({
    required String pageName,
    required Function() onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Row(
        children: [
          MyText(
            color: white,
            text: "-",
            fontsizeWeb: Dimens.textTitle,
            fontsizeNormal: Dimens.textTitle,
            fontwaight: FontWeight.w500,
            textalign: TextAlign.justify,
            fontstyle: FontStyle.normal,
            multilanguage: false,
          ),
          const SizedBox(width: 8),
          InteractiveText(
            text: pageName,
            multilanguage: false,
            maxline: 2,
            textalign: TextAlign.justify,
            fontstyle: FontStyle.normal,
            fontsizeWeb: Dimens.textTitle,
            fontweight: FontWeight.w500,
            activeColor: colorAccent,
            inctiveColor: white,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLink() {
    return Consumer<ProfileProvider>(
        builder: (context, profileprovider, child) {
      if (profileprovider.loading) {
        return const SizedBox.shrink();
      } else {
        if (profileprovider.socialLinkModel.status == 200 &&
            profileprovider.socialLinkModel.result != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MyText(
                color: colorAccent,
                multilanguage: true,
                text: "connectwithus",
                fontwaight: FontWeight.w600,
                fontsizeWeb: Dimens.textBig,
                fontsizeNormal: Dimens.textBig,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount:
                    (profileProvider.socialLinkModel.result?.length ?? 0),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int position) {
                  return Wrap(
                    children: [
                      buildSocialIcon(
                        iconUrl: profileProvider
                                .socialLinkModel.result?[position].image ??
                            "",
                        onClick: () {
                          _redirectToUrl(profileProvider
                                  .socialLinkModel.result?[position].url ??
                              "");
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget buildSocialIcon({
    required String iconUrl,
    required Function() onClick,
  }) {
    return SizedBox(
      height: Dimens.heightSocialBtn,
      width: Dimens.widthSocialBtn,
      child: InkWell(
        borderRadius: BorderRadius.circular(3.0),
        onTap: onClick,
        child: InteractiveNetworkIcon(
          height: 30,
          width: 30,
          iconFit: BoxFit.contain,
          imagePath: iconUrl,
          withBG: true,
          bgRadius: 3.0,
          bgColor: colorPrimary,
          bgHoverColor: colorPrimary,
        ),
      ),
    );
  }
}
