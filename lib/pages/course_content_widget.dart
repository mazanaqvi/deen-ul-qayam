// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:yourappname/provider/coursedetailsprovider.dart';
// import 'parent_container_widget.dart';
// import 'child_container_widget.dart';

// class CourseContentWidget extends StatelessWidget {
//   final String courseId;

//   const CourseContentWidget({Key? key, required this.courseId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CourseDetailsProvider>(
//       builder: (context, detailProvider, child) {
//         if (detailProvider.loading) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           if (detailProvider.courseDetailsModel.status == 200) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       children: [
//                         ParentContainerWidget(),
//                         ChildContainerWidget(),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Implement other widgets as needed
//               ],
//             );
//           } else {
//             return const Center(child: Text('No Data'));
//           }
//         }
//       },
//     );
//   }
// }
