// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadItemAdapter extends TypeAdapter<DownloadItem> {
  @override
  final int typeId = 0;

  @override
  DownloadItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadItem(
      id: fields[0] as int?,
      securityKey: fields[1] as String?,
      tutorId: fields[2] as int?,
      categoryId: fields[3] as int?,
      languageId: fields[4] as int?,
      title: fields[5] as String?,
      description: fields[6] as String?,
      thumbnailImg: fields[7] as String?,
      landscapeImg: fields[8] as String?,
      isFree: fields[9] as int?,
      price: fields[10] as int?,
      totalView: fields[11] as int?,
      status: fields[12] as int?,
      createdAt: fields[13] as String?,
      updatedAt: fields[14] as String?,
      categoryName: fields[15] as String?,
      languageName: fields[16] as String?,
      tutorName: fields[17] as String?,
      isBuy: fields[18] as int?,
      isUserBuy: fields[19] as int?,
      avgRating: fields[20] as String?,
      isWishlist: fields[21] as int?,
      isDownloadCertificate: fields[22] as int?,
      totalDuration: fields[23] as int?,
      savedDir: fields[24] as String?,
      savedFile: fields[25] as String?,
      chapter: (fields[26] as List?)?.cast<ChapterItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, DownloadItem obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.securityKey)
      ..writeByte(2)
      ..write(obj.tutorId)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.languageId)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.thumbnailImg)
      ..writeByte(8)
      ..write(obj.landscapeImg)
      ..writeByte(9)
      ..write(obj.isFree)
      ..writeByte(10)
      ..write(obj.price)
      ..writeByte(11)
      ..write(obj.totalView)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.categoryName)
      ..writeByte(16)
      ..write(obj.languageName)
      ..writeByte(17)
      ..write(obj.tutorName)
      ..writeByte(18)
      ..write(obj.isBuy)
      ..writeByte(19)
      ..write(obj.isUserBuy)
      ..writeByte(20)
      ..write(obj.avgRating)
      ..writeByte(21)
      ..write(obj.isWishlist)
      ..writeByte(22)
      ..write(obj.isDownloadCertificate)
      ..writeByte(23)
      ..write(obj.totalDuration)
      ..writeByte(24)
      ..write(obj.savedDir)
      ..writeByte(25)
      ..write(obj.savedFile)
      ..writeByte(26)
      ..write(obj.chapter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChapterItemAdapter extends TypeAdapter<ChapterItem> {
  @override
  final int typeId = 1;

  @override
  ChapterItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterItem(
      id: fields[0] as int?,
      courseId: fields[1] as int?,
      sessionPosition: fields[2] as int?,
      name: fields[3] as String?,
      image: fields[4] as int?,
      quizStatus: fields[5] as int?,
      status: fields[6] as int?,
      createdAt: fields[7] as int?,
      updatedAt: fields[8] as int?,
      isQuizPlay: fields[9] as int?,
      isDownload: fields[10] as int?,
      episode: (fields[11] as List?)?.cast<EpisodeItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChapterItem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseId)
      ..writeByte(2)
      ..write(obj.sessionPosition)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.quizStatus)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isQuizPlay)
      ..writeByte(10)
      ..write(obj.isDownload)
      ..writeByte(11)
      ..write(obj.episode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EpisodeItemAdapter extends TypeAdapter<EpisodeItem> {
  @override
  final int typeId = 2;

  @override
  EpisodeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EpisodeItem(
      id: fields[0] as int?,
      courseId: fields[1] as int?,
      chapterId: fields[2] as int?,
      title: fields[3] as String?,
      thumbnailImg: fields[4] as String?,
      landscapeImg: fields[5] as String?,
      videoType: fields[6] as String?,
      videoUrl: fields[7] as String?,
      duration: fields[8] as String?,
      description: fields[9] as String?,
      totalView: fields[10] as int?,
      status: fields[11] as int?,
      createdAt: fields[12] as String?,
      updatedAt: fields[13] as String?,
      isBuy: fields[14] as int?,
      isRead: fields[15] as int?,
      securityKey: fields[16] as String?,
      savedDir: fields[17] as String?,
      savedFile: fields[18] as String?,
      isDownloaded: fields[19] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EpisodeItem obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseId)
      ..writeByte(2)
      ..write(obj.chapterId)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.thumbnailImg)
      ..writeByte(5)
      ..write(obj.landscapeImg)
      ..writeByte(6)
      ..write(obj.videoType)
      ..writeByte(7)
      ..write(obj.videoUrl)
      ..writeByte(8)
      ..write(obj.duration)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.totalView)
      ..writeByte(11)
      ..write(obj.status)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.isBuy)
      ..writeByte(15)
      ..write(obj.isRead)
      ..writeByte(16)
      ..write(obj.securityKey)
      ..writeByte(17)
      ..write(obj.savedDir)
      ..writeByte(18)
      ..write(obj.savedFile)
      ..writeByte(19)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
