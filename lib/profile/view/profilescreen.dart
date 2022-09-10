import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({Key? key}) : super(key: key);
final GetUser_Controller getUser_Controller =Get.put(GetUser_Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff06142b),
      appBar: AppBar(
        backgroundColor:const Color(0xff06142b),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100,),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Card(
                  color: const Color(0xff0b1b38),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Container(
                    height: 200,
                  ),
                ),
              ),
              (getUser_Controller.photo.toString()=="null")?  Positioned(
                  top: -55,
                  child:Container(
                    decoration:const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black, spreadRadius: 5)],
                    ),

                    child:const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      backgroundImage: AssetImage('images/profile.png',),
                    ),
                  )):Positioned(
                top: -55,
                child: Container(
                  decoration:const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black, spreadRadius: 5)],
                  ),
                  child: CircleAvatar(
                  backgroundImage: NetworkImage(getUser_Controller.photo.toString()),
                  radius: 60,
                  backgroundColor: Colors.black,
              ),
                ),
                  ),

              Column(
                children: [
                  const SizedBox(height: 50,),
                  Text(getUser_Controller.name.toString(),style:const TextStyle(
                      color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 10,),

                  Text('Followers'.toString(),style:const TextStyle(
                      color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21
                  ),),
                  Text(getUser_Controller.Follwers.toString(),style:const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 21
                  ),),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}
