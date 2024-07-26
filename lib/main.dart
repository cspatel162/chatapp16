// import 'package:chatapp16/routes/AppRoutes.dart';
// import 'package:chatapp16/utils/constants.dart';
// import 'package:chatapp16/utils/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'firebase_options.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   _initializeFirebase();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: AppConstants.appName,
//       color: ThemeProvider.appColor,
//       debugShowCheckedModeBanner: false,
//       navigatorKey: Get.key,
//       initialRoute: AppRoutes.initial,
//       getPages: AppRoutes.routes,
//       defaultTransition: Transition.native,
//       // translations: LocaleString(),
//       // locale: const Locale('en', 'US'),
//       theme: ThemeData(fontFamily: "regular"),
//     );
//   }
// }
// // this using  firebase app initialization
//  _initializeFirebase() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }
//
import 'package:chatapp16/routes/AppRoutes.dart';
import 'package:chatapp16/utils/constants.dart';
import 'package:chatapp16/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        String initialRoute = snapshot.hasData ? AppRoutes.userList : AppRoutes.login;

        return GetMaterialApp(
          title: AppConstants.appName,
          color: ThemeProvider.appColor,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          initialRoute: initialRoute,
          getPages: AppRoutes.routes,
          defaultTransition: Transition.native,
          // translations: LocaleString(),
          // locale: const Locale('en', 'US'),
          theme: ThemeData(fontFamily: "regular"),
        );
      },
    );
  }
}
