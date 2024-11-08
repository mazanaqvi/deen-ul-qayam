// parent_container.dart
import 'package:flutter/material.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:yourappname/widget/mynetworkimg.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';
import 'package:provider/provider.dart';

class ParentContainer extends StatelessWidget {
  const ParentContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<CourseDetailsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                color: black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MyNetworkImage(
                  imgHeight: 200,
                  fit: BoxFit.fill,
                  islandscap: true,
                  imageUrl: detailProvider
                          .courseDetailsModel.result?[0].thumbnailImg
                          .toString() ??
                      "",
                ),
              ),
            ),
            Positioned.fill(
              child: InkWell(
                splashColor: transparentColor,
                onTap: () {
                  // Implement your video play logic here
                },
                child: const Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.play_arrow_outlined,
                      size: 65, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        MyText(
          color: Theme.of(context).colorScheme.surface,
          text: detailProvider.courseDetailsModel.result?[0].title.toString() ??
              "",
          fontsizeNormal: Dimens.textBig,
          fontwaight: FontWeight.w700,
          maxline: 3,
          overflow: TextOverflow.ellipsis,
          textalign: TextAlign.left,
          fontstyle: FontStyle.normal,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            MyText(
              color: Theme.of(context).colorScheme.surface,
              text: "Created by",
              fontsizeNormal: Dimens.textTitle,
              fontwaight: FontWeight.w600,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: InkWell(
                onTap: () {
                  // Navigate to tutor profile
                },
                child: MyText(
                  color: colorPrimary,
                  text: detailProvider
                              .courseDetailsModel.result?[0].tutorName ==
                          ""
                      ? "Guest User"
                      : detailProvider.courseDetailsModel.result?[0].tutorName
                              .toString() ??
                          "",
                  fontsizeNormal: Dimens.textTitle,
                  fontwaight: FontWeight.w700,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
