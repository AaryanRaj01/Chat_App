import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application/Pages/HomePage.dart';
import 'package:flutter_chat_application/services/auth/loginorSignup.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
              //user is loggedin
               if(snapshot.hasData){
                 return const HomePage();
               }


              //user is not loggedin
               else{
                 return const LoginOrRegister();
               }
    },


      ),
    );
  }
}
