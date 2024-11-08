import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:yourappname/pages/tutorprofilepage.dart';
import 'package:hive/hive.dart';
import 'package:yourappname/model/download_item.dart';
import 'package:yourappname/pages/login.dart';
import 'package:yourappname/pages/nodata.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/provider/lessonsprovider.dart';
import 'package:yourappname/provider/showdownloadprovider.dart';
import 'package:yourappname/quiz/quiz.dart';
import 'package:yourappname/subscription/allpayment.dart';
import 'package:yourappname/utils/adhelper.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/customwidget.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/widget/myrating.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:yourappname/model/lesson_model.dart';
import 'package:video_player/video_player.dart';

class Detail extends StatefulWidget {
  final Lesson? lesson; // Optional Lesson object
  final String? courseId;
  final bool isLesson;

  const Detail({
    Key? key,
    this.lesson, // Not required
    this.courseId, // Not required
    this.isLesson = false,
  })  : assert(!isLesson || (isLesson && lesson != null),
            'Lesson must be provided when isLesson is true'),
        super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  /* Create Instance And Initialize Hive */
  late Box<DownloadItem> downloadBox;
  late Box<ChapterItem> seasonBox;
  late Box<EpisodeItem> episodeBox;

  late CourseDetailsProvider detailProvider;
  late LessonsProvider lessonsProvider;
  late ShowDownloadProvider downloadProvider;
  late ScrollController _scrollController;
  late VideoPlayerController _controller;
  ChewieController? _chewieController; // Make ChewieController nullable

  final commentController = TextEditingController();
  double addrating = 0.0;
  final ReceivePort _port = ReceivePort();
  dynamic _tasks;
  int progress = 0;

  void _videoListener() {
    if (_controller.value.hasError) {
      print("Video Player Error: ${_controller.value.errorDescription}");
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize VideoPlayerController with the fixed video URL
    _controller = VideoPlayerController.network(
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    )
      ..addListener(_videoListener)
      ..setLooping(true)
      ..initialize().then((_) {
        print("Video Player initialized successfully.");
        setState(() {
          // Initialize ChewieController after _controller is initialized
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            aspectRatio: _controller.value.aspectRatio,
            autoPlay: true,
            looping: true,
          );
        });
        _controller.play();
      }).catchError((error) {
        print("Error initializing Video Player: $error");
      });

    // Initialize Providers, Scroll Controller, Background Isolate, etc.
    detailProvider = Provider.of<CourseDetailsProvider>(context, listen: false);
    downloadProvider =
        Provider.of<ShowDownloadProvider>(context, listen: false);
    lessonsProvider = Provider.of<LessonsProvider>(context, listen: false);

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    if (!kIsWeb) {
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback, step: 1);
    }

    getApi();

    if (widget.isLesson) {
      fetchLessonDetails();
    } else {
      fetchCourseDetails();
    }
  }

  Future<void> fetchCourseDetails() async {
    await detailProvider.getCourseDetails(widget.courseId);
    getRelatedList(0);
    getReviewList(0);
  }

  Future<void> fetchLessonDetails() async {
    await lessonsProvider.fetchLessons();
  }

  _scrollListener() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        (detailProvider.reviewcurrentPage ?? 0) <
            (detailProvider.reviewtotalPage ?? 0)) {
      await detailProvider.setReviewLoadMore(true);
      getReviewList(detailProvider.reviewcurrentPage ?? 0);
    }
  }

  getApi() async {
    await detailProvider.getCourseDetails(widget.courseId);
    getRelatedList(0);
    getReviewList(0);
    if (detailProvider.courseDetailsModel.result?[0].chapter != null ||
        (detailProvider.courseDetailsModel.result?[0].chapter?.length ?? 0) !=
            0) {
      await detailProvider.openChapterVideo(0, true);
      getVideoByChapter(
          detailProvider.courseDetailsModel.result?[0].chapter?[0].id ?? 0,
          0,
          false);
    }
  }

  Future<void> getReviewList(int? nextPage) async {
    await detailProvider.getReviewByCourse(
        "3", widget.courseId, (nextPage ?? 0) + 1);
    await detailProvider.setReviewLoadMore(false);
  }

  Future<void> getRelatedList(int? nextPage) async {
    await detailProvider.getRelatedCourse(widget.courseId, (nextPage ?? 0) + 1);
    await detailProvider.setRelatedCourseLoadMore(false);
  }

  Future<void> getVideoByChapter(chapterId, int? nextPage, isViewAll) async {
    await detailProvider.getVideoByChapter(
        widget.courseId, chapterId, (nextPage ?? 0) + 1, isViewAll);
    await detailProvider.setVideoLoadMore(false);
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
          detailProvider.setDownloadProgress(progress);
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

    printLog("downloadCallback==> $progress%");

    if (!kIsWeb) {
      IsolateNameServer.lookupPortByName(Constant.videoDownloadPort)
          ?.send([id, status, progress]);
    }
  }

  /* ======== Download End =========== */

  @override
  void dispose() {
    _chewieController?.dispose(); // Dispose ChewieController if not null
    _controller.removeListener(_videoListener); // Remove the listener
    _controller.dispose(); // Dispose the controller
    detailProvider.clearProvider();
    downloadProvider.clearProvider();
    lessonsProvider.clearProvider();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLesson) {
      // Logging in build Method
      print("===== Building Detail Screen for Lesson =====");
      print("Lesson Name: ${widget.lesson?.name}");
      print("Lesson Description: ${widget.lesson?.description}");
      print("Video URL: ${widget.lesson?.videoAddress}");
      print("Thumbnail URL: ${widget.lesson?.thumbnail}");
      print("===============================================");

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          actions: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                // Add sharing functionality here
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.share, color: Colors.white),
              ),
            ),
          ],
        ),
        body: widget.lesson == null
            ? const NoData()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200, // Set a fixed height
                          foregroundDecoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: MyNetworkImage(
                              imgHeight: 200,
                              fit: BoxFit.fill,
                              islandscap: true,
                              imageUrl: widget.lesson!.thumbnail ?? "",
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () async {
                              // Add sharing functionality here
                            },
                            child: const Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.play_arrow_outlined,
                                  size: 65, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyText(
                      color: Theme.of(context).colorScheme.surface,
                      text: widget.lesson!.name ?? 'No Name',
                      fontsizeNormal: Dimens.textBig,
                      fontwaight: FontWeight.w700,
                      maxline: 3,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.left,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 10),
                    // Video Player within AspectRatio to prevent infinite height
                    Center(
                      child: _controller.value.isInitialized &&
                              _chewieController != null
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Chewie(
                                controller: _chewieController!,
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 10),
                    // Play/Pause Button
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                        ),
                        const Text("Play/Pause Video"),
                      ],
                    ),
                  ],
                ),
              ),
      );
    }  else {
      // Existing course detail UI
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.arrow_back), // Replace with your custom icon
              ),
            ),
          ),
          actions: [
            Consumer<CourseDetailsProvider>(
              builder: (context, detailprovider, child) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          AdHelper.showFullscreenAd(
                            context,
                            Constant.interstialAdType,
                            () async {
                              if (Constant.userID == null) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const Login(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                await detailprovider.addRemoveWishlist(
                                  "3",
                                  detailprovider
                                          .courseDetailsModel.result?[0].id
                                          .toString() ??
                                      "",
                                );
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            detailprovider.courseDetailsModel.result?[0]
                                        .isWishlist ==
                                    1
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: detailprovider.courseDetailsModel.result?[0]
                                        .isWishlist ==
                                    1
                                ? Colors.red
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          AdHelper.showFullscreenAd(
                            context,
                            Constant.interstialAdType,
                            () {
                              if (Constant.userID == null) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const Login(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                if (detailprovider.courseDetailsModel.result?[0]
                                            .isFree ==
                                        0 &&
                                    detailprovider.courseDetailsModel.result?[0]
                                            .isUserBuy !=
                                        1) {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          AllPayment(
                                        contentType: "2",
                                        payType: 'Content',
                                        itemId: detailprovider
                                                .courseDetailsModel
                                                .result?[0]
                                                .id
                                                .toString() ??
                                            "",
                                        price: detailprovider.courseDetailsModel
                                                .result?[0].price
                                                .toString() ??
                                            "",
                                        itemTitle: detailprovider
                                                .courseDetailsModel
                                                .result?[0]
                                                .title
                                                .toString() ??
                                            "",
                                        currency: Constant.currency,
                                        coin:
                                            "yourCoinValue", // Provide a value
                                        typeId:
                                            "yourTypeIdValue", // Provide a value
                                        videoType:
                                            "yourVideoTypeValue", // Provide a value
                                        productPackage:
                                            "yourProductPackageValue", // Provide a value
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.ease;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  addReviewBottomSheet(
                                    context,
                                    detailprovider
                                            .courseDetailsModel.result?[0].id
                                            .toString() ??
                                        "",
                                  );
                                }
                              }
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.star_border,
                            color: Colors.white, // Adjust color as needed
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          AdHelper.showFullscreenAd(
                            context,
                            Constant.interstialAdType,
                            () {
                              Utils.shareApp(
                                Platform.isIOS
                                    ? "Hey! I'm Watching ${detailprovider.courseDetailsModel.result?[0].title.toString()}. Check it out now on ${Constant.appName}! \nhttps://apps.apple.com/us/app/${Constant.appName.toLowerCase()}/${Constant.appPackageName} \n"
                                    : "Hey! I'm Watching ${detailprovider.courseDetailsModel.result?[0].title.toString()}. Check it out now on ${Constant.appName}! \nhttps://play.google.com/store/apps/details?id=${Constant.appPackageName} \n",
                              );
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons
                                .share, // Replace with your custom icon if needed
                            color: Colors.white, // Adjust color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<CourseDetailsProvider>(
          builder: (context, detailprovider, child) {
            if (detailprovider.loading) {
              return commanShimmer();
            } else {
              if (detailprovider.courseDetailsModel.status == 200) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            parentConainer(),
                            childContainer(),
                          ],
                        ),
                      ),
                    ),
                    Utils.showBannerAd(context),
                    buildBottonButton(),
                  ],
                );
              } else {
                return const NoData();
              }
            }
          },
        ),
      );
    }
  }

  Widget parentConainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                  color: black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MyNetworkImage(
                    imgHeight: 200,
                    fit: BoxFit.fill,
                    islandscap: true,
                    imageUrl: detailProvider
                            .courseDetailsModel.result?[0].thumbnailImg
                            .toString() ??
                        ""),
              ),
            ),
            Positioned.fill(
              child: InkWell(
                splashColor: transparentColor,
                focusColor: transparentColor,
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () async {
                  AdHelper.showFullscreenAd(context, Constant.rewardAdType, () {
                    if (Constant.userID == null) {
                      /* Login Page */
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Login(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    } else {
                      if (detailProvider.courseDetailsModel.result?[0].isFree ==
                              0 &&
                          detailProvider
                                  .courseDetailsModel.result?[0].isUserBuy !=
                              1) {
                        /* Primium Page  */
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    AllPayment(
                              /* ContentType 1 == Book */
                              /* ContentType 2 == Course */
                              contentType: "2",
                              payType: 'Content',
                              itemId: detailProvider
                                      .courseDetailsModel.result?[0].id
                                      .toString() ??
                                  "",
                              price: detailProvider
                                      .courseDetailsModel.result?[0].price
                                      .toString() ??
                                  "",
                              itemTitle: detailProvider
                                      .courseDetailsModel.result?[0].title
                                      .toString() ??
                                  "",
                              typeId: "",
                              videoType: "",
                              productPackage: "",
                              currency: Constant.currency,
                              coin: "",
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      } else {
                        /* Open Video Player */
                        if ((detailProvider.videoList == null ||
                                (detailProvider.videoList?.length ?? 0) == 0) &&
                            (detailProvider.courseDetailsModel.result?[0]
                                        .chapter ==
                                    null ||
                                (detailProvider.courseDetailsModel.result?[0]
                                            .chapter?.length ??
                                        0) ==
                                    0)) {
                          Utils.showSnackbar(
                              context, "info", "video_not_found", true);
                        } else {
                          Utils.openPlayer(
                              context: context,
                              type: "video",
                              secreateKey: "",
                              videoId: detailProvider.videoList?[0].id ?? 0,
                              videoUrl: detailProvider.videoList?[0].videoUrl
                                      .toString() ??
                                  "",
                              vUploadType: detailProvider
                                      .videoList?[0].videoType
                                      .toString() ??
                                  "",
                              videoThumb: detailProvider
                                      .videoList?[0].landscapeImg
                                      .toString() ??
                                  "",
                              courseId: detailProvider
                                      .courseDetailsModel.result?[0].id ??
                                  0,
                              chepterId: detailProvider.courseDetailsModel
                                      .result?[0].chapter?[0].id ??
                                  0);
                        }
                      }
                    }
                  });
                },
                child: const Align(
                  alignment: Alignment.center,
                  child:
                      Icon(Icons.play_arrow_outlined, size: 65, color: white),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 15),
        // DetailVideo Title Text
        MyText(
            color: Theme.of(context).colorScheme.surface,
            text:
                detailProvider.courseDetailsModel.result?[0].title.toString() ??
                    "",
            fontsizeNormal: Dimens.textBig,
            fontwaight: FontWeight.w700,
            maxline: 3,
            overflow: TextOverflow.ellipsis,
            textalign: TextAlign.left,
            fontstyle: FontStyle.normal),
        // const SizedBox(height: 10),

        const SizedBox(height: 10),

        // Created By List
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
                color: Theme.of(context).colorScheme.surface,
                text: "createdby",
                fontsizeNormal: Dimens.textTitle,
                fontwaight: FontWeight.w600,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal,
                multilanguage: true),
            const SizedBox(width: 3),
            Expanded(
              child: InkWell(
                splashColor: transparentColor,
                focusColor: transparentColor,
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            TutorProfilePage(
                          tutorid: detailProvider
                                  .courseDetailsModel.result?[0].tutorId
                                  .toString() ??
                              "",
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  });
                },
                child: MyText(
                    color: colorPrimary,
                    text: detailProvider
                                .courseDetailsModel.result?[0].tutorName ==
                            ""
                        ? "Guest User"
                        : detailProvider.courseDetailsModel.result?[0].tutorName
                                .toString() ??
                            "",
                    fontsizeNormal: Dimens.textTitle,
                    fontwaight: FontWeight.w700,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget childContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // color: white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          children: [
            // courseInclude(),
            // const SizedBox(height: 15),
            // whatYouLearn(),
            // const SizedBox(height: 15),
            // requirementBox(),
            // const SizedBox(height: 15),
            // description(),
            // const SizedBox(height: 15),
            relatedCourse(),
            const SizedBox(height: 15),
            courseEpisodes(),
            // Hiding the certificate in the general certificate page
            // generateCertificate(),
            const SizedBox(height: 20),
            buildStudentFeedback(),
          ],
        ),
      ),
    );
  }

  Widget commanShimmer() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomWidget.roundcorner(
              height: 200,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(height: 15),
          CustomWidget.roundrectborder(
            height: 10,
            width: MediaQuery.of(context).size.width,
          ),
          const CustomWidget.roundrectborder(
            height: 10,
            width: 200,
          ),
          const SizedBox(height: 10),

          const CustomWidget.roundrectborder(
            height: 10,
            width: 150,
          ),
          const SizedBox(height: 10),

          const CustomWidget.roundrectborder(
            height: 10,
            width: 100,
          ),
          const SizedBox(height: 10),
          // Course Description
          CustomWidget.roundrectborder(
            height: 5,
            width: MediaQuery.of(context).size.width,
          ),
          CustomWidget.roundrectborder(
            height: 5,
            width: MediaQuery.of(context).size.width,
          ),
          CustomWidget.roundrectborder(
            height: 5,
            width: MediaQuery.of(context).size.width,
          ),
          CustomWidget.roundrectborder(
            height: 5,
            width: MediaQuery.of(context).size.width,
          ),
          CustomWidget.roundrectborder(
            height: 5,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 10),
          const CustomWidget.roundrectborder(
            height: 10,
            width: 200,
          ),
          const SizedBox(height: 10),
          const CustomWidget.roundrectborder(
            height: 10,
            width: 200,
          ),
          const SizedBox(height: 10),
          const CustomWidget.roundrectborder(
            height: 10,
            width: 200,
          ),
          const SizedBox(height: 10),
          const CustomWidget.roundrectborder(
            height: 10,
            width: 200,
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.10),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CustomWidget.roundrectborder(
                  height: 10,
                  width: 200,
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomWidget.circular(
                            height: 15,
                            width: 15,
                          ),
                          SizedBox(width: 14),
                          CustomWidget.roundrectborder(
                            height: 5,
                            width: 200,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

/* Related Course */

  Widget relatedCourse() {
    return Consumer<CourseDetailsProvider>(
        builder: (context, detailprovider, child) {
      if (detailprovider.loading && !detailprovider.relatedCourseloadmore) {
        return const SizedBox.shrink();
      } else {
        if (detailprovider.relatedCourseModel.status == 200 &&
            detailProvider.relatedCourseList != null &&
            (detailProvider.relatedCourseModel.result?.length ?? 0) > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                  color: Theme.of(context).colorScheme.surface,
                  fontwaight: FontWeight.w600,
                  fontsizeNormal: Dimens.textTitle,
                  overflow: TextOverflow.ellipsis,
                  maxline: 1,
                  text: "relatedcourse",
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                  multilanguage: true),
              const SizedBox(height: 10),
              relatedCourseItem(),
              if (detailprovider.relatedCourseloadmore)
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
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget relatedCourseItem() {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 25,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        detailProvider.reviewList?.length ?? 0,
        (index) {
          return InkWell(
            splashColor: transparentColor,
            focusColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () {
              AdHelper.showFullscreenAd(context, Constant.interstialAdType, () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Detail(
                      courseId: detailProvider.relatedCourseList?[index].id
                              .toString() ??
                          "",
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: gray.withOpacity(0.50),
                    blurRadius: 2,
                    offset: const Offset(0.1, 0.1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                    child: MyNetworkImage(
                      imgWidth: 110,
                      imgHeight: 100,
                      imageUrl: detailProvider
                              .relatedCourseList?[index].thumbnailImg
                              .toString() ??
                          "",
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            color: Theme.of(context).colorScheme.surface,
                            text: detailProvider
                                    .relatedCourseList?[index].description
                                    .toString() ??
                                "",
                            fontsizeNormal: Dimens.textMedium,
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
                                  int.parse(detailProvider
                                          .relatedCourseList?[index].totalView
                                          .toString() ??
                                      ""),
                                ),
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
                                rating: double.parse((detailProvider
                                        .relatedCourseList?[index].avgRating
                                        .toString() ??
                                    "")),
                                spacing: 1,
                                size: 10),
                            const SizedBox(width: 8),
                            MyText(
                                color: colorAccent,
                                text:
                                    "${double.parse(detailProvider.relatedCourseList?[index].avgRating.toString() ?? "")} ",
                                fontsizeNormal: Dimens.textMedium,
                                fontwaight: FontWeight.w600,
                                maxline: 1,
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
          );
        },
      ),
    );
  }

/* course Episodes */

  Widget courseEpisodes() {
    if (detailProvider.courseDetailsModel.result![0].chapter != null &&
        (detailProvider.courseDetailsModel.result?[0].chapter?.length ?? 0) >
            0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
              color: Theme.of(context).colorScheme.surface,
              text: "Curriculum",
              fontsizeNormal: Dimens.textTitle,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal,
              multilanguage: true),
          const SizedBox(height: 10),
          // Course Episodes
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                detailProvider.courseDetailsModel.result?[0].chapter?.length ??
                    0,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                splashColor: transparentColor,
                focusColor: transparentColor,
                onTap: () async {
                  if (detailProvider.chapterIndex == index &&
                      detailProvider.isOpen == true) {
                    await detailProvider.openChapterVideo(index, false);
                    detailProvider.clearVideoChapter();
                  } else {
                    await detailProvider.openChapterVideo(index, true);
                    getVideoByChapter(
                        detailProvider.courseDetailsModel.result?[0]
                                .chapter?[index].id
                                .toString() ??
                            "",
                        0,
                        false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeIn,
                    height: detailProvider.chapterIndex == index &&
                            detailProvider.isOpen == true
                        ? null
                        : 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: gray.withOpacity(0.50), width: 0.5)),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: MyText(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    fontsizeNormal: Dimens.textDesc,
                                    maxline: 2,
                                    fontwaight: FontWeight.w600,
                                    text:
                                        "${(index + 1)}.  ${detailProvider.courseDetailsModel.result?[0].chapter?[index].name.toString() ?? ""}",
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              Icon(
                                detailProvider.chapterIndex == index &&
                                        detailProvider.isOpen == true
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: gray,
                              ),
                            ],
                          ),
                          chapterVideoList(
                              index,
                              detailProvider.courseDetailsModel.result?[0]
                                      .chapter?[index].id ??
                                  0),
                          const SizedBox(height: 10),
                          /* ViewAll Button  */
                          if (((detailProvider.videocurrentPage ?? 0) <
                                  (detailProvider.videototalPage ?? 0)) &&
                              !detailProvider.videoloadmore)
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () async {
                                  await detailProvider.setVideoLoadMore(true);
                                  getVideoByChapter(
                                      detailProvider.courseDetailsModel
                                              .result?[0].chapter?[index].id
                                              .toString() ??
                                          "",
                                      detailProvider.videocurrentPage ?? 0,
                                      true);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  child: MyText(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontsizeNormal: Dimens.textMedium,
                                      maxline: 2,
                                      multilanguage: true,
                                      fontwaight: FontWeight.w600,
                                      text: "viewall",
                                      textalign: TextAlign.left,
                                      fontstyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          /* ViewAll ProgressBar  */
                          if (detailProvider.videoloadmore)
                            const Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: colorPrimary,
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

/* Chepter Video List in DropDown */

  Widget chapterVideoList(index, chapterId) {
    if (detailProvider.chapterIndex == index && detailProvider.isOpen == true) {
      if (detailProvider.videoloading && !detailProvider.videoloadmore) {
        return const Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: colorPrimary,
              strokeWidth: 1,
            ),
          ),
        );
      } else {
        if (detailProvider.getVideoByChapterModel.status == 200 &&
            detailProvider.videoList != null) {
          if ((detailProvider.videoList?.length ?? 0) > 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, indexSaprate) =>
                      const SizedBox(height: 0),
                  itemCount: detailProvider.videoList?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    return InkWell(
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      splashColor: transparentColor,
                      focusColor: transparentColor,
                      onTap: () {
                        AdHelper.showFullscreenAd(
                            context, Constant.rewardAdType, () {
                          if (Constant.userID == null) {
                            /* Login Page */
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const Login(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          } else {
                            if (detailProvider
                                        .courseDetailsModel.result?[0].isFree ==
                                    0 &&
                                detailProvider.courseDetailsModel.result?[0]
                                        .isUserBuy !=
                                    1) {
                              /* Primium Page  */
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      AllPayment(
                                    /* ContentType 1 == Book */
                                    /* ContentType 2 == Course */
                                    contentType: "2",
                                    payType: 'Content',
                                    itemId: detailProvider
                                            .courseDetailsModel.result?[0].id
                                            .toString() ??
                                        "",
                                    price: detailProvider
                                            .courseDetailsModel.result?[0].price
                                            .toString() ??
                                        "",
                                    itemTitle: detailProvider
                                            .courseDetailsModel.result?[0].title
                                            .toString() ??
                                        "",
                                    typeId: "",
                                    videoType: "",
                                    productPackage: "",
                                    currency: Constant.currency,
                                    coin: "",
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            } else {
                              /* Open Video Player */
                              if (detailProvider.videoList == null ||
                                  (detailProvider.videoList?.length ?? 0) ==
                                      0) {
                                Utils.showSnackbar(
                                    context, "info", "video_not_found", true);
                              } else {
                                if ((detailProvider.videoList == null ||
                                        (detailProvider.videoList?.length ??
                                                0) ==
                                            0) &&
                                    (detailProvider.courseDetailsModel
                                                .result?[0].chapter ==
                                            null ||
                                        (detailProvider
                                                    .courseDetailsModel
                                                    .result?[0]
                                                    .chapter
                                                    ?.length ??
                                                0) ==
                                            0)) {
                                  Utils.showSnackbar(
                                      context, "info", "video_not_found", true);
                                } else {
                                  Utils.openPlayer(
                                    context: context,
                                    type: "video",
                                    secreateKey: "",
                                    videoId: detailProvider
                                            .videoList?[position].id ??
                                        0,
                                    videoUrl: detailProvider
                                            .videoList?[position].videoUrl
                                            .toString() ??
                                        "",
                                    vUploadType: detailProvider
                                            .videoList?[position].videoType
                                            .toString() ??
                                        "",
                                    videoThumb: detailProvider
                                            .videoList?[position].landscapeImg
                                            .toString() ??
                                        "",
                                    courseId: detailProvider
                                            .courseDetailsModel.result?[0].id ??
                                        0,
                                    chepterId: chapterId,
                                  );
                                }
                              }
                            }
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
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
                                  maxline: 5,
                                  fontwaight: FontWeight.w600,
                                  text: detailProvider
                                          .videoList?[position].title
                                          .toString() ??
                                      "",
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                            ),
                            // _buildDownloadBtn(
                            //     position: position, chapterPos: index),
                            const SizedBox(width: 15),
                            detailProvider.videoList?[position].isRead == 1
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          width: 1.5, color: colorPrimary),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: colorPrimary,
                                    ),
                                  )
                                : const Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: colorPrimary,
                                    size: 25,
                                  )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                /* Quize Button in Video Bottom */
                detailProvider.courseDetailsModel.result?[0].chapter?[index]
                            .quizStatus ==
                        0
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () {
                          if (Constant.userID == null) {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const Login(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          } else {
                            if (detailProvider.courseDetailsModel.result?[0]
                                    .chapter?[index].isQuizPlay ==
                                0) {
                              Utils.showSnackbar(context, "fail",
                                  "pleasewatchallvideos", true);
                            } else {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Quize(
                                    courseId: widget.courseId! as int,
                                    chapterId: chapterId,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, bottom: 25, left: 5, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MyText(
                                  color: colorPrimary,
                                  fontsizeNormal: Dimens.textBig,
                                  maxline: 2,
                                  fontwaight: FontWeight.w600,
                                  text:
                                      "${((detailProvider.videoList?.length ?? 0) + 1).toString()}.",
                                  textalign: TextAlign.left,
                                  fontstyle: FontStyle.normal),
                              const SizedBox(width: 10),
                              Expanded(
                                child: MyText(
                                    color: colorPrimary,
                                    fontsizeNormal: Dimens.textDesc,
                                    maxline: 3,
                                    fontwaight: FontWeight.w600,
                                    text: "Play Quiz",
                                    textalign: TextAlign.left,
                                    fontstyle: FontStyle.normal),
                              ),
                              const SizedBox(width: 10),
                              detailProvider.courseDetailsModel.result?[0]
                                          .chapter?[index].isQuizPlay ==
                                      1
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            width: 1.5, color: colorPrimary),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: colorPrimary,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.lightbulb_outline,
                                      color: colorPrimary,
                                      size: 25,
                                    )
                            ],
                          ),
                        ),
                      ),
              ],
            );
          } else {
            return Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                  color: colorPrimary,
                  fontsizeNormal: Dimens.textMedium,
                  maxline: 2,
                  fontwaight: FontWeight.w600,
                  text: "No Video Found",
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal),
            );
          }
        } else {
          return Align(
            alignment: Alignment.centerLeft,
            child: MyText(
                color: colorPrimary,
                fontsizeNormal: Dimens.textMedium,
                maxline: 2,
                fontwaight: FontWeight.w600,
                text: "No Video Found",
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
          );
        }
      }
    } else {
      return const SizedBox.shrink();
    }
  }

/* Student Comments And Review List */

  Widget buildStudentFeedback() {
    return Consumer<CourseDetailsProvider>(
        builder: (context, detailprovider, child) {
      if (detailprovider.reviewloading && !detailprovider.reviewloadmore) {
        return const SizedBox.shrink();
      } else {
        if (detailprovider.getCourseReviewModel.status == 200 &&
            detailprovider.reviewList != null) {
          if ((detailprovider.reviewList?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: "studentfeedback",
                    fontsizeNormal: Dimens.textTitle,
                    fontwaight: FontWeight.w600,
                    maxline: 1,
                    multilanguage: true,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal),
                const SizedBox(height: 15),
                buildStudentFeedbackItem(),
                if (detailprovider.reviewloadmore)
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
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      }
    });
  }

  Widget buildStudentFeedbackItem() {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 15,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        detailProvider.reviewList?.length ?? 0,
        (index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: gray.withOpacity(0.08),
                  spreadRadius: 1.5,
                  blurRadius: 0.5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: MyNetworkImage(
                        imgWidth: 30,
                        imgHeight: 30,
                        imageUrl: detailProvider.reviewList?[index].image ?? "",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: detailProvider.reviewList?[index].fullName == ""
                            ? MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: detailProvider.reviewList?[index].userName
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textMedium,
                                fontwaight: FontWeight.w700,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal)
                            : MyText(
                                color: Theme.of(context).colorScheme.surface,
                                text: detailProvider.reviewList?[index].fullName
                                        .toString() ??
                                    "",
                                fontsizeNormal: Dimens.textMedium,
                                fontwaight: FontWeight.w700,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                textalign: TextAlign.center,
                                fontstyle: FontStyle.normal),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MyText(
                        color: colorPrimary,
                        text: Utils.formateDate(
                            detailProvider.reviewList?[index].createdAt
                                    .toString() ??
                                "",
                            Constant.dateformat),
                        fontsizeNormal: Dimens.textSmall,
                        fontwaight: FontWeight.w500,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyRating(
                      size: 18,
                      rating: double.parse((detailProvider
                              .reviewList?[index].rating
                              .toString() ??
                          "")),
                      spacing: 3,
                    ),
                    const SizedBox(width: 5),
                    MyText(
                        color: colorAccent,
                        text:
                            "${double.parse((detailProvider.reviewList?[index].rating.toString() ?? ""))}",
                        fontsizeNormal: Dimens.textMedium,
                        fontwaight: FontWeight.w600,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.left,
                        fontstyle: FontStyle.normal),
                  ],
                ),
                const SizedBox(height: 10),
                MyText(
                    color: gray,
                    text:
                        detailProvider.reviewList?[index].comment.toString() ??
                            "",
                    fontsizeNormal: Dimens.textSmall,
                    fontwaight: FontWeight.w400,
                    maxline: 5,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ],
            ),
          );
        },
      ),
    );
  }

/* Add Review BottomSheet */

  addReviewBottomSheet(BuildContext context, String courseId) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Consumer<CourseDetailsProvider>(
              builder: (context, detailprovider, child) {
            return Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(20).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                          color: Theme.of(context).colorScheme.surface,
                          fontsizeNormal: Dimens.textBig,
                          fontsizeWeb: Dimens.textBig,
                          multilanguage: true,
                          maxline: 1,
                          fontwaight: FontWeight.w600,
                          text: "addreview",
                          textalign: TextAlign.left,
                          fontstyle: FontStyle.normal),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 25,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star,
                            color: colorAccent,
                          ),
                          half: const Icon(Icons.star_half, color: colorAccent),
                          empty:
                              const Icon(Icons.star_border, color: colorAccent),
                        ),
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          addrating = rating;
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: TextField(
                      textAlign: TextAlign.start,
                      controller: commentController,
                      cursorColor: Theme.of(context).colorScheme.surface,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      style: GoogleFonts.inter(
                        fontSize: Dimens.textTitle,
                        fontStyle: FontStyle.normal,
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: Locales.string(context, "addcomment"),
                        hintStyle: GoogleFonts.inter(
                          fontSize: Dimens.textTitle,
                          fontStyle: FontStyle.normal,
                          color: colorPrimary.withOpacity(0.40),
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0.8,
                            color: colorPrimary.withOpacity(0.40),
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.all(15),
                        fillColor: transparentColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 0.8,
                                color: gray.withOpacity(0.50),
                              ),
                            ),
                            child: MyText(
                                color: gray.withOpacity(0.50),
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
                                multilanguage: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                text: "cancel",
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                        ),
                        const SizedBox(width: 15),
                        InkWell(
                          onTap: () async {
                            if (addrating == 0.0) {
                              Utils.showSnackbar(
                                  context, "fail", "pleaseenterrating", true);
                            } else if (commentController.text.toString() ==
                                "") {
                              Utils.showSnackbar(
                                  context, "fail", "pleaseentercomment", true);
                            } else {
                              Utils().showProgress(context, "Review Adding");
                              await detailprovider.addReview("3", courseId,
                                  commentController.text, addrating);

                              if (detailprovider.successModel.status == 200) {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                Utils.showSnackbar(
                                    context,
                                    "success",
                                    detailprovider.successModel.message ?? "",
                                    false);
                                commentController.clear();
                                addrating = 0;
                                getReviewList(0);
                                Utils().hideProgress(context);
                              } else {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                Utils.showSnackbar(
                                    context,
                                    "fail",
                                    detailprovider.successModel.message ?? "",
                                    false);
                                Utils().hideProgress(context);
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            curve: Curves.bounceInOut,
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: colorPrimary,
                              border: Border.all(
                                width: 0.8,
                                color: gray.withOpacity(0.20),
                              ),
                            ),
                            child: MyText(
                                color: white,
                                fontsizeNormal: Dimens.textTitle,
                                fontsizeWeb: Dimens.textTitle,
                                multilanguage: true,
                                maxline: 1,
                                fontwaight: FontWeight.w500,
                                text: "submit",
                                textalign: TextAlign.left,
                                fontstyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
      },
    );
  }

/* Enroll And Start Course Button  */

  Widget buildBottonButton() {
    return Container(
      height: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      width: MediaQuery.of(context).size.width,
      color: lightblack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 0.7, color: colorAccent),
            ),
            child: MyText(
                color: colorAccent,
                text: detailProvider.courseDetailsModel.result?[0].isFree ==
                            1 ||
                        (detailProvider.courseDetailsModel.result?[0].isFree ==
                                0 &&
                            detailProvider
                                    .courseDetailsModel.result?[0].isUserBuy ==
                                1)
                    ? "free"
                    : "${Constant.currencyCode}${detailProvider.courseDetailsModel.result?[0].price}",
                multilanguage: false,
                fontsizeNormal: Dimens.textTitle,
                fontwaight: FontWeight.w700,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () {
                AdHelper.showFullscreenAd(context, Constant.rewardAdType, () {
                  if (Constant.userID == null) {
                    /* Login Page */
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const Login(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  } else {
                    /* Primium Page  */
                    if (detailProvider.courseDetailsModel.result?[0].isFree ==
                            0 &&
                        detailProvider
                                .courseDetailsModel.result?[0].isUserBuy !=
                            1) {
                      /* Primium Page  */
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AllPayment(
                            /* ContentType 1 == Book */
                            /* ContentType 2 == Course */
                            contentType: "2",
                            payType: 'Content',
                            itemId: detailProvider
                                    .courseDetailsModel.result?[0].id
                                    .toString() ??
                                "",
                            price: detailProvider
                                    .courseDetailsModel.result?[0].price
                                    .toString() ??
                                "",
                            itemTitle: detailProvider
                                    .courseDetailsModel.result?[0].title
                                    .toString() ??
                                "",
                            typeId: "",
                            videoType: "",
                            productPackage: "",
                            currency: Constant.currency,
                            coin: "",
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    } else {
                      /* Open Video Player */
                      if ((detailProvider.videoList == null ||
                              (detailProvider.videoList?.length ?? 0) == 0) &&
                          (detailProvider
                                      .courseDetailsModel.result?[0].chapter ==
                                  null ||
                              (detailProvider.courseDetailsModel.result?[0]
                                          .chapter?.length ??
                                      0) ==
                                  0)) {
                        Utils.showSnackbar(
                            context, "info", "video_not_found", true);
                      } else {
                        printLog(
                            "vUploadType==> ${detailProvider.videoList?[0].videoType.toString() ?? ""}");
                        printLog(
                            "videoUrl==> ${detailProvider.videoList?[0].videoUrl.toString() ?? ""}");

                        Utils.openPlayer(
                          context: context,
                          secreateKey: "",
                          type: "video",
                          videoId: detailProvider.videoList?[0].id ?? 0,
                          videoUrl: detailProvider.videoList?[0].videoUrl
                                  .toString() ??
                              "",
                          vUploadType: detailProvider.videoList?[0].videoType
                                  .toString() ??
                              "",
                          videoThumb: detailProvider.videoList?[0].landscapeImg
                                  .toString() ??
                              "",
                          courseId:
                              detailProvider.courseDetailsModel.result?[0].id ??
                                  0,
                          chepterId: detailProvider.courseDetailsModel
                                  .result?[0].chapter?[0].id ??
                              0,
                        );
                      }
                    }
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: colorPrimary,
                ),
                child: MyText(
                    color: white,
                    text: detailProvider.courseDetailsModel.result?[0].isFree ==
                                1 ||
                            detailProvider
                                    .courseDetailsModel.result?[0].isUserBuy ==
                                1
                        ? "startcourse"
                        : "enrollnow",
                    multilanguage: true,
                    fontsizeNormal: Dimens.textTitle,
                    fontwaight: FontWeight.w600,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
