// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yourappname/provider/lessonsprovider.dart';

// class LessonContentWidget extends StatelessWidget {
//   final String courseId;

//   const LessonContentWidget({Key? key, required this.courseId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LessonsProvider>(
//       builder: (context, lessonsProvider, child) {
//         if (lessonsProvider.loading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (lessonsProvider.lessonsList.isEmpty) {
//           return const Center(child: Text('No Data'));
//         } else {
//           // Get all lessons for the course
//           List<Lesson> lessons = lessonsProvider.lessonsList;

//           if (lessons.isEmpty) {
//             return const Center(child: Text('No Data'));
//           } else {
//             // Parse course name from the first lesson's videoAddress
//             String courseName = '';
//             if (lessons[0].videoAddress?.isNotEmpty ?? false) {
//               Uri uri = Uri.parse(lessons[0].videoAddress!);
//               List<String> pathSegments = uri.pathSegments;
//               if (pathSegments.length >= 2) {
//                 courseName = pathSegments[pathSegments.length - 2];
//               }
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Display the course name
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Text(
//                     'Course: $courseName',
//                     style: const TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: lessons.length,
//                     itemBuilder: (context, index) {
//                       final lesson = lessons[index];

//                       // Extract lesson number from the lesson name
//                       String lessonNumber = '';
//                       if (lesson.name?.isNotEmpty ?? false) {
//                         RegExp regExp = RegExp(r'Dars-(\d+)$');
//                         Match? match = regExp.firstMatch(lesson.name!);
//                         if (match != null) {
//                           lessonNumber = match.group(1) ?? '';
//                         }
//                       }

//                       return ListTile(
//                         title: Text('Lesson: $lessonNumber'),
//                         onTap: () {
//                           // Play the video
//                           String videoUrl = lesson.videoAddress ?? '';
//                           if (videoUrl.isNotEmpty) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => VideoPlayerPage(
//                                   videoUrl: videoUrl,
//                                   lessonNumber: lessonNumber,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             // Handle error
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text('Video URL is not available')),
//                             );
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         }
//       },
//     );
//   }
// }
