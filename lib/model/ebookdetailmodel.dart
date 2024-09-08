// To parse this JSON data, do
//
//     final ebookDetailModel = ebookDetailModelFromJson(jsonString);

import 'dart:convert';

EbookDetailModel ebookDetailModelFromJson(String str) =>
    EbookDetailModel.fromJson(json.decode(str));

String ebookDetailModelToJson(EbookDetailModel data) =>
    json.encode(data.toJson());

class EbookDetailModel {
  int? status;
  String? message;
  List<Result>? result;

  EbookDetailModel({
    this.status,
    this.message,
    this.result,
  });

  factory EbookDetailModel.fromJson(Map<String, dynamic> json) =>
      EbookDetailModel(
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
  String? bookUrl;
  String? thumbnailImg;
  String? landscapeImg;
  int? isFree;
  int? price;
  String? description;
  String? summary;
  String? specification;
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

  Result({
    this.id,
    this.tutorId,
    this.categoryId,
    this.languageId,
    this.title,
    this.bookUrl,
    this.thumbnailImg,
    this.landscapeImg,
    this.isFree,
    this.price,
    this.description,
    this.summary,
    this.specification,
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
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        tutorId: json["tutor_id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        title: json["title"],
        bookUrl: json["book_url"],
        thumbnailImg: json["thumbnail_img"],
        landscapeImg: json["landscape_img"],
        isFree: json["is_free"],
        price: json["price"],
        description: json["description"],
        summary: json["summary"],
        specification: json["specification"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tutor_id": tutorId,
        "category_id": categoryId,
        "language_id": languageId,
        "title": title,
        "book_url": bookUrl,
        "thumbnail_img": thumbnailImg,
        "landscape_img": landscapeImg,
        "is_free": isFree,
        "price": price,
        "description": description,
        "summary": summary,
        "specification": specification,
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
      };
}
