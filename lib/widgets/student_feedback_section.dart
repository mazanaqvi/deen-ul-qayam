// // student_feedback_section.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yourappname/provider/coursedetailsprovider.dart';
// import 'package:yourappname/widgets/student_feedback_item.dart';

// class StudentFeedbackSection extends StatelessWidget {
//   const StudentFeedbackSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final detailProvider = Provider.of<CourseDetailsProvider>(context);

//     if (detailProvider.reviewList == null ||
//         detailProvider.reviewList!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Student Feedback",
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.surface,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         const SizedBox(height: 15),
//         ListView.builder(
//           itemCount: detailProvider.reviewList!.length,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return StudentFeedbackItem(
//               review: detailProvider.reviewList![index],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
