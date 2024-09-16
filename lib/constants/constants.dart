import 'package:flutter/material.dart';
import 'package:flutter_video_call/page/home_page.dart';
import 'package:flutter_video_call/page/login_page.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class PageRouteNames {
  static const String login = '/login';
  static const String home = '/home_page';
}

Map<String, WidgetBuilder> routes = {
  PageRouteNames.login: (context) => const LoginPage(),
  PageRouteNames.home: (context) => const ZegoUIKitPrebuiltCallMiniPopScope(
        child: HomePage(),
      ),
};

class UserInfo {
  String id = '';
  String name = '';

  UserInfo({
    required this.id,
    required this.name,
  });

  // UserInfo({ required this.id, required this.name, });: This is a named constructor that requires both id and name to be provided when creating an instance of UserInfo.

  bool get isEmpty => id.isEmpty;

  UserInfo.empty();
}

// This is a named constructor that creates an empty UserInfo instance. It doesn't initialize any properties, so id and name remain as empty strings.

UserInfo currentUser = UserInfo.empty();
const String cacheUserIDKey = 'cache_user_id_key';

const TextStyle textStyle = TextStyle(
  color: Colors.black,
  fontSize: 13.0,
  decoration: TextDecoration.none,
);
