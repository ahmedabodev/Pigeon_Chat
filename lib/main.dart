import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/Auth/view/screens/loginscreen.dart';
import 'package:firebase_testing/Home/view/homescreen.dart';
import 'package:firebase_testing/chat/view/chatscreen.dart';
import 'package:firebase_testing/chat/view/mainchat/mainchatscreen.dart';
import 'package:firebase_testing/const.dart';
import 'package:firebase_testing/mainscreen/view/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'post/controller/post_controller.dart';
final Auth_Controller auth_controller=Get.put(Auth_Controller());

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.getToken().then((token) {
        print('tokeeeeeeeeeeeen'+token.toString());
        mytoken=token.toString();
  });
  print('tokeeeeeeeeeeeen');
  await GetStorage.init();
  HttpOverrides.global = MyHttpOverrides();
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen(( event) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${event.data.toString()}');

  });
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
 print('datanotfiavtion${remoteMessage.notification!.toMap()}');
 Get.to(MainChatScreen());
 // Get.to(()=>ChatScreen(docid: remoteMessage.data['mydata']['docid'], name: name, image: image));
});
  FirebaseAuth firebaseAuth =FirebaseAuth.instance;
  var user=firebaseAuth.currentUser;
  if(user==null){
    checkuser=false;
  }
  else{
    checkuser=true;

  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pigeon Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:AnimatedSplashScreen(
        //to cover the photo the phone
        splashIconSize: double.infinity,
        duration: 2000,

        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/dove.png',
              height: 70,
              width: 70,
            ),
          const SizedBox(height: 5,),
          const  Text('Pigeon Chat',style: TextStyle(
              color: Colors.white,
            fontSize: 20,
            ),)
          ],
        ),
        nextScreen: (checkuser)?MainScreen(): LoginScreens(),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: const Color(0xff0b1b38),
      ),
    );
  }
}

