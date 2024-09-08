// To parse this JSON data, do
//
//     final loginmodel = loginmodelFromJson(jsonString);

import 'dart:convert';

Loginmodel loginmodelFromJson(String str) =>
    Loginmodel.fromJson(json.decode(str));

String loginmodelToJson(Loginmodel data) => json.encode(data.toJson());

class Loginmodel {
  int? status;
  String? message;
  List<Result>? result;

  Loginmodel({
    this.status,
    this.message,
    this.result,
  });

  factory Loginmodel.fromJson(Map<String, dynamic> json) => Loginmodel(
        status: json["status"],
        message: json["message"],
        result: List<Result>.from(
            json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  int? id;
  String? firebaseId;
  String? userName;
  String? fullName;
  String? email;
  String? password;
  String? mobileNumber;
  int? type;
  String? image;
  String? bio;
  int? deviceType;
  String? deviceToken;
  int? praticeQuizScore;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isBuy;

  Result({
    this.id,
    this.firebaseId,
    this.userName,
    this.fullName,
    this.email,
    this.password,
    this.mobileNumber,
    this.type,
    this.image,
    this.bio,
    this.deviceType,
    this.deviceToken,
    this.praticeQuizScore,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isBuy,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        firebaseId: json["firebase_id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        password: json["password"],
        mobileNumber: json["mobile_number"],
        type: json["type"],
        image: json["image"],
        bio: json["bio"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        praticeQuizScore: json["pratice_quiz_score"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firebase_id": firebaseId,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "type": type,
        "image": image,
        "bio": bio,
        "device_type": deviceType,
        "device_token": deviceToken,
        "pratice_quiz_score": praticeQuizScore,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_buy": isBuy,
      };
}
