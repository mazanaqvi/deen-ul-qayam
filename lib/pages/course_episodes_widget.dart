import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';

class CourseEpisodesWidget extends StatelessWidget {
  const CourseEpisodesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseDetailsProvider>(
      builder: (context, detailProvider, child) {
        if (detailProvider.courseDetailsModel.result?[0].chapter != null &&
            (detailProvider.courseDetailsModel.result?[0].chapter?.length ??
                    0) >
                0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Curriculum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // Course Episodes
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: detailProvider
                        .courseDetailsModel.result?[0].chapter?.length ??
                    0,
                itemBuilder: (BuildContext context, int index) {
                  final chapter = detailProvider
                      .courseDetailsModel.result?[0].chapter?[index];
                  return ExpansionTile(
                    title: Text(chapter?.name ?? ''),
                    children: [
                      // List of videos in the chapter
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: detailProvider.videoList?.length ?? 0,
                        itemBuilder: (context, videoIndex) {
                          final video = detailProvider.videoList?[videoIndex];
                          return ListTile(
                            title: Text(video?.title ?? ''),
                            onTap: () {
                              // Handle video tap
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
