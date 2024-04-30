import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocab_app/configs/size_config.dart';
import 'package:vocab_app/constants/color_constant.dart';
import 'package:vocab_app/constants/font_constant.dart';

class PlayButton extends StatefulWidget {
  final String playMode;
  final String audioUrl;
  final Function(bool isPlaying)? onPlayingChanged;

  const PlayButton(
      {super.key,
      required this.audioUrl,
      this.onPlayingChanged,
      required this.playMode});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _audioUrl = "";
  String _playMode = "";
  bool _isMounted = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _playMode = widget.playMode;
    _audioUrl = widget.audioUrl;

    _setAudio();

    ///Listen: playing, paused, stopped
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _safeSetState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    ///Listen: audio duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _safeSetState(() {
        _duration = newDuration;
      });
    });

    ///Listen: audio position
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _safeSetState(() {
        _position = newPosition;
      });
    });
  }

  void _safeSetState(VoidCallback fn) {
    if (_isMounted) {
      setState(fn);
    }
  }

  Future _setAudio() async {
    _audioPlayer.setReleaseMode(ReleaseMode.loop);

    final audioUrl = UrlSource(_audioUrl);
    _audioPlayer.setSource(audioUrl);
  }

  void onPlay() async {
    if (_isPlaying) {
      _stopAudio();
    } else {
      _playAudio();
    }
  }

  Future _playAudio() async {
    await _audioPlayer.resume();
    if (_playMode != "recording") {
      widget.onPlayingChanged!(_isPlaying);
    }
  }

  Future _stopAudio() async {
    await _audioPlayer.pause();
    if (_playMode != "recording") {
      widget.onPlayingChanged!(_isPlaying);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPlay,
        child: _isPlaying
            ? Row(
                children: [
                  Container(
                    width: SizeConfig.defaultSize * 4,
                    height: SizeConfig.defaultSize * 4,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.defaultSize * 2),
                      color: COLOR_CONST.activeColor,
                    ),
                    child: const Icon(CupertinoIcons.play),
                  ),
                  SizedBox(width: SizeConfig.defaultSize * 1.5),
                  Expanded(child: _slider())
                ],
              )
            : Container(
                width: SizeConfig.defaultSize * 4,
                height: SizeConfig.defaultSize * 4,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.defaultSize * 2),
                  color: COLOR_CONST.primaryColor,
                ),
                child: const Icon(CupertinoIcons.play),
              ));
  }

  Widget _slider() {
    return Column(
      children: [
        Slider(
            activeColor: COLOR_CONST.primaryColor,
            min: 0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(position);
              _safeSetState(() {
                _position = position;
              });
            }),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${formatTime(_position)}s",
                  style: FONT_CONST.REGULAR_DEFAULT_16),
              const SizedBox(width: 70),
              Text("${formatTime(_duration - _position)}s",
                  style: FONT_CONST.REGULAR_DEFAULT_16),
            ],
          ),
        )
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inMinutes > 0) minutes,
      seconds,
    ].join(":");
  }
}
