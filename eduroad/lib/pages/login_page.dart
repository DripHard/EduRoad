import 'package:eduroad/components/custom_button.dart';
import 'package:eduroad/components/custom_textfields.dart';
import 'package:eduroad/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'package:eduroad/features/login.dart';

class LoginPage extends StatefulWidget{

    final Function()? onTap;

    const LoginPage ({super.key, required this.onTap});

    @override
    State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{



    //text editing controller
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    //sign in user
    void signUserIn() async{
        //loading animation
        showDialog(context: context, builder: (context){
            return Center(
                child: CircularProgressIndicator(),
            ); //Center
        }); //showDialog

        //sign in
        try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text
            );

            //stop loading animation
            Navigator.pop(context);

        } on FirebaseAuthException catch (e) {

            //stop loading animation
            Navigator.pop(context);

            //show error message
            showErrorMessage(e.code);
        }
    }
    //alternative sign in


    void googleSignIn() async {
        try{
            final authClient = await AuthService().signInWithGoogle();

            if (authClient != null){
                print("Successfully signed in with Google");
             }


            else {
            print("Google sign-in canceled or failed");
            }
        }
            catch (e){
                print("Error during alternative sign-in: $e");


        }

    }
    //show error message
    void showErrorMessage(String message){
        showDialog(
            context: context,
            builder: (context){
                return AlertDialog(
                    title: Text(
                        message,
                        style: TextStyle(color: Colors.white),
                    ),
                ); // AlertDialog
            }
        ); //showDialog
    }



    void signUserOut() async {
        await FirebaseAuth.instance.signOut();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
                child: SingleChildScrollView(
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
                                controller: emailController,
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
                                text: "Sign In",
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

                            // google
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    //google button
                                    SquareTile(
                                        imagePath: "assets/GoogleLogo.png",
                                        onTap: googleSignIn,
                                ),

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
                                    const SizedBox(width: 4),

                                    GestureDetector(
                                        onTap: widget.onTap,
                                        child: Text(
                                            "Register Now",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                            ), //TextStyle
                                        ), // Text
                                    ),
                                ],
                            ), //Row
                        ]
                    )
                )

            )
        );
    }
}
