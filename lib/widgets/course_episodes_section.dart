import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:yourappname/widgets/course_episode_item.dart';

class CourseEpisodesSection extends StatelessWidget {
  const CourseEpisodesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<CourseDetailsProvider>(context);

    final courseResult = detailProvider.courseDetailsModel.result;
    final chapters = courseResult != null && courseResult.isNotEmpty
        ? courseResult[0].chapter
        : null;

    if (chapters == null || chapters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Curriculum",
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          itemCount: chapters.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return CourseEpisodeItem(
              chapter: chapters[index],
              index: index,
            );
          },
        ),
      ],
    );
  }
}
