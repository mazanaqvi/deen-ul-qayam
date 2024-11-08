// // student_feedback_item.dart
// import 'package:flutter/material.dart';
// import 'package:yourappname/model/reviewmodel.dart';
// import 'package:yourappname/widget/mytext.dart';
// import 'package:yourappname/widget/mynetworkimg.dart';
// import 'package:yourappname/utils/dimens.dart';
// import 'package:yourappname/utils/color.dart';

// class StudentFeedbackItem extends StatelessWidget {
//   final Review review;

//   const StudentFeedbackItem({Key? key, required this.review}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.08),
//             spreadRadius: 1.5,
//             blurRadius: 0.5,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(50),
//                 child: MyNetworkImage(
//                   imgWidth: 30,
//                   imgHeight: 30,
//                   imageUrl: review.image ?? "",
//                   fit: BoxFit.fill,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   review.fullName ?? review.userName ?? "",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.surface,
//                     fontSize: Dimens.textMedium,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 review.createdAt ?? "",
//                 style: TextStyle(
//                   color: colorPrimary,
//                   fontSize: Dimens.textSmall,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           // Implement rating and comment display
//           Text(
//             review.comment ?? "",
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: Dimens.textSmall,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
