import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'detail.dart';

class RelatedCourseWidget extends StatelessWidget {
  const RelatedCourseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseDetailsProvider>(
      builder: (context, detailProvider, child) {
        if (detailProvider.loading && !detailProvider.relatedCourseloadmore) {
          return const SizedBox.shrink();
        } else {
          if (detailProvider.relatedCourseModel.status == 200 &&
              detailProvider.relatedCourseList != null &&
              (detailProvider.relatedCourseList?.length ?? 0) > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Related Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                buildRelatedCourseItem(detailProvider, context),
                if (detailProvider.relatedCourseloadmore)
                  const Center(child: CircularProgressIndicator())
                else
                  const SizedBox.shrink(),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget buildRelatedCourseItem(
      CourseDetailsProvider detailProvider, BuildContext context) {
    return ResponsiveGridList(
      minItemWidth: 120,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      horizontalGridSpacing: 10,
      verticalGridSpacing: 25,
      listViewBuilderOptions: ListViewBuilderOptions(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        detailProvider.relatedCourseList?.length ?? 0,
        (index) {
          final course = detailProvider.relatedCourseList?[index];
          return InkWell(
            onTap: () {
              // Navigate to course detail page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Detail(
                    courseId: course?.id.toString() ?? '',
                    isLesson: false,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  // Course Thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5),
                    ),
                    child: Image.network(
                      course?.thumbnailImg ?? '',
                      width: 110,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Course Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course?.description ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${course?.totalView ?? 0} Students',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Implement your rating widget here
                            Text(
                              '${course?.avgRating ?? 0}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.amber,
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
        },
      ),
    );
  }
}
