import 'package:yourappname/model/videobyidmodel.dart' as videobyid;
import 'package:yourappname/model/videobyidmodel.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:yourappname/utils/utils.dart';

class VideoByIdViewAllProvider extends ChangeNotifier {
  /* getCourse By Category And Language */
  VideobyIdModel videobyIdModel = VideobyIdModel();
  List<videobyid.Result>? getCourseList = [];

  /* Common Fields */
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;
  bool loading = false, loadmore = false;

  String layoutType = Constant.grid;

/* Video by Id Api (get_course_by_category & get_course_by_language) */

  Future<void> getVideoById(id, type, pageNo) async {
    loading = true;
    if (type == "category") {
      videobyIdModel = await ApiService().getContentbyCategoryId(id, pageNo);
    } else {
      videobyIdModel = await ApiService().getContentbyLanguageId(id, pageNo);
    }

    if (videobyIdModel.status == 200) {
      setSectionPaginationData(
          videobyIdModel.totalRows,
          videobyIdModel.totalPage,
          videobyIdModel.currentPage,
          videobyIdModel.morePage);
      if (videobyIdModel.result != null &&
          (videobyIdModel.result?.length ?? 0) > 0) {
        printLog(
            "VideoByIdModel length :==> ${(videobyIdModel.result?.length ?? 0)}");
        if (videobyIdModel.result != null &&
            (videobyIdModel.result?.length ?? 0) > 0) {
          printLog(
              "VideoByIdModel length :==> ${(videobyIdModel.result?.length ?? 0)}");
          for (var i = 0; i < (videobyIdModel.result?.length ?? 0); i++) {
            getCourseList?.add(videobyIdModel.result?[i] ?? videobyid.Result());
          }
          final Map<int, videobyid.Result> postMap = {};
          getCourseList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          getCourseList = postMap.values.toList();
          printLog("VideoByIdList length :==> ${(getCourseList?.length ?? 0)}");
          setLoadMore(false);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  setSectionPaginationData(
      int? totalRows, int? totalPage, int? currentPage, bool? isMorePage) {
    this.currentPage = currentPage;
    this.totalRows = totalRows;
    this.totalPage = totalPage;
    isMorePage = isMorePage;
    notifyListeners();
  }

  setLoadMore(loadmore) {
    this.loadmore = loadmore;
    notifyListeners();
  }

  selectLayout(type) async {
    layoutType = type;
    notifyListeners();
  }

  clearProvider() {
    videobyIdModel = VideobyIdModel();
    getCourseList = [];
    getCourseList?.clear();
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
    loading = false;
    loadmore = false;
    layoutType = Constant.grid;
  }
}
