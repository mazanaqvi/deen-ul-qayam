// // model/lesson_detail_model.dart
// import 'lesson_model.dart';

// class LessonDetail extends Lesson {
//   LessonDetail({
//     required String name,
//     String? audioAddress,
//     String? audioSize,
//     String? videoAddress,
//     String? videoSize,
//     String? duration,
//     String? id,
//     String? title,
//     String? description,
//   }) : super(
//           name: name,
//           audioAddress: audioAddress,
//           audioSize: audioSize,
//           videoAddress: videoAddress,
//           videoSize: videoSize,
//           duration: duration,
//           id: id,
//           title: title,
//           description: description,
//         );

//   factory LessonDetail.fromJson(Map<String, dynamic> json) {
//     return LessonDetail(
//       name: json['name'] as String? ?? '',
//       audioAddress: json['audioAddress'] as String? ?? '',
//       audioSize: json['audioSize'] as String? ?? '-1',
//       videoAddress: json['videoAddress'] as String? ?? '',
//       videoSize: json['videoSize'] as String? ?? '-1',
//       duration: json['duration'] as String? ?? '',
//       id: json['id'] as String?,
//       title: json['title'] as String?,
//       description: json['description'] as String?,
//     );
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     final data = super.toJson();
//     data.addAll({
//       'id': id,
//       'title': title,
//       'description': description,
//     });
//     return data;
//   }
// }
