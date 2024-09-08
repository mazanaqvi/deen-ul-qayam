import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yourappname/pages/mydownloads.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:yourappname/pages/getpages.dart';
import 'package:yourappname/pages/login.dart';
import 'package:yourappname/pages/notificationpage.dart';
import 'package:yourappname/pages/wishlist.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/provider/themeprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webwidget/forgotpassword.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({
    Key? key,
  }) : super(key: key);

  @override
  State<Account> createState() => AccountState();
}

class AccountState extends State<Account> {
  SharedPre sharedpre = SharedPre();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ProfileProvider profileProvider;
  final ImagePicker picker = ImagePicker();
  bool? isSwitched;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  String mobilenumber = "", countrycode = "", countryname = "";

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    super.initState();
    getApi();
  }

  getApi() async {
    await profileProvider.getprofile(context);
    await profileProvider.getPages();
    await profileProvider.getSocialLink();
  }

  toggleSwitch(bool value) async {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
    } else {
      setState(() {
        isSwitched = false;
      });
    }
    if (!kIsWeb) {
      if ((isSwitched ?? false)) {
        OneSignal.User.pushSubscription.optIn();
      } else {
        OneSignal.User.pushSubscription.optOut();
      }
      await sharedpre.saveBool("PUSH", isSwitched);
    }
  }

  @override
  void dispose() {
    profileProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        surfaceTintColor: transparentColor,
        // backgroundColor: white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: white,
        ),
        automaticallyImplyLeading: false,
        title: MyText(
            color: Theme.of(context).colorScheme.surface,
            text: "profile",
            fontsizeNormal: Dimens.textBig,
            maxline: 1,
            fontwaight: FontWeight.w700,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            multilanguage: true),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 5, bottom: 100),
        child: Consumer<ProfileProvider>(
            builder: (context, profileprovider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userInfoWithSubscription(),
              buildSettings(),
            ],
          );
        }),
      ),
    );
  }

  Widget userInfoWithSubscription() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* User Info */
          if (Constant.userID != null)
            if (profileProvider.loading)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1, color: colorPrimary),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: const CustomWidget.circular(
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget.roundrectborder(
                          width: 150,
                          height: 8,
                        ),
                        CustomWidget.roundrectborder(
                          width: 150,
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  const CustomWidget.circular(
                    width: 18,
                    height: 18,
                  ),
                ],
              )
            else if (profileProvider.profileModel.status == 200)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: MyNetworkImage(
                      imgWidth: 45,
                      imgHeight: 45,
                      fit: BoxFit.fill,
                      imageUrl: profileProvider.profileModel.result?[0].image
                              .toString() ??
                          "",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          color: Theme.of(context).colorScheme.surface,
                          text: profileProvider.profileModel.result?[0].fullName
                                      .toString() ==
                                  ""
                              ? "New User"
                              : profileProvider.profileModel.result?[0].fullName
                                      .toString() ??
                                  "",
                          maxline: 2,
                          fontwaight: FontWeight.w700,
                          fontsizeNormal: Dimens.textlargeBig,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal,
                          multilanguage: false,
                        ),
                        const SizedBox(height: 8),
                        MyText(
                          color: gray,
                          text: profileProvider.profileModel.result?[0].email
                                  .toString() ??
                              "",
                          maxline: 2,
                          fontwaight: FontWeight.w400,
                          fontsizeNormal: Dimens.textDesc,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal,
                          multilanguage: false,
                        ),
                      ],
                    ),
                  ),
                  Constant.userID == null
                      ? const SizedBox.shrink()
                      : InkWell(
                          splashColor: transparentColor,
                          focusColor: transparentColor,
                          hoverColor: transparentColor,
                          highlightColor: transparentColor,
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            nameController.text = profileProvider
                                    .profileModel.result?[0].fullName
                                    .toString() ??
                                "";
                            emailController.text = profileProvider
                                    .profileModel.result?[0].email
                                    .toString() ??
                                "";
                            numberController.text = profileProvider
                                    .profileModel.result?[0].mobileNumber
                                    .toString() ??
                                "";
                            editProfileBottomSheet();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: MyImage(
                              width: 18,
                              height: 18,
                              imagePath: "ic_edit.png",
                              color: colorPrimary,
                            ),
                          ),
                        ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1, color: colorPrimary),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: MyImage(
                        width: 45,
                        height: 45,
                        fit: BoxFit.fill,
                        imagePath: "ic_tutor.png",
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "Guest User",
                      maxline: 2,
                      fontwaight: FontWeight.w700,
                      fontsizeNormal: Dimens.textlargeBig,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                      multilanguage: false,
                    ),
                  ),
                ],
              )
          else
            InkWell(
              splashColor: transparentColor,
              focusColor: transparentColor,
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Login();
                    },
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 1, color: colorPrimary),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyImage(
                            width: 40,
                            height: 40,
                            imagePath: "ic_user.png",
                            color: colorPrimary,
                          ),
                          const SizedBox(width: 15),
                          MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: "login",
                            maxline: 1,
                            fontwaight: FontWeight.w500,
                            fontsizeNormal: Dimens.textTitle,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal,
                            multilanguage: true,
                          ),
                        ],
                      ),
                      MyImage(
                        width: 12,
                        height: 15,
                        imagePath: "ic_right.png",
                        color: gray,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          /* Subscription Page Open */
          InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              if (Constant.userID == null) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Login(),
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
                Utils.openSubscription(context);
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 18, 15, 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 0.8,
                  color: gray.withOpacity(0.45),
                ),
              ),
              child: Column(
                children: [
                  /* Package Discription */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyImage(
                        width: 25,
                        height: 25,
                        imagePath: "ic_premium.png",
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: MyText(
                          color: Theme.of(context).colorScheme.surface,
                          text: "subscribedisc",
                          maxline: 2,
                          fontwaight: FontWeight.w600,
                          fontsizeNormal: Dimens.textTitle,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal,
                          multilanguage: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: MyImage(
                          width: 12,
                          height: 15,
                          imagePath: "ic_right.png",
                          color: gray,
                        ),
                      ),
                    ],
                  ),
                  /* Active Package */
                  // Constant.isBuy == "1"
                  Constant.isBuy == "1" && Constant.userID != null
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                color: colorAccent,
                                text: "Active Plan",
                                maxline: 1,
                                fontwaight: FontWeight.w700,
                                fontsizeNormal: Dimens.textMedium,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal,
                                multilanguage: false,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                    decoration: BoxDecoration(
                                      color: colorAccent,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: MyText(
                                      color: black,
                                      text:
                                          "${profileProvider.profileModel.result?[0].packageName.toString() ?? ""}/${Constant.currencyCode}${profileProvider.profileModel.result?[0].packagePrice.toString() ?? ""}",
                                      maxline: 1,
                                      fontwaight: FontWeight.w500,
                                      fontsizeNormal: Dimens.textMedium,
                                      overflow: TextOverflow.ellipsis,
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal,
                                      multilanguage: false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettings() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* All Pages */
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  color: Theme.of(context).colorScheme.surface,
                  text: "setting",
                  fontsizeNormal: Dimens.textTitle,
                  maxline: 1,
                  fontwaight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
              const SizedBox(height: 10),
              /* Notification */
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: InkWell(
                  splashColor: transparentColor,
                  focusColor: transparentColor,
                  hoverColor: transparentColor,
                  highlightColor: transparentColor,
                  onTap: () {
                    AdHelper.showFullscreenAd(
                        context, Constant.interstialAdType, () {
                      if (Constant.userID == null) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Login(),
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
                      } else {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const NotificationPage(),
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
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorPrimary.withOpacity(0.75),
                              ),
                              child: MyImage(
                                width: 20,
                                height: 20,
                                imagePath: "ic_notification.png",
                                color: white,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    text: "notification",
                                    fontsizeNormal: Dimens.textTitle,
                                    maxline: 1,
                                    fontwaight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal,
                                    multilanguage: true),
                              ),
                            ),
                            Switch(
                              activeColor: colorPrimary,
                              activeTrackColor: gray,
                              inactiveTrackColor: gray,
                              value: isSwitched ?? true,
                              onChanged: toggleSwitch,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.8,
                        color: gray.withOpacity(0.45),
                      ),
                    ],
                  ),
                ),
              ),
              /* Dark Light Mode */
              Consumer<ThemeProvider>(builder: (context, themeprovider, child) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorPrimary.withOpacity(0.75),
                              ),
                              child: MyImage(
                                width: 20,
                                height: 20,
                                imagePath: "ic_darkmode.png",
                                color: white,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: MyText(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    text: "darkmode",
                                    fontsizeNormal: Dimens.textTitle,
                                    maxline: 1,
                                    fontwaight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    textalign: TextAlign.center,
                                    fontstyle: FontStyle.normal,
                                    multilanguage: true),
                              ),
                            ),
                            Switch(
                              activeColor: colorPrimary,
                              activeTrackColor: gray,
                              inactiveTrackColor: gray,
                              value: Constant.isDark,
                              onChanged: (value) async {
                                themeprovider.changeTheme(value);
                                await sharedpre.remove("isdark");
                                await sharedpre.saveBool("isdark", value);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.8,
                        color: gray.withOpacity(0.45),
                      ),
                    ],
                  ),
                );
              }),
              /* Wishlist */
              settingItem(
                  icon: "wishlist.png",
                  title: "wishlist",
                  onTap: () {
                    AdHelper.showFullscreenAd(
                        context, Constant.interstialAdType, () {
                      if (Constant.userID == null) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Login(),
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
                      } else {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const WishList(),
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
                    });
                  },
                  multilanguage: true),
              /* Download */
              settingItem(
                  icon: "ic_downloads.png",
                  title: "downloads",
                  onTap: () {
                    AdHelper.showFullscreenAd(
                        context, Constant.interstialAdType, () {
                      if (Constant.userID == null) {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Login(),
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
                      } else {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const MyDownloads(),
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
                    });
                  },
                  multilanguage: true),
              /* Get Pages */
              _buildPages(),
              /* Forgot Password  */
              /* Profile type == 4 Means Normal Login */
              Constant.userID != null &&
                      profileProvider.profileModel.result?[0].type == 4
                  ? settingItem(
                      icon: "ic_forgotpassword.png",
                      title: "forgotpasswordtitle",
                      onTap: () {
                        forgotPasswordDilog();
                      },
                      multilanguage: true,
                    )
                  : const SizedBox.shrink(),
              /* Change Language */
              settingItem(
                  icon: "ic_language.png",
                  title: "language",
                  onTap: () {
                    Utils.languageChangeDialogMobile(context);
                  },
                  multilanguage: true,
                  removeLine: Constant.userID != null ? false : true),
              /* Login Logout */
              Constant.userID != null
                  ? settingItem(
                      icon: "ic_logout.png",
                      title: "logout",
                      onTap: () {
                        logoutPopup();
                      },
                      multilanguage: true,
                      removeLine: true)
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 25),
          /* Social */
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  color: Theme.of(context).colorScheme.surface,
                  text: "social",
                  fontsizeNormal: Dimens.textTitle,
                  maxline: 1,
                  fontwaight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
              const SizedBox(height: 10),
              _buildSocialLink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget settingItem(
      {icon, title, onTap, removeLine, multilanguage, isNetworkImg}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: InkWell(
        hoverColor: transparentColor,
        focusColor: transparentColor,
        highlightColor: transparentColor,
        splashColor: transparentColor,
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPrimary.withOpacity(0.75),
                    ),
                    child: isNetworkImg == true
                        ? Consumer<ThemeProvider>(
                            builder: (context, themeprovider, child) {
                            return SizedBox(
                              height: 20,
                              width: 20,
                              child: CachedNetworkImage(
                                imageUrl: icon,
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                      // invertColors: Constant.isDark == true
                                      //     ? true
                                      //     : false,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) {
                                  return MyImage(
                                    width: 25,
                                    height: 25,
                                    imagePath: "no_image_land.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return MyImage(
                                    width: 25,
                                    height: 25,
                                    imagePath: "no_image_land.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            );
                          })
                        : MyImage(
                            width: 20,
                            height: 20,
                            imagePath: icon,
                            color: white,
                          ),
                  ),
                  const SizedBox(width: 15),
                  MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: title,
                      fontsizeNormal: Dimens.textTitle,
                      maxline: 1,
                      fontwaight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                      multilanguage: multilanguage),
                ],
              ),
            ),
            removeLine == true
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 25),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.8,
                        color: gray.withOpacity(0.45),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget profileshimmer() {
    return const Positioned.fill(
      bottom: 20,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // UserImage and Username
            CustomWidget.circular(
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 10,
            ),
            CustomWidget.roundrectborder(
              height: 10,
              width: 100,
            ),
          ],
        ),
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
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              itemCount: (profileprovider.getpagemodel.result?.length ?? 0),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int position) {
                return settingItem(
                  multilanguage: false,
                  isNetworkImg: true,
                  icon:
                      profileprovider.getpagemodel.result?[position].icon ?? '',
                  title: profileprovider.getpagemodel.result?[position].title ??
                      '',
                  onTap: () {
                    AdHelper.showFullscreenAd(
                        context, Constant.interstialAdType, () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  GetPages(
                            appBarTitle: profileprovider
                                    .getpagemodel.result?[position].title ??
                                '',
                            loadURL: profileprovider
                                    .getpagemodel.result?[position].url ??
                                '',
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
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget _buildSocialLink() {
    return Consumer<ProfileProvider>(
        builder: (context, profileprovider, child) {
      if (profileprovider.loading) {
        return const SizedBox.shrink();
      } else {
        if (profileprovider.socialLinkModel.status == 200 &&
            profileprovider.socialLinkModel.result != null) {
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              itemCount: (profileprovider.socialLinkModel.result?.length ?? 0),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int position) {
                return settingItem(
                  multilanguage: false,
                  removeLine: position ==
                          ((profileprovider.socialLinkModel.result?.length ??
                                  0) -
                              1)
                      ? true
                      : false,
                  isNetworkImg: true,
                  icon:
                      profileprovider.socialLinkModel.result?[position].image ??
                          '',
                  title:
                      profileprovider.socialLinkModel.result?[position].name ??
                          '',
                  onTap: () {
                    AdHelper.showFullscreenAd(
                        context, Constant.interstialAdType, () {
                      Utils.lanchUrl(profileprovider
                              .socialLinkModel.result?[position].url ??
                          "");
                    });
                  },
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  editProfileBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          padding: const EdgeInsets.all(20).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Consumer<ProfileProvider>(
              builder: (context, profileprovider, child) {
            return Wrap(
              alignment: WrapAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      splashColor: transparentColor,
                      focusColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.surface,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    MyText(
                        color: Theme.of(context).colorScheme.surface,
                        text: "editprofile",
                        fontsizeNormal: Dimens.textTitle,
                        maxline: 1,
                        fontwaight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: true),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profileprovider.imageFile == null
                            ? MyNetworkImage(
                                imgWidth: 90,
                                imgHeight: 90,
                                imageUrl: profileprovider
                                        .profileModel.result?[0].image
                                        .toString() ??
                                    "",
                                fit: BoxFit.fill,
                              )
                            : Image.file(
                                profileprovider.imageFile ?? File(""),
                                fit: BoxFit.fill,
                                width: 90,
                                height: 90,
                              ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            splashColor: transparentColor,
                            focusColor: transparentColor,
                            hoverColor: transparentColor,
                            highlightColor: transparentColor,
                            onTap: () {
                              getImageFromGallery();
                            },
                            child: const Icon(
                              Icons.edit,
                              color: white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                editableTextField(
                    controller: nameController,
                    keybordType: TextInputType.text,
                    hintText: "fullname",
                    textInputAction: TextInputAction.next),
                editableTextField(
                    controller: emailController,
                    keybordType: TextInputType.text,
                    hintText: "email",
                    textInputAction: TextInputAction.next),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                          color: Theme.of(context).colorScheme.surface,
                          text: "mobilenumber",
                          fontsizeNormal: Dimens.textMedium,
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true),
                      const SizedBox(height: 8),
                      IntlPhoneField(
                        disableLengthCheck: true,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: Theme.of(context).colorScheme.surface,
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: numberController,
                        style: GoogleFonts.inter(
                            fontSize: Dimens.textMedium,
                            fontStyle: FontStyle.normal,
                            color: Theme.of(context).colorScheme.surface,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w600),
                        showCountryFlag: true,
                        showDropdownIcon: false,
                        initialCountryCode: profileprovider
                                        .profileModel.result?[0].countryName ==
                                    "" ||
                                profileprovider
                                        .profileModel.result?[0].countryName ==
                                    null
                            ? "IN"
                            : profileprovider
                                    .profileModel.result?[0].countryName
                                    .toString() ??
                                "IN",
                        dropdownTextStyle: GoogleFonts.inter(
                            fontSize: Dimens.textSmall,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 1.0,
                            color: gray.withOpacity(0.50),
                            fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.number,
                        textInputAction: Platform.isIOS
                            ? TextInputAction.next
                            : TextInputAction.done,
                        decoration: InputDecoration(
                          fillColor: gray.withOpacity(0.10),
                          filled: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(width: 1, color: white),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(width: 1, color: white),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            borderSide: BorderSide(width: 1, color: white),
                          ),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),
                              borderSide: BorderSide(width: 1, color: white)),
                          hintText: "mobilenumber",
                          hintStyle: GoogleFonts.inter(
                              fontSize: Dimens.textMedium,
                              fontStyle: FontStyle.normal,
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w400),
                        ),
                        onChanged: (phone) {
                          mobilenumber = phone.completeNumber;
                          countryname = phone.countryISOCode;
                          countrycode = phone.countryCode;
                        },
                        onCountryChanged: (country) {
                          countryname = country.code.replaceAll('+', '');
                          countrycode = "+${country.dialCode.toString()}";
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 20),
                  child: InkWell(
                    splashColor: transparentColor,
                    focusColor: transparentColor,
                    hoverColor: transparentColor,
                    highlightColor: transparentColor,
                    onTap: () async {
                      await profileprovider.getUpdateProfile(
                        nameController.text.toString(),
                        numberController.text.toString(),
                        emailController.text.toString(),
                        countrycode,
                        countryname,
                      );

                      if (!profileprovider.updateprofileLoading) {
                        if (profileprovider.updateprofilemodel.status == 200) {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          Utils.showSnackbar(
                              context,
                              "success",
                              profileprovider.updateprofilemodel.message
                                  .toString(),
                              false);
                          getApi();
                        } else {
                          if (!context.mounted) return;
                          Utils.showSnackbar(
                              context,
                              "fail",
                              profileprovider.updateprofilemodel.message
                                  .toString(),
                              false);
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 1000),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      curve: Curves.bounceInOut,
                      width: profileprovider.updateprofileLoading
                          ? 100
                          : MediaQuery.of(context).size.width,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: profileprovider.updateprofileLoading
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: white,
                                strokeWidth: 2,
                              ),
                            )
                          : MyText(
                              color: white,
                              text: "updatetext",
                              fontsizeNormal: Dimens.textTitle,
                              maxline: 1,
                              fontwaight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                              multilanguage: true),
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  getImageFromGallery() async {
    var image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      profileProvider.selectImage(File(image.path));
    }
  }

  Padding editableTextField(
      {controller, hintText, textInputAction, keybordType}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
              color: Theme.of(context).colorScheme.surface,
              text: hintText,
              fontsizeNormal: Dimens.textMedium,
              maxline: 1,
              fontwaight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: false,
            keyboardType: keybordType,
            controller: controller,
            textInputAction: textInputAction,
            cursorColor: Theme.of(context).colorScheme.surface,
            style: GoogleFonts.inter(
                fontSize: Dimens.textMedium,
                fontStyle: FontStyle.normal,
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              fillColor: gray.withOpacity(0.10),
              filled: true,
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: white),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: white),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(width: 1, color: white),
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  borderSide: BorderSide(width: 1, color: white)),
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                  fontSize: Dimens.textMedium,
                  fontStyle: FontStyle.normal,
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  logoutPopup() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: BorderRadius.circular(15)),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    MyImage(
                      width: 90,
                      fit: BoxFit.contain,
                      height: 90,
                      imagePath: "ic_logoutsure.png",
                    ),
                    const SizedBox(height: 20),
                    MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "logoutsure",
                      maxline: 1,
                      fontwaight: FontWeight.w500,
                      fontsizeNormal: Dimens.textlargeBig,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                      multilanguage: true,
                    ),
                    const SizedBox(height: 20),
                    MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "areyousurewanttologout",
                      maxline: 2,
                      fontwaight: FontWeight.w400,
                      fontsizeNormal: Dimens.textMedium,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                      multilanguage: true,
                    ),
                    const SizedBox(height: 25),
                    /* Logout Button */
                    InkWell(
                      splashColor: transparentColor,
                      focusColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async {
                        /* Clear Local Data */
                        await sharedpre.clear();
                        await profileProvider.clearProvider();
                        await _auth.signOut();
                        await GoogleSignIn().signOut();
                        await Utils.setUserId(null);
                        Constant.userID = null;
                        printLog("UserIds====>${Constant.userID}");
                        if (!context.mounted) return;
                        /* Close Logout Popup */
                        Navigator.pop(context);
                        /* Open Login Page */
                        await Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const Login(),
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
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: white,
                          text: "yeslogout",
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsizeNormal: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    /* Cancel  Button */
                    InkWell(
                      splashColor: transparentColor,
                      focusColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(50)),
                        child: MyText(
                          color: colorPrimary,
                          text: "stayloggedin",
                          maxline: 1,
                          fontwaight: FontWeight.w500,
                          fontsizeNormal: 14,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) async {
      Utils.loadAds(context);
      setState(() {});
    });
  }

  forgotPasswordDilog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const ForgotPassword();
      },
    );
  }
}
