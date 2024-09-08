import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/provider/playerprovider.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

class PlayerVimeo extends StatefulWidget {
  final String? videoUrl, vUploadType, videoThumb;
  final int? videoId, courseId, chepterId;
  const PlayerVimeo(this.videoId, this.videoUrl, this.vUploadType,
      this.chepterId, this.videoThumb, this.courseId,
      {Key? key})
      : super(key: key);

  @override
  State<PlayerVimeo> createState() => PlayerVimeoState();
}

class PlayerVimeoState extends State<PlayerVimeo> {
  late PlayerProvider playerProvider;
  String? vUrl;
  int? playerCPosition, videoDuration;

  @override
  void initState() {
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    super.initState();
    vUrl = widget.videoUrl;
    if (!(vUrl ?? "").contains("https://vimeo.com/")) {
      vUrl = "https://vimeo.com/$vUrl";
    }
    addView();
    printLog("vUrl===> $vUrl");
  }

  addView() async {
    await playerProvider.addVideoView("3", widget.courseId, widget.videoId);
  }

  @override
  void dispose() {
    if (!(kIsWeb)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => onBackPressed,
      child: Scaffold(
        backgroundColor: black,
        body: Stack(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () async {
                    final detailProvider = Provider.of<CourseDetailsProvider>(
                        context,
                        listen: false);
                    Utils().showProgress(context, "Please Wait...");
                    await playerProvider.addVideoRead(
                        widget.courseId, widget.videoId, widget.chepterId);

                    if (!playerProvider.loading) {
                      if (playerProvider.successVideoReadModel.status == 200) {
                        if (!context.mounted) return;
                        Utils().hideProgress(context);
                        Navigator.pop(context);
                        await detailProvider.getVideoByChapter(
                            widget.courseId ?? 0,
                            widget.chepterId ?? 0,
                            0,
                            false);
                      } else {
                        if (!context.mounted) return;
                        Utils().hideProgress(context);
                        Utils.showSnackbar(
                            context,
                            "fail",
                            playerProvider.successVideoReadModel.message ?? "",
                            false);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: colorPrimary,
                    ),
                    child: MyText(
                        color: white,
                        fontsizeNormal: Dimens.textMedium,
                        maxline: 2,
                        multilanguage: true,
                        fontwaight: FontWeight.w500,
                        text: "markcomplite",
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ),
                ),
                Expanded(
                  child: VimeoVideoPlayer(
                    url: vUrl ?? "",
                    autoPlay: true,
                    systemUiOverlay: const [],
                    deviceOrientation: const [
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ],
                    startAt: Duration.zero,
                    onProgress: (timePoint) {
                      playerCPosition = timePoint.inMilliseconds;
                      printLog("playerCPosition :===> $playerCPosition");
                    },
                    onFinished: () async {
                      /* Remove From Continue */
                    },
                  ),
                ),
              ],
            ),
            (!kIsWeb &&
                    MediaQuery.of(context).orientation == Orientation.portrait)
                ? Positioned.fill(
                    top: 15,
                    left: 15,
                    bottom: 50,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () async {
                          final detailProvider =
                              Provider.of<CourseDetailsProvider>(context,
                                  listen: false);
                          Utils().showProgress(context, "Please Wait...");
                          await playerProvider.addVideoRead(widget.courseId,
                              widget.videoId, widget.chepterId);

                          if (!playerProvider.loading) {
                            if (playerProvider.successVideoReadModel.status ==
                                200) {
                              if (!context.mounted) return;
                              Utils().hideProgress(context);
                              Navigator.pop(context);
                              await detailProvider.getVideoByChapter(
                                  widget.courseId ?? 0,
                                  widget.chepterId ?? 0,
                                  0,
                                  false);
                            } else {
                              if (!context.mounted) return;
                              Utils().hideProgress(context);
                              Utils.showSnackbar(
                                  context,
                                  "fail",
                                  playerProvider
                                          .successVideoReadModel.message ??
                                      "",
                                  false);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: colorPrimary,
                          ),
                          child: MyText(
                              color: white,
                              fontsizeNormal: Dimens.textMedium,
                              maxline: 2,
                              multilanguage: true,
                              fontwaight: FontWeight.w500,
                              text: "markcomplite",
                              textalign: TextAlign.left,
                              fontstyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            if (!kIsWeb)
              Positioned(
                top: 15,
                left: 15,
                child: SafeArea(
                  child: InkWell(
                    onTap: onBackPressed,
                    focusColor: gray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    child: Utils.buildBackBtnDesign(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
    if (!(kIsWeb)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    printLog("onBackPressed playerCPosition :===> $playerCPosition");
    printLog("onBackPressed videoDuration :===> $videoDuration");
    if (!mounted) return Future.value(false);
    Navigator.pop(context, false);
    return Future.value(true);
  }
}
