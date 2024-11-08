// models/item.dart
abstract class Item {
  String get id;
  String get title;
  String get description;
  String get thumbnailImg;
  double get avgRating;
  int get totalView;
  bool get isWishlist;
  bool get isFree;
  // Add other common properties as needed
}
