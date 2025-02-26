import 'package:eduroad/components/custom_button.dart';
import 'package:eduroad/components/custom_textfields.dart';
import 'package:eduroad/components/square_tile.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
    LoginPage({super.key});

    //text editing controller
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    //sign in user
    void signUserIn(){}

    @override
    Widget build(BuildContext context){
        return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const SizedBox(height: 50),
                        //eduroadlogo
                        //temporary
                        const Icon(
                            Icons.topic,
                            size: 80,
                        ),

                        const  SizedBox(height: 50),

                        Text(
                            "Welcome!",
                            style: TextStyle(color: Colors.grey[700],
                            fontSize: 16,
                            ),
                        ),


                        const SizedBox(height: 25),

                        //username TextField
                        CustomTextField(
                            controller: usernameController,
                            hintText: "Username or Email",
                            obscureText: false,
                        ),

                        const SizedBox(height: 10),

                        //password TextField
                        CustomTextField(
                            controller: passwordController,
                            hintText: "Password",
                            obscureText: true,
                        ),

                        const SizedBox(height: 10),

                        //forgot password

                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    Text(
                                        "Forgot Password?",
                                        style: TextStyle(color: Colors.grey[600]),
                                    ), //Text
                                ]
                            ), //Row
                        ), //Padding

                        const SizedBox(height: 25.0),

                        // sign in button
                        CustomButton(
                            onTap: signUserIn,
                        ),

                        const SizedBox(height: 40),

                        //alternative sign-in
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                                children: [
                                    Expanded(
                                        child: Divider(
                                            thickness: 0.5,
                                            color: Colors.grey[400]
                                        ) // Divider
                                    ), //Expanded

                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Text(
                                            "Or Continue With",
                                            style: TextStyle(color: Colors.grey[700]),
                                        ), //Text
                                    ), //Padding

                                    Expanded(
                                        child: Divider(
                                            thickness: 0.5,
                                            color: Colors.grey[400]
                                        ) // Divider
                                    ), //Expanded
                                ]
                            ) //Row
                        ), // Padding

                      const SizedBox(height: 35),

                        // google, facebook, apple sign-in buttons
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                                //google button
                                SquareTile(imagePath: "assets/GoogleLogo.png"),

                                SizedBox(width: 20.0),

                                //Facebook button
                                SquareTile(imagePath: "assets/FacebookLogo.png"),

                                SizedBox(width: 20.0),

                                //Apple Button
                                SquareTile(imagePath: "assets/AppleLogo.png"),

                            ]
                        ), //Row

                        const SizedBox(height: 35),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                    "Not a member?",
                                    style: TextStyle(color: Colors.grey[700])
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    "Register Now",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold
                                    ),
                                )
                            ],
                        )
                    ]
                )
            )

        );
    }
}
