import 'package:yourappname/model/SuccessModel.dart';
import 'package:yourappname/model/notificationmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModel notificationModel = NotificationModel();
  SuccessModel successModel = SuccessModel();
  int position = 0;
  bool isNotification = false;
  bool readnotificationloading = false;

  List<Result>? notificationList = [];
  bool loadMore = false, loading = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  Future<void> getNotification(pageNo) async {
    loading = true;
    notificationModel = await ApiService().getNotification(pageNo);
    if (notificationModel.status == 200) {
      setPaginationData(
          notificationModel.totalRows,
          notificationModel.totalPage,
          notificationModel.currentPage,
          notificationModel.morePage);
      if (notificationModel.result != null &&
          (notificationModel.result?.length ?? 0) > 0) {
        printLog(
            "followingModel length :==> ${(notificationModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (notificationModel.result != null &&
            (notificationModel.result?.length ?? 0) > 0) {
          printLog(
              "followingModel length :==> ${(notificationModel.result?.length ?? 0)}");
          for (var i = 0; i < (notificationModel.result?.length ?? 0); i++) {
            notificationList?.add(notificationModel.result?[i] ?? Result());
          }
          final Map<int, Result> postMap = {};
          notificationList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          notificationList = postMap.values.toList();
          printLog(
              "followFollowingList length :==> ${(notificationList?.length ?? 0)}");
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

  getReadNotification(index, notificationId, isNotification) async {
    position = index;
    isNotification = isNotification;
    setReadNotificationLoading(true);
    successModel = await ApiService().readNotification(notificationId);
    setReadNotificationLoading(false);
    notificationList?.removeAt(index);
  }

  setReadNotificationLoading(isSending) {
    printLog("isSending ==> $isSending");
    readnotificationloading = isSending;
    notifyListeners();
  }

  clearProvider() {
    notificationModel = NotificationModel();
    loading = false;
    position = 0;
    notificationList = [];
    notificationList?.clear();
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
