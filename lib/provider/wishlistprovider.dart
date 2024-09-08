import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/wishlistmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:yourappname/utils/utils.dart';

class WishlistProvider extends ChangeNotifier {
  /* Wishlist Fields */
  Wishlistmodel wishlistmodel = Wishlistmodel();
  List<Result>? wishList = [];
  bool loading = false, loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;
  int tabindex = 0;

  int position = 0;
  bool deleteWishlistloading = false;
  SuccessModel successModel = SuccessModel();

  Future<void> getWishList(type, pageno) async {
    loading = true;
    wishlistmodel = await ApiService().wishlist(type, pageno);
    if (wishlistmodel.status == 200) {
      setPaginationData(wishlistmodel.totalRows, wishlistmodel.totalPage,
          wishlistmodel.currentPage, wishlistmodel.morePage);
      if (wishlistmodel.result != null &&
          (wishlistmodel.result?.length ?? 0) > 0) {
        printLog("wishlist length :==> ${(wishlistmodel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (wishlistmodel.result != null &&
            (wishlistmodel.result?.length ?? 0) > 0) {
          printLog(
              "wishlist length :==> ${(wishlistmodel.result?.length ?? 0)}");
          for (var i = 0; i < (wishlistmodel.result?.length ?? 0); i++) {
            wishList?.add(wishlistmodel.result?[i] ?? Result());
          }
          final Map<int, Result> postMap = {};
          wishList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          wishList = postMap.values.toList();
          printLog("wishlist length :==> ${(wishList?.length ?? 0)}");
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

/* Add Remove Wishlist Api */

  addremoveWatchLater(type, index, contentId) async {
    position = index;
    removeWishList(true);
    successModel = await ApiService().addRemoveWishlist(type, contentId);
    removeWishList(false);
    wishList?.removeAt(index);
  }

  removeWishList(isSending) {
    deleteWishlistloading = isSending;
    notifyListeners();
  }

/* Chnage Tab */
  chageTab(int index) {
    tabindex = index;
    notifyListeners();
  }

  clearWishList() {
    wishlistmodel = Wishlistmodel();
    wishList?.clear();
    wishList = [];
  }

/* Clear Provider */

  clearProvider() {
    /* Wishlist Fields */
    wishlistmodel = Wishlistmodel();
    wishList = [];
    loading = false;
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
    tabindex = 0;
    position = 0;
    deleteWishlistloading = false;
    successModel = SuccessModel();
  }
}
