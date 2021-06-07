import 'package:flutter/material.dart';
import 'package:deniz/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  final String url;
  VideoPlayerPage({
    this.url,
  });
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  var _init;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.url),
      // 'assets/images/bee.mp4',
    );
    print('fucking url: ${widget.url}');

    // _controller.addListener(() {
    //   setState(() {});
    // });
    _controller.setLooping(true);
    _init = _controller.initialize();
    // _controller.initialize().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.expand(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.borderRadius,
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          _controller.play();
          return SizedBox.expand(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(
                  _controller,
                ),
                ClosedCaption(text: _controller.value.caption.text),
                // _PlayPauseOverlay(controller: _controller),
                // VideoProgressIndicator(_controller, allowScrubbing: true),
              ],
            ),
            // ),
          );
        }
      },
    );
    // return Center(
    //   child: _controller.value.initialized
    //       ? AspectRatio(
    //           aspectRatio: _controller.value.aspectRatio,
    //           child: VideoPlayer(_controller),
    //         )
    //       : Container(),
    // );
  }
}

// class _PlayPauseOverlay extends StatelessWidget {
//   const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

//   final VideoPlayerController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 50),
//           reverseDuration: Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: MyColors.white,
//                       size: SizeConfig.heightMultiplier * 10,
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//       ],
//     );
//   }
// }

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.asset('assets/Butterfly-209.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}
