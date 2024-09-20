import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yourappname/pages/detail.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/mycourseprovider.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:path/path.dart' as path;

class MyCourse extends StatefulWidget {
  const MyCourse({Key? key}) : super(key: key);

  @override
  State<MyCourse> createState() => MyCourseState();
}

class MyCourseState extends State<MyCourse> {
  late MyCourseProvider myCourseProvider;
  late ScrollController _scrollController;
  double? width;
  double? height;

  /* Download Certificate */
  final ReceivePort _port = ReceivePort();
  dynamic _tasks;
  int progress = 0;

  @override
  void initState() {
    if (!kIsWeb) {
      /* Download init ****/
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback, step: 1);
      /* ****/
    }
    myCourseProvider = Provider.of<MyCourseProvider>(context, listen: false);
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
        (myCourseProvider.currentPage ?? 0) <
            (myCourseProvider.totalPage ?? 0)) {
      await myCourseProvider.setLoadMore(true);
      _fetchData(myCourseProvider.currentPage ?? 0);
    }
  }

  Future<void> _fetchData(int? nextPage) async {
    await myCourseProvider.getMyCourse((nextPage ?? 0) + 1);
    await myCourseProvider.setLoadMore(false);
  }

  @override
  void dispose() {
    myCourseProvider.clearProvider();
    super.dispose();
  }

  /* ======== Download Start=========== */

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as int;
      final progress = data[2] as int;

      printLog(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        printLog(task.toString());

        if (progress > 0) {
          printLog("progress==>${progress.toString()}%");
          myCourseProvider.setDownloadProgress(progress);
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    printLog(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    if (!kIsWeb) {
      IsolateNameServer.lookupPortByName(Constant.videoDownloadPort)
          ?.send([id, status, progress]);
    }
  }

/* ======== Download End =========== */

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: colorPrimary,
        ),
        centerTitle: false,
        backgroundColor: colorPrimary,
        automaticallyImplyLeading: false,
        title: MyText(
            color: white,
            text: "mycourse",
            fontsizeNormal: Dimens.textTitle,
            maxline: 1,
            fontwaight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.center,
            fontstyle: FontStyle.normal,
            multilanguage: true),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: Column(
          children: [
            buildPage(),
          ],
        ),
      ),
    );
  }

  Widget buildPage() {
    return Consumer<MyCourseProvider>(
        builder: (context, mycourseProvider, child) {
      if (myCourseProvider.loading && !myCourseProvider.loadMore) {
        return buildShimmer();
      } else {
        if (myCourseProvider.myCourseModel.status == 200 &&
            myCourseProvider.mycourseList != null) {
          if ((myCourseProvider.mycourseList?.length ?? 0) > 0) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  mycourselist(),
                  if (mycourseProvider.loadMore)
                    Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Utils.pageLoader(),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
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

  Widget mycourselist() {
    return MediaQuery.removePadding(
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
          myCourseProvider.mycourseList?.length ?? 0,
          (index) {
            return InkWell(
              onTap: () {
                AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                    () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return Detail(
                            courseId: myCourseProvider.mycourseList?[index].id
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
                });
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
                            imageUrl: myCourseProvider
                                    .mycourseList?[index].thumbnailImg
                                    .toString() ??
                                "",
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                  color: Theme.of(context).colorScheme.surface,
                                  text: myCourseProvider
                                          .mycourseList?[index].description
                                          .toString() ??
                                      "",
                                  fontsizeNormal: Dimens.textBigSmall,
                                  fontwaight: FontWeight.w600,
                                  maxline: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(height: 8),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     MyText(
                              //         color: gray,
                              //         text: Utils.kmbGenerator(
                              //           int.parse(myCourseProvider
                              //                   .mycourseList?[index].totalView
                              //                   .toString() ??
                              //               ""),
                              //         ),
                              //         fontsizeNormal: Dimens.textSmall,
                              //         fontwaight: FontWeight.w500,
                              //         maxline: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //         textalign: TextAlign.left,
                              //         fontstyle: FontStyle.normal),
                              //     const SizedBox(width: 5),
                              //     // MyText(
                              //     //     color: gray,
                              //     //     text: "students",
                              //     //     fontsizeNormal: Dimens.textSmall,
                              //     //     fontwaight: FontWeight.w500,
                              //     //     maxline: 1,
                              //     //     multilanguage: true,
                              //     //     overflow: TextOverflow.ellipsis,
                              //     //     textalign: TextAlign.left,
                              //     //     fontstyle: FontStyle.normal),
                              //   ],
                              // ),
                              // const SizedBox(height: 8),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     MyRating(
                              //       size: 13,
                              //       rating: double.parse(myCourseProvider
                              //               .mycourseList?[index].avgRating
                              //               .toString() ??
                              //           ""),
                              //       spacing: 2,
                              //     ),
                              //     const SizedBox(width: 5),
                              //     MyText(
                              //         color: colorAccent,
                              //         text:
                              //             "${double.parse(myCourseProvider.mycourseList?[index].avgRating.toString() ?? "")}",
                              //         fontsizeNormal: Dimens.textBigSmall,
                              //         fontwaight: FontWeight.w600,
                              //         maxline: 2,
                              //         overflow: TextOverflow.ellipsis,
                              //         textalign: TextAlign.left,
                              //         fontstyle: FontStyle.normal),
                              //   ],
                              // ),
                              // Hiding the Download Certificate Option
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  myCourseProvider.mycourseList?.length == index + 1
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
    );
  }

  Widget buildShimmer() {
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
                            height: 100,
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
                  const SizedBox(height: 20),
                  myCourseProvider.mycourseList?.length == index + 1
                      ? const SizedBox.shrink()
                      : Container(
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

/* Generate Certificate Button With Api Calling Start */

  Widget generateCertificate(courseId) {
    if ((myCourseProvider.mycourseList?[0].isDownloadCertificate ?? 0) == 1 &&
        Constant.userID != null) {
      return InkWell(
        highlightColor: transparentColor,
        hoverColor: transparentColor,
        splashColor: transparentColor,
        focusColor: transparentColor,
        onTap: () async {
          getCertificateApiWithDownload(courseId);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: MyText(
              color: colorPrimary,
              fontsizeNormal: Dimens.textSmall,
              maxline: 1,
              fontwaight: FontWeight.w600,
              multilanguage: true,
              overflow: TextOverflow.ellipsis,
              text: "downloadcertificate",
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<String> prepareSaveDir() async {
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

  Future<String?> _getSavedDir() async {
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

  getCertificateApiWithDownload(courseId) async {
    File? mTargetFile;
    String? localPath;
    String? mFileName = '${("certificate")}' '${(courseId)}';
    try {
      localPath = await prepareSaveDir();
      printLog("localPath ====> $localPath");
      mTargetFile = File(path.join(localPath, '$mFileName.${("pdf")}'));
    } catch (e) {
      printLog("saveVideoStorage Exception ===> $e");
    }
    printLog("mFileName ========> $mFileName");
    printLog("mTargetFile ========> $mTargetFile");
    if (!mounted) return;
    Utils().showProgress(context, "Generate Certificate...");
    await myCourseProvider.fetchCertificate(courseId);

    if (!myCourseProvider.certificateDownloading) {
      if (myCourseProvider.certificateModel.status == 200 &&
          myCourseProvider.certificateModel.result != null) {
        if (!mounted) return;
        Utils().hideProgress(context);
        if (mTargetFile != null) {
          myCourseProvider.downloadCertificate(
              myCourseProvider.certificateModel.result?.pdfUrl ?? "",
              localPath,
              mTargetFile);
          printLog("mTargetFile length ========> ${mTargetFile.length()}");
        }
      } else {
        if (!mounted) return;
        Utils().hideProgress(context);
        Utils.showSnackbar(context, "fail", "somethingwentwronge", true);
      }
    }
  }

/* Download certicicate End */
}
