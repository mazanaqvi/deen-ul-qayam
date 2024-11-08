// // related_course_section.dart
// import 'package:flutter/material.dart';
// import 'package:yourappname/widgets/related_course_item.dart';
// import 'package:provider/provider.dart';
// import 'package:yourappname/provider/coursedetailsprovider.dart';

// class RelatedCourseSection extends StatelessWidget {
//   const RelatedCourseSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final detailProvider = Provider.of<CourseDetailsProvider>(context);

//     if (detailProvider.relatedCourseList == null ||
//         detailProvider.relatedCourseList!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Related Courses",
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.surface,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         const SizedBox(height: 10),
//         ListView.builder(
//           itemCount: detailProvider.relatedCourseList!.length,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return RelatedCourseItem(
//               course: detailProvider.relatedCourseList![index],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
