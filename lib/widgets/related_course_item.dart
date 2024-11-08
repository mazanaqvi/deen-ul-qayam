// related_course_item.dart
import 'package:flutter/material.dart';
import 'package:yourappname/model/coursemodel.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:yourappname/widget/mynetworkimg.dart';

class RelatedCourseItem extends StatelessWidget {
  final Result course;

  const RelatedCourseItem({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to course detail
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 2,
              offset: const Offset(0.1, 0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              child: MyNetworkImage(
                imgWidth: 110,
                imgHeight: 100,
                imageUrl: course.thumbnailImg ?? "",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    color: Theme.of(context).colorScheme.surface,
                    text: course.description ?? "",
                    fontsizeNormal: 16,
                    fontwaight: FontWeight.w600,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.left,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${course.view ?? 0} students",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Implement your rating widget
                      Text(
                        "${course.avgRating ?? 0}",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
