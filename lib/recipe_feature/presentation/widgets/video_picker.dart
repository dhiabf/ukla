import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPicker extends StatelessWidget {
  final XFile? selectedVideo;
  final VideoPlayerController? videoPlayerController;
  final VoidCallback onPickVideo;
  final VoidCallback onPlayVideo;
  final VoidCallback onDeleteVideo;

  const VideoPicker({
    Key? key,
    required this.selectedVideo,
    required this.videoPlayerController,
    required this.onPickVideo,
    required this.onPlayVideo,
    required this.onDeleteVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickVideo,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (selectedVideo == null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, size: 40, color: Colors.green),
                    SizedBox(height: 8),
                    Text(
                      'Add Video',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              else if (videoPlayerController != null && videoPlayerController!.value.isInitialized)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  ),
                ),
              if (selectedVideo != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onPlayVideo,
                        icon: Icon(
                          videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: onDeleteVideo,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
