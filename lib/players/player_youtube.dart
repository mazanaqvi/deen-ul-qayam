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
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerYoutube extends StatefulWidget {
  final String? videoUrl, vUploadType, videoThumb;
  final int? videoId, courseId, chepterId;
  const PlayerYoutube(this.videoId, this.videoUrl, this.vUploadType,
      this.videoThumb, this.courseId, this.chepterId,
      {Key? key})
      : super(key: key);

  @override
  State<PlayerYoutube> createState() => PlayerYoutubeState();
}

class PlayerYoutubeState extends State<PlayerYoutube> {
  late PlayerProvider playerProvider;
  YoutubePlayerController? controller;
  bool fullScreen = false;
  int? playerCPosition, videoDuration;

  @override
  void initState() {
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _initPlayer();
  }

  _initPlayer() async {
    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
    printLog("Enter Youtube :===>");
    printLog("videoUrl :===> ${widget.videoUrl}");
    var videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl ?? "");
    printLog("videoId :====> $videoId");
    controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
    printLog("Start Playing :====> $videoId");
    // Api Call CourseView
    await playerProvider.addVideoView(
      "3",
      widget.courseId,
      widget.videoId,
    );
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return PopScope(
      onPopInvoked: (didPop) => onBackPressed,
      child: Scaffold(
        backgroundColor: black,
        body: Stack(
          children: [
            _buildPlayer(),
            (!kIsWeb &&
                    (MediaQuery.of(context).orientation ==
                        Orientation.portrait))
                ? Positioned.fill(
                    top: 55,
                    left: 15,
                    child: Align(
                      alignment: Alignment.topCenter,
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
                              await detailProvider
                                  .getCourseDetails(widget.courseId);
                              await detailProvider.getVideoByChapter(
                                  widget.courseId ?? 0,
                                  widget.chepterId ?? 0,
                                  0,
                                  false);
                              if (!context.mounted) return;
                              Utils().hideProgress(context);
                              Navigator.pop(context);
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

  Widget _buildPlayer() {
    if (controller == null) {
      return Utils.pageLoader();
    } else {
      if (kIsWeb) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final detailProvider =
                    Provider.of<CourseDetailsProvider>(context, listen: false);
                Utils().showProgress(context, "Please Wait...");
                await playerProvider.addVideoRead(
                    widget.courseId, widget.videoId, widget.chepterId);

                if (!playerProvider.loading) {
                  if (playerProvider.successVideoReadModel.status == 200) {
                    await detailProvider.getCourseDetails(widget.courseId);
                    await detailProvider.getVideoByChapter(
                        widget.courseId ?? 0, widget.chepterId ?? 0, 0, false);
                    if (!mounted) return;
                    Utils().hideProgress(context);
                    Navigator.pop(context);
                  } else {
                    if (!mounted) return;
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
              child: YoutubePlayerScaffold(
                backgroundColor: black,
                controller: controller!,
                autoFullScreen: true,
                defaultOrientations: const [
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ],
                builder: (context, player) {
                  return Scaffold(
                    backgroundColor: black,
                    body: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return player;
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return YoutubePlayerScaffold(
          backgroundColor: black,
          controller: controller!,
          autoFullScreen: true,
          defaultOrientations: const [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          builder: (context, player) {
            return Scaffold(
              backgroundColor: black,
              body: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return player;
                  },
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    controller?.close();
    if (!(kIsWeb)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
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
