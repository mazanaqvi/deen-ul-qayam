// To parse this JSON data, do
//
//     final getPageModel = getPageModelFromJson(jsonString);

import 'dart:convert';

GetPageModel getPageModelFromJson(String str) =>
    GetPageModel.fromJson(json.decode(str));

String getPageModelToJson(GetPageModel data) => json.encode(data.toJson());

class GetPageModel {
  int? status;
  String? message;
  List<Result>? result;

  GetPageModel({
    this.status,
    this.message,
    this.result,
  });

  factory GetPageModel.fromJson(Map<String, dynamic> json) => GetPageModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] != null
            ? List<Result>.from(json["result"].map((x) => Result.fromJson(x)))
            : [], // Safely handle the null result case
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result != null
            ? List<dynamic>.from(result!.map((x) => x.toJson()))
            : [],
      };
}


class Result {
  String? pageName;
  String? title;
  String? url;
  String? icon;

  Result({
    this.pageName,
    this.title,
    this.url,
    this.icon,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pageName: json["page_name"],
        title: json["title"],
        url: json["url"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "page_name": pageName,
        "title": title,
        "url": url,
        "icon": icon,
      };
}
