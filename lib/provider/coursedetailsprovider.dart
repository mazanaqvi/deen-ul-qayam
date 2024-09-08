import 'dart:io';
import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/certificatemodel.dart';
import 'package:yourappname/model/coursedetailsmodel.dart';
import 'package:yourappname/model/getcoursereviewmodel.dart' as review;
import 'package:yourappname/model/getcoursereviewmodel.dart';
import 'package:yourappname/model/getvideobychapter.dart' as video;
import 'package:yourappname/model/getvideobychapter.dart';
import 'package:yourappname/model/relatedcoursemodel.dart' as related;
import 'package:yourappname/model/relatedcoursemodel.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';

class CourseDetailsProvider extends ChangeNotifier {
  /* Course Detail Field */
  CourseDetailsModel courseDetailsModel = CourseDetailsModel();
  bool loading = false;

  /* Get Review By Course Field */
  GetCourseReviewModel getCourseReviewModel = GetCourseReviewModel();
  List<review.Result>? reviewList = [];
  int? reviewtotalRows, reviewtotalPage, reviewcurrentPage;
  bool? reviewisMorePage;
  bool reviewloading = false, reviewloadmore = false;

  /* Get Related Course Field */
  RelatedCourseModel relatedCourseModel = RelatedCourseModel();
  List<related.Result>? relatedCourseList = [];
  int? relatedCoursetotalRows, relatedCoursetotalPage, relatedCoursecurrentPage;
  bool? relatedCourseisMorePage;
  bool relatedCourseloading = false, relatedCourseloadmore = false;

  /* Add Review Field */
  SuccessModel successModel = SuccessModel();

  /* Video By Chapter */

  GetVideoByChapterModel getVideoByChapterModel = GetVideoByChapterModel();
  List<video.Result>? videoList = [];
  int? videototalRows, videototalPage, videocurrentPage;
  bool? videoisMorePage;
  bool videoloading = false, videoloadmore = false;

  /* Open CLose Chapter Video */
  int? chapterIndex;
  bool isOpen = true;
  int dProgress = 0;

  /* Generate Certificate */
  CertificateModel certificateModel = CertificateModel();
  bool certificateDownloading = false;
  String? taskId;

/* Course Detail Api */

  Future<void> getCourseDetails(courseId) async {
    loading = true;
    courseDetailsModel = await ApiService().courseDetail(courseId);
    loading = false;
    notifyListeners();
  }

/* Course Review List */

  Future<void> getReviewByCourse(type, contentId, pageNo) async {
    reviewloading = true;
    getCourseReviewModel =
        await ApiService().courseReviewList(type, contentId, pageNo);
    if (getCourseReviewModel.status == 200) {
      setReviewPaginationData(
          getCourseReviewModel.totalRows,
          getCourseReviewModel.totalPage,
          getCourseReviewModel.currentPage,
          getCourseReviewModel.morePage);
      if (getCourseReviewModel.result != null &&
          (getCourseReviewModel.result?.length ?? 0) > 0) {
        printLog(
            "reviewList length :==> ${(getCourseReviewModel.result?.length ?? 0)}");
        if (getCourseReviewModel.result != null &&
            (getCourseReviewModel.result?.length ?? 0) > 0) {
          printLog(
              "reviewList length :==> ${(getCourseReviewModel.result?.length ?? 0)}");
          for (var i = 0; i < (getCourseReviewModel.result?.length ?? 0); i++) {
            reviewList?.add(getCourseReviewModel.result?[i] ?? review.Result());
          }
          final Map<int, review.Result> postMap = {};
          reviewList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          reviewList = postMap.values.toList();
          printLog("reviewList length :==> ${(reviewList?.length ?? 0)}");
          setReviewLoadMore(false);
        }
      }
    }
    reviewloading = false;
    notifyListeners();
  }

  setReviewPaginationData(int? reviewtotalRows, int? reviewtotalPage,
      int? reviewcurrentPage, bool? reviewisMorePage) {
    this.reviewcurrentPage = reviewcurrentPage;
    this.reviewtotalRows = reviewtotalRows;
    this.reviewtotalPage = reviewtotalPage;
    reviewisMorePage = reviewisMorePage;
    notifyListeners();
  }

  setReviewLoadMore(reviewloadmore) {
    this.reviewloadmore = reviewloadmore;
    notifyListeners();
  }

/* Related Course */

  Future<void> getRelatedCourse(courseId, pageNo) async {
    reviewloading = true;
    relatedCourseModel = await ApiService().relatedcourse(courseId, pageNo);
    if (relatedCourseModel.status == 200) {
      setReviewPaginationData(
          relatedCourseModel.totalRows,
          relatedCourseModel.totalPage,
          relatedCourseModel.currentPage,
          relatedCourseModel.morePage);
      if (relatedCourseModel.result != null &&
          (relatedCourseModel.result?.length ?? 0) > 0) {
        printLog(
            "relatedCourseList length :==> ${(relatedCourseModel.result?.length ?? 0)}");
        if (relatedCourseModel.result != null &&
            (relatedCourseModel.result?.length ?? 0) > 0) {
          printLog(
              "relatedCourseList length :==> ${(relatedCourseModel.result?.length ?? 0)}");
          for (var i = 0; i < (relatedCourseModel.result?.length ?? 0); i++) {
            relatedCourseList
                ?.add(relatedCourseModel.result?[i] ?? related.Result());
          }
          final Map<int, related.Result> postMap = {};
          relatedCourseList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          relatedCourseList = postMap.values.toList();
          printLog(
              "relatedCourseList length :==> ${(relatedCourseList?.length ?? 0)}");
          setReviewLoadMore(false);
        }
      }
    }
    reviewloading = false;
    notifyListeners();
  }

  setRelatedCoursePaginationData(
      int? relatedCoursetotalRows,
      int? relatedCoursetotalPage,
      int? relatedCoursecurrentPage,
      bool? relatedCourseisMorePage) {
    this.relatedCoursecurrentPage = relatedCoursecurrentPage;
    this.relatedCoursetotalRows = relatedCoursetotalRows;
    this.relatedCoursetotalPage = relatedCoursetotalPage;
    relatedCourseisMorePage = relatedCourseisMorePage;
    notifyListeners();
  }

  setRelatedCourseLoadMore(relatedCourseloadmore) {
    this.relatedCourseloadmore = relatedCourseloadmore;
    notifyListeners();
  }

/* Get Video By Chapter */

  Future<void> getVideoByChapter(courseId, chapterId, pageNo, isViewAll) async {
    if (isViewAll == false) {
      videoList = [];
      videoList?.clear();
    }
    videoloading = true;
    getVideoByChapterModel =
        await ApiService().videoByChapter(courseId, chapterId, pageNo);
    if (getVideoByChapterModel.status == 200) {
      setVideoPaginationData(
          getVideoByChapterModel.totalRows,
          getVideoByChapterModel.totalPage,
          getVideoByChapterModel.currentPage,
          getVideoByChapterModel.morePage);
      if (getVideoByChapterModel.result != null &&
          (getVideoByChapterModel.result?.length ?? 0) > 0) {
        printLog(
            "videoList length :==> ${(getVideoByChapterModel.result?.length ?? 0)}");
        if (getVideoByChapterModel.result != null &&
            (getVideoByChapterModel.result?.length ?? 0) > 0) {
          printLog(
              "videoList length :==> ${(getVideoByChapterModel.result?.length ?? 0)}");
          for (var i = 0;
              i < (getVideoByChapterModel.result?.length ?? 0);
              i++) {
            videoList?.add(getVideoByChapterModel.result?[i] ?? video.Result());
          }
          final Map<int, video.Result> postMap = {};
          videoList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          videoList = postMap.values.toList();
          printLog("videoList length :==> ${(videoList?.length ?? 0)}");
          setVideoLoadMore(false);
        }
      }
    }
    videoloading = false;
    notifyListeners();
  }

  setVideoPaginationData(int? videototalRows, int? videototalPage,
      int? videocurrentPage, bool? videoisMorePage) {
    this.videocurrentPage = videocurrentPage;
    this.videototalRows = videototalRows;
    this.videototalPage = videototalPage;
    videoisMorePage = videoisMorePage;
    notifyListeners();
  }

  setVideoLoadMore(videoloadmore) {
    this.videoloadmore = videoloadmore;
    notifyListeners();
  }

/* Add Like Dislike */

  /* Product Like Dislike */
  addRemoveWishlist(type, contentId) {
    if ((courseDetailsModel.result?[0].isWishlist ?? 0) == 0) {
      courseDetailsModel.result?[0].isWishlist = 1;
    } else {
      courseDetailsModel.result?[0].isWishlist = 0;
    }
    notifyListeners();
    addremoveWishList(type, contentId);
  }

  Future<void> addremoveWishList(type, contentId) async {
    successModel = await ApiService().addRemoveWishlist(type, contentId);
  }

/* clear Video */

/* Open Close Video Dropdown */
  openChapterVideo(index, open) async {
    chapterIndex = index;
    isOpen = open;
    notifyListeners();
  }

/* Add Review Api */

  Future<void> addReview(type, contentId, comment, rating) async {
    loading = true;
    successModel =
        await ApiService().addContentReview(type, contentId, comment, rating);
    loading = false;
    notifyListeners();
  }

/* Generate Certificate With Download Start */

  fetchCertificate(courseId) async {
    certificateDownloading = true;
    certificateModel = await ApiService().fetchCertificate(courseId);
    certificateDownloading = false;
    notifyListeners();
  }

  Future<void> downloadCertificate(
      String? url, String? localPath, File saveFile) async {
    taskId = await FlutterDownloader.enqueue(
      url: url ?? "",
      savedDir: localPath ?? "",
      fileName: basename(saveFile.path),
      saveInPublicStorage: false,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  setDownloadProgress(int progress) {
    dProgress = progress;
    notifyListeners();
    printLog('setDownloadProgress dProgress ==============> $dProgress');
  }

/* Generate Certificate With Download End */

  clearVideoChapter() {
    getVideoByChapterModel = GetVideoByChapterModel();
    videoList = [];
    videoList?.clear();
    videototalRows;
    videototalPage;
    videocurrentPage;
    videoisMorePage;
    videoloading = false;
    videoloadmore = false;
  }

  clearProvider() {
    /* Course Detail Field */
    courseDetailsModel = CourseDetailsModel();
    loading = false;
    /* Get Review By Course Field */
    getCourseReviewModel = GetCourseReviewModel();
    reviewList = [];
    reviewList?.clear();
    reviewtotalRows;
    reviewtotalPage;
    reviewcurrentPage;
    reviewisMorePage;
    reviewloading = false;
    reviewloadmore = false;
    /* Get Related Course Field */
    relatedCourseModel = RelatedCourseModel();
    relatedCourseList = [];
    relatedCourseList?.clear();
    relatedCoursetotalRows;
    relatedCoursetotalPage;
    relatedCoursecurrentPage;
    relatedCourseisMorePage;
    relatedCourseloading = false;
    relatedCourseloadmore = false;
    /* Add Review Field */
    successModel = SuccessModel();
    getVideoByChapterModel = GetVideoByChapterModel();
    videoList = [];
    videoList?.clear();
    videototalRows;
    videototalPage;
    videocurrentPage;
    videoisMorePage;
    videoloading = false;
    videoloadmore = false;

    chapterIndex;
    isOpen = false;
    /* Generate Certificate */
    certificateModel = CertificateModel();
    certificateDownloading = false;
    dProgress = 0;
  }
}
