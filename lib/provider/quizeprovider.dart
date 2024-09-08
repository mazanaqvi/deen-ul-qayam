import 'package:yourappname/model/getquestionbycategorymodel.dart';
import 'package:yourappname/model/savequestionreportmodel.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';
import 'package:flutter/material.dart';

class QuizeProvider extends ChangeNotifier {
  GetQuestionByChapterModel getQuestionByChapterModel =
      GetQuestionByChapterModel();
  SaveQuestionReportModel saveQuestionReportModel = SaveQuestionReportModel();
  bool loading = false;

/* Change Page in Next Button Field */
  int pageIndex = 0;

/* Check Answers With Selection (Right Or Wronge) */
  String optionType = "";
  String optionName = "";
  String correctAns = "";
  bool isSelectAns = false;
  bool rightAnswer = false;
  int rightAnsCount = 0;

/* Check Question Miss OR Select Field */
  int attendedQuestion = 0;

  getQuestionByChapter(courseId, chapterId) async {
    loading = true;
    getQuestionByChapterModel =
        await ApiService().questionByChapter(courseId, chapterId);
    loading = false;
    notifyListeners();
  }

/* Change Page in Next Button */
  setCurrentBanner(position) {
    pageIndex = position;
    notifyListeners();
  }

/* Check Answers (Right Or Wronge) */
/* type (1 ==> optionA), (2 ==> optionB), (3 ==> optionC), (4 ==> optionD) */
  checkAnswer({
    required type,
    required option,
    required rightAns,
    required isSelect,
  }) {
    if (type == rightAns) {
      rightAnswer = true;
      rightAnsCount = rightAnsCount + 1;
    }
    optionType = type;
    optionName = option;
    isSelectAns = isSelect;
    correctAns = rightAns;
    printLog("type==>$type");
    printLog("option==>$option");
    printLog("rightAns==>$rightAns");
    printLog("isSelect==>$isSelect");
    printLog("rightAnsCount==>$rightAnsCount");
    notifyListeners();
  }

  getSavePraticeQuestionReport(
      {courseId,
      chapterId,
      totalQuestion,
      questionsAttended,
      correctAnswers}) async {
    saveQuestionReportModel = await ApiService().saveCourseQuestionReport(
      courseId,
      chapterId,
      totalQuestion,
      questionsAttended,
      correctAnswers,
    );
    notifyListeners();
  }

/*  Check Question Miss OR Select  */
  totalAttendedQuestion() {
    attendedQuestion = attendedQuestion + 1;
    printLog("Attended===> $attendedQuestion");
    notifyListeners();
  }

  clearOnlySelectedAnswer() {
    optionType = "";
    optionName = "";
    correctAns = "";
    isSelectAns = false;
    rightAnswer = false;
    // rightAnsCount = 0;
  }

  clearProvider() {
    printLog("Clear===>");
    getQuestionByChapterModel = GetQuestionByChapterModel();
    loading = false;
    pageIndex = 0;
    optionType = "";
    correctAns = "";
    optionName = "";
    attendedQuestion = 0;
    saveQuestionReportModel = SaveQuestionReportModel();
    isSelectAns = false;
    rightAnswer = false;
    rightAnsCount = 0;
  }
}
