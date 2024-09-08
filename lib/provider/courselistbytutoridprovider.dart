import 'package:yourappname/model/courselistbytutoridmodel.dart' as courselist;
import 'package:yourappname/model/courselistbytutoridmodel.dart';
import 'package:yourappname/model/tutorprofilemodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/material.dart';

class CourselistByTutoridProvider extends ChangeNotifier {
  /* Tutor Profile */
  Tutorprofilemodel tutorprofilemodel = Tutorprofilemodel();
  bool loading = false;

  /* Tutor Course List */
  CourselistbytutoridModel courselistbytutoridModel =
      CourselistbytutoridModel();
  List<courselist.Result>? courseList = [];
  bool loadMore = false;
  int? totalRows, totalPage, currentPage;
  bool? isMorePage;

/* Tutor Profile */

  Future<void> getTutorprofile(tutorId) async {
    loading = true;
    tutorprofilemodel = await ApiService().tutorprofile(tutorId);
    loading = false;
    notifyListeners();
  }

  Future<void> getCourseByTutor(type, tutorId, pageNo) async {
    loading = true;
    courselistbytutoridModel =
        await ApiService().getContentByTutor(type, tutorId, pageNo);
    if (courselistbytutoridModel.status == 200) {
      setPaginationData(
          courselistbytutoridModel.totalRows,
          courselistbytutoridModel.totalPage,
          courselistbytutoridModel.currentPage,
          courselistbytutoridModel.morePage);
      if (courselistbytutoridModel.result != null &&
          (courselistbytutoridModel.result?.length ?? 0) > 0) {
        printLog(
            "courseList length :==> ${(courselistbytutoridModel.result?.length ?? 0)}");
        printLog('Now on page ==========> $currentPage');
        if (courselistbytutoridModel.result != null &&
            (courselistbytutoridModel.result?.length ?? 0) > 0) {
          printLog(
              "courseList length :==> ${(courselistbytutoridModel.result?.length ?? 0)}");
          for (var i = 0;
              i < (courselistbytutoridModel.result?.length ?? 0);
              i++) {
            courseList?.add(
                courselistbytutoridModel.result?[i] ?? courselist.Result());
          }
          final Map<int, courselist.Result> postMap = {};
          courseList?.forEach((item) {
            postMap[item.id ?? 0] = item;
          });
          courseList = postMap.values.toList();
          printLog("courseList length :==> ${(courseList?.length ?? 0)}");
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

  /* Clear Provider */

  clearProvider() {
    /* Tutor Profile */
    tutorprofilemodel = Tutorprofilemodel();
    loading = false;
    /* Tutor Course List */
    courselistbytutoridModel = CourselistbytutoridModel();
    courseList = [];
    courseList?.clear();
    loadMore = false;
    totalRows;
    totalPage;
    currentPage;
    isMorePage;
  }
}
