// bottom_button.dart
import 'package:flutter/material.dart';
import 'package:yourappname/utils/color.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/dimens.dart';
import 'package:yourappname/widget/mytext.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<CourseDetailsProvider>(context);

    return Container(
      height: 70,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      width: MediaQuery.of(context).size.width,
      color: lightblack,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 0.7, color: colorAccent),
            ),
            child: MyText(
              color: colorAccent,
              text: detailProvider.courseDetailsModel.result?[0].isFree == 1 ||
                      (detailProvider.courseDetailsModel.result?[0].isFree ==
                              0 &&
                          detailProvider
                                  .courseDetailsModel.result?[0].isUserBuy ==
                              1)
                  ? "Free"
                  : "${Constant.currencyCode}${detailProvider.courseDetailsModel.result?[0].price}",
              fontsizeNormal: Dimens.textTitle,
              fontwaight: FontWeight.w700,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.left,
              fontstyle: FontStyle.normal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () {
                // Implement your enroll/start course logic
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: colorPrimary,
                ),
                child: MyText(
                  color: Colors.white,
                  text: detailProvider.courseDetailsModel.result?[0].isFree ==
                              1 ||
                          detailProvider
                                  .courseDetailsModel.result?[0].isUserBuy ==
                              1
                      ? "Start Course"
                      : "Enroll Now",
                  fontsizeNormal: Dimens.textTitle,
                  fontwaight: FontWeight.w600,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.left,
                  fontstyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
