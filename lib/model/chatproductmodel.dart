import 'package:yourappname/utils/firebaseconstant.dart';

class ChatProductModel {
  String productImage;
  String productName;

  ChatProductModel({
    required this.productImage,
    required this.productName,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.courseImage: productImage,
      FirestoreConstants.courseName: productName,
    };
  }

  factory ChatProductModel.fromMap(Map<String, dynamic> doc) {
    String productImage = "";
    String productName = "";

    try {
      productImage = doc[FirestoreConstants.courseImage] ?? "";
    } catch (e) {
      productImage = "";
    }
    try {
      productName = doc[FirestoreConstants.courseName] ?? "";
    } catch (e) {
      productName = "";
    }

    return ChatProductModel(
      productImage: productImage,
      productName: productName,
    );
  }
}
