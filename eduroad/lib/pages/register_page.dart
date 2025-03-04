import 'package:eduroad/components/custom_button.dart';
import 'package:eduroad/components/custom_textfields.dart';
import 'package:eduroad/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget{

    final Function()? onTap;
    const RegisterPage ({super.key, required this.onTap});

    @override
    State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage>{



    //text editing controller
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    UserCredential? userCredential;
    //sign in user
    void signUserUp() async{
        //loading animation
        showDialog(context: context, builder: (context){
            return Center(
                child: CircularProgressIndicator(),
            ); //Center
        }); //showDialog

        //sign up
        try {
            //check if the password is correct/confirmed
            if(passwordController.text == confirmPasswordController.text){
               userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text
                );
            } else {
                // show error message, password dont match
                showErrorMessage("Password don't match");
            }
            User? user = userCredential?.user;
            if (user != null) {
        await _saveUserToFirestore(user);
      }
            //stop loading animation
            Navigator.pop(context);

        } on FirebaseAuthException catch (e) {

            //stop loading animation
            Navigator.pop(context);

            //show error message
            showErrorMessage(e.code);
        }
    }
    Future<void> _saveUserToFirestore(User user) async {
    DocumentReference userRef = _firestore.collection('Users').doc(user.uid);
    DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        'uid': user.uid,
        'firebaseEmail': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

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
                                size: 50,
                            ),

                            const  SizedBox(height: 50),

                            Text(
                                "Create Your Account",
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

                            //confirm password TextField
                            CustomTextField(
                                controller: confirmPasswordController,
                                hintText: "Confirm Password",
                                obscureText: true,
                            ),

                            const SizedBox(height: 25.0),

                            // sign in button
                            CustomButton(
                                text: "Sign Up",
                                onTap: signUserUp,
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
                                        "Already Have an Account?",
                                        style: TextStyle(color: Colors.grey[700])
                                    ),
                                    const SizedBox(width: 4),

                                    GestureDetector(
                                        onTap: widget.onTap,
                                        child: Text(
                                            "Login Now",
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

