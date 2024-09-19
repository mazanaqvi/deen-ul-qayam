import 'dart:io';
import 'package:yourappname/pages/login.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/subscriptionprovider.dart';
import 'package:yourappname/subscription/allpayment.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/sharedpre.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webwidget/footerweb.dart';
import 'package:yourappname/webwidget/interactivecontainer.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../model/packagemodel.dart';

class Subscription extends StatefulWidget {
  final String? userName, userEmail, userMobileNo;
  const Subscription({
    super.key,
    this.userEmail,
    this.userName,
    this.userMobileNo,
  });

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  late SubscriptionProvider subscriptionProvider;
  SharedPre sharedPre = SharedPre();
  late ScrollController _scrollController;
  String? userName, userEmail, userMobileNo;

  @override
  void initState() {
    subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _fetchData(0);
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (subscriptionProvider.currentPage ?? 0) <
            (subscriptionProvider.totalPage ?? 0)) {
      printLog("load more====>");
      subscriptionProvider.setLoadMore(true);
      _fetchData(subscriptionProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("isMorePage  ======> ${subscriptionProvider.isMorePage}");
    printLog("currentPage ======> ${subscriptionProvider.currentPage}");
    printLog("totalPage   ======> ${subscriptionProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    await subscriptionProvider.getPackage((nextPage ?? 0) + 1);
    await _getUserData();
  }

  _getUserData() async {
    userName = await sharedPre.read("fullname");
    userEmail = await sharedPre.read("email");
    userMobileNo = await sharedPre.read("mobilenumber");
    printLog('getUserData userName ==> $userName');
    printLog('getUserData userEmail ==> $userEmail');
    printLog('getUserData userMobileNo ==> $userMobileNo');
  }

  @override
  void dispose() {
    super.dispose();
    subscriptionProvider.clearPackageList();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: Utils.webMainAppbar(),
        body: Utils.hoverItemWithPage(
          myWidget: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Utils.childPanel(context),
                const SizedBox(height: 50),
                buildTitleWeb(),
                const SizedBox(height: 20),
                buildPackage(),
                const SizedBox(height: 20),
                const FooterWeb(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTitle(),
              const SizedBox(height: 20),
              buildPackage(),
            ],
          ),
        ),
      );
    }
  }

/* Mobile UI Layout For Package Open */

  Widget buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Navigator.pop(context);
            subscriptionProvider.clearAllPaymentProvider();
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.surface,
              opticalSize: 0.8,
              weight: 0.8,
              size: 25,
            ),
          ),
        ),
        MyImage(
          width: 50,
          height: 50,
          imagePath: "ic_premium.png",
          color: Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(height: 20),
        MyText(
          color: colorPrimary,
          text: "unlockeverything",
          maxline: 1,
          fontwaight: FontWeight.w600,
          fontsizeNormal: Dimens.textlargeBig,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
          multilanguage: true,
        ),
        const SizedBox(height: 10),
        MyText(
          color: gray,
          text: "unlockeverythingdisc",
          maxline: 2,
          fontwaight: FontWeight.w500,
          fontsizeNormal: Dimens.textMedium,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
          multilanguage: true,
        ),
      ],
    );
  }

  Widget buildShimmer() {
    return ResponsiveGridList(
      minItemWidth: 160,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        5,
        (index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1.5,
                color: gray.withOpacity(0.20),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomWidget.roundrectborder(
                      height: 8,
                      width: 100,
                    ),
                    CustomWidget.roundrectborder(
                      height: 8,
                      width: 50,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomWidget.roundrectborder(
                  height: 8,
                ),
                SizedBox(height: 15),
                CustomWidget.circleborder(
                  height: 40,
                  width: 100,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

/* Web UI Layout For Package Open */

  Widget buildTitleWeb() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.subscriptions_rounded,
          color: Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(height: 20),
        MyText(
          color: Theme.of(context).colorScheme.surface,
          text: "unlockeverything",
          maxline: 1,
          fontwaight: FontWeight.w700,
          fontsizeNormal: Dimens.textExtraBig,
          fontsizeWeb: Dimens.textExtraBig,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
          multilanguage: true,
        ),
        const SizedBox(height: 10),
        MyText(
          color: Theme.of(context).colorScheme.surface,
          text: "unlockeverythingdisc",
          maxline: 2,
          fontwaight: FontWeight.w500,
          fontsizeNormal: Dimens.textTitle,
          fontsizeWeb: Dimens.textTitle,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.center,
          fontstyle: FontStyle.normal,
          multilanguage: true,
        ),
      ],
    );
  }

  Widget buildPackage() {
    return Consumer<SubscriptionProvider>(
        builder: (context, subscriptionprovider, child) {
      if (subscriptionprovider.loading && !subscriptionprovider.loadmore) {
        return kIsWeb ? Utils.pageLoader() : buildShimmer();
      } else {
        if (subscriptionprovider.packageModel.status == 200 &&
            subscriptionprovider.packageList != null) {
          if ((subscriptionprovider.packageList?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                kIsWeb ? buildPackageListWeb() : buildPackageListMobile(),
                if (subscriptionprovider.loadmore)
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
            return const NoData();
          }
        } else {
          return const NoData();
        }
      }
    });
  }

  Widget buildPackageListMobile() {
    return ResponsiveGridList(
      minItemWidth: 160,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        subscriptionProvider.packageList?.length ?? 0,
        (index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              _checkAndPay(subscriptionProvider.packageList ?? [], index);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              margin:
                  (kIsWeb) ? const EdgeInsets.fromLTRB(20, 0, 20, 20) : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1.5,
                  color: gray.withOpacity(0.20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        color: Theme.of(context).colorScheme.surface,
                        text: subscriptionProvider
                                .packageModel.result?[index].name
                                .toString()
                                .toUpperCase() ??
                            "",
                        maxline: 1,
                        fontwaight: FontWeight.w700,
                        fontsizeNormal: Dimens.textTitle,
                        fontsizeWeb: Dimens.textBig,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: false,
                      ),
                      MyText(
                        color: green,
                        text:
                            "${Constant.currencyCode} ${subscriptionProvider.packageList?[index].price.toString() ?? ""}",
                        maxline: 1,
                        fontwaight: FontWeight.w700,
                        fontsizeNormal: Dimens.textBig,
                        fontsizeWeb: Dimens.textBig,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                        multilanguage: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyText(
                    color: gray,
                    text:
                        "Ads Free Content for ${subscriptionProvider.packageList?[index].time.toString() ?? ""} ${subscriptionProvider.packageList?[index].type.toString() ?? ""}",
                    maxline: 1,
                    fontwaight: FontWeight.w400,
                    fontsizeNormal: Dimens.textSmall,
                    fontsizeWeb: Dimens.textMedium,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    multilanguage: false,
                  ),
                  const SizedBox(height: 15),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     _checkAndPay(
                  //         subscriptionProvider.packageList ?? [], index);
                  //   },
                  //   child: Container(
                  //     width: 100,
                  //     height: 40,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(50),
                  //       color:
                  //           (subscriptionProvider.packageList?[index].isBuy ==
                  //                   1)
                  //               ? colorAccent
                  //               : colorPrimary,
                  //     ),
                  //     child: MyText(
                  //       color:
                  //           (subscriptionProvider.packageList?[index].isBuy ==
                  //                   1)
                  //               ? black
                  //               : white,
                  //       text: (subscriptionProvider.packageList?[index].isBuy ==
                  //               1)
                  //           ? "active"
                  //           : "subscribe",
                  //       maxline: 1,
                  //       fontwaight:
                  //           (subscriptionProvider.packageList?[index].isBuy ==
                  //                   1)
                  //               ? FontWeight.w600
                  //               : FontWeight.w500,
                  //       fontsizeNormal: Dimens.textSmall,
                  //       fontsizeWeb: Dimens.textTitle,
                  //       overflow: TextOverflow.ellipsis,
                  //       textalign: TextAlign.center,
                  //       fontstyle: FontStyle.normal,
                  //       multilanguage: true,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPackageListWeb() {
    return ResponsiveGridList(
      minItemWidth: 160,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        subscriptionProvider.packageList?.length ?? 0,
        (index) {
          return InkWell(
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              _checkAndPay(subscriptionProvider.packageList ?? [], index);
            },
            child: InteractiveContainer(child: (isHovered) {
              return Align(
                alignment: Alignment.center,
                child: AnimatedScale(
                  scale: isHovered ? 1.1 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * 0.40
                        : MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isHovered ? colorPrimary : transparentColor,
                      border: Border.all(
                        width: 1.5,
                        color: isHovered ? colorAccent : gray.withOpacity(0.20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                              color: isHovered
                                  ? white
                                  : Theme.of(context).colorScheme.surface,
                              text: subscriptionProvider
                                      .packageModel.result?[index].name
                                      .toString()
                                      .toUpperCase() ??
                                  "",
                              maxline: 1,
                              fontwaight: FontWeight.w700,
                              fontsizeNormal: Dimens.textTitle,
                              fontsizeWeb: Dimens.textlargeBig,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                              multilanguage: false,
                            ),
                            MyText(
                              color: isHovered ? white : green,
                              text:
                                  "${Constant.currencyCode} ${subscriptionProvider.packageList?[index].price.toString() ?? ""}",
                              maxline: 1,
                              fontwaight: FontWeight.w700,
                              fontsizeNormal: Dimens.textBig,
                              fontsizeWeb: Dimens.textBig,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                              multilanguage: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyText(
                          color: isHovered ? white : gray,
                          text:
                              "Get all the premium courses for ${subscriptionProvider.packageList?[index].time.toString() ?? ""} ${subscriptionProvider.packageList?[index].type.toString() ?? ""}",
                          maxline: 1,
                          fontwaight: FontWeight.w400,
                          fontsizeNormal: Dimens.textSmall,
                          fontsizeWeb: Dimens.textMedium,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                          multilanguage: false,
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            _checkAndPay(
                                subscriptionProvider.packageList ?? [], index);
                          },
                          child: Container(
                            width: 100,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: isHovered
                                  ? colorAccent
                                  : (subscriptionProvider
                                              .packageList?[index].isBuy ==
                                          1)
                                      ? colorAccent
                                      : colorPrimary,
                            ),
                            child: MyText(
                              color: isHovered
                                  ? black
                                  : (subscriptionProvider
                                              .packageList?[index].isBuy ==
                                          1)
                                      ? black
                                      : white,
                              text: (subscriptionProvider
                                          .packageList?[index].isBuy ==
                                      1)
                                  ? "active"
                                  : "subscribe",
                              maxline: 1,
                              fontwaight: (subscriptionProvider
                                          .packageList?[index].isBuy ==
                                      1)
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontsizeNormal: Dimens.textSmall,
                              fontsizeWeb: Dimens.textTitle,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.center,
                              fontstyle: FontStyle.normal,
                              multilanguage: true,
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
    );
  }

/* Check And Pay */

  _checkAndPay(List<Result>? packageList, int index) async {
    if (Constant.userID != null) {
      for (var i = 0; i < (packageList?.length ?? 0); i++) {
        if (packageList?[i].isBuy == 1) {
          printLog("<============= Purchaged =============>");
          Utils.showSnackbar(context, "fail", "already_purchased", true);
          return;
        }
      }
      if (packageList?[index].isBuy == 0) {
        if ((userName ?? "").isEmpty ||
            (userEmail ?? "").isEmpty ||
            (userMobileNo ?? "").isEmpty) {
          if (kIsWeb) {
            updateDataDialogWeb(
              isNameReq: (userName ?? "").isEmpty,
              isEmailReq: (userEmail ?? "").isEmpty,
              isMobileReq: (userMobileNo ?? "").isEmpty,
            );
            return;
          } else {
            updateDataDialogMobile(
              isNameReq: (userName ?? "").isEmpty,
              isEmailReq: (userEmail ?? "").isEmpty,
              isMobileReq: (userMobileNo ?? "").isEmpty,
            );
            return;
          }
        }
        /* Update Required data for payment */
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AllPayment(
                payType: 'Package',
                contentType: "",
                itemId: packageList?[index].id.toString() ?? '',
                price: packageList?[index].price.toString() ?? '',
                itemTitle: packageList?[index].name.toString() ?? '',
                typeId: '',
                videoType: '',
                productPackage: (!kIsWeb)
                    ? (Platform.isIOS
                        ? (packageList?[index].iosProductPackage.toString() ??
                            '')
                        : (packageList?[index]
                                .androidProductPackage
                                .toString() ??
                            ''))
                    : '',
                currency: Constant.currency,
                coin: '',
              );
            },
          ),
        );
      }
    } else {
      await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Login(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  updateDataDialogMobile({
    required bool isNameReq,
    required bool isEmailReq,
    required bool isMobileReq,
  }) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final mobileController = TextEditingController();
    if (!context.mounted) return;
    dynamic result = await showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: colorPrimary,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Utils.dataUpdateDialog(
              context,
              isNameReq: isNameReq,
              isEmailReq: isEmailReq,
              isMobileReq: isMobileReq,
              nameController: nameController,
              emailController: emailController,
              mobileController: mobileController,
            ),
          ],
        );
      },
    );
    if (result != null) {
      await _getUserData();
      Future.delayed(Duration.zero).then((value) {
        if (!context.mounted) return;
        setState(() {});
      });
    }
  }

  updateDataDialogWeb({
    required bool isNameReq,
    required bool isEmailReq,
    required bool isMobileReq,
  }) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final mobileController = TextEditingController();
    if (!context.mounted) return;
    dynamic result = await showDialog<dynamic>(
      context: context,
      barrierColor: transparentColor,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: colorPrimaryDark,
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(
              minWidth: 400,
              maxWidth: 500,
              minHeight: 400,
              maxHeight: 450,
            ),
            child: Wrap(
              children: [
                Utils.dataUpdateDialog(
                  context,
                  isNameReq: isNameReq,
                  isEmailReq: isEmailReq,
                  isMobileReq: isMobileReq,
                  nameController: nameController,
                  emailController: emailController,
                  mobileController: mobileController,
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result != null) {
      await _getUserData();
      Future.delayed(Duration.zero).then((value) {
        if (!context.mounted) return;
        setState(() {});
      });
    }
  }
}
