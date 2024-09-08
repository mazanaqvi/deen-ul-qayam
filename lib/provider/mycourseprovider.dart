import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:yourappname/model/certificatemodel.dart';
import 'package:yourappname/model/mycoursemodel.dart' as mycourse;
import 'package:yourappname/model/mycoursemodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:yourappname/utils/utils.dart';

class MyCourseProvider extends ChangeNotifier {
  MyCourseModel myCourseModel = MyCourseModel();

  List<mycourse.Result>? mycourseList = [];
  bool loading = false, loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

  /* Generate Certificate */
  CertificateModel certificateModel = CertificateModel();
  bool certificateDownloading = false;
  String? taskId;
  int dProgress = 0;

  Future<void> getMyCourse(pageno) async {
    loading = true;
    myCourseModel = await ApiService().mycourse(pageno);
    if (myCourseModel.status == 200) {
      setPaginationData(myCourseModel.totalRows, myCourseModel.totalPage,
          myCourseModel.currentPage, myCourseModel.morePage);
      if (myCourseModel.result != null &&
          (myCourseModel.result?.length ?? 0) > 0) {
        printLog("MyCourse length :==> ${(myCourseModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (myCourseModel.result != null &&
            (myCourseModel.result?.length ?? 0) > 0) {
          printLog(
              "MyCourse length :==> ${(myCourseModel.result?.length ?? 0)}");
          for (var i = 0; i < (myCourseModel.result?.length ?? 0); i++) {
            mycourseList?.add(myCourseModel.result?[i] ?? mycourse.Result());
          }
          final Map<int, mycourse.Result> postMap = {};
          mycourseList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          mycourseList = postMap.values.toList();
          printLog("MyCourseList length :==> ${(mycourseList?.length ?? 0)}");
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
  clearProvider() {
    myCourseModel = MyCourseModel();
    mycourseList = [];
    mycourseList?.clear();
    loading = false;
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
