// To parse this JSON data, do
//
//     final wishlistmodel = wishlistmodelFromJson(jsonString);

import 'dart:convert';

CourseModel wishlistmodelFromJson(String str) =>
    CourseModel.fromJson(json.decode(str));

String wishlistmodelToJson(CourseModel data) => json.encode(data.toJson());

class CourseModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  CourseModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        totalRows: json["total_rows"],
        totalPage: json["total_page"],
        currentPage: json["current_page"],
        morePage: json["more_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
        "total_rows": totalRows,
        "total_page": totalPage,
        "current_page": currentPage,
        "more_page": morePage,
      };
}

class Result {
  int? id;
  int? categoryId;
  int? languageId;
  int? subcategoryId;
  int? tutorId;
  String? name;
  String? description;
  String? thumbnailImg;
  String? landscapeImg;
  int? salePrice;
  int? price;
  int? view;
  int? isDownload;
  int? isPremium;
  int? isFetured;
  int? isAdded;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? subcategoryName;
  String? languageName;
  String? tutorName;
  int? totalComment;
  dynamic avgRating;
  int? isCart;
  int? isWishlist;

  Result({
    this.id,
    this.categoryId,
    this.languageId,
    this.subcategoryId,
    this.tutorId,
    this.name,
    this.description,
    this.thumbnailImg,
    this.landscapeImg,
    this.salePrice,
    this.price,
    this.view,
    this.isDownload,
    this.isPremium,
    this.isFetured,
    this.isAdded,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.subcategoryName,
    this.languageName,
    this.tutorName,
    this.totalComment,
    this.avgRating,
    this.isCart,
    this.isWishlist,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        subcategoryId: json["subcategory_id"],
        tutorId: json["tutor_id"],
        name: json["name"],
        description: json["description"],
        thumbnailImg: json["thumbnail_img"],
        landscapeImg: json["landscape_img"],
        salePrice: json["sale_price"],
        price: json["price"],
        view: json["view"],
        isDownload: json["is_download"],
        isPremium: json["is_premium"],
        isFetured: json["is_fetured"],
        isAdded: json["is_added"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryName: json["category_name"],
        subcategoryName: json["subcategory_name"],
        languageName: json["language_name"],
        tutorName: json["tutor_name"],
        totalComment: json["total_comment"],
        avgRating: json["avg_rating"],
        isCart: json["is_cart"],
        isWishlist: json["is_wishlist"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "subcategory_id": subcategoryId,
        "tutor_id": tutorId,
        "name": name,
        "description": description,
        "thumbnail_img": thumbnailImg,
        "landscape_img": landscapeImg,
        "sale_price": salePrice,
        "price": price,
        "view": view,
        "is_download": isDownload,
        "is_premium": isPremium,
        "is_fetured": isFetured,
        "is_added": isAdded,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_name": categoryName,
        "subcategory_name": subcategoryName,
        "language_name": languageName,
        "tutor_name": tutorName,
        "total_comment": totalComment,
        "avg_rating": avgRating,
        "is_cart": isCart,
        "is_wishlist": isWishlist,
      };
}
