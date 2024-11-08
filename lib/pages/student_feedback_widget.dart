// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yourappname/provider/coursedetailsprovider.dart';
// import 'package:responsive_grid_list/responsive_grid_list.dart';

// class StudentFeedbackWidget extends StatelessWidget {
//   const StudentFeedbackWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CourseDetailsProvider>(
//       builder: (context, detailProvider, child) {
//         if (detailProvider.reviewloading && !detailProvider.reviewloadmore) {
//           return const SizedBox.shrink();
//         } else {
//           if (detailProvider.getCourseReviewModel.status == 200 &&
//               detailProvider.reviewList != null &&
//               (detailProvider.reviewList?.length ?? 0) > 0) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Student Feedback',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 buildStudentFeedbackItem(detailProvider),
//                 if (detailProvider.reviewloadmore)
//                   const Center(child: CircularProgressIndicator())
//                 else
//                   const SizedBox.shrink(),
//               ],
//             );
//           } else {
//             return const SizedBox.shrink();
//           }
//         }
//       },
//     );
//   }

//   Widget buildStudentFeedbackItem(CourseDetailsProvider detailProvider) {
//     return ResponsiveGridList(
//       minItemWidth: 120,
//       minItemsPerRow: 1,
//       maxItemsPerRow: 1,
//       horizontalGridSpacing: 10,
//       verticalGridSpacing: 15,
//       listViewBuilderOptions: ListViewBuilderOptions(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//       ),
//       children: List.generate(
//         detailProvider.reviewList?.length ?? 0,
//         (index) {
//           final review = detailProvider.reviewList?[index];
//           return Container(
//             padding: const EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               color: Theme.of(detailProvider.context).cardColor,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Reviewer's Name and Date
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(review?.image ?? ''),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         review?.fullName ?? 'Guest User',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       review?.createdAt ?? '',
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 // Rating
//                 Row(
//                   children: [
//                     // Implement your rating widget here
//                     Text(
//                       '${review?.rating ?? 0}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.amber,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 // Comment
//                 Text(
//                   review?.comment ?? '',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
