// To parse this JSON data, do
//
//     final sectionListModel = sectionListModelFromJson(jsonString);

import 'dart:convert';

SectionListModel sectionListModelFromJson(String str) =>
    SectionListModel.fromJson(json.decode(str));

String sectionListModelToJson(SectionListModel data) =>
    json.encode(data.toJson());

class SectionListModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  SectionListModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory SectionListModel.fromJson(Map<String, dynamic> json) =>
      SectionListModel(
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
  int? type;
  String? title;
  String? shortTitle;
  String? screenLayout;
  int? categoryId;
  int? languageId;
  int? tutorId;
  int? orderByUpload;
  int? orderByView;
  int? premiumCourse;
  int? noOfContent;
  int? viewAll;
  int? sortable;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<Datum>? data;

  Result({
    this.id,
    this.type,
    this.title,
    this.shortTitle,
    this.screenLayout,
    this.categoryId,
    this.languageId,
    this.tutorId,
    this.orderByUpload,
    this.orderByView,
    this.premiumCourse,
    this.noOfContent,
    this.viewAll,
    this.sortable,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        shortTitle: json["short_title"],
        screenLayout: json["screen_layout"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        tutorId: json["tutor_id"],
        orderByUpload: json["order_by_upload"],
        orderByView: json["order_by_view"],
        premiumCourse: json["premium_course"],
        noOfContent: json["no_of_content"],
        viewAll: json["view_all"],
        sortable: json["sortable"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(
                json["data"]?.map((x) => Datum.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "title": title,
        "short_title": shortTitle,
        "screen_layout": screenLayout,
        "category_id": categoryId,
        "language_id": languageId,
        "tutor_id": tutorId,
        "order_by_upload": orderByUpload,
        "order_by_view": orderByView,
        "premium_course": premiumCourse,
        "no_of_content": noOfContent,
        "view_all": viewAll,
        "sortable": sortable,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
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
  String? avgRating;
  int? isWishlist;
  String? tutorName;
  String? categoryName;
  String? languageName;
  int? isBuy;
  String? userName;
  String? fullName;
  String? email;
  String? countryCode;
  String? mobileNumber;
  String? countryName;
  String? image;
  String? designation;
  String? name;

  Datum({
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
    this.avgRating,
    this.isWishlist,
    this.tutorName,
    this.categoryName,
    this.languageName,
    this.isBuy,
    this.userName,
    this.fullName,
    this.email,
    this.countryCode,
    this.mobileNumber,
    this.countryName,
    this.image,
    this.designation,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        avgRating: json["avg_rating"],
        isWishlist: json["is_wishlist"],
        tutorName: json["tutor_name"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        isBuy: json["is_buy"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        countryCode: json["country_code"],
        mobileNumber: json["mobile_number"],
        countryName: json["country_name"],
        image: json["image"],
        designation: json["designation"],
        name: json["name"],
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
        "avg_rating": avgRating,
        "is_wishlist": isWishlist,
        "tutor_name": tutorName,
        "category_name": categoryName,
        "language_name": languageName,
        "is_buy": isBuy,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "country_name": countryName,
        "image": image,
        "designation": designation,
        "name": name,
      };
}
