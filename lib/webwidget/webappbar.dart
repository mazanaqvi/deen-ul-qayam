import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/profileprovider.dart';
import 'package:yourappname/provider/searchprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webpages/webhome.dart';
import 'package:yourappname/webpages/weblogin.dart';
import 'package:yourappname/webpages/webmycourse.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:provider/provider.dart';

class WebAppbar extends StatefulWidget {
  const WebAppbar({super.key});

  @override
  State<WebAppbar> createState() => _WebAppbarState();
}

class _WebAppbarState extends State<WebAppbar> {
  late ProfileProvider profileProvider;

  @override
  void initState() {
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralProvider>(
        builder: (context, generalprovider, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.centerLeft,
        padding: MediaQuery.of(context).size.width > 800
            ? const EdgeInsets.fromLTRB(100, 0, 100, 0)
            : const EdgeInsets.fromLTRB(20, 0, 20, 0),
        // color: white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* AppIcon With AppName */
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/appicon/appicon.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                ),
                MediaQuery.of(context).size.width > 1200
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 7),
                          MyText(
                              color: Theme.of(context).colorScheme.surface,
                              multilanguage: false,
                              text: Constant.appName,
                              textalign: TextAlign.left,
                              fontsizeNormal:
                                  MediaQuery.of(context).size.width > 800
                                      ? Dimens.textBig
                                      : Dimens.textMedium,
                              fontsizeWeb:
                                  MediaQuery.of(context).size.width > 800
                                      ? Dimens.textBig
                                      : Dimens.textMedium,
                              maxline: 1,
                              fontwaight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal)
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(width: 15),
            /* Search Fields */
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextFormField(
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    cursorColor: gray,
                    style: TextStyle(
                        fontSize: Dimens.textSmall,
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: gray.withOpacity(0.10),
                      prefixIcon: const Icon(
                        Icons.search_sharp,
                        color: gray,
                        size: 20,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(
                          width: 0.6,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(
                          width: 0.6,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(
                          width: 0.6,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide(
                          width: 0.6,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      hintText: Locales.string(context, "searchbarhint"),
                      hintStyle: TextStyle(
                          fontSize: Dimens.textSmall,
                          fontStyle: FontStyle.normal,
                          color: gray,
                          fontWeight: FontWeight.w300),
                    ),
                    onChanged: (value) async {
                      final searchprovider =
                          Provider.of<SearchProvider>(context, listen: false);
                      if (generalprovider.isSearch == false &&
                          value.isNotEmpty) {
                        await generalprovider.getOpenSearchSection(true);
                        await searchprovider.getSearch("3", value);
                      } else {
                        await generalprovider.getOpenSearchSection(false);
                      }
                    },
                  ),
                ),
              ),
            ),
            /* Tab With Login Button */
            const SizedBox(width: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTab(
                    name: "home",
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return const WebHome();
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
                buildTab(
                    name: "mycourse",
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
                buildIconTab(
                    onTap: () async {
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
                        if (generalprovider.isNotification == false) {
                          await generalprovider
                              .getNotificationSectionShowHide(true);
                        } else {
                          await generalprovider
                              .getNotificationSectionShowHide(false);
                        }
                      }
                    },
                    icon: Icons.notifications_none_outlined),
                /* Login Logout Text */
                InteractiveContainer(child: (isHovered) {
                  return InkWell(
                    hoverColor: transparentColor,
                    splashColor: transparentColor,
                    focusColor: transparentColor,
                    highlightColor: transparentColor,
                    onTap: () async {
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
                        //   /* Logout Dilog */
                        Utils.logoutPopup(context);
                      }
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: Consumer<ProfileProvider>(
                        builder: (context, profileprovider, child) {
                      return Constant.userID == null
                          ? AnimatedScale(
                              scale: isHovered ? 1.05 : 1,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOut,
                              child: MyText(
                                  color: isHovered
                                      ? colorAccent
                                      : Theme.of(context).colorScheme.surface,
                                  multilanguage: true,
                                  text: "log_in",
                                  textalign: TextAlign.left,
                                  fontsizeNormal: Dimens.textMedium,
                                  fontsizeWeb: Dimens.textMedium,
                                  maxline: 1,
                                  fontwaight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            )
                          : InkWell(
                              hoverColor: transparentColor,
                              highlightColor: transparentColor,
                              onTap: () async {
                                if (generalprovider.isProfile == false) {
                                  await generalprovider
                                      .getOpenProfileSection(true);
                                  if (!context.mounted) return;
                                  await profileProvider.getprofile(context);
                                } else {
                                  await generalprovider
                                      .getOpenProfileSection(false);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: MyNetworkImage(
                                  imgWidth: 30,
                                  imgHeight: 30,
                                  imageUrl: Constant.userImage ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                    }),
                  );
                }),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget buildTab({name, onTap}) {
    return InteractiveContainer(child: (isHovered) {
      return InkWell(
        hoverColor: transparentColor,
        splashColor: transparentColor,
        focusColor: transparentColor,
        highlightColor: transparentColor,
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: MediaQuery.of(context).size.width > 800
              ? const EdgeInsets.fromLTRB(10, 12, 10, 12)
              : const EdgeInsets.fromLTRB(5, 8, 5, 8),
          margin: const EdgeInsets.only(right: 10),
          child: AnimatedScale(
            scale: isHovered ? 1.06 : 1,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: MyText(
                color: isHovered
                    ? colorAccent
                    : Theme.of(context).colorScheme.surface,
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
        ),
      );
    });
  }

  Widget buildIconTab({icon, onTap}) {
    return InteractiveContainer(child: (isHovered) {
      return InkWell(
        hoverColor: transparentColor,
        splashColor: transparentColor,
        focusColor: transparentColor,
        highlightColor: transparentColor,
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: MediaQuery.of(context).size.width > 800
              ? const EdgeInsets.fromLTRB(10, 12, 10, 12)
              : const EdgeInsets.fromLTRB(5, 8, 5, 8),
          margin: const EdgeInsets.only(right: 10),
          child: AnimatedScale(
              scale: isHovered ? 1.06 : 1,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                color: isHovered
                    ? colorAccent
                    : Theme.of(context).colorScheme.surface,
              )),
        ),
      );
    });
  }
}
