import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netzoon/presentation/core/constant/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoFreeZoneWidget extends StatelessWidget {
  const VideoFreeZoneWidget(
      {Key? key, required this.title, required this.vediourl})
      : super(key: key);
  final String title;
  final String vediourl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColor.black,
            ),
          ),
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(vediourl) ?? '',
                flags: const YoutubePlayerFlags(
                  mute: false,
                  autoPlay: false,
                  disableDragSeek: false,
                  loop: false,
                  isLive: false,
                  forceHD: false,
                  enableCaption: true,
                ),
              ),
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) => player,
          ),
        ],
      ),
    );
  }
}
