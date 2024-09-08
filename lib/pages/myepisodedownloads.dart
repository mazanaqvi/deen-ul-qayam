import 'dart:io';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/showdownloadprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MyEpisodeDownloads extends StatefulWidget {
  final int position, courseId;
  const MyEpisodeDownloads(this.position, this.courseId, {super.key});

  @override
  State<MyEpisodeDownloads> createState() => _MyEpisodeDownloadsState();
}

class _MyEpisodeDownloadsState extends State<MyEpisodeDownloads> {
  late ShowDownloadProvider downloadProvider;
  /* Create Instance And Initilize Hive */
  late Box<DownloadItem> downloadBox;
  late Box<ChapterItem> seasonBox;
  late Box<EpisodeItem> episodeBox;
  List<ChapterItem>? mySeasonList;
  List<EpisodeItem>? myEpisodeList;

  @override
  void initState() {
    downloadProvider =
        Provider.of<ShowDownloadProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  _getData() async {
    /* Initilize Hive */
    if (Constant.userID != null) {
      downloadBox = Hive.box<DownloadItem>(
          '${Constant.hiveDownloadBox}_${Constant.userID}');
      seasonBox = Hive.box<ChapterItem>(
          '${Constant.hiveSeasonDownloadBox}_${Constant.userID}');
      episodeBox = Hive.box<EpisodeItem>(
          '${Constant.hiveEpiDownloadBox}_${Constant.userID}');
    } else {
      downloadBox = Hive.box<DownloadItem>(Constant.hiveDownloadBox);
      seasonBox = Hive.box<ChapterItem>(Constant.hiveSeasonDownloadBox);
      episodeBox = Hive.box<EpisodeItem>(Constant.hiveEpiDownloadBox);
    }
    mySeasonList = [];
    mySeasonList = seasonBox.values.where((seasonItem) {
      return (seasonItem.courseId == widget.courseId);
    }).toList();
    printLog("myChapterList =================> ${mySeasonList?.length}");

    myEpisodeList = [];
    if ((mySeasonList?.length ?? 0) > 0) {
      await downloadProvider.setSelectedSeason(0);

      myEpisodeList = episodeBox.values.where((episodeItem) {
        return (episodeItem.courseId == widget.courseId &&
            episodeItem.chapterId == mySeasonList?[0].id);
      }).toList();
      printLog("myVideoList  ================> ${myEpisodeList?.length}");
    }
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    downloadProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.myAppBarWithBack(context, "videos", true),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints.expand(),
              padding: EdgeInsets.only(
                  top: (Dimens.tabSeasonHeight + 12), bottom: 10),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildPage(),
                    ),
                  ),
                  /* AdMob Banner */
                  Container(
                    child: Utils.showBannerAd(context),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: _buildSeason(mySeasonList),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Consumer<ShowDownloadProvider>(
      builder: (context, downloadProvider, child) {
        if (downloadProvider.loading) {
          return Utils.pageLoader();
        } else {
          if (myEpisodeList != null) {
            if ((myEpisodeList?.length ?? 0) > 0) {
              return AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myEpisodeList?.length ?? 0,
                itemBuilder: (BuildContext context, int position) {
                  return videoDownloadItem(position);
                },
              );
            } else {
              return const NoData();
            }
          } else {
            return const NoData();
          }
        }
      },
    );
  }

  Widget _buildSeason(List<ChapterItem>? seasonList) {
    return Consumer<ShowDownloadProvider>(
      builder: (context, showDownloadProvider, child) {
        return Container(
          height: Dimens.tabSeasonHeight,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: AlignedGridView.count(
              shrinkWrap: true,
              crossAxisCount: 1,
              crossAxisSpacing: 0,
              mainAxisSpacing: 10,
              itemCount: (seasonList?.length ?? 0),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            printLog("index ===========> $index");
                            myEpisodeList = [];
                            await _getEpisodeBySeason(
                                index, seasonList?[index].id ?? 0);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            alignment: Alignment.center,
                            child: MyText(
                              color: (showDownloadProvider.seasonClickIndex ==
                                      index)
                                  ? Theme.of(context).colorScheme.surface
                                  : transparentColor,
                              text: seasonList?[index].name ?? "-",
                              fontsizeNormal: 13,
                              fontsizeWeb: 15,
                              fontstyle: FontStyle.normal,
                              fontwaight: FontWeight.w600,
                              multilanguage: false,
                              maxline: 1,
                              overflow: TextOverflow.ellipsis,
                              textalign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 2,
                      constraints: const BoxConstraints(minWidth: 50),
                      decoration: Utils.setBackground(
                          (showDownloadProvider.seasonClickIndex == index)
                              ? colorPrimary
                              : gray,
                          2),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  _getEpisodeBySeason(int position, int seasonId) async {
    await downloadProvider.setSelectedSeason(position);
    myEpisodeList = [];
    myEpisodeList = episodeBox.values.where((episodeItem) {
      return (episodeItem.courseId == widget.courseId &&
          episodeItem.chapterId == seasonId);
    }).toList();
    printLog("myvideoList =======> ${myEpisodeList?.length}");
  }

  Widget videoDownloadItem(position) {
    return InkWell(
      onTap: () {
        openPlayer(position);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyText(
                color: colorPrimary,
                fontsizeNormal: Dimens.textBig,
                maxline: 2,
                fontwaight: FontWeight.w600,
                text: "${(position + 1)}.",
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
            const SizedBox(width: 10),
            Expanded(
              child: MyText(
                  color: colorPrimary,
                  fontsizeNormal: Dimens.textDesc,
                  maxline: 3,
                  fontwaight: FontWeight.w600,
                  text: myEpisodeList?[position].title ?? "",
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal),
            ),
            const SizedBox(width: 10),
            /* Download Delete */
            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () async {
                printLog("Clicked on position =============> $position");
                bool isDeleted = await deleteFromDownloads(position);
                printLog("isDeleted =============> $isDeleted");
                // if (isDeleted) {
                //   if (!mounted) return;
                //   Navigator.pop(context);
                // }
              },
              child: _buildDialogItems(
                icon: "ic_delete.png",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> deleteFromDownloads(position) async {
    printLog("deleteFromDownloads pos ===> $position");
    printLog("deleteFromDownloads id ====> ${downloadBox.get(position)?.id}");
    if (!mounted) return false;
    /* Remove from Hive START ***************** */
    printLog(
        "downloadBox length :======> ${downloadBox.values.toList().length}");
    printLog("seasonBox length :========> ${seasonBox.values.toList().length}");
    printLog(
        "episodeBox length :=======> ${episodeBox.values.toList().length}");
    /* Episode Delete */
    for (int i = 0; i < episodeBox.values.toList().length; i++) {
      final myEpisodeData = episodeBox.getAt(i);
      printLog("myEpisodeData ====> $myEpisodeData");
      if (myEpisodeData != null &&
          myEpisodeData.id == myEpisodeList?[position].id &&
          myEpisodeData.courseId == myEpisodeList?[position].courseId) {
        printLog(
            "myDownloadsList showId ====> ${myEpisodeList?[position].courseId}");
        printLog("myEpisodeData showId ======> ${myEpisodeData.courseId}");
        if (myEpisodeData.savedFile != null && myEpisodeData.savedFile != "") {
          try {
            File filePath = File(myEpisodeData.savedFile ?? "");
            File filePortImgPath = File(myEpisodeData.thumbnailImg ?? "");
            File fileLandImgPath = File(myEpisodeData.landscapeImg ?? "");
            printLog("myEpisodeData filePath =============> $filePath");
            printLog("myEpisodeData filePortImgPath ======> $filePortImgPath");
            printLog("myEpisodeData fileLandImgPath ======> $fileLandImgPath");
            bool? isFileExists = await filePath.exists();
            bool? isPortImgFileExists = await filePortImgPath.exists();
            bool? isLandImgFileExists = await fileLandImgPath.exists();
            printLog("myEpisodeData isFileExists =========> $isFileExists");
            printLog(
                "myEpisodeData isPortImgFileExists ==> $isPortImgFileExists");
            printLog(
                "myEpisodeData isLandImgFileExists ==> $isLandImgFileExists");
            if (isFileExists) {
              await filePath.delete();
            }
            if (isPortImgFileExists) {
              await filePortImgPath.delete();
            }
            if (isLandImgFileExists) {
              await fileLandImgPath.delete();
            }
          } on Exception catch (exception) {
            printLog("Episode DeleteFile Exception ==> $exception");
          }
        }
        await episodeBox.deleteAt(i);
        if (episodeBox.isEmpty) {
          episodeBox.clear();
          if ((myEpisodeData.savedDir ?? "").isNotEmpty) {
            try {
              String dirPath = myEpisodeData.savedDir ?? "";
              printLog("dirPath ==> $dirPath");
              File dirFolder = File(dirPath);
              printLog("File existsSync ==> ${dirFolder.existsSync()}");
              dirFolder.deleteSync(recursive: true);
            } on Exception catch (exception) {
              printLog("Episode Delete Exception ==> $exception");
            }
          }
        }
      }
    }
    if (episodeBox.values.toList().isEmpty) {
      episodeBox.clear();

      /* Season Delete */
      for (int i = 0; i < seasonBox.values.toList().length; i++) {
        final mySeasonData = seasonBox.getAt(i);
        if (mySeasonData != null &&
            mySeasonData.id ==
                mySeasonList?[downloadProvider.seasonClickIndex ?? 0].id &&
            mySeasonData.courseId ==
                mySeasonList?[downloadProvider.seasonClickIndex ?? 0]
                    .courseId) {
          printLog(
              "myDownloadsList showId ====> ${mySeasonList?[downloadProvider.seasonClickIndex ?? 0].courseId}");
          printLog("mySeasonData showId =======> ${mySeasonData.courseId}");
          await seasonBox.deleteAt(i);
        }
      }
      if (seasonBox.values.toList().isEmpty) {
        seasonBox.clear();
      }
    }
    printLog("episodeBox length :=======> ${episodeBox.length}");
    printLog(
        "episodeBox length :=======> ${episodeBox.values.toList().length}");
    printLog("seasonBox length :========> ${seasonBox.values.toList().length}");
    if (downloadBox.values.toList().isNotEmpty &&
        (episodeBox.values.toList().isEmpty || episodeBox.isEmpty)) {
      /* Video/Show Delete */
      for (int i = 0; i < downloadBox.values.toList().length; i++) {
        final myDownloadData = downloadBox.getAt(i);
        if (myDownloadData != null && myDownloadData.id == widget.courseId) {
          printLog("myDownloadsList showId =======> ${widget.courseId}");
          printLog("myDownloadData showId ========> ${myDownloadData.id}");

          await downloadBox.deleteAt(i);
          if (downloadBox.isEmpty) {
            downloadBox.clear();
            if ((myDownloadData.savedDir ?? "").isNotEmpty) {
              try {
                String dirPath = myDownloadData.savedDir ?? "";
                printLog("dirPath ==> $dirPath");
                File dirFolder = File(dirPath);
                printLog("File existsSync ==> ${dirFolder.existsSync()}");
                dirFolder.deleteSync(recursive: true);
              } on Exception catch (exception) {
                printLog("All Delete Exception ==> $exception");
              }
            }
          }
        }
      }
      printLog("downloadBox length :======> ${downloadBox.length}");
      if (downloadBox.length == 0) {
        downloadBox.clear();
        if (!mounted) return false;
        Navigator.pop(context);
      }
    }
    await downloadProvider.notifyProvider();
    /* ******************* Remove from Hive END */
    myEpisodeList?.removeAt(position);
    setState(() {});
    return true;
  }

  Widget _buildDialogItems({
    required String icon,
  }) {
    return Container(
      height: Dimens.minHtDialogContent,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: MyImage(
        width: Dimens.dialogIconSize,
        height: Dimens.dialogIconSize,
        imagePath: icon,
        fit: BoxFit.contain,
        color: gray,
      ),
    );
  }

  openPlayer(position) async {
    Utils.openPlayer(
      context: context,
      type: "download",
      secreateKey: myEpisodeList?[position].securityKey ?? "",
      videoId: myEpisodeList?[position].id ?? 0,
      videoUrl: myEpisodeList?[position].videoUrl.toString() ?? "",
      vUploadType: myEpisodeList?[position].videoType.toString() ?? "",
      videoThumb: myEpisodeList?[position].thumbnailImg.toString() ?? "",
      courseId: myEpisodeList?[position].courseId ?? 0,
      chepterId: myEpisodeList?[position].chapterId ?? 0,
    );
  }
}
