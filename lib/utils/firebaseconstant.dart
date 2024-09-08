import 'package:yourappname/utils/constant.dart';

class FirestoreConstants {
  /* Firestore */
  static String pathUserCollection = "users_${Constant.chatAppName}";
  static String pathMessageCollection = "chatrooms_${Constant.chatAppName}";

  /* User */
  static const id = "id";
  static const userid = "userid";
  static const name = "name";
  static const email = "email";
  static const profileurl = "profileurl";
  static const chattingWith = "chattingWith";
  static const deviceToken = "deviceToken";
  static const isOnline = "isOnline";
  static const createdAt = "createdAt";
  static const bioData = "biodata";
  static const username = "username";
  static const mobileNumber = "mobileNumber";

  /* Live Chat */
  static const idFrom = "idFrom";
  static const idTo = "idTo";
  static const timestamp = "timestamp";
  static const content = "content";
  static const type = "type";
  static const read = "read";

  /* Chats Document Fields */
  static const convId = "convid";
  static const users = "users";
  static const lastMessage = "lastMessage";
  static const chatproductdetails = "productdetails";

  /* Firebase Storage */
  static const pathImages = "images";
  static const pathVideos = "videos";
  static const pathGif = "gif";

  /*Product details in firebase */
  static const courseImage = "productImage";
  static const courseName = "productName";
}
