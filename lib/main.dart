import 'dart:io';
//import 'dart:js';
//import 'package:js/js.dart';
import 'package:driver_app/authentication/login_screen.dart';
import 'package:driver_app/pages/dashboard.dart';
import 'package:driver_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCbJ-P-nFNdCYZ4IFhH4Cp2ptnNQeWRAs4",
      appId: "1:340717826978:android:f9f4d25e55f95a1c2538fb",
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

  await Permission.notification.isDenied.then((valueOfPermission)
  {
    if(valueOfPermission)
    {
      Permission.notification.request();
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
    return MaterialApp(
      title: 'Drivers App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : Dashboard(),//If the driver is not logged in then only take the subject to login page or else take the subject to homepage
    );
  }
}
