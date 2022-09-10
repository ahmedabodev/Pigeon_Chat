import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/chat/view/chatscreen.dart';
import 'package:firebase_testing/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widget/text form field passward.dart';
import 'sginupscreen.dart';

class LoginScreens extends StatelessWidget {
   LoginScreens({Key? key}) : super(key: key);
final Auth_Controller _auth_controller =Get.put(Auth_Controller());

TextEditingController emailcontroller =TextEditingController();
TextEditingController passwordcontroller =TextEditingController();
   final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor:const Color(0xff06142b),

        body: Form(
          key:_formKey ,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // decoration:const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage('images/background.jpg'),
            //     fit: BoxFit.cover,
            //
            //   )
            // ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.black26.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                          child: Column(

                            children: [
                              const SizedBox(height: 10,),

                              TextFormField(
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'pls Enter you Email';
                                  }
                                  else if(value=='@'){

                                  }
                                },
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                    hintText: 'Email',
                                    fillColor: Colors.white,
                                    filled: true
                                ),
                              ),
                              const SizedBox(height: 20,),

                              Textformfieldpassward(
                                controller: passwordcontroller,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'pls Enter you Email';
                                  }
                                },
                                obscureText: true,
                                hintText: 'Password',
                              ),
                              const SizedBox(height: 20,),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                height: 40,
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  _auth_controller.signInWithEmailandPassword(
                                    email: emailcontroller.text,
                                    password: passwordcontroller.text
                                  );

                                }
                              },
                                color: const Color(0XFF02c38e),
                                child:const Text('Login',style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),),

                              ),
                              const SizedBox(height: 10,),
                              const Text('or',style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                              )),
                              const SizedBox(height: 10,),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                height: 40,
                                minWidth: MediaQuery.of(context).size.width,
                                onPressed: (){
                                  _auth_controller.signInWithGoogle();
                                },
                                color: Colors.white,
                                child:Row(
                                  children: [
                                    Image.asset('images/google.png',height: 20,),
                                    const SizedBox(width: 20,),
                                    const Text('Continue With Google',style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                    ),),
                                  ],
                                ),

                              ),
                              Row(
                                children:  [
                                  const Text('dont have account?',style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                  TextButton(onPressed: (){
                                    Get.to(()=>SignScreen());
                                  }, child:const Text('Sign up',style:  TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                  ),),
                                  )

                                ],
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
