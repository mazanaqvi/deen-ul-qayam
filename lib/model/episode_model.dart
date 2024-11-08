// lib/model/episode_model.dart

class Episode {
  final String? name;
  final String? audioAddress;
  final String? audioSize;
  final String? videoAddress;
  final String? videoSize;
  final String? duration;
  final String? title;
  final String? description;
  final String? thumbnail;

  Episode({
    this.name,
    this.audioAddress,
    this.audioSize,
    this.videoAddress,
    this.videoSize,
    this.duration,
    this.title,
    this.description,
    this.thumbnail,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      name: json['name'],
      audioAddress: json['audioAddress'],
      audioSize: json['audioSize'],
      videoAddress: json['videoAddress'],
      videoSize: json['videoSize'],
      duration: json['duration'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'audioAddress': audioAddress,
      'audioSize': audioSize,
      'videoAddress': videoAddress,
      'videoSize': videoSize,
      'duration': duration,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  Episode copyWith({
    String? name,
    String? audioAddress,
    String? audioSize,
    String? videoAddress,
    String? videoSize,
    String? duration,
    String? title,
    String? description,
    String? thumbnail,
  }) {
    return Episode(
      name: name ?? this.name,
      audioAddress: audioAddress ?? this.audioAddress,
      audioSize: audioSize ?? this.audioSize,
      videoAddress: videoAddress ?? this.videoAddress,
      videoSize: videoSize ?? this.videoSize,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
