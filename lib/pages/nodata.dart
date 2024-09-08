import 'package:yourappname/widget/myimage.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
      child: MyImage(
        height: 280,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
        imagePath: "nodata.png",
      ),
    );

    // Container(
    //   padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
    //   width: MediaQuery.of(context).size.width,
    //   height: MediaQuery.of(context).size.height,
    //   decoration: BoxDecoration(
    //     color: white,
    //     borderRadius: BorderRadius.circular(12),
    //     shape: BoxShape.rectangle,
    //   ),
    //   constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
    //   child: Center(
    //     child: MyImage(
    //       height: 280,
    //       width: MediaQuery.of(context).size.width,
    //       fit: BoxFit.contain,
    //       imagePath: "nodata.png",
    //     ),
    //   ),
    // );
  }
}
