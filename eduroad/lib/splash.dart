import 'package:flutter/material.dart';
import 'package:eduroad/main.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome()async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.bricolageGrotesque(fontSize: 64),
            children: [
              TextSpan(
                text: 'ed',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 64,
                  color: Color(0xFFF78000),
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: 'R',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 80,
                  color: Color(0xFF3C4241),
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: 'oad',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 32,
                  color: Color(0xFF3C4241),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
