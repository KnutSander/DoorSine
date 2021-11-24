# Video Calling
There are a couple of different APIs that can be used to create video calls in Flutter.  
Below are the three most prominent ones.

## AgoraIO
A comprehensive API that allows for voice calls, video calls, live streaming, messaging, recording and more.  
Looks like the most substantial of the APIs, and I've already created an account on it for testing.

[AgoraIO Main Page](https://console.agora.io/), Only accessible with an account  
[AgoraIO Flutter Github](https://github.com/AgoraIO-Community/Agora-Flutter-Quickstart)

Tutorials:  
[Medium](https://medium.com/agora-io/building-a-flutter-video-call-app-with-in-call-statistics-bfb1e02abc0e)  
[AgoraIO](https://www.agora.io/en/blog/add-video-calling-to-your-flutter-app-using-agora/)  

## WebRTC
A real-time communication API created for the web in JavaScript. Has support for most platforms.

[WebRTC Main Page](https://webrtc.org/)  
[WebRTC Flutter Github](https://github.com/flutter-webrtc/flutter-webrtc)  

Tuorial:
[WebRTC With Firebase](https://webrtc.org/getting-started/firebase-rtc-codelab)  

## jitsi_meet
An open-source Apache API based on WebRTC and uses Jitsi Videobridge to provide video conferences.

[jitsi_meet Main Page](https://pub.dev/packages/jitsi_meet)

## Main Takeaway
Out of these three APIs, AgoraIO seems the most useful and geared towards my needs, as it provides a  
server to host the calls on as well as implementing the features need for calls and messaging.  
The other two APIs are nice to have in case of issues and other unforeseen things.
