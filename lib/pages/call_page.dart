/// Created by Knut Sander Lien Blakkestad
/// Essex Capstone Project 2021/2022
/// Last updated: 27/03/2021

// Imports
import 'dart:convert';

import 'package:capstone_project/main.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// CallPage class is used by both sides of the app for calling
class CallPage extends StatefulWidget {
  // Constructor
  const CallPage({Key? key, required this.channelName}) : super(key: key);

  // Channel name is lecturer email
  final String channelName;

  // Create state function
  @override
  _CallPageState createState() => _CallPageState();
}

// State class all StatefulWidgets use
class _CallPageState extends State<CallPage> {

  // The ids of the connected users, list is necessary for functionality
  static final _usedIDs = <int>[];

  // List of information strings when different events happen
  final _info = <String>[];

  // Base url that links to Heroku, which generates the channel token
  String baseUrl = 'https://door-sine.herokuapp.com';

  // Starting user id
  int uid = 0;

  // RtcEngine which connects the app to AgoraIO
  late RtcEngine _rtcEngine;

  // Channel token
  late String token;

  // Initialise function when state is created
  @override
  initState() {
    super.initState();
    initialise();
  }

  // Dispose function when state is terminated
  @override
  void dispose() {
    _usedIDs.clear();
    _rtcEngine.leaveChannel();
    _rtcEngine.destroy();
    super.dispose();
  }

  // Main build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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

  // Initialise function that initialises everything the app needs
  // to be able to call one another
  Future<void> initialise() async {

    // Check that the app id has been set in main
    if (appID.isEmpty) {
      setState(() {
        _info.add('no App ID found, please provide an App ID');
      });
      return;
    }

    // More necessary initialisation of various variables and objects
    await _initRtcEngine();
    _addAgoraEventHandlers();
    await getToken();

    // Joins the channel with the given name securely using a token
    // No optional parameters and 0 as the user id (assigns num automatically)
    await _rtcEngine.joinChannel(
        token,
        widget.channelName,
        null,
        0);
  }

  // Initialises the RtcEngine
  Future<void> _initRtcEngine() async {
    _rtcEngine = await RtcEngine.create(appID);
    await _rtcEngine.enableVideo();
  }

  // Retrieve the token needed to initialise the call
  // Function adapted from https://gist.github.com/Meherdeep/25d4bdac5dad0c4547809754c9e8417e
  Future<void> getToken() async {
    final response = await http.get(Uri.parse(baseUrl +
        '/rtc/' +
        widget.channelName +
        '/publisher/uid/' +
        uid.toString()));

    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
      });
    } else {
      print('Failed to fetch token');
    }
  }

  // Add necessary event handlers
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
      tokenPrivilegeWillExpire: (token) async {
        await getToken();
        await _rtcEngine.renewToken(token);
      },
    ));
  }

  // Returns a video of the recipient, person on the other device
  Widget _recipientVideo() {
    final videoFeeds = _getVideos();
    if (videoFeeds.length == 2) {
      return _videoView(videoFeeds[1]);
    } else {
      return const Center(
          child: Text(
        "Calling...",
        style: TextStyle(color: Colors.white),
        textScaleFactor: 2,
      ));
    }
  }

  // Returns the video of the caller, device user
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

  // Toolbar that contains a button that can flip the camera
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _flipCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.red,
              size: 35.0,
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

  // Returns a list of all the videos
  List<Widget> _getVideos() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    for (var uid in _usedIDs) {
      list.add(RtcRemoteView.SurfaceView(
        channelId: widget.channelName,
        uid: uid,
        renderMode: VideoRenderMode.Fit,
      ));
    }
    return list;
  }

  // Returns a video container
  Widget _videoView(video) {
    return Expanded(child: Container(child: video));
  }

  // Flips the camera
  void _flipCamera() {
    _rtcEngine.switchCamera();
  }
}
