import 'dart:io';
import 'package:provider/provider.dart';
import 'package:yourappname/pages/account.dart';
import 'package:yourappname/pages/ebook.dart';
import 'package:yourappname/pages/home.dart';
import 'package:yourappname/pages/mycourse.dart';
import 'package:yourappname/pages/explore.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({Key? key}) : super(key: key);

  @override
  State<Bottombar> createState() => BottombarState();
}

class BottombarState extends State<Bottombar> {
  SharedPre sharedpre = SharedPre();
  late GeneralProvider generalProvider;
  late ProfileProvider profileProvider;
  int selectedIndex = 0;
  String userid = "";
  String currencycode = "";

  @override
  initState() {
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    super.initState();
    AdHelper().initGoogleMobileAds();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async {
    pushNotification();
    if (Constant.userID != null) {
      await profileProvider.getprofile(context);
    }
    if (!mounted) return;
    Utils.loadAds(context);
    await generalProvider.getGeneralsetting(context);
    setState(() {});
  }

  pushNotification() async {
    Constant.oneSignalAppId = await sharedpre.read(Constant.oneSignalAppIdKey);
    printLog("OneSignal===>${Constant.oneSignalAppId}");
    /*  Push Notification Method OneSignal Start */
    if (!kIsWeb) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      // Initialize OneSignal
      printLog("OneSignal PushNotification===> ${Constant.oneSignalAppId}");
      OneSignal.initialize(Constant.oneSignalAppId ?? "");
      OneSignal.Notifications.requestPermission(false);
      OneSignal.Notifications.addPermissionObserver((state) {
        printLog("Has permission ==> $state");
      });
      OneSignal.User.pushSubscription.addObserver((state) {
        printLog(
            "pushSubscription state ==> ${state.current.jsonRepresentation()}");
      });
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        /// preventDefault to not display the notification
        event.preventDefault();
        // Do async work
        /// notification.display() to display after preventing default
        event.notification.display();
      });
    }
/*  Push Notification Method OneSignal End */
  }

  List<Widget> _children() => [
        const Home(),
        const Expore(),
        const MyCourse(),
        const Ebook(),
        const Account(),
      ];

  void _onItemTapped(int index) {
    AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
      setState(() {
        switch (index) {
          case 0:
            selectedIndex = index;
            break;
          case 1:
            selectedIndex = index;
            break;
          case 2:
            if (Utils.checkLoginUser(context)) {
              selectedIndex = index;
            }
            break;
          case 3:
            selectedIndex = index;
            break;
          case 4:
            selectedIndex = index;
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: children[selectedIndex],
            ),
          ),
          /* AdMob Banner */
          Utils.showBannerAd(context),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: Platform.isIOS ? 80 : 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            bottomNavigationItem(
                icon: "ic_bottomNavhome.png",
                title: Locales.string(context, "home"),
                index: 0,
                selectedIndex: selectedIndex),
            bottomNavigationItem(
                icon: "ic_bottomNavcategory.png",
                title: Locales.string(context, "explore"),
                index: 1,
                selectedIndex: selectedIndex),
            bottomNavigationItem(
                icon: "ic_mycourses.png",
                title: Locales.string(context, "mycourse"),
                index: 2,
                selectedIndex: selectedIndex),
            bottomNavigationItem(
                icon: "ic_ebook.png",
                title: Locales.string(context, "ebook"),
                index: 3,
                selectedIndex: selectedIndex),
            bottomNavigationItem(
                icon: "ic_bottomNavAccount.png",
                title: Locales.string(context, "setting"),
                index: 4,
                selectedIndex: selectedIndex),
          ],
        ),
      ),
    );
  }
  // Locales.string(context, "searchbarhint"),

  bottomNavigationItem({required icon, required title, selectedIndex, index}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        _onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.linear,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 40,
        alignment: Alignment.center,
        width: selectedIndex == index ? 110 : 50,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color:
                selectedIndex == index ? colorPrimary.withOpacity(0.20) : null),
        child: selectedIndex == index
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyImage(
                    imagePath: icon,
                    width: 20,
                    height: 20,
                    color: colorPrimary,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: MyText(
                        color: colorPrimary,
                        text: title,
                        maxline: 1,
                        fontwaight: FontWeight.w500,
                        fontsizeNormal: Dimens.textSmall,
                      ),
                    ),
                  ),
                ],
              )
            : MyImage(
                imagePath: icon,
                width: 22,
                color: gray.withOpacity(0.50),
                height: 22,
              ),
      ),
    );
  }
}
