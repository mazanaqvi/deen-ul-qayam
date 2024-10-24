// // pages/lesson_detail.dart
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:yourappname/model/lesson_model.dart';
// import 'package:yourappname/utils/color.dart';
// import 'package:video_player/video_player.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:yourappname/pages/full_screen_video.dart';

// class LessonDetail extends StatefulWidget {
//   final Lesson lesson;

//   const LessonDetail({Key? key, required this.lesson}) : super(key: key);

//   @override
//   _LessonDetailState createState() => _LessonDetailState();
// }

// class _LessonDetailState extends State<LessonDetail> {
//   VideoPlayerController? _videoController;
//   Future<void>? _initializeVideoPlayerFuture;

//   // Hardcoded video URL
//   final String _hardcodedVideoUrl =
//       'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.network(_hardcodedVideoUrl);
//     _initializeVideoPlayerFuture =
//         _videoController!.initialize().catchError((error) {
//       print('Error initializing video player: $error');
//     }).then((_) {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   String formatBytes(int bytes, [int decimals = 2]) {
//     if (bytes <= 0) return "0 B";
//     const suffixes = ["B", "KB", "MB", "GB", "TB"];
//     var i = (log(bytes) / log(1024)).floor();
//     return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
//         ' ' +
//         suffixes[i];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.lesson.name), // Assuming name is non-null
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start, // Ensure proper alignment
//             children: [
//               // Video Section
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 10),
//                   _videoController != null
//                       ? FutureBuilder(
//                           future: _initializeVideoPlayerFuture,
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.done) {
//                               return Column(
//                                 children: [
//                                   AspectRatio(
//                                     aspectRatio:
//                                         _videoController!.value.aspectRatio,
//                                     child: VideoPlayer(_videoController!),
//                                   ),
//                                   VideoProgressIndicator(_videoController!,
//                                       allowScrubbing: true),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           _videoController!.value.isPlaying
//                                               ? Icons.pause
//                                               : Icons.play_arrow,
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             _videoController!.value.isPlaying
//                                                 ? _videoController!.pause()
//                                                 : _videoController!.play();
//                                           });
//                                         },
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(Icons.fullscreen),
//                                         onPressed: () {
//                                           // Navigate to full-screen mode
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   FullScreenVideoPlayer(
//                                                       videoController:
//                                                           _videoController!),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               );
//                             } else {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             }
//                           },
//                         )
//                       : const SizedBox.shrink(),
//                   const SizedBox(height: 5),
//                   // Optional: Display video size if available
//                   if (widget.lesson.videoSize != null &&
//                       widget.lesson.videoSize!.isNotEmpty)
//                     Text(
//                       'Size: ${formatBytes(int.tryParse(widget.lesson.videoSize!) ?? 0)}',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Duration Section
//               if (widget.lesson.duration != null &&
//                   widget.lesson.duration!.isNotEmpty)
//                 Row(
//                   children: [
//                     const Icon(Icons.access_time, color: colorPrimary),
//                     const SizedBox(width: 10),
//                     Text(
//                       'Duration: ${widget.lesson.duration}',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),

//               // Lesson Title (Already in AppBar, consider removing or keeping based on UX)
//               if (widget.lesson.title != null &&
//                   widget.lesson.title!.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: Text(
//                     widget.lesson.title!,
//                     style: Theme.of(context)
//                         .textTheme
//                         .headlineSmall
//                         ?.copyWith(fontWeight: FontWeight.bold),
//                   ),
//                 ),

//               // Lesson Description
//               if (widget.lesson.description != null &&
//                   widget.lesson.description!.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: Text(
//                     widget.lesson.description!,
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                 ),

//               // Audio Section (Uncomment and implement if needed)
//               /*
//               if (widget.lesson.audioAddress != null &&
//                   widget.lesson.audioAddress!.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Audio',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ElevatedButton.icon(
//                       onPressed: _toggleAudioPlayback,
//                       icon: Icon(
//                         _isAudioPlaying ? Icons.pause : Icons.audiotrack,
//                       ),
//                       label: Text(
//                         _isAudioPlaying ? 'Pause Audio' : 'Play Audio',
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Size: ${formatBytes(int.tryParse(widget.lesson.audioSize ?? '0') ?? 0)}',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               */
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Implement audio playback methods if needed
//   /*
//   bool _isAudioPlaying = false;
//   AudioPlayer _audioPlayer = AudioPlayer();

//   void _toggleAudioPlayback() async {
//     if (_isAudioPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.play(widget.lesson.audioAddress!);
//     }
//     setState(() {
//       _isAudioPlaying = !_isAudioPlaying;
//     });
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//   */
// }
