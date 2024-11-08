// course_episode_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/model/coursedetailsmodel.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';

class CourseEpisodeItem extends StatelessWidget {
  final Chapter chapter;
  final int index;

  const CourseEpisodeItem(
      {Key? key, required this.chapter, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<CourseDetailsProvider>(context);

    return InkWell(
      onTap: () {
        // Handle chapter expand/collapse
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${index + 1}. ${chapter.name ?? ""}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  detailProvider.chapterIndex == index &&
                          detailProvider.isOpen == true
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
            // Implement video list for the chapter
          ],
        ),
      ),
    );
  }
}
