import 'package:yourappname/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:yourappname/model/getebookmodel.dart' as ebook;
import 'package:yourappname/model/getebookmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';

class EbookProvider extends ChangeNotifier {
  EbookModel getEbookModel = EbookModel();
  List<ebook.Result>? ebookList = [];
  bool loading = false, loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  Future<void> getEbooks(pageNo) async {
    loading = true;
    getEbookModel = await ApiService().bookList(pageNo);
    if (getEbookModel.status == 200) {
      setPaginationData(getEbookModel.totalRows, getEbookModel.totalPage,
          getEbookModel.currentPage, getEbookModel.morePage);
      if (getEbookModel.result != null &&
          (getEbookModel.result?.length ?? 0) > 0) {
        printLog(
            "followingModel length :==> ${(getEbookModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (getEbookModel.result != null &&
            (getEbookModel.result?.length ?? 0) > 0) {
          printLog(
              "followingModel length :==> ${(getEbookModel.result?.length ?? 0)}");
          for (var i = 0; i < (getEbookModel.result?.length ?? 0); i++) {
            ebookList?.add(getEbookModel.result?[i] ?? ebook.Result());
          }
          final Map<int, ebook.Result> postMap = {};
          ebookList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          ebookList = postMap.values.toList();
          printLog(
              "followFollowingList length :==> ${(ebookList?.length ?? 0)}");
          setLoadMore(false);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  setPaginationData(
      int? totalRows, int? totalPage, int? currentPage, bool? morePage) {
    this.currentPage = currentPage;
    this.totalRows = totalRows;
    this.totalPage = totalPage;
    isMorePage = morePage;
    notifyListeners();
  }

  setLoadMore(loadMore) {
    this.loadMore = loadMore;
    notifyListeners();
  }

  clearProvider() {
    getEbookModel = EbookModel();
    ebookList?.clear();
    ebookList = [];
    loading = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
