// child_container.dart
import 'package:flutter/material.dart';
import 'package:yourappname/widgets/related_course_section.dart';
import 'package:yourappname/widgets/course_episodes_section.dart';
import 'package:yourappname/widgets/student_feedback_section.dart';

class ChildContainer extends StatelessWidget {
  const ChildContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        const RelatedCourseSection(),
        const SizedBox(height: 15),
        const CourseEpisodesSection(),
        const SizedBox(height: 15),
        const StudentFeedbackSection(),
        const SizedBox(height: 20),
      ],
    );
  }
}
