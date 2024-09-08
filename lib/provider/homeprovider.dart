import 'package:yourappname/model/sectionlistmodel.dart' as section;
import 'package:yourappname/model/sectionlistmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:yourappname/utils/utils.dart';

class HomeProvider extends ChangeNotifier {
  /* New Field */
  bool loading = false, loadmore = false;
  SectionListModel sectionListModel = SectionListModel();
  List<section.Result>? sectionList = [];
  int? sectiontotalRows, sectiontotalPage, sectioncurrentPage;
  bool? sectionisMorePage;

  /* PageView Arrow */
  int? cBannerIndex = 0;

  /* New Api */

  Future<void> getSeactionList(pageNo) async {
    loading = true;
    sectionListModel = await ApiService().sectionList(pageNo);
    if (sectionListModel.status == 200) {
      setSectionPaginationData(
          sectionListModel.totalRows,
          sectionListModel.totalPage,
          sectionListModel.currentPage,
          sectionListModel.morePage);
      if (sectionListModel.result != null &&
          (sectionListModel.result?.length ?? 0) > 0) {
        printLog(
            "followingModel length :==> ${(sectionListModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $sectioncurrentPage');
        if (sectionListModel.result != null &&
            (sectionListModel.result?.length ?? 0) > 0) {
          printLog(
              "followingModel length :==> ${(sectionListModel.result?.length ?? 0)}");
          for (var i = 0; i < (sectionListModel.result?.length ?? 0); i++) {
            sectionList?.add(sectionListModel.result?[i] ?? section.Result());
          }
          final Map<int, section.Result> postMap = {};
          sectionList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          sectionList = postMap.values.toList();
          printLog(
              "followFollowingList length :==> ${(sectionList?.length ?? 0)}");
          setLoadMore(false);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  setSectionPaginationData(int? sectiontotalRows, int? sectiontotalPage,
      int? sectioncurrentPage, bool? sectionisMorePage) {
    this.sectioncurrentPage = sectioncurrentPage;
    this.sectiontotalRows = sectiontotalRows;
    this.sectiontotalPage = sectiontotalPage;
    sectionisMorePage = sectionisMorePage;
    notifyListeners();
  }

  setLoadMore(loadmore) {
    this.loadmore = loadmore;
    notifyListeners();
  }

  clearProvider() {
    loading = false;
    loadmore = false;
    sectionListModel = SectionListModel();
    sectionList = [];
    sectionList?.clear();
    sectiontotalRows;
    sectiontotalPage;
    sectioncurrentPage;
    sectionisMorePage;
  }

  setCurrentBanner(position) {
    cBannerIndex = position;
    notifyListeners();
  }
}
