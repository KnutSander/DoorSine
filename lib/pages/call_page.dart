/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 07/02/2021

import 'package:capstone_project/main.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  final String channelName;

  const CallPage({Key? key, required this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _usedIDs = <int>[];
  final _info = <String>[];
  late RtcEngine _rtcEngine;

  @override
  initState() {
    super.initState();
    initialise();
  }

  @override
  void dispose() {
    _usedIDs.clear();
    _rtcEngine.leaveChannel();
    _rtcEngine.destroy();
    super.dispose();
  }

  Future<void> initialise() async {
    if (appID.isEmpty) {
      setState(() {
        _info.add('no App ID found, please provide an App ID');
      });
      return;
    }

    await _initRtcEngine();
    _addAgoraEventHandlers();
    // TODO: Generate tokens automatically
    await _rtcEngine.joinChannel(
        '006d73f28067efd4f2bb80d756a87326e33IAAf7nvWOBoPaqc2xNh/djq75QpO2E6TnqRSd75QPDfs+B7wLAoAAAAAEADL5xHftjUGYgEAAQC3NQZi',
        widget.channelName,
        null,
        0);
  }

  Future<void> _initRtcEngine() async {
    _rtcEngine = await RtcEngine.create(appID);
    await _rtcEngine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    _rtcEngine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'Error: $code';
          _info.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'JoinChannel: $channel, uid: $uid';
          _info.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _info.add('onLeaveChannel');
          _usedIDs.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _info.add(info);
          _usedIDs.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _info.add(info);
          _usedIDs.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          _info.add(info);
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            _recipientVideo(),
            _callerVideo(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  Widget _recipientVideo() {
    final videoFeeds = _getVideos();
    if (videoFeeds.length == 2) {
      return _videoView(videoFeeds[1]);
    } else {
      return const Text("Calling...");
    }
  }

  Widget _callerVideo() {
    final videoFeeds = _getVideos();
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 4,
        child: _videoView(videoFeeds[0]),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _endCall(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _flipCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  List<Widget> _getVideos() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    for (var uid in _usedIDs) {
      list.add(RtcRemoteView.SurfaceView(
        uid: uid,
        renderMode: VideoRenderMode.Fit,
      ));
    }
    return list;
  }

  Widget _videoView(video) {
    return Expanded(child: Container(child: video));
  }

  void _endCall(BuildContext context) {
    Navigator.pop(context);
  }

  void _flipCamera() {
    _rtcEngine.switchCamera();
  }
}
