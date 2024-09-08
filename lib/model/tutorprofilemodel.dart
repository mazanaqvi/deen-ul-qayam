// To parse this JSON data, do
//
//     final tutorprofilemodel = tutorprofilemodelFromJson(jsonString);

import 'dart:convert';

Tutorprofilemodel tutorprofilemodelFromJson(String str) =>
    Tutorprofilemodel.fromJson(json.decode(str));

String tutorprofilemodelToJson(Tutorprofilemodel data) =>
    json.encode(data.toJson());

class Tutorprofilemodel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  Tutorprofilemodel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory Tutorprofilemodel.fromJson(Map<String, dynamic> json) =>
      Tutorprofilemodel(
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
  int? isTutor;
  String? userName;
  String? fullName;
  String? email;
  String? mobileNumber;
  int? type;
  String? image;
  String? description;
  int? deviceType;
  String? deviceToken;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? totalCourse;

  Result({
    this.id,
    this.isTutor,
    this.userName,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.type,
    this.image,
    this.description,
    this.deviceType,
    this.deviceToken,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalCourse,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        isTutor: json["is_tutor"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        type: json["type"],
        image: json["image"],
        description: json["description"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        totalCourse: json["total_course"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_tutor": isTutor,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "mobile_number": mobileNumber,
        "type": type,
        "image": image,
        "description": description,
        "device_type": deviceType,
        "device_token": deviceToken,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "total_course": totalCourse,
      };
}
