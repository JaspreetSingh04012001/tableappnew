
import 'package:efood_table_booking/controller/promotional_controller.dart';
import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubePLayer extends StatefulWidget {
  final double height;
  final double width;
  const CustomYoutubePLayer({Key? key, required this.height, required this.width, }) : super(key: key);

  @override
  State<CustomYoutubePLayer> createState() => _CustomYoutubePLayerState();
}

class _CustomYoutubePLayerState extends State<CustomYoutubePLayer> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState playerState;
  late YoutubeMetaData videoMetaData;
  double volume = 100;
  bool muted = false;
  bool _isPlayerReady = false;




  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: Get.find<PromotionalController>().videoIds.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        playerState = _controller.value.playerState;
        videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionalController>(
      builder: (promotionalController) {
        return SizedBox(
          height: widget.height, width: widget.width,
          child: YoutubePlayerBuilder(
            onExitFullScreen: () {
              SystemChrome.setPreferredOrientations(DeviceOrientation.values);
            },
            player: YoutubePlayer(
              width: widget.width,
              controller: _controller,
              showVideoProgressIndicator: true,
              aspectRatio: ResponsiveHelper.isSmallTab() ? 2.5 : 16/9,
              progressIndicatorColor: Theme.of(context).primaryColor,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: robotoRegular.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),

              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                _controller
                    .load(promotionalController.videoIds[(
                    promotionalController.videoIds.indexOf(data.videoId) + 1
                ) % promotionalController.videoIds.length]);
              },
            ),
            builder: (context, player) => const SizedBox(
            ),
          ),
        );
      }
    );
  }

}
