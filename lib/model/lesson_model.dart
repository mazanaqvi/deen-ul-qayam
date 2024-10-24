class Lesson {
  final String? name;
  final String? audioAddress;
  final String? audioSize;
  final String? videoAddress;
  final String? videoSize;
  final String? duration;
  // Remove the id field as it's not provided by the API
  // final int? id;
  final String? title;
  final String? description;

  Lesson({
    this.name,
    this.audioAddress,
    this.audioSize,
    this.videoAddress,
    this.videoSize,
    this.duration,
    this.title,
    this.description,
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
    };
  }
}
