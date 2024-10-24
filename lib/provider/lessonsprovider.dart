import 'package:flutter/material.dart';
import 'package:yourappname/model/video_api_response.dart'; // This already imports Lesson
import 'package:yourappname/model/lesson_model.dart'; // Add if directly using Lesson
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';

class LessonsProvider extends ChangeNotifier {
  VideoApiResponse? videoApiResponse;
  List<Lesson> lessonsList = [];
  bool loading = false;

  Future<void> fetchLessons({int page = 1}) async {
    loading = true;
    notifyListeners();

    try {
      videoApiResponse = await ApiService().getLessonsData();

      if (videoApiResponse != null &&
          videoApiResponse!.lessons != null &&
          videoApiResponse!.lessons!.isNotEmpty) {
        if (page == 1) {
          lessonsList = videoApiResponse!.lessons!;
        } else {
          lessonsList.addAll(videoApiResponse!.lessons!);
        }
        printLog("Lessons fetched successfully: ${lessonsList.length}");
      } else {
        printLog("No lessons available.");
      }
    } catch (e) {
      printLog("Error fetching lessons: $e");
    }

    loading = false;
    notifyListeners();
  }

  void clearProvider() {
    videoApiResponse = null;
    lessonsList = [];
    loading = false;
    notifyListeners();
  }
}
