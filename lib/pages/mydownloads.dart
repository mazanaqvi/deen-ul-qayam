import 'dart:io';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/pages/myepisodedownloads.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/videodownloadprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/myfileimage.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MyDownloads extends StatefulWidget {
  const MyDownloads({super.key});

  @override
  State<MyDownloads> createState() => _MyDownloadsState();
}

class _MyDownloadsState extends State<MyDownloads> {
  /* Create Instance And Initilize Hive */
  late Box<DownloadItem> downloadBox;
  late Box<ChapterItem> seasonBox;
  late Box<EpisodeItem> episodeBox;
  List<DownloadItem>? myDownloadsList;

  @override
  void initState() {
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
    myDownloadsList = [];
    myDownloadsList = downloadBox.values.toList();
    printLog("myDownloadsList =================> ${myDownloadsList?.length}");
    Future.delayed(Duration.zero).then((value) {
      if (!context.mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.myAppBarWithBack(context, "downloads", true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: _buildDownloadList(),
              ),
            ),
            /* AdMob Banner */
            Container(
              child: Utils.showBannerAd(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadList() {
    return Consumer<VideoDownloadProvider>(
      builder: (context, downloadProvider, child) {
        if (myDownloadsList != null) {
          if ((myDownloadsList?.length ?? 0) > 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myDownloadsList?.length ?? 0,
                itemBuilder: (BuildContext context, int position) {
                  return courseDownloadItem(position);
                },
              ),
            );
          } else {
            return const NoData();
          }
        } else {
          return const NoData();
        }
      },
    );
  }

  Widget courseDownloadItem(position) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MyEpisodeDownloads(
                position,
                myDownloadsList?[position].id ?? 0,
              );
            },
          ),
        );
        _getData();
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
                  child: MyFileImage(
                    width: 115,
                    height: 100,
                    imagePath: myDownloadsList?[position].landscapeImg ?? "",
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
                          text: myDownloadsList?[position].title ?? "",
                          fontsizeNormal: Dimens.textBigSmall,
                          fontwaight: FontWeight.w600,
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(
                              color: gray,
                              text: Utils.kmbGenerator(
                                  myDownloadsList?[position].totalView ?? 0),
                              fontsizeNormal: Dimens.textSmall,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyRating(
                            size: 13,
                            rating: double.parse(myDownloadsList?[position]
                                    .avgRating
                                    .toString() ??
                                ""),
                            spacing: 2,
                          ),
                          const SizedBox(width: 5),
                          MyText(
                              color: colorAccent,
                              text:
                                  "${double.parse(myDownloadsList?[position].avgRating.toString() ?? "")}",
                              fontsizeNormal: Dimens.textBigSmall,
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
          myDownloadsList?.length == position + 1
              ? const SizedBox.shrink()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.9,
                  color: gray.withOpacity(0.15),
                ),
        ],
      ),
    );
  }

  Future<bool> deleteFromDownloads(position) async {
    printLog("deleteFromDownloads pos ===> $position");
    printLog("deleteFromDownloads id ====> ${downloadBox.get(position)}");
    if (!mounted) return false;
    /* Remove from Hive START ***************** */
    printLog(
        "downloadBox length :======> ${downloadBox.values.toList().length}");
    printLog("seasonBox length :========> ${seasonBox.values.toList().length}");
    printLog(
        "episodeBox length :=======> ${episodeBox.values.toList().length}");
    if (downloadBox.values.toList().isNotEmpty) {
      /* Video/Show Delete */
      for (int i = 0; i < downloadBox.values.toList().length; i++) {
        final myDownloadData = downloadBox.getAt(i);
        if (myDownloadData != null &&
            myDownloadData.id == myDownloadsList?[position].id) {
          printLog(
              "myDownloadsList showId =======> ${myDownloadsList?[position].id}");
          printLog("myDownloadData showId ========> ${myDownloadData.id}");

          if (myDownloadData.savedFile != null &&
              myDownloadData.savedFile != "") {
            try {
              File filePath = File(myDownloadData.savedFile ?? "");
              File filePortImgPath = File(myDownloadData.thumbnailImg ?? "");
              File fileLandImgPath = File(myDownloadData.landscapeImg ?? "");
              printLog("myDownloadData filePath =============> $filePath");
              printLog(
                  "myDownloadData filePortImgPath ======> $filePortImgPath");
              printLog(
                  "myDownloadData fileLandImgPath ======> $fileLandImgPath");
              bool? isFileExists = await filePath.exists();
              bool? isPortImgFileExists = await filePortImgPath.exists();
              bool? isLandImgFileExists = await fileLandImgPath.exists();
              printLog("myDownloadData isFileExists =========> $isFileExists");
              printLog(
                  "myDownloadData isPortImgFileExists ==> $isPortImgFileExists");
              printLog(
                  "myDownloadData isLandImgFileExists ==> $isLandImgFileExists");
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
              printLog("Video DeleteFile Exception ==> $exception");
            }
          }
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
      if (downloadBox.values.toList().isEmpty) {
        downloadBox.clear();
      }
    }
    /* ******************* Remove from Hive END */
    myDownloadsList?.removeAt(position);
    setState(() {});
    return true;
  }

  // openPlayer(position) async {
  //   PlayerModel playerModel = PlayerModel(
  //     playType: "Download",
  //     videoId: myDownloadsList?[position].id ?? 0,
  //     videoTitle: myDownloadsList?[position].name ?? "",
  //     videoType: myDownloadsList?[position].videoType ?? 0,
  //     subVideoType: myDownloadsList?[position].subVideoType ?? 0,
  //     typeId: myDownloadsList?[position].typeId ?? 0,
  //     episodeId: 0,
  //     videoUrl: myDownloadsList?[position].savedFile ?? "",
  //     trailerUrl: myDownloadsList?[position].trailerUrl ?? "",
  //     uploadType: myDownloadsList?[position].videoUploadType ?? "",
  //     videoThumb: myDownloadsList?[position].landscapeImg ?? "",
  //     stopTime: myDownloadsList?[position].stopTime ?? 0,
  //     securityKey: myDownloadsList?[position].securityKey ?? "",
  //   );
  //   if (!mounted) return;
  //   Utils.openPlayer(
  //     context: context,
  //     playerModel: playerModel,
  //   );
  // }
}
