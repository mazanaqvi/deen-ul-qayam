// lib/model/video_api_response.dart
import 'package:yourappname/model/lesson_model.dart'; // Add this import

class VideoApiResponse {
  final int? code;
  final List<Lesson>? lessons;

  VideoApiResponse({this.code, this.lessons});

  factory VideoApiResponse.fromJson(Map<String, dynamic> json) {
    return VideoApiResponse(
      code: json['code'],
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e))
          .toList(),
    );
  }
}
