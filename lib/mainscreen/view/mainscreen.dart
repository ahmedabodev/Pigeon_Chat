import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/Auth/view/screens/loginscreen.dart';
import 'package:firebase_testing/Home/model/home.dart';
import 'package:firebase_testing/mainscreen/controller/main_controller.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:firebase_testing/profile/view/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
   MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
final Main_Controller _main_controller=Get.put(Main_Controller());

   final Auth_Controller _auth_controller = Get.put(Auth_Controller());

   final GetUser_Controller getUser_Controller=Get.put(GetUser_Controller());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser_Controller.getdata();

}
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Main_Controller>(builder: ( controller) {

      return WillPopScope(

        onWillPop: () async{
          showDialog(context: context, builder: (BuildContext context) {
            return  AlertDialog(
              elevation: 10,

              backgroundColor: const Color(0xff06142b),
              title: Column(
                children: [
                  const Text('Do you want Close App ?',style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),),
                  const SizedBox(height: 10,),
                  Wrap(
                    children: [
                      OutlinedButton(

                        onPressed: (){
                          SystemNavigator.pop();

                          Get.back();
                        },
                        child:const Text('Yes',style: TextStyle(
                          fontSize: 14,
                        ),),

                      ),
                      const SizedBox(width: 10,),
                      OutlinedButton(onPressed: (){
                        Get.back();
                      },
                        child: const Text('No',style: TextStyle(
                          fontSize: 14,
                        ),),

                      )
                    ],
                  ),
                ],
              ),
            );
          },);

          return false;
        },
        child:  Scaffold(

          backgroundColor: const Color(0xff061328),

          appBar: AppBar(
            backgroundColor:const Color(0xff06142b),
            title:   GetBuilder<GetUser_Controller>(builder: ( controller) {
              return ( controller.name==null)?Center(child: CircularProgressIndicator()):Text(
                controller.name.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18
                ),
              );
            },),
            centerTitle: true,
            actions: [
              GetBuilder<GetUser_Controller>(builder: ( controller) {
                return (controller.photo=='null')?InkWell(
                  onTap: (){
                    Get.to(()=>ProfileScreen());
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage:AssetImage('images/profile.png') ,
                    backgroundColor: Colors.black,
                  ),
                ): InkWell(
                  onTap: (){
                    Get.to(()=>ProfileScreen());

                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:NetworkImage(controller.photo.toString()) ,
                    backgroundColor: Colors.red,
                  ),
                );
              },),
              IconButton(onPressed: (){
                _auth_controller.signOut();
                _auth_controller.boxemail.remove('boxemail');
                _auth_controller.boxemailgoogle.remove('boxemailgoogle');
                _auth_controller.boxcheck.remove('boxemailgoogle');
                _auth_controller.boxname.remove('boxname');
                _auth_controller.boxnamegoogle.remove('boxnamegoogle');
                _auth_controller.boxcheckid.remove('boxcheckid');
              }, icon:const Icon(Icons.exit_to_app)),

            ],

          ),
          body: OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ) {
              final bool connected = connectivity!= ConnectivityResult.none;
              if(connected){
                return  controller.Screens[controller.index];
              }else{
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Image.asset('images/wifi.png',height: 200,color: Colors.grey,),
                    Center(
                      child: Text(
                        'No Internet Please Connection to Your Network ',style: TextStyle(
                          color: Colors.white
                      ),
                      ),
                    ),
                  ],
                );
              }

            },
            child: const Center(
              child: CircularProgressIndicator(),
            ),

          ),

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xff0b1b38),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              controller.changebottom(value);
            },
            elevation: 0,
            currentIndex: controller.index,
            items:  [
              const   BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',

              ),
              const  BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: 'Create Post',

              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Users',

              ),
              BottomNavigationBarItem(
                icon: GetBuilder<GetUser_Controller>(builder: ( controller) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(Icons.chat),
                      (controller.showmessage==false)?SizedBox():CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 6,
                      ),
                    ],
                  );
                },),
                label: 'Chat',

              ),

            ],
          ),
        ),
      );
    },);
  }
}
