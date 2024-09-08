import 'package:yourappname/model/categorymodel.dart' as category;
import 'package:yourappname/model/categorymodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/material.dart';

class ExploreProvider extends ChangeNotifier {
  CategoryModel categoryModel = CategoryModel();
  List<category.Result>? categoryList = [];
  bool loading = false, loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

/* Category List */

  Future<void> getCategory(pageNo) async {
    loading = true;
    categoryModel = await ApiService().category(pageNo);
    if (categoryModel.status == 200) {
      setPaginationData(categoryModel.totalRows, categoryModel.totalPage,
          categoryModel.currentPage, categoryModel.morePage);
      if (categoryModel.result != null &&
          (categoryModel.result?.length ?? 0) > 0) {
        printLog(
            "categoryList length :==> ${(categoryModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (categoryModel.result != null &&
            (categoryModel.result?.length ?? 0) > 0) {
          printLog(
              "categoryList length :==> ${(categoryModel.result?.length ?? 0)}");
          for (var i = 0; i < (categoryModel.result?.length ?? 0); i++) {
            categoryList?.add(categoryModel.result?[i] ?? category.Result());
          }
          final Map<int, category.Result> postMap = {};
          categoryList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          categoryList = postMap.values.toList();
          printLog("categoryList length :==> ${(categoryList?.length ?? 0)}");
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

  /* clear Provider */

  clearProvider() {
    categoryModel = CategoryModel();
    categoryList = [];
    loading = false;
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
