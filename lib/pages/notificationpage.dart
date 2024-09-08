import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/notificationprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  late NotificationProvider notificationProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
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
    return Stack(
      children: [
        Scaffold(
          appBar: Utils.myAppBarWithBack(context, "notification", true),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 80),
            physics: const BouncingScrollPhysics(),
            child: buildNotification(),
          ),
        ),
        /* AdMob Banner */
        Utils.showBannerAd(context),
      ],
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
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                children: [
                  Row(
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
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.textSmall,
                                  fontWeight: FontWeight.w400,
                                  color: gray),
                              trimCollapsedText: 'Read More',
                              colorClickableText: black,
                              trimMode: TrimMode.Line,
                              trimExpandedText: 'Read less',
                              lessStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.textSmall,
                                  fontWeight: FontWeight.w600,
                                  color: black),
                              moreStyle: GoogleFonts.montserrat(
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
                                  notificationProvider
                                          .notificationList?[index].id
                                          ?.toString() ??
                                      "",
                                  true);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.delete,
                                size: 18,
                                color: colorAccent,
                              ),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                  const SizedBox(height: 15),
                  notificationProvider.notificationList?.length == index + 1
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
