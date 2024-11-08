import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourappname/provider/coursedetailsprovider.dart';


class BottomButtonWidget extends StatelessWidget {
  final String courseId;

  const BottomButtonWidget({Key? key, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseDetailsProvider>(
      builder: (context, detailProvider, child) {
        // Your existing code for the bottom button
        return Container(
          height: 70,
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Row(
            children: [
              // Price Container
              Container(
                height: 50,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 0.7, color: Colors.blueAccent),
                ),
                child: Text(
                  detailProvider.courseDetailsModel.result?[0].isFree == 1
                      ? 'Free'
                      : '${detailProvider.courseDetailsModel.result?[0].price}',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Enroll or Start Course Button
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Handle button tap
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      detailProvider.courseDetailsModel.result?[0].isFree ==
                                  1 ||
                              detailProvider.courseDetailsModel.result?[0]
                                      .isUserBuy ==
                                  1
                          ? 'Start Course'
                          : 'Enroll Now',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
