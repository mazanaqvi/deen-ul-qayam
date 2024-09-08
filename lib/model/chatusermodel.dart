import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yourappname/utils/constant.dart';
import 'package:yourappname/utils/firebaseconstant.dart';

class ChatUserModel {
  String biodata;
  String chattingWith;
  String pushToken;
  String createdAt;
  String email;
  String name;
  String photoUrl;
  String userid;
  String userName;
  String isOnline;

  ChatUserModel(
      {required this.biodata,
      required this.chattingWith,
      required this.pushToken,
      required this.createdAt,
      required this.email,
      required this.name,
      required this.photoUrl,
      required this.userid,
      required this.userName,
      required this.isOnline});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.bioData: biodata,
      FirestoreConstants.chattingWith: chattingWith,
      FirestoreConstants.deviceToken: pushToken,
      FirestoreConstants.createdAt: createdAt,
      FirestoreConstants.email: email,
      FirestoreConstants.name: name,
      FirestoreConstants.profileurl: photoUrl,
      FirestoreConstants.userid: userid,
      FirestoreConstants.username: userName,
      FirestoreConstants.isOnline: isOnline,
    };
  }

  factory ChatUserModel.fromDocument(DocumentSnapshot doc) {
    String biodata = "";
    String chattingWith = "";
    String pushToken = "";
    String createdAt = "";
    String email = "";
    String name = "";
    String photoUrl = "";
    String userid = "";
    String userName = "";
    String isOnline = "";
    try {
      biodata = doc[FirestoreConstants.bioData] ?? "";
    } catch (e) {
      biodata = "";
    }
    try {
      chattingWith = doc[FirestoreConstants.chattingWith] ?? "";
    } catch (e) {
      chattingWith = "";
    }
    try {
      pushToken = doc[FirestoreConstants.deviceToken] ?? "";
    } catch (e) {
      pushToken = "";
    }
    try {
      createdAt = doc[FirestoreConstants.createdAt] ?? "";
    } catch (e) {
      createdAt = "";
    }
    try {
      email = doc[FirestoreConstants.email] ?? "";
    } catch (e) {
      email = "";
    }
    try {
      name = doc[FirestoreConstants.name] ?? "";
    } catch (e) {
      name = "";
    }
    try {
      photoUrl = doc[FirestoreConstants.profileurl] ?? "";
    } catch (e) {
      photoUrl = Constant.userPlaceholder;
    }
    try {
      userid = doc[FirestoreConstants.userid] ?? "";
    } catch (e) {
      userid = "";
    }
    try {
      userName = doc[FirestoreConstants.username] ?? "";
    } catch (e) {
      userName = "";
    }
    return ChatUserModel(
        biodata: biodata,
        chattingWith: chattingWith,
        pushToken: pushToken,
        createdAt: createdAt,
        email: email,
        name: name,
        photoUrl: photoUrl,
        userid: userid,
        userName: userName,
        isOnline: isOnline);
  }
}
