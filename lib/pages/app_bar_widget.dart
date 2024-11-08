import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/lessonsprovider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLesson;
  final BuildContext parentContext;

  const CustomAppBar(
      {Key? key, required this.isLesson, required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: buildAppBarLeading(),
      actions: buildAppBarActions(context),
    );
  }

  Widget buildAppBarLeading() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(parentContext).pop(false);
      },
      child: const Padding(
        padding: EdgeInsets.all(5),
        child: Align(
          alignment: Alignment.center,
          child: Icon(Icons.arrow_back),
        ),
      ),
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    if (isLesson) {
      return [buildLessonAppBarActions()];
    } else {
      return [buildCourseAppBarActions()];
    }
  }

  Widget buildLessonAppBarActions() {
    return Consumer<LessonsProvider>(
      builder: (context, lessonsProvider, child) {
        // Customize as needed
        return Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Implement share functionality
            },
          ),
        );
      },
    );
  }

  Widget buildCourseAppBarActions() {
    return Consumer<CourseDetailsProvider>(
      builder: (context, detailProvider, child) {
        // Existing code for course AppBar actions
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Wishlist Icon
              IconButton(
                icon: Icon(
                  detailProvider.courseDetailsModel.result?[0].isWishlist == 1
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      detailProvider.courseDetailsModel.result?[0].isWishlist ==
                              1
                          ? Colors.red
                          : Colors.white,
                ),
                onPressed: () {
                  // Handle wishlist action
                },
              ),
              // Share Icon
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Handle share action
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
