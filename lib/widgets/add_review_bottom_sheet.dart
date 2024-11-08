// add_review_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final String courseId;

  const AddReviewBottomSheet({Key? key, required this.courseId})
      : super(key: key);

  @override
  _AddReviewBottomSheetState createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  final commentController = TextEditingController();
  double addrating = 0.0;

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<CourseDetailsProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                color: Theme.of(context).colorScheme.surface,
                fontsizeNormal: Dimens.textBig,
                fontsizeWeb: Dimens.textBig,
                multilanguage: true,
                maxline: 1,
                fontwaight: FontWeight.w600,
                text: "Add Review",
                textalign: TextAlign.left,
                fontstyle: FontStyle.normal,
              ),
              RatingBar(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 25,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: colorAccent),
                  half: const Icon(Icons.star_half, color: colorAccent),
                  empty: const Icon(Icons.star_border, color: colorAccent),
                ),
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  setState(() {
                    addrating = rating;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: TextField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Add Comment",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    // Implement add review logic
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
