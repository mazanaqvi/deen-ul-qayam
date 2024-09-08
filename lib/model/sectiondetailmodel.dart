// To parse this JSON data, do
//
//     final sectionDetailModel = sectionDetailModelFromJson(jsonString);

import 'dart:convert';

SectionDetailModel sectionDetailModelFromJson(String str) =>
    SectionDetailModel.fromJson(json.decode(str));

String sectionDetailModelToJson(SectionDetailModel data) =>
    json.encode(data.toJson());

class SectionDetailModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  SectionDetailModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory SectionDetailModel.fromJson(Map<String, dynamic> json) =>
      SectionDetailModel(
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
  String? name;
  String? fullName;
  String? description;
  String? thumbnailImg;
  String? landscapeImg;
  String? image;
  int? isFree;
  int? price;
  int? totalView;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isBuy;
  int? isUserBuy;
  String? avgRating;
  int? isWishlist;
  String? tutorName;
  String? categoryName;
  String? languageName;
  int? totalDuration;

  Result({
    this.id,
    this.tutorId,
    this.categoryId,
    this.languageId,
    this.title,
    this.name,
    this.fullName,
    this.description,
    this.thumbnailImg,
    this.landscapeImg,
    this.image,
    this.isFree,
    this.price,
    this.totalView,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isBuy,
    this.isUserBuy,
    this.avgRating,
    this.isWishlist,
    this.tutorName,
    this.categoryName,
    this.languageName,
    this.totalDuration,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        tutorId: json["tutor_id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        title: json["title"],
        name: json["name"],
        fullName: json["full_name"],
        description: json["description"],
        thumbnailImg: json["thumbnail_img"],
        landscapeImg: json["landscape_img"],
        image: json["image"],
        isFree: json["is_free"],
        price: json["price"],
        totalView: json["total_view"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBuy: json["is_buy"],
        isUserBuy: json["is_user_buy"],
        avgRating: json["avg_rating"],
        isWishlist: json["is_wishlist"],
        tutorName: json["tutor_name"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        totalDuration: json["total_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tutor_id": tutorId,
        "category_id": categoryId,
        "language_id": languageId,
        "title": title,
        "name": name,
        "full_name": fullName,
        "description": description,
        "thumbnail_img": thumbnailImg,
        "landscape_img": landscapeImg,
        "image": image,
        "is_free": isFree,
        "price": price,
        "total_view": totalView,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_buy": isBuy,
        "is_user_buy": isUserBuy,
        "avg_rating": avgRating,
        "is_wishlist": isWishlist,
        "tutor_name": tutorName,
        "category_name": categoryName,
        "language_name": languageName,
        "total_duration": totalDuration,
      };
}
