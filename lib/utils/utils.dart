import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/pages/login.dart';
import 'package:yourappname/pages/notificationpage.dart';
import 'package:yourappname/pages/search.dart';
import 'package:yourappname/pages/wishlist.dart';
import 'package:yourappname/players/player_video.dart';
import 'package:yourappname/players/player_vimeo.dart';
import 'package:yourappname/players/player_youtube.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/provider/searchprovider.dart';
import 'package:yourappname/provider/themeprovider.dart';
import 'package:yourappname/subscription/subscription.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/constant.dart';
import 'dart:math' as number;
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/webpages/webdetails.dart';
import 'package:yourappname/webpages/weblogin.dart';
import 'package:yourappname/webpages/webmycourse.dart';
import 'package:yourappname/webpages/webnotificationpage.dart';
import 'package:yourappname/webpages/webwishlist.dart';
import 'package:yourappname/webwidget/forgotpassword.dart';
import 'package:yourappname/webwidget/webappbar.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:encrypt/encrypt.dart' as excrypt;

printLog(String message) {
  if (kDebugMode) {
    return print(message);
  }
}

class Utils {
  ProgressDialog? prDialog;

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: colorAccent,
        textColor: white,
        fontSize: 14);
  }

  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorPrimary,
      ),
    );
  }

  static String formateDate(String date, String format) {
    String finalDate = "";
    DateFormat inputDate = DateFormat("yyyy-MM-dd");
    DateFormat outputDate = DateFormat(format);

    DateTime inputTime = inputDate.parse(date);

    finalDate = outputDate.format(inputTime);

    return finalDate;
  }

  static String formatDuration(double time) {
    Duration duration = Duration(milliseconds: time.round());

    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  static String timeAgoCustom(DateTime d) {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return DateFormat.E().add_jm().format(d);
    }
    if (diff.inHours > 0) return "Today ${DateFormat('jm').format(d)}";
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  void showProgress(BuildContext context, String message) async {
    prDialog = ProgressDialog(context);
    prDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);

    prDialog?.style(
      message: message.toString(),
      borderRadius: 5,
      progressWidget: Container(
        width: 200,
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(
          color: colorAccent,
        ),
      ),
      maxProgress: 100,
      progressTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Theme.of(context).cardColor,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );

    await prDialog!.show();
  }

  void hideProgress(BuildContext context) async {
    prDialog = ProgressDialog(context);
    if (prDialog!.isShowing()) {
      prDialog!.hide();
    }
  }

  /* ***************** generate Unique OrderID START ***************** */
  static String generateRandomOrderID() {
    int getRandomNumber;
    String? finalOID;
    printLog("fixFourDigit =>>> ${Constant().fixFourDigit}");
    printLog("fixSixDigit =>>> ${Constant().fixSixDigit}");

    number.Random r = number.Random();
    int ran5thDigit = r.nextInt(9);
    printLog("Random ran5thDigit =>>> $ran5thDigit");

    int randomNumber = number.Random().nextInt(9999999);
    printLog("Random randomNumber =>>> $randomNumber");
    if (randomNumber < 0) {
      randomNumber = -randomNumber;
    }
    getRandomNumber = randomNumber;
    printLog("getRandomNumber =>>> $getRandomNumber");

    finalOID = "${Constant().fixFourDigit.toInt()}"
        "$ran5thDigit"
        "${Constant().fixSixDigit.toInt()}"
        "$getRandomNumber";
    printLog("finalOID =>>> $finalOID");

    return finalOID;
  }
  /* ***************** generate Unique OrderID END ***************** */

  // ignore: avoid_types_as_parameter_names
  static String kmbGenerator(int num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  static AppBar myAppBarWithBack(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      elevation: 0,
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //   statusBarColor: colorPrimary,
      //   statusBarIconBrightness: Brightness.light,
      //   statusBarBrightness: Brightness.light,
      // ),
      centerTitle: false,
      leading: IconButton(
        autofocus: true,
        focusColor: white.withOpacity(0.5),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: MyImage(
          imagePath: "ic_left.png",
          height: 16,
          width: 16,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
      title: MyText(
        text: appBarTitle,
        multilanguage: multilanguage,
        fontsizeNormal: Dimens.textTitle,
        fontsizeWeb: Dimens.textTitle,
        fontstyle: FontStyle.normal,
        fontwaight: FontWeight.bold,
        textalign: TextAlign.center,
        color: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  static AppBar mainAppBar(BuildContext context, bool isAction) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colorPrimary,
      titleSpacing: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      leading: Align(
        alignment: Alignment.center,
        child: MyImage(
          width: 30,
          height: 30,
          imagePath: "appicon_transparent.png",
          fit: BoxFit.cover,
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () {},
          child: MyText(
              color: white,
              text: "appname",
              maxline: 1,
              fontwaight: FontWeight.w500,
              fontsizeNormal: 16,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
              multilanguage: true),
        ),
      ),
      actions: [
        isAction == true
            ? Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          AdHelper.showFullscreenAd(
                              context, Constant.interstialAdType, () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const Search(
                                  searchType: "3",
                                  type: "course",
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
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.search,
                            color: white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AdHelper.showFullscreenAd(
                              context, Constant.interstialAdType, () {
                            if (Constant.userID == null) {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.favorite_border,
                            color: white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AdHelper.showFullscreenAd(
                              context, Constant.interstialAdType, () {
                            if (Constant.userID == null) {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
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
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.notifications_none,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  static BoxDecoration setBackground(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static Future<void> initializeHiveBoxes() async {
    printLog("initializeHiveBoxes userId ==> ${Constant.userID}");
    if (Constant.userID == null) {
      try {
        await Hive.deleteBoxFromDisk(Constant.hiveDownloadBox);
        await Hive.deleteBoxFromDisk(Constant.hiveSeasonDownloadBox);
        await Hive.deleteBoxFromDisk(Constant.hiveEpiDownloadBox);
      } catch (e) {
        printLog("Error ===> ${e.toString()}");
      }
    }

    printLog("hiveDownloadBox ============> ${Constant.hiveDownloadBox}");
    printLog("hiveSeasonDownloadBox ======> ${Constant.hiveSeasonDownloadBox}");
    printLog("hiveEpiDownloadBox =========> ${Constant.hiveEpiDownloadBox}");
    if (Constant.userID != null) {
      bool? isDownloadBoxExists = await Hive.boxExists(
          '${Constant.hiveDownloadBox}_${Constant.userID}');
      bool? isSeasonBoxExists = await Hive.boxExists(
          '${Constant.hiveSeasonDownloadBox}_${Constant.userID}');
      bool? isEpisodeBoxExists = await Hive.boxExists(
          '${Constant.hiveEpiDownloadBox}_${Constant.userID}');

      printLog("isDownloadBoxExists ========> $isDownloadBoxExists");
      printLog("isSeasonBoxExists ==========> $isSeasonBoxExists");
      printLog("isEpisodeBoxExists =========> $isEpisodeBoxExists");
      await Hive.openBox<DownloadItem>(
          '${Constant.hiveDownloadBox}_${Constant.userID}');
      await Hive.openBox<ChapterItem>(
          '${Constant.hiveSeasonDownloadBox}_${Constant.userID}');
      await Hive.openBox<EpisodeItem>(
          '${Constant.hiveEpiDownloadBox}_${Constant.userID}');
    } else {
      await Hive.openBox<DownloadItem>(Constant.hiveDownloadBox);
      await Hive.openBox<ChapterItem>(Constant.hiveSeasonDownloadBox);
      await Hive.openBox<EpisodeItem>(Constant.hiveEpiDownloadBox);
    }
  }

  static void showSnackbar(BuildContext context, String showFor, String message,
      bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: kIsWeb
            ? MediaQuery.of(context).size.width * 0.50
            : MediaQuery.of(context).size.width,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: showFor == "fail"
            ? red
            : showFor == "info"
                ? colorPrimary
                : showFor == "success"
                    ? colorPrimary
                    : colorPrimary,
        content: MyText(
          text: message,
          fontsizeNormal: 14,
          fontsizeWeb: 14,
          multilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontwaight: FontWeight.w500,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  static Future<File?> saveImageInStorage(imgUrl) async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      Directory? documentDirectory;
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      File file = File(path.join(documentDirectory?.path ?? "",
          '${DateTime.now().millisecondsSinceEpoch.toString()}.png'));
      file.writeAsBytesSync(response.bodyBytes);
      return file;
    } catch (e) {
      printLog("saveImageInStorage Exception ===> $e");
      return null;
    }
  }

  static void getCurrencySymbol() async {
    SharedPre sharedPref = SharedPre();
    Constant.currencyCode = await sharedPref.read("currency_code") ?? "";
    Constant.currency = await sharedPref.read("currency") ?? "";
  }

  static saveUserCreds({
    required userID,
    required userName,
    required fullName,
    required email,
    required mobileNumber,
    required image,
    required deviceType,
    required deviceToken,
    required userIsBuy,
    required firebaseId,
  }) async {
    SharedPre sharedPref = SharedPre();
    if (userID != null) {
      await sharedPref.save("userid", userID);
      await sharedPref.save("username", userName);
      await sharedPref.save("fullname", fullName);
      await sharedPref.save("email", email);
      await sharedPref.save("mobilenumber", mobileNumber);
      await sharedPref.save("userimage", image);
      await sharedPref.save("devicetype", deviceType);
      await sharedPref.save("divicetoken", deviceToken);
      await sharedPref.save("userIsBuy", userIsBuy);
      await sharedPref.save("firebaseid", firebaseId);
    } else {
      await sharedPref.remove("userid");
      await sharedPref.remove("username");
      await sharedPref.remove("fullname");
      await sharedPref.remove("email");
      await sharedPref.remove("mobilenumber");
      await sharedPref.remove("userimage");
      await sharedPref.remove("devicetype");
      await sharedPref.remove("devicetoken");
      await sharedPref.remove("userIsBuy");
      await sharedPref.remove("firebaseid");
    }

    Constant.userID = await sharedPref.read("userid");
    Constant.userImage = await sharedPref.read("userimage");
    Constant.isBuy = await sharedPref.read("userIsBuy");

    printLog('setUserId userID ==> ${Constant.userID}');
    printLog('setUserId userID ==> ${Constant.userImage}');
    printLog('setUserId userID ==> ${Constant.isBuy}');
  }

  static setUserId(userID) async {
    SharedPre sharedPref = SharedPre();
    if (userID != null) {
      await sharedPref.save("userid", userID);
    } else {
      await sharedPref.remove("userid");
      await sharedPref.remove("username");
      await sharedPref.remove("fullname");
      await sharedPref.remove("email");
      await sharedPref.remove("mobilenumber");
      await sharedPref.remove("userimage");
      await sharedPref.remove("devicetype");
      await sharedPref.remove("devicetoken");
      await sharedPref.remove("userIsBuy");
      await sharedPref.remove("firebaseid");
    }
    printLog("Clear Data====>");
  }

  static openPlayer({
    required BuildContext context,
    required int videoId,
    required String videoUrl,
    required String vUploadType,
    required String videoThumb,
    required int courseId,
    required String type,
    required int chepterId,
    required String secreateKey,
  }) {
    if (kIsWeb) {
      /* Normal, Vimeo & Youtube Player */
      if (!context.mounted) return;
      if (vUploadType == "youtube") {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PlayerYoutube(videoId, videoUrl, vUploadType, videoThumb,
                  courseId, chepterId);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      } else if (vUploadType == "external") {
        if (videoUrl.contains('youtube')) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return PlayerYoutube(videoId, videoUrl, vUploadType, videoThumb,
                    courseId, chepterId);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        } else {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return PlayerVideo(videoId, videoUrl, vUploadType, chepterId,
                    videoThumb, courseId, type, secreateKey);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        }
      } else {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PlayerVideo(videoId, videoUrl, vUploadType, chepterId,
                  videoThumb, courseId, type, secreateKey);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      }
    } else {
      /* Better, Youtube & Vimeo Players */
      if (vUploadType == "youtube") {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PlayerYoutube(videoId, videoUrl, vUploadType, videoThumb,
                  courseId, chepterId);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      } else if (vUploadType == "vimeo") {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PlayerVimeo(videoId, videoUrl, vUploadType, chepterId,
                  videoThumb, courseId);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      } else if (vUploadType == "external") {
        if (videoUrl.contains('youtube')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PlayerYoutube(videoId, videoUrl, vUploadType, videoThumb,
                    courseId, chepterId);
              },
            ),
          );
        } else {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return PlayerVideo(videoId, videoUrl, vUploadType, chepterId,
                    videoThumb, courseId, type, secreateKey);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            ),
          );
        }
      } else {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return PlayerVideo(videoId, videoUrl, vUploadType, chepterId,
                  videoThumb, courseId, type, secreateKey);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      }
    }
  }

  static Widget buildBackBtnDesign(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MyImage(
        height: 17,
        width: 17,
        imagePath: "ic_back.png",
        color: white,
      ),
    );
  }

  static Future<void> shareApp(shareMessage) async {
    try {
      await FlutterShare.share(
        title: Constant.appName,
        linkUrl: shareMessage,
      );
    } catch (e) {
      printLog("shareFile Exception ===> $e");
      return;
    }
  }

  /* Google AdMob Methods Start */
  static Widget showBannerAd(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 0,
          minWidth: 0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: AdHelper.bannerAd(context),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static loadAds(BuildContext context) async {
    if (context.mounted) {
      AdHelper.getAds(context);
    }
    if (!kIsWeb) {
      AdHelper.createInterstitialAd();
      AdHelper.createRewardedAd();
    }
  }
/* Google AdMob Methods End */

  static Future<bool> checkPremiumUser() async {
    SharedPre sharedPre = SharedPre();
    String? isPremiumBuy = await sharedPre.read("userIsBuy");
    printLog('checkPremiumUser isPremiumBuy ==> $isPremiumBuy');
    if (isPremiumBuy != null && isPremiumBuy == "1") {
      return true;
    } else {
      return false;
    }
  }

  static void updatePremium(String isPremiumBuy) async {
    printLog('updatePremium isPremiumBuy ==> $isPremiumBuy');
    SharedPre sharedPre = SharedPre();
    await sharedPre.save("userpremium", isPremiumBuy);
    String? isPremium = await sharedPre.read("userpremium");
    printLog('updatePremium ===============> $isPremium');
  }

  static checkLoginUser(BuildContext context) {
    if (Constant.userID != null) {
      return true;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Login();
        },
      ),
    );
    return false;
  }

/* Subscription Bottom Sheet */
  static openSubscription(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return const Subscription();
      },
    );
  }

  static Widget dataUpdateDialog(
    BuildContext context, {
    required bool isNameReq,
    required bool isEmailReq,
    required bool isMobileReq,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController mobileController,
  }) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Container(
        padding: const EdgeInsets.all(23),
        color: white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Title & Subtitle */
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    color: black,
                    text: "editprofile",
                    multilanguage: true,
                    textalign: TextAlign.start,
                    fontsizeNormal: Dimens.textTitle,
                    fontwaight: FontWeight.w700,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(height: 3),
                  MyText(
                    color: black,
                    text: "editpersonaldetail",
                    multilanguage: true,
                    textalign: TextAlign.start,
                    fontsizeNormal: Dimens.textSmall,
                    fontwaight: FontWeight.w500,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                  )
                ],
              ),
            ),

            /* Fullname */
            const SizedBox(height: 30),
            if (isNameReq)
              _buildTextFormField(
                controller: nameController,
                hintText: "full_name",
                inputType: TextInputType.name,
                readOnly: false,
              ),

            /* Email */
            if (isEmailReq)
              _buildTextFormField(
                controller: emailController,
                hintText: "email_address",
                inputType: TextInputType.emailAddress,
                readOnly: false,
              ),

            /* Mobile */
            if (isMobileReq)
              _buildTextFormField(
                controller: mobileController,
                hintText: "mobile_number",
                inputType: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                readOnly: false,
              ),
            const SizedBox(height: 5),

            /* Cancel & Update Buttons */
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* Cancel */
                  InkWell(
                    onTap: () {
                      final profileEditProvider =
                          Provider.of<ProfileProvider>(context, listen: false);
                      if (!profileEditProvider.loadingUpdate) {
                        Navigator.pop(context, false);
                      }
                    },
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 75),
                      height: 50,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: black,
                          width: .5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: MyText(
                        color: black,
                        text: "cancel",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsizeNormal: Dimens.textTitle,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        fontwaight: FontWeight.w500,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  /* Submit */
                  Consumer<ProfileProvider>(
                    builder: (context, profileEditProvider, child) {
                      if (profileEditProvider.loadingUpdate) {
                        return Container(
                          width: 100,
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                          alignment: Alignment.center,
                          child: pageLoader(),
                        );
                      }
                      return InkWell(
                        onTap: () async {
                          SharedPre sharedPref = SharedPre();
                          final fullName =
                              nameController.text.toString().trim();
                          final emailAddress =
                              emailController.text.toString().trim();
                          final mobileNumber =
                              mobileController.text.toString().trim();

                          printLog(
                              "fullName =======> $fullName ; required ========> $isNameReq");
                          printLog(
                              "emailAddress ===> $emailAddress ; required ====> $isEmailReq");
                          printLog(
                              "mobileNumber ===> $mobileNumber ; required ====> $isMobileReq");
                          if (isNameReq && fullName.isEmpty) {
                            Utils.showSnackbar(
                                context, "fail", "enter_fullname", true);
                          } else if (isEmailReq && emailAddress.isEmpty) {
                            Utils.showSnackbar(
                                context, "fail", "enter_email", true);
                          } else if (isMobileReq && mobileNumber.isEmpty) {
                            Utils.showSnackbar(
                                context, "fail", "enter_mobile_number", true);
                          } else if (isEmailReq &&
                              !EmailValidator.validate(emailAddress)) {
                            Utils.showSnackbar(
                                context, "fail", "enter_valid_email", true);
                          } else {
                            final profileEditProvider =
                                Provider.of<ProfileProvider>(context,
                                    listen: false);
                            await profileEditProvider.setUpdateLoading(true);

                            await profileEditProvider.getUpdateDataForPayment(
                                fullName, emailAddress, mobileNumber);
                            if (!profileEditProvider.loadingUpdate) {
                              await profileEditProvider.setUpdateLoading(false);
                              if (profileEditProvider.successModel.status ==
                                  200) {
                                if (isNameReq) {
                                  await sharedPref.save('fullname', fullName);
                                }
                                if (isEmailReq) {
                                  await sharedPref.save('email', emailAddress);
                                }
                                if (isMobileReq) {
                                  await sharedPref.save(
                                      'mobilenumber', mobileNumber);
                                }
                                if (context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              }
                            }
                          }
                        },
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 75),
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: MyText(
                            color: white,
                            text: "submit",
                            textalign: TextAlign.center,
                            fontsizeNormal: Dimens.textTitle,
                            multilanguage: true,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontwaight: FontWeight.w700,
                            fontstyle: FontStyle.normal,
                          ),
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
    );
  }

  static Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType inputType,
    required bool readOnly,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      margin: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        obscureText: false,
        maxLines: 1,
        readOnly: readOnly,
        cursorColor: black,
        cursorRadius: const Radius.circular(2),
        decoration: InputDecoration(
          filled: true,
          isDense: false,
          fillColor: transparentColor,
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colorPrimary)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colorPrimary)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colorPrimary)),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: colorPrimary)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: colorPrimary)),
          label: MyText(
            multilanguage: true,
            color: black,
            text: hintText,
            textalign: TextAlign.start,
            fontstyle: FontStyle.normal,
            fontsizeNormal: Dimens.textMedium,
            fontwaight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 14,
            color: black,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }

  static void lanchUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw Utils().showToast("Could Not Lunch This Url $url");
    }
  }

  static Color generateRendomColor() {
    final Random random = Random();
    final int red = random.nextInt(256);
    final int green = random.nextInt(256);
    final int blue = random.nextInt(256);
    final Color color = Color.fromARGB(255, red, green, blue);
    return color;
  }

/* Logout Dilog Both (App) And (Web) */

  static logoutPopup(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              constraints: kIsWeb
                  ? const BoxConstraints(
                      minWidth: 250,
                      maxWidth: 400,
                      minHeight: 300,
                      maxHeight: 350,
                    )
                  : null,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(15)),
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
                        color: black,
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
                        color: black,
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
                        onTap: () async {
                          SharedPre sharedpre = SharedPre();
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final profileProvider = Provider.of<ProfileProvider>(
                              context,
                              listen: false);
                          /* Clear Local Data */
                          await sharedpre.clear();
                          await profileProvider.clearProvider();
                          await auth.signOut();
                          await GoogleSignIn().signOut();
                          await Utils.setUserId(null);
                          Constant.userID = null;
                          setState;
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          await Navigator.of(context).push(
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
        });
      },
    );
  }

  /* ***************** Download ***************** */
  static Future<String> prepareSaveDir() async {
    String localPath = (await _getSavedDir())!;
    printLog("localPath ------------> $localPath");
    final savedDir = Directory(localPath);
    printLog("savedDir -------------> $savedDir");
    printLog("is exists ? ----------> ${savedDir.existsSync()}");
    if (!(await savedDir.exists())) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  static Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      try {
        externalStorageDirPath = "${directory?.absolute.path}/downloads/";
      } catch (err, st) {
        printLog('failed to get downloads path: $err, $st');
        externalStorageDirPath = "${directory?.absolute.path}/downloads/";
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    printLog("externalStorageDirPath ------------> $externalStorageDirPath");
    return externalStorageDirPath;
  }

  static Future<String> prepareShowSaveDir(
      String showName, String seasonName) async {
    printLog("showName -------------> $showName");
    printLog("seasonName -------------> $seasonName");
    String localPath = (await _getShowSavedDir(showName, seasonName))!;
    final savedDir = Directory(localPath);
    printLog("savedDir -------------> $savedDir");
    printLog("savedDir path --------> ${savedDir.path}");
    if (!savedDir.existsSync()) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  static Future<String?> _getShowSavedDir(
      String showName, String seasonName) async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath =
            "${directory?.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
      } catch (err, st) {
        printLog('failed to get downloads path: $err, $st');
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath =
            "${directory?.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          "${(await getApplicationDocumentsDirectory()).absolute.path}/downloads/${showName.toLowerCase()}/${seasonName.toLowerCase()}";
    }
    return externalStorageDirPath;
  }

  static encryptFile(File inFile, File outFile, String generateKey) async {
    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      await outFile.create();
    }

    final videoFileContents = inFile.readAsStringSync(encoding: latin1);

    final key = excrypt.Key.fromUtf8(generateKey);
    final iv = excrypt.IV.fromLength(16);

    final encrypter =
        excrypt.Encrypter(excrypt.AES(key, mode: excrypt.AESMode.ecb));

    final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);
  }

  static String generateRandomKey(int len) {
    final random = Random.secure();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /* ***************** Download ***************** */

/*----------------------------------------------------------------- Web Utils --------------------------------------------------------------------------------------- */

  static PreferredSize webMainAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: white,
        centerTitle: true,
        elevation: 0,
        titleSpacing: 0,
        flexibleSpace: const WebAppbar(),
      ),
    );
  }

  static Widget hoverItemWithPage({required Widget myWidget, isProfile}) {
    return Consumer<GeneralProvider>(
        builder: (context, generalprovider, child) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          MouseRegion(
            onHover: (value) async {
              await generalprovider.getNotificationSectionShowHide(false);
              await generalprovider.getOpenSearchSection(false);
              await generalprovider.getOpenProfileSection(false);
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: myWidget,
            ),
          ),
          /* Notification Panel Show Home Page */
          generalprovider.isNotification == true
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width > 1200 ? 500 : 400,
                    height: 600,
                    margin: const EdgeInsets.only(left: 20, right: 50),
                    decoration: BoxDecoration(
                      // border: Border.all(width: 0.9, color: colorPrimary),
                      borderRadius: BorderRadius.circular(0),
                      color: Theme.of(context).cardColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: const WebNotificationPage(),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          /* Search Panel Show Home Page */
          generalprovider.isSearch == true
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * 0.50
                        : MediaQuery.of(context).size.width,
                    // height: 500,
                    margin: MediaQuery.of(context).size.width > 800
                        ? const EdgeInsets.only(left: 100, right: 100)
                        : const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Theme.of(context).cardColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: searchCourse(context),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          generalprovider.isProfile == true
              ? Align(
                  alignment: Alignment.topRight,
                  child: Consumer<ProfileProvider>(
                    builder: (context, profileprovider, child) {
                      return Container(
                        width:
                            MediaQuery.of(context).size.width > 800 ? 300 : 200,
                        height: 450,
                        padding: const EdgeInsets.only(bottom: 15, top: 20),
                        margin: const EdgeInsets.only(left: 20, right: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 115, 106, 106)
                                  .withOpacity(0.08),
                              spreadRadius: 1.5,
                              blurRadius: 0.5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /* User Profile Info */
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                children: [
                                  if (Constant.userID != null)
                                    if (profileprovider.loading)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  width: 1,
                                                  color: colorPrimary),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child:
                                                  const CustomWidget.circular(
                                                width: 70,
                                                height: 70,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          const Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                    else if (profileprovider
                                            .profileModel.status ==
                                        200)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: MyNetworkImage(
                                              imgWidth: 45,
                                              imgHeight: 45,
                                              imageUrl:
                                                  Constant.userImage ?? "",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                MyText(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  text: profileprovider
                                                              .profileModel
                                                              .result?[0]
                                                              .fullName
                                                              .toString() ==
                                                          ""
                                                      ? "New User"
                                                      : profileprovider
                                                              .profileModel
                                                              .result?[0]
                                                              .fullName
                                                              .toString() ??
                                                          "",
                                                  maxline: 2,
                                                  fontwaight: FontWeight.w700,
                                                  fontsizeNormal:
                                                      Dimens.textExtraBig,
                                                  fontsizeWeb: Dimens.textBig,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal,
                                                  multilanguage: false,
                                                ),
                                                const SizedBox(height: 8),
                                                MyText(
                                                  color: gray,
                                                  text: profileprovider
                                                          .profileModel
                                                          .result?[0]
                                                          .email
                                                          .toString() ??
                                                      "",
                                                  maxline: 2,
                                                  fontwaight: FontWeight.w400,
                                                  fontsizeNormal:
                                                      Dimens.textTitle,
                                                  fontsizeWeb:
                                                      Dimens.textMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textalign: TextAlign.left,
                                                  fontstyle: FontStyle.normal,
                                                  multilanguage: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  width: 1,
                                                  color: colorPrimary),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              text: "Guest User",
                                              maxline: 2,
                                              fontwaight: FontWeight.w700,
                                              fontsizeNormal:
                                                  Dimens.textlargeBig,
                                              fontsizeWeb: Dimens.textBig,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 70,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 1, color: colorPrimary),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  MyImage(
                                                    width: 40,
                                                    height: 40,
                                                    imagePath: "ic_user.png",
                                                    color: colorPrimary,
                                                  ),
                                                  const SizedBox(width: 15),
                                                  MyText(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                    text: "login",
                                                    maxline: 1,
                                                    fontwaight: FontWeight.w500,
                                                    fontsizeNormal:
                                                        Dimens.textTitle,
                                                    fontsizeWeb:
                                                        Dimens.textTitle,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                ],
                              ),
                            ),
                            /* All Pages */
                            const SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 0.6,
                              color: gray,
                            ),
                            const SizedBox(height: 20),
                            webProfilePages(context, "mycourse", () {
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
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 1000),
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return const WebMyCourse();
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
                            }),
                            webProfilePages(context, "wishlist", () {
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
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 1000),
                                    pageBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return const WebWishList();
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
                            }),
                            webProfilePages(context, "subsciption", () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 1000),
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return const Subscription();
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
                            }),
                            webProfilePages(context, "forgotpasswordtitle", () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 1000),
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return const ForgotPassword();
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
                            }),
                            webProfilePages(context, "log_out", () {
                              Utils.logoutPopup(context);
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    });
  }

  static Widget childPanel(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeprovider, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: comman,
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
            : const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                languageChangeDialogWeb(context);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: MyText(
                    color: white,
                    text: "language",
                    fontsizeNormal: Dimens.textMedium,
                    maxline: 1,
                    fontwaight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    multilanguage: true),
              ),
            ),
            MyText(
                color: white,
                text: "darkmode",
                fontsizeNormal: Dimens.textMedium,
                maxline: 1,
                fontwaight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.center,
                fontstyle: FontStyle.normal,
                multilanguage: true),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Switch(
                  activeColor: colorPrimary,
                  activeTrackColor: white,
                  inactiveTrackColor: white,
                  inactiveThumbColor: gray,
                  value: Constant.isDark,
                  onChanged: (value) async {
                    SharedPre sharedpre = SharedPre();
                    themeprovider.changeTheme(value);
                    await sharedpre.remove("isdark");
                    await sharedpre.saveBool("isdark", value);
                    printLog(
                        "ISDARK==> ${sharedpre.readBool("isdark").toString()}");
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  static webProfilePages(BuildContext context, name, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: MyText(
            color: Theme.of(context).colorScheme.surface,
            multilanguage: true,
            text: name,
            textalign: TextAlign.left,
            fontsizeNormal: Dimens.textMedium,
            fontsizeWeb: Dimens.textMedium,
            maxline: 1,
            fontwaight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal),
      ),
    );
  }

  static int customCrossAxisCount(
      {required BuildContext context,
      required int height1600,
      required int height1200,
      required int height800,
      required int height400}) {
    if (MediaQuery.of(context).size.width > 1600) {
      return height1600;
    } else if (MediaQuery.of(context).size.width > 1200) {
      return height1200;
    } else if (MediaQuery.of(context).size.width > 800) {
      return height800;
    } else if (MediaQuery.of(context).size.width > 400) {
      return height400;
    } else {
      return height400;
    }
  }

  static pageTitleLayout(BuildContext context, title, isMultilanguage) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: MediaQuery.of(context).size.width > 800
          ? const EdgeInsets.fromLTRB(100, 30, 100, 30)
          : const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorPrimary,
            colorPrimary.withOpacity(0.35),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: MyText(
                color: white,
                text: title,
                fontsizeNormal: Dimens.textExtralargeBig,
                fontsizeWeb: Dimens.textExtralargeBig,
                fontwaight: FontWeight.w500,
                maxline: 3,
                multilanguage: isMultilanguage,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
          ),
          MyImage(
            width: Dimens.learningPosterWidth,
            height: Dimens.learningPosterHeight,
            imagePath: "ic_courseposter.png",
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  static languageChangeDialogMobile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: transparentColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      elevation: 20,
      builder: (BuildContext context) {
        return BottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
            ),
          ),
          onClosing: () {},
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, state) {
                return Wrap(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).bottomSheetTheme.backgroundColor,
                      padding: const EdgeInsets.all(23),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  color: Theme.of(context).colorScheme.surface,
                                  text: "language",
                                  multilanguage: true,
                                  textalign: TextAlign.center,
                                  fontsizeNormal: Dimens.textTitle,
                                  fontwaight: FontWeight.bold,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                                const SizedBox(height: 3),
                                MyText(
                                  color: gray,
                                  text: "selectyourlanguage",
                                  multilanguage: true,
                                  textalign: TextAlign.center,
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w500,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          /* English */
                          InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('en');
                              Navigator.pop(context);
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                              height: 48,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorPrimary,
                                  width: .5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: "English",
                                textalign: TextAlign.center,
                                fontsizeNormal: Dimens.textTitle,
                                multilanguage: false,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w500,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /* Arabic */
                          InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('ar');
                              Navigator.pop(context);
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                              height: 48,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorPrimary,
                                  width: .5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: "Arabic",
                                textalign: TextAlign.center,
                                fontsizeNormal: Dimens.textTitle,
                                multilanguage: false,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w500,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /* Hindi */
                          InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              state(() {});
                              LocaleNotifier.of(context)?.change('hi');
                              Navigator.pop(context);
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                              ),
                              height: 48,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorPrimary,
                                  width: .5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: "Hindi",
                                textalign: TextAlign.center,
                                fontsizeNormal: Dimens.textTitle,
                                multilanguage: false,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontwaight: FontWeight.w500,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  static languageChangeDialogWeb(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: transparentColor,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: white,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(
              minWidth: 400,
              maxWidth: 500,
              minHeight: 450,
              maxHeight: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: "changelanguage",
                      multilanguage: true,
                      textalign: TextAlign.start,
                      fontsizeNormal: Dimens.textBig,
                      fontsizeWeb: Dimens.textBig,
                      fontwaight: FontWeight.bold,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                /* English */
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildLanguage(
                          context: context,
                          langName: "English",
                          onClick: () {
                            LocaleNotifier.of(context)?.change('en');
                            Navigator.pop(context);
                          },
                        ),

                        /* Arabic */
                        const SizedBox(height: 20),
                        _buildLanguage(
                          context: context,
                          langName: "Arabic",
                          onClick: () {
                            LocaleNotifier.of(context)?.change('ar');
                            Navigator.pop(context);
                          },
                        ),

                        /* Hindi */
                        const SizedBox(height: 20),
                        _buildLanguage(
                          context: context,
                          langName: "Hindi",
                          onClick: () {
                            LocaleNotifier.of(context)?.change('hi');
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildLanguage({
    required BuildContext context,
    required String langName,
    required Function() onClick,
  }) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        height: 48,
        padding: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: .5,
          ),
          // color: colorPrimary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: MyText(
          color: Theme.of(context).colorScheme.surface,
          text: langName,
          textalign: TextAlign.center,
          fontsizeNormal: Dimens.textTitle,
          fontsizeWeb: Dimens.textTitle,
          multilanguage: false,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          fontwaight: FontWeight.w500,
          fontstyle: FontStyle.normal,
        ),
      ),
    );
  }

  static Widget searchCourse(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchprovider, child) {
        if (searchprovider.loading) {
          return buildShimmer(context);
        } else {
          return Padding(
            padding: const EdgeInsets.all(15.0),
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
                  searchprovider.searchModel.result?.length ?? 0,
                  (index) {
                    return InkWell(
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return WebDetail(
                                  courseId: searchprovider
                                          .searchModel.result?[index].id
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
                        final generalProvider = Provider.of<GeneralProvider>(
                            context,
                            listen: false);
                        await generalProvider.getOpenSearchSection(false);
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
                                    imageUrl: searchprovider.searchModel
                                            .result?[index].thumbnailImg
                                            .toString() ??
                                        "",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          text: searchprovider.searchModel
                                                  .result?[index].title
                                                  .toString() ??
                                              "",
                                          fontsizeNormal: Dimens.textMedium,
                                          fontsizeWeb: Dimens.textMedium,
                                          fontwaight: FontWeight.w600,
                                          maxline: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textalign: TextAlign.left,
                                          fontstyle: FontStyle.normal),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          MyText(
                                              color: gray,
                                              text: Utils.kmbGenerator(
                                                  int.parse(searchprovider
                                                          .searchModel
                                                          .result?[index]
                                                          .totalView
                                                          .toString() ??
                                                      "")),
                                              fontsizeNormal: Dimens.textSmall,
                                              fontsizeWeb: Dimens.textSmall,
                                              fontwaight: FontWeight.w500,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          MyRating(
                                            size: 13,
                                            rating: double.parse(searchprovider
                                                    .searchModel
                                                    .result?[index]
                                                    .avgRating
                                                    .toString() ??
                                                ""),
                                            spacing: 2,
                                          ),
                                          const SizedBox(width: 5),
                                          MyText(
                                              color: colorAccent,
                                              text:
                                                  "${double.parse(searchprovider.searchModel.result?[index].avgRating.toString() ?? "")}",
                                              fontsizeNormal:
                                                  Dimens.textBigSmall,
                                              fontsizeWeb: Dimens.textBigSmall,
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
                          searchprovider.searchModel.result?.length == index + 1
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
            ),
          );
        }
      },
    );
  }

  static Widget buildShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                            height: 90,
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
                  Container(
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
}

/* ================ Download =================== */

Future<void> encryptFile(List<dynamic> args) async {
  File inFile = args[0] as File;
  File outFile = args[0] as File;
  String generateKey = args[1] as String;
  final sendPort = args[2] as SendPort;
  final rootToken = args[3] as RootIsolateToken;
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

  bool outFileExists = await outFile.exists();

  if (!outFileExists) {
    await outFile.create();
  }

  final videoFileContents = inFile.readAsStringSync(encoding: latin1);

  final key = excrypt.Key.fromUtf8(generateKey);
  final iv = excrypt.IV.fromLength(16);

  final encrypter =
      excrypt.Encrypter(excrypt.AES(key, mode: excrypt.AESMode.ecb));

  final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
  await outFile.writeAsBytes(encrypted.bytes);
  sendPort.send(outFile);
}

Future<dynamic> decryptFile(List<dynamic> args) async {
  File inFile = args[0] as File;
  String generateKey = args[1] as String;
  final sendPort = args[2] as SendPort;
  final rootToken = args[3] as RootIsolateToken;
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

  final tempDir = await getTemporaryDirectory();
  final decryptedFile = File('${tempDir.path}/${path.basename(inFile.path)}');
  bool outFileExists = await decryptedFile.exists();

  if (!outFileExists) {
    await decryptedFile.create();
  }

  final videoFileContents = inFile.readAsBytesSync();

  final key = excrypt.Key.fromUtf8(generateKey);
  final iv = excrypt.IV.fromLength(16);

  final encrypter =
      excrypt.Encrypter(excrypt.AES(key, mode: excrypt.AESMode.ecb));

  final encryptedFile = excrypt.Encrypted(videoFileContents);
  final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

  final decryptedBytes = latin1.encode(decrypted);
  await decryptedFile.writeAsBytes(decryptedBytes);
  printLog("decryptedFile ====> $decryptedFile");
  sendPort.send(decryptedFile);
}

/* ================ Download =================== */
