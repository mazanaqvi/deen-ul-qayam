import 'package:hive/hive.dart';

part 'lesson.g.dart';

@HiveType(typeId: 0)
class Lesson {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String thumbnailImg;

  @HiveField(4)
  final String videoUrl;

  @HiveField(5)
  final String videoType;

  @HiveField(6)
  final String landscapeImg;

  @HiveField(7)
  final bool isWishlist;

  @HiveField(8)
  final double avgRating;

  @HiveField(9)
  final int totalView;

  @HiveField(10)
  final bool isFree;

  @HiveField(11)
  final bool isUserBuy;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailImg,
    required this.videoUrl,
    required this.videoType,
    required this.landscapeImg,
    required this.isWishlist,
    required this.avgRating,
    required this.totalView,
    required this.isFree,
    required this.isUserBuy,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailImg: json['thumbnailImg'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoType: json['videoType'] ?? '',
      landscapeImg: json['landscapeImg'] ?? '',
      isWishlist: json['isWishlist'] == 1,
      avgRating: double.parse(json['avgRating'].toString()),
      totalView: json['totalView'] ?? 0,
      isFree: json['isFree'] == 1,
      isUserBuy: json['isUserBuy'] == 1,
    );
  }
}
