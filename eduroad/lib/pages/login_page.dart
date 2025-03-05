import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'package:eduroad/features/login.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

    //text editing controller
    final emailController = TextEditingController();
    final passwordController = TextEditingController();


    void signUserOut() async {
        await FirebaseAuth.instance.signOut();
    }

  @override
  Widget build(BuildContext context) {


    //sign in user
    void signUserIn() async{
            Navigator.pushNamed(context, '/home');
    }
    //alternative sign in


    void googleSignIn() async {
            Navigator.pushNamed(context, '/home');
    }


    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF121212), // Dark top
                  Color(0xFF2A1E11),
                  Color(0xFFF78000), // Orange bottom
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Text
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/main');
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'ed',
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'R',
                              style: GoogleFonts.bricolageGrotesque(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Login Box - Positioned to Overlap the Bottom
          Positioned(
            bottom: -20, // Adjust this value to control the overlap
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email Input
                    TextField(
                    controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password Input
                    TextField(
                        controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign-in Button
                    ElevatedButton(
                      onPressed: signUserIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Sign in", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 15),

                    // Google Sign-in Button
                    OutlinedButton(
                      onPressed: googleSignIn,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 33,
                            width: 33,
                            child: Image.asset('assets/google.png', fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 5),
                          const Text("Sign in with Google"),
                        ],
                      ),
                    ),
                      const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

