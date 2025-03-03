import 'package:flutter/material.dart';
import 'package:eduroad/pages/login_page.dart';
import 'package:eduroad/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {

    const LoginOrRegisterPage({super.key});

    @override
    State<LoginOrRegisterPage> createState() => _LoginOrRegiterPageState();
}

class _LoginOrRegiterPageState extends State<LoginOrRegisterPage>{

    //initially show login page
    bool showLoginPage = true;

    //Toggle login page and register page
    void togglePages(){
        setState((){
            showLoginPage = !showLoginPage;
        });
    }

    @override
    Widget build(BuildContext context){
        if(showLoginPage){
            return LoginPage(
                onTap: togglePages,
            );
        }
        else {
            return RegisterPage(
            onTap: togglePages,
            );

        }
    }
}
