import 'package:flutter/material.dart';
import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/buybookmodel.dart';
import 'package:yourappname/model/ebookdetailmodel.dart';
import 'package:yourappname/model/getcoursereviewmodel.dart' as review;
import 'package:yourappname/model/getcoursereviewmodel.dart';
import 'package:yourappname/model/relatedbookmodel.dart' as relatedbook;
import 'package:yourappname/model/relatedbookmodel.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:yourappname/webservice/apiservice.dart';

class EbookDetailProvider extends ChangeNotifier {
  EbookDetailModel ebookDetailModel = EbookDetailModel();
  /* Add Review Field */
  SuccessModel successModel = SuccessModel();
  Buybookmodel buybookmodel = Buybookmodel();
  bool loading = false;
  int ebookType = 0;

  /* Related Book Field */
  RelatedBookModel relatedBookModel = RelatedBookModel();
  List<relatedbook.Result>? relatedBookList = [];
  bool relatedBookLoading = false, relatedBookloadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  /* Get Book Review List Field */
  GetCourseReviewModel getCourseReviewModel = GetCourseReviewModel();
  List<review.Result>? reviewList = [];
  int? reviewtotalRows, reviewtotalPage, reviewcurrentPage;
  bool? reviewisMorePage;
  bool reviewloading = false, reviewloadmore = false;

  getEbooksDetail(bookId) async {
    loading = true;
    ebookDetailModel = await ApiService().bookDetail(bookId);
    loading = false;
    notifyListeners();
  }

  getBuybook(bookid, amount, userid) async {
    loading = true;
    buybookmodel = await ApiService().buybook(bookid, amount, userid);
    loading = false;
    notifyListeners();
  }

  Future<void> addReview(type, contentId, comment, rating) async {
    loading = true;
    successModel =
        await ApiService().addContentReview(type, contentId, comment, rating);
    loading = false;
    notifyListeners();
  }

  ebookTab(int type) {
    ebookType = type;
    notifyListeners();
  }

  /* Add Like Dislike */

  /* Product Like Dislike */
  addRemoveWishlist(type, contentId) {
    if ((ebookDetailModel.result?[0].isWishlist ?? 0) == 0) {
      ebookDetailModel.result?[0].isWishlist = 1;
    } else {
      ebookDetailModel.result?[0].isWishlist = 0;
    }
    notifyListeners();
    addremoveWishList(type, contentId);
  }

  Future<void> addremoveWishList(type, contentId) async {
    successModel = await ApiService().addRemoveWishlist(type, contentId);
  }

/* Related Book With Pagination Start */

  Future<void> getRelatedBooks(bookId, pageNo) async {
    relatedBookLoading = true;
    relatedBookModel = await ApiService().relatedBooks(bookId, pageNo);
    if (relatedBookModel.status == 200) {
      setPaginationData(relatedBookModel.totalRows, relatedBookModel.totalPage,
          relatedBookModel.currentPage, relatedBookModel.morePage);
      if (relatedBookModel.result != null &&
          (relatedBookModel.result?.length ?? 0) > 0) {
        printLog(
            "Related BookModel length :==> ${(relatedBookModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (relatedBookModel.result != null &&
            (relatedBookModel.result?.length ?? 0) > 0) {
          printLog(
              "Related BookModel length :==> ${(relatedBookModel.result?.length ?? 0)}");
          for (var i = 0; i < (relatedBookModel.result?.length ?? 0); i++) {
            relatedBookList
                ?.add(relatedBookModel.result?[i] ?? relatedbook.Result());
          }
          final Map<int, relatedbook.Result> postMap = {};
          relatedBookList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          relatedBookList = postMap.values.toList();
          printLog(
              "Related BookList length :==> ${(relatedBookList?.length ?? 0)}");
          setLoadMore(false);
        }
      }
    }
    relatedBookLoading = false;
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

  setLoadMore(relatedBookloadMore) {
    this.relatedBookloadMore = relatedBookloadMore;
    notifyListeners();
  }

/* Review List */

/* Course Review List */

  Future<void> getReviewByBook(type, contentId, pageNo) async {
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

  clearProvider() {
    ebookDetailModel = EbookDetailModel();
    successModel = SuccessModel();
    buybookmodel = Buybookmodel();
    loading = false;
    ebookType = 0;
    relatedBookModel = RelatedBookModel();
    relatedBookList = [];
    relatedBookList?.clear();
    relatedBookLoading = false;
    relatedBookloadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
