
import 'package:firebase_testing/Home/view/homescreen.dart';
import 'package:firebase_testing/chat/view/mainchat/mainchatscreen.dart';
import 'package:firebase_testing/post/view/create%20post/createpostscreen.dart';
import 'package:firebase_testing/post/view/postscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Main_Controller extends GetxController{

  int index=0;
  List<Widget>Screens=[
    PostScreen(),
    CreatePostScreen(),
    MyHomePage(),
    MainChatScreen(),
  ];
  changebottom(value){
    index=value;
    Screens[index];
    update();
  }
}