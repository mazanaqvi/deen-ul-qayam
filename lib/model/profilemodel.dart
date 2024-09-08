// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? status;
  String? message;
  List<Result>? result;

  ProfileModel({
    this.status,
    this.message,
    this.result,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(json["result"] == null
            ? []
            : json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(
            result == null ? [] : result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  String? firebaseId;
  String? userName;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? countryCode;
  String? countryName;
  int? type;
  String? image;
  String? description;
  int? praticeQuizScore;
  int? isTutor;
  int? deviceType;
  String? deviceToken;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isBuy;
  String? packageName;
  dynamic packagePrice;

  Result({
    this.id,
    this.firebaseId,
    this.userName,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.countryCode,
    this.countryName,
    this.type,
    this.image,
    this.description,
    this.praticeQuizScore,
    this.isTutor,
    this.deviceType,
    this.deviceToken,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isBuy,
    this.packageName,
    this.packagePrice,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        firebaseId: json["firebase_id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        countryName: json["country_name"],
        type: json["type"],
        image: json["image"],
        description: json["description"],
        praticeQuizScore: json["pratice_quiz_score"],
        isTutor: json["is_tutor"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBuy: json["is_buy"],
        packageName: json["package_name"],
        packagePrice: json["package_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firebase_id": firebaseId,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "country_name": countryName,
        "type": type,
        "image": image,
        "description": description,
        "pratice_quiz_score": praticeQuizScore,
        "is_tutor": isTutor,
        "device_type": deviceType,
        "device_token": deviceToken,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_buy": isBuy,
        "package_name": packageName,
        "package_price": packagePrice,
      };
}
