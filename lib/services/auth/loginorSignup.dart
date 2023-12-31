import 'package:flutter/material.dart';
import 'package:flutter_chat_application/Pages/login_page.dart';
import 'package:flutter_chat_application/Pages/register_Page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show this login screen
  bool showLoginPage = true;

  //toggle between login and register page

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });

  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
