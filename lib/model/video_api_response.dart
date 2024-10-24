import 'lesson_model.dart';

class VideoApiResponse {
  int? code;
  List<Lesson>? lessons;

  VideoApiResponse({this.code, this.lessons});

  factory VideoApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['lessons'] as List;
    List<Lesson> lessonsList = list.map((i) => Lesson.fromJson(i)).toList();

    return VideoApiResponse(
      code: json['code'],
      lessons: lessonsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'lessons': lessons?.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
