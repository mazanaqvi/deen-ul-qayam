// To parse this JSON data, do
//
//     final getCourseReviewModel = getCourseReviewModelFromJson(jsonString);

import 'dart:convert';

GetCourseReviewModel getCourseReviewModelFromJson(String str) =>
    GetCourseReviewModel.fromJson(json.decode(str));

String getCourseReviewModelToJson(GetCourseReviewModel data) =>
    json.encode(data.toJson());

class GetCourseReviewModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  GetCourseReviewModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory GetCourseReviewModel.fromJson(Map<String, dynamic> json) =>
      GetCourseReviewModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(
                json["result"]?.map((x) => Result.fromJson(x)) ?? []),
        totalRows: json["total_rows"],
        totalPage: json["total_page"],
        currentPage: json["current_page"],
        morePage: json["more_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
        "total_rows": totalRows,
        "total_page": totalPage,
        "current_page": currentPage,
        "more_page": morePage,
      };
}

class Result {
  int? id;
  int? userId;
  int? courseId;
  String? comment;
  dynamic rating;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? userName;
  String? fullName;
  String? email;
  String? image;

  Result({
    this.id,
    this.userId,
    this.courseId,
    this.comment,
    this.rating,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userName,
    this.fullName,
    this.email,
    this.image,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        comment: json["comment"],
        rating: json["rating"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "comment": comment,
        "rating": rating,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "image": image,
      };
}
