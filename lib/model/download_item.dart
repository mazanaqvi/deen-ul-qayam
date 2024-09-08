import 'package:hive/hive.dart';

part 'download_item.g.dart';

@HiveType(typeId: 0)
class DownloadItem extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? securityKey;

  @HiveField(2)
  int? tutorId;

  @HiveField(3)
  int? categoryId;

  @HiveField(4)
  int? languageId;

  @HiveField(5)
  String? title;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String? thumbnailImg;

  @HiveField(8)
  String? landscapeImg;

  @HiveField(9)
  int? isFree;

  @HiveField(10)
  int? price;

  @HiveField(11)
  int? totalView;

  @HiveField(12)
  int? status;

  @HiveField(13)
  String? createdAt;

  @HiveField(14)
  String? updatedAt;

  @HiveField(15)
  String? categoryName;

  @HiveField(16)
  String? languageName;

  @HiveField(17)
  String? tutorName;

  @HiveField(18)
  int? isBuy;

  @HiveField(19)
  int? isUserBuy;

  @HiveField(20)
  String? avgRating;

  @HiveField(21)
  int? isWishlist;

  @HiveField(22)
  int? isDownloadCertificate;

  @HiveField(23)
  int? totalDuration;

  @HiveField(24)
  final String? savedDir;

  @HiveField(25)
  final String? savedFile;

  @HiveField(26)
  List<ChapterItem>? chapter;

  DownloadItem({
    this.id,
    this.securityKey,
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
    this.isUserBuy,
    this.avgRating,
    this.isWishlist,
    this.isDownloadCertificate,
    this.totalDuration,
    this.savedDir,
    this.savedFile,
    this.chapter,
  });

  factory DownloadItem.fromJson(Map<String, dynamic> json) => DownloadItem(
        id: json["id"],
        securityKey: json["securityKey"],
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
        isUserBuy: json["is_user_buy"],
        avgRating: json["avg_rating"],
        isWishlist: json["is_wishlist"],
        isDownloadCertificate: json["is_download_certificate"],
        totalDuration: json["total_duration"],
        savedDir: json["savedDir"],
        savedFile: json["savedFile"],
        chapter: List<ChapterItem>.from(
            json["session"].map((x) => ChapterItem.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "securityKey": securityKey,
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
        "is_user_buy": isUserBuy,
        "avg_rating": avgRating,
        "is_wishlist": isWishlist,
        "is_download_certificate": isDownloadCertificate,
        "total_duration": totalDuration,
        "savedDir": savedDir,
        "savedFile": savedFile,
        "chapter": List<dynamic>.from(chapter?.map((x) => x.toJson()) ?? []),
      };
}

@HiveType(typeId: 1)
class ChapterItem {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? courseId;
  @HiveField(2)
  final int? sessionPosition;
  @HiveField(3)
  final String? name;
  @HiveField(4)
  final int? image;
  @HiveField(5)
  final int? quizStatus;
  @HiveField(6)
  final int? status;
  @HiveField(7)
  final int? createdAt;
  @HiveField(8)
  final int? updatedAt;
  @HiveField(9)
  final int? isQuizPlay;
  @HiveField(10)
  final int? isDownload;
  @HiveField(11)
  List<EpisodeItem>? episode;

  ChapterItem({
    this.id,
    this.courseId,
    this.sessionPosition,
    this.name,
    this.image,
    this.quizStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isQuizPlay,
    this.isDownload,
    this.episode,
  });

  factory ChapterItem.fromJson(Map<String, dynamic> json) => ChapterItem(
        id: json["id"],
        courseId: json["course_id"],
        sessionPosition: json["sessionPosition"],
        name: json["name"],
        image: json["image"],
        quizStatus: json["quiz_status"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isQuizPlay: json["is_quiz_play"],
        isDownload: json["is_download"],
        episode: List<EpisodeItem>.from(
            json["episode"]?.map((x) => EpisodeItem.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "sessionPosition": sessionPosition,
        "name": name,
        "image": image,
        "quiz_status": quizStatus,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_quiz_play": isQuizPlay,
        "is_download": isDownload,
        "episode": List<dynamic>.from(episode?.map((x) => x.toJson()) ?? []),
      };
}

@HiveType(typeId: 2)
class EpisodeItem {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final int? courseId;
  @HiveField(2)
  final int? chapterId;
  @HiveField(3)
  final String? title;
  @HiveField(4)
  final String? thumbnailImg;
  @HiveField(5)
  final String? landscapeImg;
  @HiveField(6)
  final String? videoType;
  @HiveField(7)
  final String? videoUrl;
  @HiveField(8)
  final String? duration;
  @HiveField(9)
  final String? description;
  @HiveField(10)
  final int? totalView;
  @HiveField(11)
  final int? status;
  @HiveField(12)
  final String? createdAt;
  @HiveField(13)
  final String? updatedAt;
  @HiveField(14)
  final int? isBuy;
  @HiveField(15)
  final int? isRead;
  @HiveField(16)
  final String? securityKey;
  @HiveField(17)
  final String? savedDir;
  @HiveField(18)
  final String? savedFile;
  @HiveField(19)
  final int? isDownloaded;

  EpisodeItem({
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
    this.securityKey,
    this.savedDir,
    this.savedFile,
    this.isDownloaded,
  });

  factory EpisodeItem.fromJson(Map<String, dynamic> json) => EpisodeItem(
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
        securityKey: json["securityKey"],
        savedDir: json["savedDir"],
        savedFile: json["savedFile"],
        isDownloaded: json["is_download"],
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
        "securityKey": securityKey,
        "savedDir": savedDir,
        "savedFile": savedFile,
        "is_download": isDownloaded,
      };
}
