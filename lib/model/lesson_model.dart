class Lesson {
  final String? name;
  final String? audioAddress;
  final String? audioSize;
  final String? videoAddress;
  final String? videoSize;
  final String? duration;
  final String? title;
  final String? description;
  final String? courseName;
  final String? thumbnail; // Add thumbnail field
  final String? episodeName; // Add episodeName field

  Lesson({
    this.name,
    this.audioAddress,
    this.audioSize,
    this.videoAddress,
    this.videoSize,
    this.duration,
    this.title,
    this.description,
    this.courseName,
    this.thumbnail, // Initialize thumbnail
    this.episodeName, // Initialize episodeName
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      name: json['name'],
      audioAddress: json['audioAddress'],
      audioSize: json['audioSize'],
      videoAddress: json['videoAddress'],
      videoSize: json['videoSize'],
      duration: json['duration'],
      title: json['title'],
      description: json['description'],
      courseName: json['courseName'],
      thumbnail: json['thumbnail'], // Add JSON parsing for thumbnail
      episodeName: json['name'], // Populate episodeName from name
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
      'courseName': courseName,
      'thumbnail': thumbnail, // Include thumbnail in JSON
      'episodeName': episodeName,
    };
  }

  Lesson copyWith({
    String? name,
    String? audioAddress,
    String? audioSize,
    String? videoAddress,
    String? videoSize,
    String? duration,
    String? title,
    String? description,
    String? courseName,
    String? thumbnail,
    String? episodeName,
  }) {
    return Lesson(
      name: name ?? this.name,
      audioAddress: audioAddress ?? this.audioAddress,
      audioSize: audioSize ?? this.audioSize,
      videoAddress: videoAddress ?? this.videoAddress,
      videoSize: videoSize ?? this.videoSize,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      description: description ?? this.description,
      courseName: courseName ?? this.courseName,
      thumbnail: thumbnail ?? this.thumbnail, // Add thumbnail to copyWith
      episodeName: episodeName ?? this.episodeName,
    );
  }
}
