import 'package:flutter/material.dart';
import 'package:yourappname/model/video_api_response.dart';
import 'package:yourappname/model/lesson_model.dart';
import 'package:yourappname/webservice/apiservice.dart';
import 'package:yourappname/utils/utils.dart';

class LessonsProvider extends ChangeNotifier {
  VideoApiResponse? videoApiResponse;
  List<Lesson> lessonsList = [];
  bool loading = false;

  // New list to hold grouped lessons by course
  Map<String, List<Lesson>> groupedLessons = {};

  Future<void> fetchLessons({int page = 1}) async {
    loading = true;
    notifyListeners();

    try {
      videoApiResponse = await ApiService().getLessonsData();

      if (videoApiResponse != null &&
          videoApiResponse!.lessons != null &&
          videoApiResponse!.lessons!.isNotEmpty) {
        // Process each lesson to extract course name and episode name
        List<Lesson> processedLessons =
            videoApiResponse!.lessons!.map((lesson) {
          String courseName = _extractCourseNameFromUrl(lesson.videoAddress);
          return lesson.copyWith(
              courseName: courseName, episodeName: lesson.name);
        }).toList();

        // Group lessons by course name
        groupedLessons = {};
        for (var lesson in processedLessons) {
          groupedLessons.putIfAbsent(lesson.courseName!, () => []).add(lesson);
        }

        printLog(
            "Grouped lessons fetched and processed successfully: ${groupedLessons.length}");
      } else {
        printLog("No lessons available.");
      }
    } catch (e) {
      printLog("Error fetching lessons: $e");
    }

    loading = false;
    notifyListeners();
  }

  String _extractCourseNameFromUrl(String? videoUrl) {
    if (videoUrl == null || videoUrl.isEmpty) return "";
    Uri uri = Uri.parse(videoUrl);
    List<String> segments = uri.pathSegments;
    return segments.length >= 2 ? segments[segments.length - 2] : "";
  }

  void clearProvider() {
    videoApiResponse = null;
    lessonsList = [];
    groupedLessons = {};
    loading = false;
    notifyListeners();
  }
}
