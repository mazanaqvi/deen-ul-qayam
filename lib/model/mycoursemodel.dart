// To parse this JSON data, do
//
//     final myCourseModel = myCourseModelFromJson(jsonString);

import 'dart:convert';

MyCourseModel myCourseModelFromJson(String str) =>
    MyCourseModel.fromJson(json.decode(str));

String myCourseModelToJson(MyCourseModel data) => json.encode(data.toJson());

class MyCourseModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  MyCourseModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
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
  String? avgRating;
  int? isDownloadCertificate;

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
    this.avgRating,
    this.isDownloadCertificate,
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
        avgRating: json["avg_rating"],
        isDownloadCertificate: json["is_download_certificate"],
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
        "avg_rating": avgRating,
        "is_download_certificate": isDownloadCertificate,
      };
}
