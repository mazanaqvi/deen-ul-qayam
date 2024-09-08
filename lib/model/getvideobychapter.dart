// To parse this JSON data, do
//
//     final getVideoByChapterModel = getVideoByChapterModelFromJson(jsonString);

import 'dart:convert';

GetVideoByChapterModel getVideoByChapterModelFromJson(String str) =>
    GetVideoByChapterModel.fromJson(json.decode(str));

String getVideoByChapterModelToJson(GetVideoByChapterModel data) =>
    json.encode(data.toJson());

class GetVideoByChapterModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  int? currentPage;
  bool? morePage;

  GetVideoByChapterModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory GetVideoByChapterModel.fromJson(Map<String, dynamic> json) =>
      GetVideoByChapterModel(
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
  int? courseId;
  int? chapterId;
  String? title;
  String? thumbnailImg;
  String? landscapeImg;
  String? videoType;
  String? videoUrl;
  int? duration;
  String? description;
  int? totalView;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isBuy;
  int? isRead;

  Result({
    this.id,
    this.courseId,
    this.chapterId,
    this.title,
    this.thumbnailImg,
    this.landscapeImg,
    this.videoType,
    this.videoUrl,
    this.duration,
    this.description,
    this.totalView,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isBuy,
    this.isRead,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        courseId: json["course_id"],
        chapterId: json["chapter_id"],
        title: json["title"],
        thumbnailImg: json["thumbnail_img"],
        landscapeImg: json["landscape_img"],
        videoType: json["video_type"],
        videoUrl: json["video_url"],
        duration: json["duration"],
        description: json["description"],
        totalView: json["total_view"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBuy: json["is_buy"],
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "chapter_id": chapterId,
        "title": title,
        "thumbnail_img": thumbnailImg,
        "landscape_img": landscapeImg,
        "video_type": videoType,
        "video_url": videoUrl,
        "duration": duration,
        "description": description,
        "total_view": totalView,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_buy": isBuy,
        "is_read": isRead,
      };
}
