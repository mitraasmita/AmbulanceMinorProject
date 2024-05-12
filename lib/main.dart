import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:third_project/appInfo/app_info.dart';
import 'package:third_project/authentication/login_screen.dart';
import 'package:third_project/authentication/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:third_project/pages/home_page.dart';
//import 'package:com.asmita.thirdproject.MainActivity.dart';



Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCbJ-P-nFNdCYZ4IFhH4Cp2ptnNQeWRAs4",
      appId: "1:340717826978:android:7e98f4cb6e1d7c5f2538fb",
      messagingSenderId: "340717826978",
      projectId: "flutter-minor-project-1bf61",
    ),
  )
  :await Firebase.initializeApp();

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission)
  {
    if(valueOfPermission)
      {
        Permission.locationWhenInUse.request();
      }
  });


  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Flutter User App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : HomePage(),
      ),
    );
  }
}
