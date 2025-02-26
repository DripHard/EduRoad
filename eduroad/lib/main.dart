import 'package:eduroad/pages/login_page.dart';
import 'package:eduroad/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:eduroad/pages/roadmap.dart';


void main() async {
  runApp(const MyApp());

  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduRoad',
      home: Splash(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
  TextEditingController searchController = TextEditingController();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF121212), Color(0x752A1E11), Color(0xFFF78000)],
          stops: [0.0, 0.46, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'ed',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: 'R',
                            style: GoogleFonts.bricolageGrotesque(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: const Color.fromARGB(255, 94, 81, 81),
                            width: 2.0),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                      onPressed: () {},
                      child: Text('Sign in',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome...',
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 30,
            right: 30,
            bottom: 100,
            child: Hero (
              tag: 'searchbar',
              child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: GoogleFonts.bricolageGrotesque(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 196, 196, 196).withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: Icon(Icons.search,
                            color: Colors.white.withOpacity(0.6)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 35),
                      ),
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500), // Smooth transition
                              pageBuilder: (context, animation, secondaryAnimation) => Roadmap(searchQuery: value),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0, 0.2), // Start slightly below
                                    end: Offset(0, 0), // Move up to normal position
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeIn, // Smooth easing effect
                                  )),
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
