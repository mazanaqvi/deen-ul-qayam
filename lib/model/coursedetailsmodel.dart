// To parse this JSON data, do
//
//     final courseDetailsModel = courseDetailsModelFromJson(jsonString);

import 'dart:convert';

CourseDetailsModel courseDetailsModelFromJson(String str) =>
    CourseDetailsModel.fromJson(json.decode(str));

String courseDetailsModelToJson(CourseDetailsModel data) =>
    json.encode(data.toJson());

class CourseDetailsModel {
  int? status;
  String? message;
  List<Result>? result;

  CourseDetailsModel({
    this.status,
    this.message,
    this.result,
  });

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailsModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(
                json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  int? tutorId;
  int? categoryId;
  int? languageId;
  String? title;
  String? description;
  String? thumbnailImg;
  String? landscapeImg;
  int? isFree;
  int? price;
  int? totalView;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? languageName;
  String? tutorName;
  int? isBuy;
  int? isUserBuy;
  String? avgRating;
  int? isWishlist;
  int? isDownloadCertificate;
  int? totalDuration;
  List<Chapter>? chapter;
  List<Inlcude>? requrirment;
  List<Inlcude>? inlcude;
  List<Inlcude>? whatYouLearn;

  Result({
    this.id,
    this.tutorId,
    this.categoryId,
    this.languageId,
    this.title,
    this.description,
    this.thumbnailImg,
    this.landscapeImg,
    this.isFree,
    this.price,
    this.totalView,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.languageName,
    this.tutorName,
    this.isBuy,
    this.isUserBuy,
    this.avgRating,
    this.isWishlist,
    this.isDownloadCertificate,
    this.totalDuration,
    this.chapter,
    this.requrirment,
    this.inlcude,
    this.whatYouLearn,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        tutorId: json["tutor_id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        title: json["title"],
        description: json["description"],
        thumbnailImg: json["thumbnail_img"],
        landscapeImg: json["landscape_img"],
        isFree: json["is_free"],
        price: json["price"],
        totalView: json["total_view"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        tutorName: json["tutor_name"],
        isBuy: json["is_buy"],
        isUserBuy: json["is_user_buy"],
        avgRating: json["avg_rating"],
        isWishlist: json["is_wishlist"],
        isDownloadCertificate: json["is_download_certificate"],
        totalDuration: json["total_duration"],
        chapter: json["chapter"] == null
            ? []
            : List<Chapter>.from(
                json["chapter"]?.map((x) => Chapter.fromJson(x)) ?? []),
        requrirment: json["requrirment"] == null
            ? []
            : List<Inlcude>.from(
                json["requrirment"]?.map((x) => Inlcude.fromJson(x)) ?? []),
        inlcude: json["inlcude"] == null
            ? []
            : List<Inlcude>.from(
                json["inlcude"]?.map((x) => Inlcude.fromJson(x)) ?? []),
        whatYouLearn: json["what_you_learn"] == null
            ? []
            : List<Inlcude>.from(
                json["what_you_learn"]?.map((x) => Inlcude.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tutor_id": tutorId,
        "category_id": categoryId,
        "language_id": languageId,
        "title": title,
        "description": description,
        "thumbnail_img": thumbnailImg,
        "landscape_img": landscapeImg,
        "is_free": isFree,
        "price": price,
        "total_view": totalView,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_name": categoryName,
        "language_name": languageName,
        "tutor_name": tutorName,
        "is_buy": isBuy,
        "is_user_buy": isUserBuy,
        "avg_rating": avgRating,
        "is_wishlist": isWishlist,
        "is_download_certificate": isDownloadCertificate,
        "total_duration": totalDuration,
        "chapter": chapter == null
            ? []
            : List<dynamic>.from(chapter?.map((x) => x.toJson()) ?? []),
        "requrirment": requrirment == null
            ? []
            : List<dynamic>.from(requrirment?.map((x) => x.toJson()) ?? []),
        "inlcude": inlcude == null
            ? []
            : List<dynamic>.from(inlcude?.map((x) => x.toJson()) ?? []),
        "what_you_learn": whatYouLearn == null
            ? []
            : List<dynamic>.from(whatYouLearn?.map((x) => x.toJson()) ?? []),
      };
}

class Chapter {
  int? id;
  int? courseId;
  String? name;
  String? image;
  int? quizStatus;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isQuizPlay;

  Chapter({
    this.id,
    this.courseId,
    this.name,
    this.image,
    this.quizStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isQuizPlay,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["id"],
        courseId: json["course_id"],
        name: json["name"],
        image: json["image"],
        quizStatus: json["quiz_status"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isQuizPlay: json["is_quiz_play"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "name": name,
        "image": image,
        "quiz_status": quizStatus,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_quiz_play": isQuizPlay,
      };
}

class Inlcude {
  int? id;
  int? courseId;
  String? title;
  int? status;
  String? createdAt;
  String? updatedAt;

  Inlcude({
    this.id,
    this.courseId,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Inlcude.fromJson(Map<String, dynamic> json) => Inlcude(
        id: json["id"],
        courseId: json["course_id"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "title": title,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
