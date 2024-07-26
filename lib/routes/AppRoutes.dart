
import 'package:chatapp16/view/user_list_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../view/login_screen.dart';
import '../view/signup_screen.dart';


class AppRoutes{
  static const String initial = '/';
  static const String login = '/login';
  static const String signup = '/ragister';
  static const String userList = '/userlist';
  static const String chatscreen = '/chatscreen';

  static String getInitialRoute() => initial;
  static String getSignupRoute() => signup;
  static String getUserListRoute() => userList;
  static String getChatScreenRoute() => chatscreen;

  // static String getHomeRoute() => home;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: userList, page: () => UserListScreen()),
    // GetPage(name: chatscreen, page: () => ChatScreen()),

  ];
}

