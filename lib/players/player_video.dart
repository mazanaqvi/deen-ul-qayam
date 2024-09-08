import 'dart:io';
import 'dart:isolate';
import 'package:chewie/chewie.dart';
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
import 'package:video_player/video_player.dart';

class PlayerVideo extends StatefulWidget {
  final String? videoUrl, vUploadType, videoThumb, type, secreateKey;
  final int? videoId, courseId, chepterId;
  const PlayerVideo(
      this.videoId,
      this.videoUrl,
      this.vUploadType,
      this.chepterId,
      this.videoThumb,
      this.courseId,
      this.type,
      this.secreateKey,
      {Key? key})
      : super(key: key);

  @override
  State<PlayerVideo> createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo> {
  late PlayerProvider playerProvider;
  int? playerCPosition, videoDuration;
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playerInit();
    });
    super.initState();
  }

  _playerInit() async {
    if (widget.type == "video") {
      try {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl ?? ""),
        );
        await Future.wait([_videoPlayerController.initialize()]);
      } catch (e) {
        printLog("Error ===> ${e.toString()}");
      }
    } else {
      if (!kIsWeb && widget.type == "download") {
        File? tempFile;
        /* Decrypt Without Freez START ******************** */
        final receivePort = ReceivePort();
        var rootToken = RootIsolateToken.instance!;
        final isolate = await Isolate.spawn(decryptFile, [
          File(widget.videoUrl ?? ""),
          widget.secreateKey ?? "",
          receivePort.sendPort,
          rootToken
        ]);
        receivePort.listen((message) async {
          if (message != null) {
            tempFile = message;
            printLog("tempFile ===isolate===> $tempFile");
            _videoPlayerController = VideoPlayerController.file(tempFile!);
            receivePort.close();
            isolate.kill(priority: Isolate.immediate);
            await Future.wait([_videoPlayerController.initialize()]);
          }
        });
        /* ********************** Decrypt Without Freez END */
      }
    }

    /* Chewie Controller */

    _setupController();

    if (widget.type != "download") {
      await playerProvider.addVideoView(
          "3", (widget.courseId ?? 0), widget.videoId);
    }

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  _setupController() async {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      startAt: Duration.zero,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      fullScreenByDefault: false,
      allowFullScreen: true,
      hideControlsTimer: const Duration(seconds: 1),
      showControls: true,
      allowedScreenSleep: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      cupertinoProgressColors: ChewieProgressColors(
        playedColor: colorPrimary,
        handleColor: colorPrimary,
        backgroundColor: gray,
        bufferedColor: colorAccent,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: colorPrimary,
        handleColor: colorPrimary,
        backgroundColor: gray,
        bufferedColor: colorAccent,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: MyText(
            color: white,
            text: errorMessage,
            textalign: TextAlign.center,
            fontsizeNormal: 14,
            fontwaight: FontWeight.w600,
            fontsizeWeb: 16,
            multilanguage: false,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal,
          ),
        );
      },
    );
    _chewieController?.addListener(() {
      playerCPosition =
          (_chewieController?.videoPlayerController.value.position)
                  ?.inMilliseconds ??
              0;
      videoDuration = (_chewieController?.videoPlayerController.value.duration)
              ?.inMilliseconds ??
          0;
      printLog("playerCPosition :===> $playerCPosition");
      printLog("videoDuration :=====> $videoDuration");
    });
  }

  @override
  void dispose() {
    if (_chewieController != null) {
      _chewieController?.removeListener(() {});
      _chewieController?.videoPlayerController.dispose();
    }
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
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: _buildPage(),
              ),
              (!kIsWeb &&
                      MediaQuery.of(context).orientation ==
                          Orientation.portrait &&
                      widget.type == "video")
                  ? Positioned.fill(
                      top: 15,
                      left: 15,
                      bottom: 50,
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
                      onTap: () {
                        onBackPressed(false);
                      },
                      focusColor: gray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      child: Utils.buildBackBtnDesign(context),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (_chewieController != null &&
        _chewieController?.videoPlayerController.value != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return _buildPlayer();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Utils.pageLoader(),
          ),
          const SizedBox(height: 20),
          MyText(
            color: white,
            text: "Loading...",
            textalign: TextAlign.center,
            fontsizeNormal: 14,
            fontwaight: FontWeight.w600,
            fontsizeWeb: 16,
            multilanguage: false,
            maxline: 1,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal,
          ),
        ],
      );
    }
  }

  Widget _buildPlayer() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _chewieController?.aspectRatio ??
              (_chewieController?.videoPlayerController.value.aspectRatio ??
                  16 / 9),
          child: Chewie(
            controller: _chewieController!,
          ),
        ),
        kIsWeb
            ? Positioned.fill(
                top: 15,
                left: 15,
                bottom: 50,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () async {
                      final detailProvider = Provider.of<CourseDetailsProvider>(
                          context,
                          listen: false);
                      Utils().showProgress(context, "Please Wait...");
                      await playerProvider.addVideoRead(
                          widget.courseId, widget.videoId, widget.chepterId);

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
                          if (!mounted) return;
                          Utils().hideProgress(context);
                          Navigator.pop(context);
                        } else {
                          if (!mounted) return;
                          Utils().hideProgress(context);
                          Utils.showSnackbar(
                              context,
                              "fail",
                              playerProvider.successVideoReadModel.message ??
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
      ],
    );
  }

  Future<void> onBackPressed(didPop) async {
    if (didPop) return;
    if (!kIsWeb) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    printLog("onBackPressed playerCPosition :===> $playerCPosition");
    printLog("onBackPressed videoDuration :===> $videoDuration");

    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context, false);
    }
  }
}
