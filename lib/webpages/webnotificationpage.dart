import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/generalprovider.dart';
import 'package:yourappname/provider/notificationprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class WebNotificationPage extends StatefulWidget {
  const WebNotificationPage({super.key});

  @override
  State<WebNotificationPage> createState() => WebNotificationPageState();
}

class WebNotificationPageState extends State<WebNotificationPage> {
  late NotificationProvider notificationProvider;
  late GeneralProvider generalProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    _fetchData(0);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (notificationProvider.currentPage ?? 0) <
            (notificationProvider.totalPage ?? 0)) {
      printLog("load more====>");
      _fetchData(notificationProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    printLog("isMorePage  ======> ${notificationProvider.isMorePage}");
    printLog("currentPage ======> ${notificationProvider.currentPage}");
    printLog("totalPage   ======> ${notificationProvider.totalPage}");
    printLog("nextpage   ======> $nextPage");
    printLog("Call MyCourse");
    printLog("Pageno:== ${(nextPage ?? 0) + 1}");
    await notificationProvider.getNotification((nextPage ?? 0) + 1);
  }

  @override
  void dispose() {
    notificationProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        padding: const EdgeInsets.all(15),
        physics: const BouncingScrollPhysics(),
        child: buildNotification(),
      ),
    );
  }

  Widget buildNotification() {
    return Consumer<NotificationProvider>(
        builder: (context, notificationprovider, child) {
      if (notificationprovider.loading && !notificationprovider.loadMore) {
        return notificationShimmer();
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: "notification",
                    fontsizeNormal: Dimens.textlargeBig,
                    fontsizeWeb: Dimens.textlargeBig,
                    multilanguage: true,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal,
                    fontwaight: FontWeight.w600),
                InkWell(
                  hoverColor: transparentColor,
                  highlightColor: transparentColor,
                  onTap: () async {
                    await generalProvider.getNotificationSectionShowHide(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.surface,
                      size: 25,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            notificationList(),
            if (notificationProvider.loadMore)
              SizedBox(
                height: 50,
                child: Utils.pageLoader(),
              )
            else
              const SizedBox.shrink(),
          ],
        );
      }
    });
  }

  Widget notificationList() {
    if (notificationProvider.notificationModel.status == 200 &&
        notificationProvider.notificationList != null) {
      if ((notificationProvider.notificationList?.length ?? 0) > 0) {
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: notificationProvider.notificationList?.length ?? 0,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: gray),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: MyNetworkImage(
                        imgWidth: 35,
                        imgHeight: 35,
                        imageUrl: notificationProvider
                                .notificationList?[index].image
                                .toString() ??
                            "",
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: notificationProvider
                                    .notificationList?[index].title
                                    ?.toString() ??
                                "",
                            fontsizeNormal: Dimens.textDesc,
                            multilanguage: false,
                            fontsizeWeb: Dimens.textDesc,
                            maxline: 2,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.left,
                            fontstyle: FontStyle.normal,
                            fontwaight: FontWeight.w600),
                        const SizedBox(height: 8),
                        ReadMoreText(
                          "${notificationProvider.notificationList?[index].message?.toString() ?? ""}  ",
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
                              color: colorAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Consumer<NotificationProvider>(
                      builder: (context, notificationprovider, child) {
                    if (notificationprovider.position == index &&
                        notificationprovider.readnotificationloading) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: colorPrimary,
                          strokeWidth: 1,
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () async {
                          await notificationProvider.getReadNotification(
                              index,
                              notificationProvider.notificationList?[index].id
                                      ?.toString() ??
                                  "",
                              true);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: colorPrimary, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.delete,
                            size: 18,
                            color: white,
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            );
          },
        );
      } else {
        return const NoData();
      }
    } else {
      return const NoData();
    }
  }

  Widget notificationShimmer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomWidget.circular(
                width: 55,
                height: 55,
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget.roundrectborder(
                    width: 250,
                    height: 8,
                  ),
                  SizedBox(height: 5),
                  CustomWidget.roundrectborder(
                    width: 250,
                    height: 8,
                  ),
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}
